'use strict';

function findExport(name) {
    try { return Module.getGlobalExportByName(name); } catch (e) { return null; }
}

function bt(ctx) {
    try {
        return Thread.backtrace(ctx, Backtracer.ACCURATE)
            .map(function (a) { return DebugSymbol.fromAddress(a).toString(); })
            .join('\n');
    } catch (e) { return 'bt fail: ' + e; }
}

['exit', '_exit', 'abort'].forEach(function (name) {
    var p = findExport(name);
    if (!p) { console.log('[-] no export ' + name); return; }
    Interceptor.attach(p, {
        onEnter: function (args) {
            console.log('\n===== NATIVE ' + name + '(code=' + args[0].toInt32() + ') =====');
            console.log(bt(this.context));
        }
    });
    console.log('[+] hooked native ' + name);
});

['kill', 'tgkill', 'raise', 'pthread_kill'].forEach(function (name) {
    var p = findExport(name);
    if (!p) { console.log('[-] no export ' + name); return; }
    Interceptor.attach(p, {
        onEnter: function (args) {
            console.log('[sig] ' + name + ' a0=' + args[0].toInt32() + ' a1=' + args[1].toInt32() + '\n' + bt(this.context));
        }
    });
    console.log('[+] hooked ' + name);
});

['dlopen', 'android_dlopen_ext'].forEach(function (name) {
    var p = findExport(name);
    if (!p) { console.log('[-] no export ' + name); return; }
    Interceptor.attach(p, {
        onEnter: function (args) {
            var s = args[0].readCString();
            if (s && /msaoaidsec|dexvmp|safemode|nirvana|kntr|libtf|bprotect|shield/i.test(s)) {
                console.log('[dlopen] ' + s);
            }
        }
    });
    console.log('[+] hooked ' + name);
});

console.log('[*] native hooks ready');
