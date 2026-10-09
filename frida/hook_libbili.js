'use strict';

function sym(a) { try { return DebugSymbol.fromAddress(a).toString(); } catch (e) { return String(a); } }

var bili = null;
try { bili = Process.getModuleByName('libbili.so'); } catch (e) { console.log('libbili not loaded yet: ' + e); }
if (bili) console.log('[libbili] base=' + bili.base + ' size=' + bili.size);

var exitPtr = Module.getGlobalExportByName('exit');
var count = 0;

Interceptor.attach(exitPtr, {
    onEnter: function (args) {
        count++;
        if (count > 6) return;
        console.log('\n===== exit(' + args[0].toInt32() + ') call#' + count + ' =====');
        var ra = this.returnAddress;
        console.log('returnAddress=' + ra + '  sym=' + sym(ra));
        if (bili) {
            console.log('offset in libbili.so = ' + ra.sub(bili.base) + '  (base=' + bili.base + ')');
        }
        console.log('lr=' + sym(this.context.lr) + '  pc=' + sym(this.context.pc));
        var bt = [];
        try { bt = Thread.backtrace(this.context, Backtracer.FUZZY).slice(0, 25); } catch (e) {}
        console.log(bt.map(sym).join('\n'));
    }
});

// 记录 libbili.so 何时被加载
var adle = null;
try { adle = Module.getGlobalExportByName('android_dlopen_ext'); } catch (e) {}
if (adle) {
    Interceptor.attach(adle, {
        onEnter: function (a) {
            var s = a[0].readCString();
            if (s && /libbili\.so|libbili_core/.test(s)) console.log('[dlopen] ' + s);
        }
    });
}

console.log('[*] exit-call-site tracer ready');
