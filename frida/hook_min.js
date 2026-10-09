'use strict';
// 干净实验：只 hook libbili.so 的 exit 调用点，不碰 libc、不设异常处理器
var tries = 0;
(function poll(){
  var m = Process.findModuleByName('libbili.so');
  if (m) {
    console.log('[+] libbili.so base=' + m.base);
    var n = 0;
    Interceptor.attach(m.base.add(0x8f1c), { onEnter: function(){
      console.log('[exit-site] HIT #' + (++n) + ' (patched=ret)');
    }});
    console.log('[+] hooks installed, waiting...');
    return;
  }
  if (tries++ > 800) { console.log('[-] libbili.so not loaded'); return; }
  setTimeout(poll, 50);
})();
