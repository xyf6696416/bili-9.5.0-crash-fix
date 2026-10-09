'use strict';
// 只关心来自 libbili.so 的致命调用；命中即打印调用点偏移
function modOf(addr){ try { var m = Process.findModuleByAddress(addr); return m ? m.name : null; } catch(e){ return null; } }
function biliOff(addr){ var m = Process.findModuleByName('libbili.so'); return m ? 'libbili+0x'+addr.sub(m.base).toString(16) : addr.toString(); }

function hookLibcExport(name, extra){
  var fn = Module.getGlobalExportByName(name);
  if(!fn){ console.log('[-] no export '+name); return; }
  Interceptor.attach(fn, { onEnter: function(args){
    var caller = modOf(this.returnAddress);
    if (caller !== 'libbili.so' && caller !== 'libbili_core.so') return;
    console.log('['+name+'] from '+biliOff(this.returnAddress)+(extra?(' '+extra(args)):''));
    try { console.log(Thread.backtrace(this.context, Backtracer.FUZZY).map(DebugSymbol.fromAddress).slice(0,8).join('\n')); } catch(e){}
  }});
}

Process.setExceptionHandler(function(d){
  console.log('[EXCEPTION] '+d.type+' at '+d.address+' pc='+d.context.pc+
     ' in '+(modOf(d.context.pc)||'?'));
  try { console.log(d.backtrace.map(DebugSymbol.fromAddress).slice(0,10).join('\n')); } catch(e){}
  return true;
});

['kill','tgkill','raise','abort','_exit','exit'].forEach(function(n){
  hookLibcExport(n, function(a){
    if(n==='kill'||n==='tgkill') return 'pid='+a[0]+' sig='+a[n==='tgkill'?2:1];
    if(n==='raise') return 'sig='+a[0];
    return '';
  });
});

var tries=0;
(function poll(){
  var m = Process.findModuleByName('libbili.so');
  if(m){
    console.log('[+] libbili.so base='+m.base);
    Interceptor.attach(m.base.add(0x8f1c), { onEnter: function(){
      console.log('[exit-site 0x8f1c] HIT (patched=ret)');
    }});
    // 看门狗线程入口：JNI_OnLoad 里 pthread_create 的 routine
    Interceptor.attach(m.base.add(0x7fe0), { onEnter: function(a){
      var r = a[2];   // pthread_create(pthread_t*, attr*, routine*, arg*) -> routine 是第 3 个参数
      console.log('[pthread_create] routine='+r+' off='+(r.sub(m.base).toString(16)));
      try {
        Interceptor.attach(r, { onEnter:function(){ console.log('[watchdog routine ENTER]'); },
                               onLeave:function(){ console.log('[watchdog routine LEAVE]'); }});
      } catch(e){ console.log('attach routine failed: '+e); }
    }});
    return;
  }
  if(tries++>600){ console.log('[-] libbili.so not loaded'); return; }
  setTimeout(poll,50);
})();
