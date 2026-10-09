'use strict';

function sym(a) { try { return DebugSymbol.fromAddress(a).toString(); } catch (e) { return String(a); } }

function btOf(ctx) {
    var out = [];
    try {
        out = Thread.backtrace(ctx, Backtracer.ACCURATE).map(sym);
    } catch (e) { /* ignore */ }
    if (out.length < 3) {
        try { out = Thread.backtrace(ctx, Backtracer.FUZZY).slice(0, 20).map(sym); } catch (e) {}
    }
    return out.join('\n');
}

Process.setExceptionHandler(function (details) {
    console.log('\n########## EXCEPTION ' + details.type + ' ##########');
    try { console.log('address=' + details.address); } catch (e) {}
    try { console.log('pc=' + sym(details.pc)); } catch (e) {}
    try {
        if (details.memory) {
            console.log('memory: ' + JSON.stringify(details.memory));
        }
    } catch (e) {}
    try { console.log('thread=' + (details.thread ? details.thread.name : '?')); } catch (e) {}
    try {
        if (details.context) console.log(btOf(details.context));
    } catch (e) { console.log('bt err ' + e); }
    console.log('########## END (swallowed) ##########');
    return true;   // 吞掉异常，让进程继续活着
});

var exitPtr = null;
try { exitPtr = Module.getGlobalExportByName('exit'); } catch (e) {}
if (exitPtr) {
    Interceptor.attach(exitPtr, {
        onEnter: function (args) {
            console.log('\n===== NATIVE exit(code=' + args[0].toInt32() + ') =====');
            console.log('returnAddress=' + sym(this.returnAddress));
            console.log('pc=' + sym(this.context.pc) + ' lr=' + sym(this.context.lr));
            console.log(btOf(this.context));
        }
    });
    console.log('[+] hooked exit');
}

console.log('[*] exception handler installed');
