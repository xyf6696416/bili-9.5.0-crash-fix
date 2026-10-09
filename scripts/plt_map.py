from elftools.elf.elffile import ELFFile
from capstone import *
PATH = r"E:\nx\bili_decode\apktool\lib\arm64-v8a\libbili.so"
f = open(PATH, "rb"); data = f.read()
elf = ELFFile(f)
dynsym = elf.get_section_by_name(".dynsym")
rela = elf.get_section_by_name(".rela.plt")
relocs = list(rela.iter_relocations())
plt_base = 0x7fa0
stub2sym = {}
sym2stub = {}
for i, r in enumerate(relocs):
    si = r.entry.r_info_sym
    try:
        nm = dynsym.get_symbol(si).name
    except Exception:
        nm = f"sym{si}"
    a = plt_base + 16 * (i + 2)
    stub2sym[a] = nm
    sym2stub.setdefault(nm, a)
print("=== PLT 桩 -> 符号 ===")
for a, s in sorted(stub2sym.items()):
    print(f"  0x{a:x}  {s}")

md = Cs(CS_ARCH_ARM64, CS_MODE_ARM); md.detail = True
TARGETS = {"exit", "_exit", "abort", "kill", "tgkill", "raise", "_Exit", "syscall", "pthread_exit", "quick_exit"}
text = elf.get_section_by_name(".text")
ta, td = text["sh_addr"], text.data()
print("\n=== 退出/杀进程调用点 ===")
n = 0
for ins in md.disasm(td, ta):
    if ins.mnemonic == "bl":
        t = ins.operands[0].imm
        s = stub2sym.get(t)
        if s in TARGETS:
            print(f"  fileoff=0x{ins.address:x} (vaddr 0x{ins.address:x})  bl {s}  bytes={ins.bytes.hex()}")
            n += 1
    elif ins.mnemonic == "svc":
        print(f"  fileoff=0x{ins.address:x}  SVC {ins.op_str}  bytes={ins.bytes.hex()}")
print("total:", n)
