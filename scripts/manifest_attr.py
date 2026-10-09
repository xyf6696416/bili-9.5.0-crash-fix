import re
s = open(r'E:\nx\bili_decode\apktool\AndroidManifest.xml', encoding='utf-8', errors='replace').read()
for label, pat in [
    ('versionCode', r'android:versionCode="([^"]+)"'),
    ('versionName', r'android:versionName="([^"]+)"'),
    ('debuggable', r'<application[^>]*?android:debuggable="([^"]+)"'),
    ('minSdk', r'android:minSdkVersion="(\d+)"'),
    ('targetSdk', r'android:targetSdkVersion="(\d+)"'),
]:
    m = re.search(pat, s)
    print(f'{label:12}:', m.group(1) if m else 'N/A')
