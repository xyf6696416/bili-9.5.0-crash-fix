import sys
from elftools.elf.elffile import ELFFile
from capstone import *

path = r"E:\nx\bili_decode\apktool\lib\arm64-v8a\libbili.so"
f = open(path, "rb")
elf = ELFFile(f)

# 建立 地址->符号 映射（dynsym）
symtab = elf.get_section_by_name('.dynsym')
addrs = {}
if symtab:
    for s in symtab.iter_symbols():
        if s['st_value']:
            addrs.setdefault(s['st_value'], s.name)

# PLT 区域
plt = elf.get_section_by_name('.plt')
plt_map = {}
if plt:
    base = plt['sh_addr']
    data = plt.data()
    for i in range(0, len(data), 16):
        # 简化：不解析

        pass

sections = [(s['sh_addr'], s['sh_offset'], s['sh_size'], s.name) for s in elf.iter_sections() if s['sh_type'] == 'SHT_PROGBITS']

def find_off(vaddr):
    for a, o, sz, name in sections:
        if a <= vaddr < a + sz:
            return o + (vaddr - a), name
    return None, None

md = Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
md.detail = True

def disasm(vaddr, n=60, label=""):
    off, name = find_off(vaddr)
    if off is None:
        print(f"!! {vaddr:#x} not in a PROGBITS section")
        return
    f.seek(off)
    code = f.read(n * 8)
    print(f"\n===== {label} @ {vaddr:#x} (section {name}) =====")
    for ins in md.disasm(code, vaddr):
        sym = addrs.get(ins.address, "")
        extra = ""
        # 解析 bl/b 目标符号
        if ins.mnemonic in ("bl", "b", "cbz", "cbnz", "tbz", "tbnz", "adrp") and ins.operands:
            try:
                tgt = int(ins.operands[-1].text.split('#')[-1], 0)
                if tgt in addrs:
                    extra = f"   ; -> {addrs[tgt]}"
            except Exception:
                pass
        pre = f"  [{sym}]" if sym else ""
        print(f"  {ins.address:#010x}  {ins.mnemonic:<8} {ins.op_str}{pre}{extra}")

for off, n in [(0x8da0, 40), (0xd23c, 80), (0x8f20, 30)]:
    disasm(off, n, f"libbili.so+{off:#x}")
