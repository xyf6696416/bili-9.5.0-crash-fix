'use strict';

var mypid = Process.id;
var FATAL = { 6: 'SIGABRT', 9: 'SIGKILL', 11: 'SIGSEGV', 13: 'SIGPIPE', 15: 'SIGTERM' };
var logCount = 0;

function logOnce(msg) {
    logCount++;
    if (logCount <= 12) console.log(msg);
}

// 1) 阻断 exit / _exit
var noopInt = new NativeCallback(function (code) {
    logOnce('[BLOCK] exit(' + code + ')');
}, 'void', ['int']);
try { Interceptor.replace(Module.getGlobalExportByName('exit'), noopInt); console.log('[+] replaced exit'); } catch (e) { console.log('exit: ' + e); }
try { Interceptor.replace(Module.getGlobalExportByName('_exit'), noopInt); console.log('[+] replaced _exit'); } catch (e) { console.log('_exit: ' + e); }

// 2) 阻断 abort
var noopVoid = new NativeCallback(function () { logOnce('[BLOCK] abort()'); }, 'void', []);
try { Interceptor.replace(Module.getGlobalExportByName('abort'), noopVoid); console.log('[+] replaced abort'); } catch (e) { console.log('abort: ' + e); }

// 3) 阻断针对自身进程/线程的致命信号
var noopKill = new NativeCallback(function (pid, sig) {
    if (pid === mypid) logOnce('[BLOCK] kill(' + pid + ', ' + (FATAL[sig] || sig) + ')');
    else return realKill(pid, sig);
    return 0;
}, 'int', ['int', 'int']);

var noopTgkill = new NativeCallback(function (pid, tid, sig) {
    if (pid === mypid) logOnce('[BLOCK] tgkill(' + pid + ',' + tid + ', ' + (FATAL[sig] || sig) + ')');
    else return realTgkill(pid, tid, sig);
    return 0;
}, 'int', ['int', 'int', 'int']);

var realKill = null, realTgkill = null;
try {
    realKill = new NativeFunction(Module.getGlobalExportByName('kill'), 'int', ['int', 'int']);
    Interceptor.replace(Module.getGlobalExportByName('kill'), noopKill);
    console.log('[+] replaced kill');
} catch (e) { console.log('kill: ' + e); }
try {
    realTgkill = new NativeFunction(Module.getGlobalExportByName('tgkill'), 'int', ['int', 'int', 'int']);
    Interceptor.replace(Module.getGlobalExportByName('tgkill'), noopTgkill);
    console.log('[+] replaced tgkill');
} catch (e) { console.log('tgkill: ' + e); }

// 4) 观察 libbili.so 校验线程
try {
    var bili = Process.getModuleByName('libbili.so');
    console.log('[libbili] base=' + bili.base);
    [0x8da0, 0xd23c, 0x8f20].forEach(function (off) {
        Interceptor.attach(bili.base.add(off), { onEnter: function () { logOnce('[libbili] +0x' + off.toString(16)); } });
    });
} catch (e) { console.log('libbili: ' + e); }

console.log('[*] anti-suicide ready, pid=' + mypid);
