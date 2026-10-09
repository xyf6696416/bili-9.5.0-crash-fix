'use strict';

var FATAL = [4, 6, 7, 8, 11];
var BLOCK_CALLERS = ['libbili_core.so', 'libBugly.so', 'libmonochrome_64.so'];
var blocked = 0;

function modOf(addr) {
    try { var m = Process.findModuleByAddress(addr); return m ? m.name : null; } catch (e) { return null; }
}

var sa = Module.getGlobalExportByName('sigaction');
Interceptor.attach(sa, {
    onEnter: function (args) {
        var signum = args[0].toInt32();
        var caller = modOf(this.returnAddress);
        if (FATAL.indexOf(signum) !== -1 && BLOCK_CALLERS.indexOf(caller) !== -1) {
            blocked++;
            if (blocked <= 25) console.log('[BLOCK sigaction] sig=' + signum + ' from ' + caller);
            args[0] = ptr(0);   // 非法 signum -> sigaction 失败，处理器不会被安装
        }
    }
});

var sigFn = Module.getGlobalExportByName('signal');
if (sigFn) {
    Interceptor.attach(sigFn, {
        onEnter: function (args) {
            var s = args[0].toInt32();
            var caller = modOf(this.returnAddress);
            if (FATAL.indexOf(s) !== -1 && BLOCK_CALLERS.indexOf(caller) !== -1) {
                console.log('[BLOCK signal] sig=' + s + ' from ' + caller);
                args[0] = ptr(0);
            }
        }
    });
}

console.log('[*] crash-handler blocker ready');
