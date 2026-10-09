"""libbili.so: 定位 PLT 桩 -> 符号，找出所有调用 exit/_exit/abort/kill/tgkill 的 BL 点"""
from elftools.elf.elffile import ELFFile
from capstone import *

PATH = r"E:\nx\bili_decode\apktool\lib\arm64-v8a\libbili.so"
TARGETS = {"exit", "_exit", "abort", "kill", "tgkill", "raise", "syscall", "_Exit", "pthread_exit"}

f = open(PATH, "rb")
elf = ELFFile(f)

# ---- 重定位表: GOT 地址 -> 符号名
rela = elf.get_section_by_name(".rela.plt")
got2sym = {}
if rela:
    for i, r in enumerate(rela.iter_relocations()):
        try:
            nm = rela.symbol_at(i).name
        except Exception:
            nm = "?"
        got2sym[r.entry.r_offset] = nm
print("relocs:", len(got2sym))

# ---- 反汇编 PLT 区，解析每个桩跳转到哪个 GOT 槽
plt = elf.get_section_by_name(".plt")
md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
md.detail = True
stub2sym = {}
if plt:
    pa, pd = plt["sh_addr"], plt.data()
    cur_adrp = None
    for ins in md.disasm(pd, pa):
        m = ins.mnemonic
        if m == "adrp":
            ops = ins.operands
            if len(ops) == 2 and ops[1].type == 2:  # imm
                cur_adrp = ops[1].imm
        elif m == "add" and cur_adrp is not None:
            ops = ins.operands
            if len(ops) == 3 and ops[2].type == 2:
                cur_adrp += ops[2].imm
        elif m == "ldr" and cur_adrp is not None:
            ops = ins.operands
            if len(ops) == 2 and ops[1].mem.base and ops[1].mem.disp is not None:
                got = cur_adrp + ops[1].mem.disp
                sym = got2sym.get(got)
                if sym:
                    stub2sym[ins.address + 4] = sym   # br 紧跟在 ldr 之后
                    stub2sym[ins.address] = sym
                cur_adrp = None

print("plt stubs mapped:", len(stub2sym))
for a, s in sorted(stub2sym.items()):
    if s in TARGETS:
        print(f"  PLT stub 0x{a:x} -> {s}")

# ---- 扫描 .text 找 BL
text = elf.get_section_by_name(".text")
taddr, tdata = text["sh_addr"], text.data()
hits = []
bl_counts = {}
for ins in md.disasm(tdata, taddr):
    if ins.mnemonic == "bl":
        tgt = ins.operands[0].imm
        sym = stub2sym.get(tgt)
        key = sym if sym else hex(tgt)
        bl_counts[key] = bl_counts.get(key, 0) + 1
        if sym in TARGETS:
            hits.append((ins.address - taddr, sym, tgt - taddr, ins.bytes.hex()))
    elif ins.mnemonic == "svc":
        hits.append((ins.address - taddr, "SVC " + ins.op_str, -1, ins.bytes.hex()))

print("\n=== 退出/杀进程相关调用点 (libbili.so 文件内偏移) ===")
for off, sym, tgt, by in hits:
    print(f"  +0x{off:x}  bl {sym}   (stub +0x{tgt:x})   bytes={by}")
print("total:", len(hits))

print("\n=== 调用次数最多的外部目标 top15 ===")
for k, v in sorted(bl_counts.items(), key=lambda x: -x[1])[:15]:
    print(f"  {v:4d}  {k}")
