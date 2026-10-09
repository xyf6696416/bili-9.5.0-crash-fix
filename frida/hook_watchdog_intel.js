// 只 hook libbili.so 自己的 PLT 桩，观察看门狗到底在读什么/连什么
'use strict';
var M = null, base = null;
function stub(off, name, onEnterLog) {
  Interceptor.attach(base.add(off), {
    onEnter: function (args) {
      var s = '';
      try { s = onEnterLog(args); } catch (e) { s = 'err'; }
      console.log('[libbili:' + name + '] ' + s);
    }
  });
}
function cstr(p) { try { return p.isNull() ? 'null' : p.readCString(); } catch (e) { return '?'; } }

function install(m) {
  base = m.base;
  console.log('[+] libbili.so base=' + base);
  stub(0x83e0, 'fopen',  function (a) { return cstr(a[0]) + ' mode=' + cstr(a[1]); });
  stub(0x8000, 'open',   function (a) { return cstr(a[0]); });
  stub(0x8380, 'stat',   function (a) { return cstr(a[0]); });
  stub(0x8080, 'system', function (a) { return cstr(a[0]); });
  stub(0x83f0, 'socket', function (a) { return 'domain=' + a[0] + ' type=' + a[1] + ' proto=' + a[2]; });
  stub(0x83c0, 'connect',function (a) {
      var out = '';
      try { out = a[1].readCString(32); } catch (e) {}
      return 'fd=' + a[0] + ' sa=' + out;
  });
  stub(0x82f0, 'send',   function (a) {
      var n = a[2].toNumber(); var buf = '';
      try { buf = a[1].readUtf8String(Math.min(n, 160)); } catch (e) {}
      return 'fd=' + a[0] + ' len=' + n + ' data=' + JSON.stringify(buf);
  });
  stub(0x8240, 'recv',   function (a) { return 'fd=' + a[0] + ' len=' + a[2]; });
  stub(0x8460, 'getaddrinfo', function (a) { return 'host=' + cstr(a[0]) + ' service=' + cstr(a[1]); });
  stub(0x8440, 'sysprop', function (a) { return cstr(a[0]); });
  stub(0x81a0, 'fgets',  function (a) { return 'fd-stream'; });
  stub(0x7fe0, 'pthread_create', function (a) { return 'start_routine=' + a[1]; });
  stub(0x8370, 'dlopen', function (a) { return cstr(a[0]); });
  stub(0x8230, 'dlsym',  function (a) { return cstr(a[1]); });
  // 关键：exit 调用点 0x8f1c，打印上下文后放行
  Interceptor.attach(base.add(0x8f1c), {
    onEnter: function () {
      console.log('===== EXIT CALL @libbili+0x8f1c =====');
      try { console.log(Thread.backtrace(this.context, Backtracer.FUZZY).map(DebugSymbol.fromAddress).join('\n')); } catch (e) {}
    }
  });
}

var tries = 0;
(function poll() {
  var m = Process.findModuleByName('libbili.so');
  if (m) { install(m); return; }
  if (tries++ > 400) { console.log('[-] libbili.so never loaded'); return; }
  setTimeout(poll, 50);
})();
