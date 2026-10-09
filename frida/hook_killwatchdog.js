'use strict';

// 废掉 libbili.so 的校验线程入口 (+0x8da0)
function patch() {
    var m = Process.findModuleByName('libbili.so');
    if (!m) { setTimeout(patch, 100); return; }
    var routine = m.base.add(0x8da0);
    Interceptor.replace(routine, new NativeCallback(function (arg) {
        console.log('[NEUTRALIZED] libbili watchdog thread body @ ' + routine);
        return ptr(0);
    }, 'pointer', ['pointer']));
    console.log('[+] watchdog entry replaced: ' + routine + ' (base=' + m.base + ')');
}
patch();

// 观察是否还有 exit
try {
    Interceptor.attach(Module.getGlobalExportByName('exit'), {
        onEnter: function (a) { console.log('[exit] code=' + a[0].toInt32() + ' from ' + DebugSymbol.fromAddress(this.returnAddress)); }
    });
} catch (e) {}

console.log('[*] ready');
