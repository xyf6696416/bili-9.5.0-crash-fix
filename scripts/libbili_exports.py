from elftools.elf.elffile import ELFFile
elf = ELFFile(open(r"E:\nx\bili_decode\apktool\lib\arm64-v8a\libbili.so", "rb"))
dyn = elf.get_section_by_name('.dynsym')
exp = []
for s in dyn.iter_symbols():
    try:
        if s['st_shndx'] != 'SHN_UNDEF' and s.name:
            exp.append((s['st_value'], s.name))
    except Exception:
        pass
print("exports:", len(exp))
for v, n in sorted(exp)[:80]:
    print(hex(v), n)
