'use strict';
// 干净版：只 hook 信号发送相关导出，记录调用者模块+偏移；不设异常处理器
function modOf(addr){ try { var m = Process.findModuleByAddress(addr); return m ? m.name : null; } catch(e){ return null; } }
function off(addr){
  var mods = Process.enumerateModules();
  for (var i=0;i<mods.length;i++){ var m=mods[i];
    if (addr.compare(m.base)>=0 && addr.compare(m.base.add(m.size))<0) return m.name+'+0x'+addr.sub(m.base).toString(16);
  }
  return addr.toString();
}
['kill','tgkill','raise','pthread_kill','sigqueue','syscall'].forEach(function(n){
  var fn = Module.getGlobalExportByName(n);
  if(!fn){ console.log('[-] no '+n); return; }
  Interceptor.attach(fn, { onEnter: function(args){
    var c = this.returnAddress;
    var cn = modOf(c);
    // 只关心来自 app 自身模块的调用
    if (!cn || cn==='libc.so' || cn==='libart.so' || cn.indexOf('frida')>=0) return;
    var sig = (n==='tgkill') ? args[2].toInt32() : (n==='kill'||n==='pthread_kill') ? args[1].toInt32() : args[0].toInt32();
    console.log('['+n+'] sig='+sig+' from '+off(c));
    console.log('  bt: ' + Thread.backtrace(this.context, Backtracer.FUZZY).slice(0,6).map(function(a){return off(a);}).join(' <- '));
  }});
});
console.log('[+] signal-sender hooks installed');
