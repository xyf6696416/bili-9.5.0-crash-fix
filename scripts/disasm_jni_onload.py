from elftools.elf.elffile import ELFFile
from capstone import *
PATH = r"E:\nx\bili_decode\apktool\lib\arm64-v8a\libbili.so"
f = open(PATH, "rb"); data = f.read()
elf = ELFFile(f)
dynsym = elf.get_section_by_name(".dynsym")
rela = elf.get_section_by_name(".rela.plt")
stub2sym = {}
for i, r in enumerate(rela.iter_relocations()):
    stub2sym[0x7fa0 + 16*(i+2)] = dynsym.get_symbol(r.entry.r_info_sym).name

md = Cs(CS_ARCH_ARM64, CS_MODE_ARM); md.detail = True
START, END = 0x8470, 0x10000
print(f"=== 0x{START:x}-0x{END:x} 内所有 bl/blr（解析 PLT 目标） ===")
for ins in md.disasm(data[START:END], START):
    if ins.mnemonic == "bl":
        t = ins.operands[0].imm
        sym = stub2sym.get(t)
        print(f"0x{ins.address:x}: bl {sym if sym else hex(t)}")
    elif ins.mnemonic == "blr":
        print(f"0x{ins.address:x}: blr {ins.op_str}")
