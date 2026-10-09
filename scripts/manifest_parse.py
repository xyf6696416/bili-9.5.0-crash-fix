import re, sys
p = sys.argv[1]
s = open(p, encoding='utf-8', errors='replace').read()
def attr(pat):
    m = re.search(pat, s)
    return m.group(1) if m else 'N/A'
print('package      :', attr(r'package="([^"]+)"'))
print('versionCode  :', attr(r'android:versionCode="([^"]+)"'))
print('versionName  :', attr(r'android:versionName="([^"]+)"'))
print('application  :', attr(r'<application[^>]*?android:name="([^"]+)"'))
print('debuggable   :', attr(r'<application[^>]*?android:debuggable="([^"]+)"'))
print('allowBackup  :', attr(r'android:allowBackup="([^"]+)"'))
print('--- LAUNCHER activities ---')
blks = re.findall(r'<activity\b.*?</activity>', s, re.S)
for b in blks:
    if 'android.intent.action.MAIN' in b and 'android.intent.category.LAUNCHER' in b:
        nm = re.search(r'android:name="([^"]+)"', b)
        if nm:
            print('  LAUNCHER:', nm.group(1))
