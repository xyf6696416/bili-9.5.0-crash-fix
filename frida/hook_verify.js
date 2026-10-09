'use strict';
var tries = 0;
(function poll(){
  var m = Process.findModuleByName('libbili.so');
  if (m) {
    console.log('[+] libbili.so base=' + m.base);
    Interceptor.attach(m.base.add(0x8f1c), { onEnter: function(){ console.log('[!] watchdog exit-site reached (patched to ret)'); } });
    Interceptor.attach(m.base.add(0x7fe0), { onEnter: function(a){ console.log('[+] pthread_create routine=' + a[1]); } });
    return;
  }
  if (tries++ > 600) { console.log('[-] libbili.so not loaded'); return; }
  setTimeout(poll, 50);
})();
setTimeout(function(){ console.log('[x] 60s survived, main pid=' + Process.id); }, 60000);
