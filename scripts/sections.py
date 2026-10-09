from elftools.elf.elffile import ELFFile
from capstone import *
PATH = r"E:\nx\bili_decode\apktool\lib\arm64-v8a\libbili.so"
f = open(PATH, "rb"); elf = ELFFile(f)
print("=== sections ===")
for s in elf.iter_sections():
    print(f"  {s.name:22s} addr=0x{s['sh_addr']:x} off=0x{s['sh_offset']:x} size=0x{s['sh_size']:x} type={s['sh_type']} flags=0x{s['sh_flags']:x}")
md = Cs(CS_ARCH_ARM64, CS_MODE_ARM); md.detail = True
data = f.read()
print("\n=== disasm @0xdb100-0xdb180 ===")
for ins in md.disasm(data[0xdb100:0xdb180], 0xdb100):
    print(f"  0x{ins.address:x}: {ins.bytes.hex():12s} {ins.mnemonic} {ins.op_str}")
print("\n=== disasm @0x8190-0x84b0 (疑似 .plt) ===")
for ins in md.disasm(data[0x8190:0x8200], 0x8190):
    print(f"  0x{ins.address:x}: {ins.bytes.hex():12s} {ins.mnemonic} {ins.op_str}")
