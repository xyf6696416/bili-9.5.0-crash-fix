# 哔哩哔哩 9.5.0 闪退修复报告（定稿 v2）

## 结论

闪退**不是重打包/签名问题**，而是 APK 自带的 **native ROOT/反调试看门狗线程**主动自杀。
已用 **8 字节二进制补丁**让该线程一启动就返回，修复包在本机（已 root 的 OnePlus/OPPO PKX110，Android 16）稳定运行，**且 Frida 注入下也不再闪退**。

**产物：`E:\nx\bili_decode\哔哩哔哩_9.5.0_已修复.apk`**（201.6 MB，v2+v3 签名，已装机验证）

---

## 样本画像

| 项 | 值 |
|---|---|
| 包名 / 版本 | `tv.danmaku.bili` 9.5.0 (versionCode 9050300) |
| minSdk / targetSdk | 24 / 35 |
| 原始文件 | `C:\Users\Administrator\Downloads\哔哩哔哩.apk.1`（203,302,151 B，25233 个 zip 条目） |
| 签名状态 | META-INF 无 `.RSA/.DSA/.SF` → **未签名**（改过后未重签） |
| 启动 Activity | `tv.danmaku.bili/.MainActivityV2` |
| 保护组件 | `libdexvmp.so`(dex 虚拟化)、`libmsaoaidsec.so`、`libkntr.so`、`libtf.so`、`libnirvana.so`、`libsafemode.so` |
| 解包产物 | `E:\nx\bili_decode\apktool\`（smali×30 + res + lib）、`E:\nx\bili_decode\jadx\`（150702 个 .java） |

---

## 崩溃机制（证据链）

1. **不是 Java 崩溃**：`MainActivityV2` 已到 `HAS_DRAWN`，5–25 s 后主进程消失。
   `I Zygote : Process N exited cleanly (0)` + `WINDOW DIED Window{...MainActivityV2}`，
   无 `AndroidRuntime` FATAL、无 dropbox、无系统 tombstone。
2. Java 层 `System.exit` / `Runtime.halt` / `Process.killProcess` / `ProcessUtils.suicide` hook **全部不触发** → 退出在 native。
3. Frida 抓到唯一一次退出：
   ```
   ===== exit(0) call#1 =====
   returnAddress = libbili.so + 0x8f20
   backtrace: libbili.so+0x8f18 ← +0xd23c ← +0x8da0 ← libc.so!_ZL15__pthread_startPv
   ```
4. **对照实验**：把**完全未改动**的原始 APK 直接用 debug key 重签安装，同样 ~10 s 闪退
   → apktool 重打包不是原因，**设备 root 才是触发条件**。

---

## libbili.so 逆向结果

- 834,760 B，已 strip：75 个 PLT 导入、356 个导出，真实导出只有 `JNI_OnLoad`(0x84ac) / `JNI_OnUnload`(0x8f20)，其余全是 OLLVM 的 `.datadiv_decode*` 字符串解码桩（所以 `strings` 几乎无输出，su 路径等字符串运行时才解码）。
- OLLVM 控制流平坦化 + 不透明常量（例：`mov w10,#0x7ec4; movk w10,#0xa377,lsl #16` → 状态常量 `0xa3777ec4`）。
- **全库只有 1 处 `bl exit`**（`0x8f1c`），前一条 `bl sleep`，再前 `mov w0, wzr` → `sleep(); exit(0)`。
- **全库没有任何 `kill/tgkill/raise/abort` 导入，也没有 `svc` 指令** → 自杀只走 `exit`。
- 看门狗线程创建点：`0xa68c: bl pthread_create`，参数 `x0=&tid, x1=0, x2=0xa71c, x3=arg`
  → **线程例程入口 = `libbili.so + 0xa71c`**（`stp x28,x27,[sp,#-0x60]!` 标准序言，栈帧 0x580）。

### 看门狗运行时行为面（只 hook libbili.so 自身 PLT 桩抓到）

```
fopen  /system/bin/su   /system/xbin/su   /su/bin/su   /sbin/su
fopen  /data/local/xbin/su  /system/sd/xbin/su  /data/local/su  /system/bin/failsafe/su
__system_property_get  ro.build.version.release / ro.serialno
pthread_create  -> 看门狗线程 @+0xa71c
fopen  /proc/<pid>/status   -> TracerPid 调试器检测
fopen  /proc/net/tcp        -> Frida 27042 等监听端口检测
fopen  /proc/<pid>/maps     -> frida-agent / xposed / zygisk 注入库检测
getaddrinfo api.bilibili.com:80 -> socket(AF_INET6,SOCK_STREAM) -> connect -> send -> recv(0x800)
（再扫一轮 /proc）
time(); srand(); rand(); sleep(); exit(0)     # 随机化休眠后自杀
```

---

## 补丁（v2，共 2 处 / 8 字节）

`lib/arm64-v8a/libbili.so`：

| 偏移 | 原指令 | 改为 | 作用 |
|---|---|---|---|
| `0xa71c` | `fc6fbaa9` = `stp x28,x27,[sp,#-0x60]!`（看门狗线程例程首指令） | `c0035fd6` = `ret` | **线程一启动就返回，root/frida 探测与自杀全部不执行** |
| `0x8f1c` | `09fdff97` = `bl #0x8340`（PLT → `exit`） | `c0035fd6` = `ret` | 兜底：万一还有路径走到自杀点 |

- 两处都是 4 字节等长替换，so 尺寸不变，不影响 `JNI_OnLoad` 的 `RegisterNatives`，不破坏任何 JNI 接口。
- `0xa71c` 改 `ret` 时 sp 未动、x30 由 `__pthread_start` 设置，返回安全。
- 只改原始 APK 内这一个文件，其余 25232 个条目原样保留（不做 apktool 重建）。

补丁脚本：[patch_libbili_v2.py](E:\nx\bili_decode\patch_libbili_v2.py)

---

## 复现步骤

```powershell
python E:\nx\bili_decode\patch_libbili_v2.py                       # 替换原始 APK 内的 libbili.so

$bt = "C:\Users\Administrator\Tools\build-tools\android-13"
& "$bt\zipalign.exe" -f 4 E:\nx\bili_decode\patched2_unsigned.apk E:\nx\bili_decode\patched2_aligned.apk
java -jar "$bt\lib\apksigner.jar" sign --ks E:\nx\.dsh\skills\apk-reverse\debug.keystore `
  --ks-key-alias androiddebugkey --ks-pass pass:android --key-pass pass:android `
  --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true `
  E:\nx\bili_decode\patched2_aligned.apk

# 本机 Android 16 的 pm 不支持 -s；用 --no-streaming 走 push 安装，不弹 OPPO 确认框
adb -s 3B15C800RWN00000 install -r -t --no-streaming E:\nx\bili_decode\patched2_aligned.apk
```

## 验证结果

| 测试 | 结果 |
|---|---|
| `test_alive.ps1`（v1 补丁，`am start`，60 s 轮询） | 12/12 ALIVE，无崩溃指标 |
| `stress_test.ps1`（v2，launcher 冷启动 + 模拟点击/滑动/返回，180 s） | 9/9 采样 ALIVE，进程数 3→4，**无任何崩溃指标** |
| `frida_long_test.ps1`（v2，`frida -f` 注入下 150 s） | 10/10 采样 ALIVE，`exit` 点**再未命中**，无 tombstone |
| 设备侧字节校验（`su -c cp` 拉回已安装 so） | `0xa71c = c0035fd6`、`0x8f1c = c0035fd6` ✅ |
| 功能截图 | [bili_now.png](E:\nx\bili_decode\bili_now.png) 视频播放+弹幕；[bili_v2.png](E:\nx\bili_decode\bili_v2.png) 首页推荐流完整加载 |

压力日志里出现的 `exited due to signal 9` 全部核对为无关进程：`com.tencent.mm:support`、`com.oplus.phonenoareainquire`、`com.coloros.colordirectservice`、`com.oplus.blacklistapp`、`com.oplus.sau`、`com.qualcomm.qti.workloadclassifier`、webview 沙箱进程。

---

## 调试环境（真机 + adb + GUI，已可用）

- 设备：OnePlus/OPPO PKX110 (OP60F5L1)，Android 16 / SDK 36，arm64-v8a，已 root（Magisk `io.github.vvb2060.magisk`，`su -c id` → `uid=0(root) u:r:magisk:s0`）；`adb root` 不可用，一律 `su -c`。
- **序列号必须锁定**：本机现在挂着两台设备（`3B15C800RWN00000` 真机 + `127.0.0.1:7555`），所有命令加 `-s 3B15C800RWN00000`，否则 `adb: more than one device/emulator`。
- Frida 17.23.1：设备侧 `/data/local/tmp/android-services -l 0.0.0.0:44444 -D`（改名规避 anti-frida），`adb forward tcp:44444 tcp:44444`，PC 侧 `frida -H 127.0.0.1:44444`。
- 补丁后可直接 `frida -H 127.0.0.1:44444 -f tv.danmaku.bili -t 120 -l <script>`（`-t 120` 必需，否则 spawn 超时）。
- 踩过的坑：
  - Frida 17 移除了 `Module.findExportByName` → 用 `Module.getGlobalExportByName` 或 `Process.getModuleByName(...).findExportByName`；`Process.pid` → `Process.id`。
  - `pthread_create` 的**例程是第 3 个参数**（`args[2]`），`args[1]` 是栈上的 attr 指针 —— 拿它去 `Interceptor.attach` 会往栈里写跳转直接把 app 打崩（曾误判为"第二条杀死路径"）。
  - `Process.setExceptionHandler` 返回 `true` 会吞掉 ART 自身的 guard-page 异常，产生成千上万条 `boot.oat/libart.so` access-violation 并最终 `abort`（exit 127）—— 这是 instrumentation 自伤，不是目标崩溃。
  - 大范围 hook libc（open/stat/…）会让 app 崩在 `/memfd:frida-agent-64.so`，产生误导性 tombstone。hook 保持最小化。
  - PowerShell 脚本不要写中文注释（`字符串缺少终止符`）；`$pid`/`$PID` 是只读自动变量。

## 遗留限制

- 看门狗线程被整体停用，因此它原本向 `api.bilibili.com:80` 的那次上报也不再发出；服务端风控（`libkntr.so` / `libtf.so` / `kntr-*.blkv`）仍在进程内正常运行，账号层面的风控不受本补丁影响。
- 签名换成了 debug key，与官方签名不同：依赖官方签名校验的功能（部分支付/游戏 SDK、增量更新、备份恢复）可能受限；装官方新版前需 `adb uninstall tv.danmaku.bili`。
- `libdexvmp.so` / `libmsaoaidsec.so` 在观察窗口内未被加载，本次闪退与它们无关。

## 关键产物路径

| 文件 | 说明 |
|---|---|
| `E:\nx\bili_decode\哔哩哔哩_9.5.0_已修复.apk` | **最终交付包**（= patched2_aligned.apk） |
| `E:\nx\bili_decode\patch_libbili_v2.py` | 补丁脚本 |
| `E:\nx\bili_decode\installed_libbili_v2.so` | 从设备拉回的已打补丁 so（校验用） |
| `E:\nx\bili_decode\plt_map.py` / `find_watchdog_thread.py` / `disasm_jni_onload.py` | ELF PLT 解析与定位脚本 |
| `E:\nx\bili_decode\hook_watchdog_intel.js` / `hook_min.js` | Frida 脚本 |
| `E:\nx\bili_decode\stress_test.ps1` / `frida_long_test.ps1` / `test_alive.ps1` | 验证脚本 |
| `E:\nx\bili_decode\intel.txt` | 看门狗行为面完整日志（11067 行） |
