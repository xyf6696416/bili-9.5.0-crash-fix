'use strict';

// 监控文件访问，判断是 root/hook 检测还是签名校验
var PAT = /su$|\/su\/|magisk|lspd|lsposed|xposed|taichi|zygisk|shamiko|\/proc\/mounts|\/proc\/maps|\/proc\/status|busybox|\/dev\/pts|Superuser|supersu|kernel|remount|\/system\/xposed|frida|\/proc\/self|\/data\/data|\.RSA|META-INF|packages\.info|\/proc\/pid|\/sys\/class|ro\.boot|getprop/i;
var seen = {};
var n = 0;

function report(tag, path, caller) {
    if (!path) return;
    if (!PAT.test(path)) return;
    var key = tag + ' ' + path;
    if (seen[key]) return;
    seen[key] = 1;
    if (n < 60) { n++; console.log('[' + tag + '] ' + path + '   <- ' + caller); }
}

function callerOf(ra) {
    try { var s = DebugSymbol.fromAddress(ra); return s.moduleName ? (s.moduleName + '+' + s.offset) : String(ra); } catch (e) { return String(ra); }
}

['open', 'openat', 'fopen', 'stat', 'lstat', 'statx', 'access', 'faccessat', 'readlink', '__system_property_get'].forEach(function (name) {
    var p = null;
    try { p = Module.getGlobalExportByName(name); } catch (e) {}
    if (!p) return;
    Interceptor.attach(p, {
        onEnter: function (args) {
            // open/openat: 路径在第 1 或第 2 个参数
            var idx = (name === 'openat') ? 1 : 0;
            var path = null;
            try { path = args[idx].readCString(); } catch (e) {}
            report(name, path, callerOf(this.returnAddress));
        }
    });
    console.log('[+] hooked ' + name);
});

// 记录可疑 native 库加载
try {
    Interceptor.attach(Module.getGlobalExportByName('android_dlopen_ext'), {
        onEnter: function (a) {
            var s = a[0].readCString();
            if (s && /msaoaidsec|dexvmp|safemode|kntr|libbili\.so|libtf\.so|nirvana/.test(s)) console.log('[dlopen] ' + s);
        }
    });
} catch (e) {}

try {
    Interceptor.attach(Module.getGlobalExportByName('exit'), {
        onEnter: function (a) { console.log('[exit] ' + a[0].toInt32() + ' from ' + callerOf(this.returnAddress)); }
    });
} catch (e) {}

console.log('[*] probe ready');
