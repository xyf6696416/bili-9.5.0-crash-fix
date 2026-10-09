'use strict';

// 记录所有 sigaction 安装；阻止 Bugly 抢注致命信号处理器，让 debuggerd 生成真实 tombstone
var FATAL = [4, 6, 7, 8, 11];   // SIGILL SIGABRT SIGBUS SIGFPE SIGSEGV
var logged = 0;

function modOf(addr) {
    try {
        var m = Process.findModuleByAddress(addr);
        return m ? m.name : null;
    } catch (e) { return null; }
}

var sa = null;
try { sa = Module.getGlobalExportByName('sigaction'); } catch (e) {}
if (sa) {
    Interceptor.attach(sa, {
        onEnter: function (args) {
            var signum = args[0].toInt32();
            var actPtr = args[1];
            var handler = null;
            try { handler = actPtr.isNull() ? null : actPtr.readPointer(); } catch (e) {}
            var hm = handler ? modOf(handler) : null;
            var caller = modOf(this.returnAddress);
            if (logged < 60) {
                logged++;
                console.log('[sigaction] sig=' + signum + ' handler=' + handler + ' mod=' + hm + ' caller=' + caller);
            }
            if (hm === 'libBugly.so' && FATAL.indexOf(signum) !== -1) {
                console.log('   -> BLOCK Bugly handler for sig ' + signum);
                args[0] = ptr(0);   // 非法 signum，令 sigaction 失败
            }
        }
    });
    console.log('[+] hooked sigaction');
} else {
    console.log('[-] sigaction not found');
}

// 记录 signal() 简单注册
var sigFn = null;
try { sigFn = Module.getGlobalExportByName('signal'); } catch (e) {}
if (sigFn) {
    Interceptor.attach(sigFn, {
        onEnter: function (args) {
            var s = args[0].toInt32();
            var h = args[1];
            if (logged < 80) console.log('[signal] sig=' + s + ' handler=' + h + ' mod=' + (h ? modOf(h) : '?'));
            if (h && modOf(h) === 'libBugly.so' && FATAL.indexOf(s) !== -1) args[0] = ptr(0);
        }
    });
    console.log('[+] hooked signal');
}

console.log('[*] sigaction tracer ready');
