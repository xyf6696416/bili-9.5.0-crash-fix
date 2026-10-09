from elftools.elf.elffile import ELFFile
from capstone import *
PATH = r"E:\nx\bili_decode\apktool\lib\arm64-v8a\libbili.so"
f = open(PATH, "rb"); data = f.read()
elf = ELFFile(f)
dynsym = elf.get_section_by_name(".dynsym")
rela = elf.get_section_by_name(".rela.plt")
stub2sym = {0x7fa0 + 16*(i+2): dynsym.get_symbol(r.entry.r_info_sym).name
            for i, r in enumerate(rela.iter_relocations())}
sym2stub = {}
for a, s in stub2sym.items(): sym2stub.setdefault(s, a)
md = Cs(CS_ARCH_ARM64, CS_MODE_ARM); md.detail = True

text = elf.get_section_by_name(".text"); ta, td = text["sh_addr"], text.data()
pc_stub = sym2stub["pthread_create"]
print("pthread_create stub =", hex(pc_stub))
print("=== .text 中所有调用 pthread_create 的位置 ===")
for ins in md.disasm(td, ta):
    if ins.mnemonic == "bl" and ins.operands[0].imm == pc_stub:
        print(f"  0x{ins.address:x}")

print(f"\n=== 0xa560-0xa6c0 反汇编（看门狗线程创建点上下文） ===")
for ins in md.disasm(data[0xa560:0xa6c0], 0xa560):
    note = ""
    if ins.mnemonic == "bl":
        note = "  -> " + stub2sym.get(ins.operands[0].imm, hex(ins.operands[0].imm))
    print(f"0x{ins.address:x}: {ins.mnemonic:8s} {ins.op_str}{note}")
