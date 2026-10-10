import zipfile, struct, sys

path = sys.argv[1] if len(sys.argv) > 1 else r'E:\nx\bili_decode\adblock_final.apk'
z = zipfile.ZipFile(path)
names = [x for x in z.namelist() if x.endswith('.dex')]
def key(s):
    body = s[:-4][6:]
    return int(body) if body.isdigit() else 0
for n in sorted(names, key=key):
    d = z.read(n)
    n_method = struct.unpack('<I', d[0x58:0x5c])[0]
    n_class = struct.unpack('<I', d[0x60:0x64])[0]
    n_strings = struct.unpack('<I', d[0x38:0x3c])[0]
    print(f"{n:16} methods={n_method:6d} free={65536-n_method:6d} strings={n_strings:6d} classes={n_class}")
