'use strict';

// 阻断 libc exit/_exit，验证 libbili.so 的自杀是否是闪退唯一原因
var blocked = 0;

function noopExit(code) {
    blocked++;
    if (blocked <= 5) console.log('[BLOCKED] exit(' + code + ') #' + blocked);
}

var cb = new NativeCallback(noopExit, 'void', ['int']);

['exit', '_exit'].forEach(function (name) {
    var p = null;
    try { p = Module.getGlobalExportByName(name); } catch (e) {}
    if (!p) { console.log('no ' + name); return; }
    Interceptor.replace(p, cb);
    console.log('[+] REPLACED ' + name);
});

// 同时观察 libbili.so 的校验线程
var bili = null;
try { bili = Process.getModuleByName('libbili.so'); } catch (e) {}
if (bili) {
    console.log('[libbili] base=' + bili.base);
    [0x8da0, 0xd23c, 0x8f20].forEach(function (off) {
        try {
            Interceptor.attach(bili.base.add(off), {
                onEnter: function () { console.log('[libbili] hit +0x' + off.toString(16)); }
            });
            console.log('[+] hooked libbili.so+0x' + off.toString(16));
        } catch (e) { console.log('hook fail +0x' + off.toString(16) + ': ' + e); }
    });
}

console.log('[*] block-exit ready');
