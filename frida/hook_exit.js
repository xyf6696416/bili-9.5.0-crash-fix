// 抓 bilibili 主动退出(System.exit/halt/killProcess)的 Java 栈，并阻止退出
'use strict';

function jstack() {
    try {
        return Java.use('android.util.Log').getStackTraceString(Java.use('java.lang.Throwable').$new());
    } catch (e) {
        return 'stack unavailable: ' + e;
    }
}

Java.perform(function () {
    console.log('[*] hooks installing');

    // 1) System.exit
    try {
        var System = Java.use('java.lang.System');
        System.exit.implementation = function (code) {
            console.log('\n===== System.exit(' + code + ') BLOCKED =====');
            console.log(jstack());
            // 不调用 original，让进程活下来
        };
        console.log('[+] hooked java.lang.System.exit');
    } catch (e) { console.log('[-] System.exit hook fail: ' + e); }

    // 2) Runtime.exit / halt
    try {
        var Runtime = Java.use('java.lang.Runtime');
        ['exit', 'halt'].forEach(function (m) {
            try {
                Runtime[m].implementation = function (code) {
                    console.log('\n===== Runtime.' + m + '(' + code + ') BLOCKED =====');
                    console.log(jstack());
                };
                console.log('[+] hooked java.lang.Runtime.' + m);
            } catch (e) { console.log('[-] Runtime.' + m + ' fail: ' + e); }
        });
    } catch (e) { console.log('[-] Runtime hook fail: ' + e); }

    // 3) Process.killProcess / ProcessUtils.suicide
    try {
        var Proc = Java.use('android.os.Process');
        Proc.killProcess.implementation = function (pid) {
            console.log('\n===== Process.killProcess(' + pid + ') BLOCKED =====');
            console.log(jstack());
        };
        console.log('[+] hooked android.os.Process.killProcess');
    } catch (e) { console.log('[-] killProcess hook fail: ' + e); }

    try {
        var PU = Java.use('com.bilibili.droid.ProcessUtils');
        ['suicide', 'killOtherAllProcess'].forEach(function (m) {
            try {
                PU[m].overloads.forEach(function (ov) {
                    ov.implementation = function () {
                        console.log('\n===== ProcessUtils.' + m + ' BLOCKED =====');
                        console.log(jstack());
                    };
                });
                console.log('[+] hooked ProcessUtils.' + m);
            } catch (e) { console.log('[-] ProcessUtils.' + m + ' fail: ' + e); }
        });
    } catch (e) { console.log('[-] ProcessUtils not found: ' + e); }

    // 4) 记录 native 库加载，看加固库是否加载
    try {
        var R = Java.use('java.lang.Runtime');
        R.loadLibrary.implementation = function (name) {
            console.log('[lib] loadLibrary: ' + name);
            return this.loadLibrary(name);
        };
        console.log('[+] hooked Runtime.loadLibrary');
    } catch (e) { console.log('[-] loadLibrary hook fail: ' + e); }

    // 5) 抓未捕获异常
    try {
        var TH = Java.use('java.lang.Thread');
        var Uncaught = Java.use('java.lang.Thread$UncaughtExceptionHandler');
        var DefaultHandler = Java.use('com.bilibili.base.BiliApp');
    } catch (e) {}

    console.log('[*] hooks ready');
});
