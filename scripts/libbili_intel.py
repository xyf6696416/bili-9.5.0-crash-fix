import re
from elftools.elf.elffile import ELFFile

path = r"E:\nx\bili_decode\apktool\lib\arm64-v8a\libbili.so"
elf = ELFFile(open(path, "rb"))

# 未定义符号 = 导入
dyn = elf.get_section_by_name('.dynsym')
imports = [s.name for s in dyn.iter_symbols() if s['st_shndx'] == 'SHN_UNDEF' and s.name]
print("=== IMPORTS (%d) ===" % len(imports))
kw = re.compile(r'Sign|sign|Cert|cert|Verify|verify|Package|getPackage|Field|Method|CallStatic|GetIntField|GetString|FindClass|GetFieldID|ptrace|proc|dlopen|mmap|protect|Ptrace|Tracer', re.I)
for i in sorted(set(imports)):
    if kw.search(i):
        print("  ", i)

data = open(path, "rb").read()
strs = re.findall(rb"[\x20-\x7e]{5,}", data)
KEY = re.compile(rb"sign|cert|META-INF|\.RSA|sha1|sha256|md5|tamper|illegal|detect|xposed|magisk|frida|ptrace|/proc/|su\b|root|debug|tracer|hook|verify|integrity|package|danmaku|bilibili|check", re.I)
hits = []
seen = set()
for s in strs:
    if KEY.search(s):
        t = s.decode('ascii', 'ignore')
        if t not in seen:
            seen.add(t)
            hits.append(t)
print("\n=== STRINGS (%d unique hits) ===" % len(hits))
for h in hits[:120]:
    print("  ", h)
