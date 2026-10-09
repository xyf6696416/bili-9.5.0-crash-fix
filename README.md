# 哔哩哔哩 9.5.0 闪退修复（root 设备上的 native 看门狗）

**目标**：`tv.danmaku.bili` 版本 `9.5.0`（versionCode `9050300`，minSdk 24 / targetSdk 35，arm64-v8a）
**症状**：冷启动约 10 秒后整个进程消失，**没有** `AndroidRuntime: FATAL EXCEPTION`，**没有**系统 tombstone，logcat 里只留下 `I Zygote : Process N exited cleanly (0)`。
**结论**：闪退与重打包、与签名都无关。真正原因是 `lib/arm64-v8a/libbili.so` 里一个 native **ROOT / 反调试看门狗线程**，探测到 root / tracer 后主动 `exit(0)` 自杀。
**修复**：对该 so 打两处 **4 字节等长**补丁，让看门狗线程一启动就返回，并兜底把唯一的 `bl exit` 改成 `ret`。

> 本仓库只包含分析脚本、补丁器、构建脚本与报告。**不包含、也不授权分发原始 APK。**
> 直接下载的成品 APK 放在本仓库的 Release 里，前提是你自己合法持有同一版本的原始安装包。
> 仅用于自有设备与获授权的安全研究。

---

## 1. 两种用法

### A. 直接下载成品（最快）

Release `v9.5.0-fixed` 提供成品：[bilibili_9.5.0_fixed.apk](https://github.com/xyf6696416/bili-9.5.0-crash-fix/releases/download/v9.5.0-fixed/bilibili_9.5.0_fixed.apk)（201.6 MB / 211437006 字节，已 zipalign、已用 debug key 做 v2+v3 签名）

```
SHA-256  08000111eb3d0c2c0dd263fa12d2cbb8e4ed8b66560629adea96d68f2f9ff87f
```

发布页：<https://github.com/xyf6696416/bili-9.5.0-crash-fix/releases/tag/v9.5.0-fixed>

```bash
# 卸载旧版（签名不同必须先卸载，否则 INSTALL_FAILED_UPDATE_INCOMPATIBLE）
adb -s <serial> uninstall tv.danmaku.bili

# 安装（Android 16 的 pm 已不支持 -s 选项；--no-streaming 可跳过部分厂商的安装确认弹窗）
adb -s <serial> install -r -t --no-streaming "bilibili_9.5.0_fixed.apk"
```

如果 `adb install` 报 `remote couldn't create file: Is a directory`（部分 adb/厂商组合下的已知问题），改用推送 + 本地安装：

```bash
adb -s <serial> push "bilibili_9.5.0_fixed.apk" /data/local/tmp/bili_fix.apk
adb -s <serial> shell pm install -r -t /data/local/tmp/bili_fix.apk
```

### B. 从源码自己编译

```powershell
# Windows
pwsh -File build/build.ps1 -InputApk "C:\path\to\哔哩哔哩_9.5.0.apk" -OutDir out -Install
```

```bash
# Linux / macOS
ANDROID_BUILD_TOOLS=/opt/android-sdk/build-tools/33.0.2 ./build/build.sh /path/to/bili.apk out
```

流程：`patch_libbili.py` 定位并打补丁 → `zipalign -p 4` → `apksigner sign`（v1/v2/v3，没有 keystore 时自动用 `keytool` 生成一个 debug keystore）。

自己编译出来的包 SHA-256 与 Release 里的成品不同是正常的：Release 成品用的是分析过程中那份 debug keystore，你自己构建时会新生成一份密钥，签名块不同。里面的 `lib/arm64-v8a/libbili.so` 与 Release 成品逐字节一致（可用 `python scripts/patch_libbili.py --verify` 或 `unzip -p 包 lib/arm64-v8a/libbili.so | sha256sum` 对照）。

---

## 2. 根因证据

### 2.1 排除签名/重打包

把**未修改的原始 APK** 用 debug key 重新签名后安装，同样在 ~10 秒闪退。
所以问题不在 apktool 重打包、不在签名方案，而在 native 层。

### 2.2 看门狗的真实行为

只 hook `libbili.so` 自己的 PLT 桩（不 hook libc，避免误伤 ART），抓到的完整行为序列：

```
fopen /system/bin/su          fopen /system/xbin/su      fopen /su/bin/su
fopen /sbin/su                fopen /data/local/xbin/su  fopen /data/local/su
fopen /system/sd/xbin/su      fopen /system/bin/failsafe/su
__system_property_get ro.build.version.release
__system_property_get ro.serialno
open /proc/<pid>/status        -> fgets 读 TracerPid
open /proc/net/tcp             -> 扫描（Frida 端口特征）
open /proc/<pid>/maps          -> 扫描注入库特征
getaddrinfo("api.bilibili.com", "80") -> socket -> connect -> send -> recv(0x800)
再次扫描 /proc
sleep(...)
exit(0)                       <- 唯一的 bl exit
```

完整原始日志见 [docs/logs/watchdog_behavior.txt](docs/logs/watchdog_behavior.txt)。

### 2.3 静态定位（OLLVM 平坦化 + 不透明常量，已 strip）

`lib/arm64-v8a/libbili.so`：834760 字节，`.text` vaddr == off `0x8470`，size `0xb85d8`；
`.plt` `0x7fa0` size `0x4d0`，75 条 `.rela.plt`，桩地址 `stub_i = 0x7fa0 + 16*(i+2)`（前两项是 `.plt.hdr`）。
真实导出只有 `JNI_OnLoad = 0x84ac`、`JNI_OnUnload = 0x8f20`，其余是 `.datadiv_decode*` 字符串解码桩。

关键事实：

| 项目 | 值 |
|---|---|
| 整个 `.text` 里 `bl exit` 的数量 | **只有 1 处：`0x8f1c`**（前面是 `0x8f14 bl sleep`、`0x8f18 mov w0, wzr`） |
| `kill` / `tgkill` / `raise` / `abort` 导入 | 无 |
| `svc` 指令 | 无 |
| `bl pthread_create` 调用点 | `0xa68c`（`x2 = 0xa71c`）、`0x24548`（`x2 = 0x24570`） |
| `JNI_OnLoad` 函数体内直接 `bl` 的 `.text` 目标 | `0xa630`、`0x155a4`、`0x1d814`、`0xa5474`、`0xaaa84` |

`0xa68c` 位于 `0xa630`，而 `0xa630` 被 `JNI_OnLoad` 直接调用 → **`0xa71c` 就是看门狗线程例程**。
另一个 `0x24570` 的创建者 `0x24500` 不在 `JNI_OnLoad` 的直接调用集合里，**它是应用功能线程，动它应用直接死**（实测：三处全打补丁后 5 秒即死，`pidof` 为空）。

---

## 3. 补丁点

等长替换，so 尺寸不变，`RegisterNatives` / JNI 接口不受影响。

| 地址 | 原始字节 | 指令 | 补丁后 | 作用 |
|---|---|---|---|---|
| `0xa71c` | `fc6fbaa9` | `stp x28,x27,[sp,#-0x60]!`（看门狗例程入口） | `c0035fd6` = `ret` | 线程一创建就立刻返回，root/frida 探测与自杀全部不执行 |
| `0x8f1c` | `09fdff97` | `bl #0x8340` = `bl exit` | `c0035fd6` = `ret` | 兜底：即使有其它路径走到这里也不会退出 |

只打 `0x8f1c`（v1）日常使用不闪退，但**在 Frida 附加下仍会死**（会发出 `SI_USER` 伪造的 SIGSEGV）；两处都打（v2）在 Frida 附加下也稳定。

**不要**打 `0x24570`。

---

## 4. 通用补丁器（不写死偏移）

`scripts/patch_libbili.py` 从 ELF 动态定位补丁点，可跨小版本复用：

```bash
# 只定位，不修改（.so 或 APK 都可以）
python scripts/patch_libbili.py --locate libbili.so
#   0x8f1c   exit-call                 (exit)
#   0xa71c   watchdog-routine-entry    (pthread_create@0xa68c <- 0xa630)  [由 JNI_OnLoad 直接创建]
#   0x24570  watchdog-routine-entry    (pthread_create@0x24548 <- 0x24500) [非 JNI_OnLoad 直连 -> 默认不动]

# 打补丁（输出未签名 APK，还需 zipalign + apksigner）
python scripts/patch_libbili.py 输入.apk 输出.apk

# 最小改动：只改 bl exit
python scripts/patch_libbili.py 输入.apk 输出.apk --exit-only

# 校验补丁状态
python scripts/patch_libbili.py --verify 输出.apk
#   0xa71c   watchdog-routine-entry   bytes=c0035fd6  -> PATCHED (ret)
#   0x24570  watchdog-routine-entry   bytes=ff4301d1  -> unpatched  [默认不停用]

# 危险开关：停用所有 pthread_create 例程（会打死应用，仅用于分析）
python scripts/patch_libbili.py 输入.apk 输出.apk --all-threads
```

定位逻辑：
1. 解析 `.rela.plt` + `.dynsym` 得到 PLT 桩 → 符号名映射；
2. 在 `.text` 里找所有 `bl <PLT(exit|_exit|abort)>` → 兜底补丁点；
3. 在 `.text` 里找所有 `bl <PLT(pthread_create)>`，回溯其前的 `adrp`/`add`/`mov` 链取出 `x2`（`start_routine`）→ 候选线程例程；
4. 只有**创建者函数被 `JNI_OnLoad` 直接调用**的例程才被视为看门狗并打补丁，其余打印 `[SKIP]`。

依赖：`pip install pyelftools capstone`（capstone 5 需要显式 `md.detail = True` 才能读 `operands`）。

---

## 5. 验证结果

| 场景 | 结果 |
|---|---|
| 无 Frida，180 秒 monkey 点击/滑动/按键压力 | 9/9 次采样进程存活，零崩溃指标 |
| Frida 附加（spawn 模式）150 秒 | 10/10 次采样存活，`0x8f1c` 从未命中 |
| 设备上拉回的 so 字节校验 | `0xa71c = c0035fd6`、`0x8f1c = c0035fd6` |
| 功能 | 首页信息流、视频播放、弹幕均正常（见 `docs/screenshots/`） |

崩溃判据（用来确认修复是否生效）：

```bash
adb -s <serial> logcat -d | Select-String "exited cleanly|exited due to signal|WINDOW DIED|AndroidRuntime: FATAL|Fatal signal|Process crashed"
adb -s <serial> shell pidof tv.danmaku.bili
```

正常时不应出现 `tv.danmaku.bili` 相关的 `exited cleanly (0)` / `WINDOW DIED`。
注意 B 站自己也会把 tombstone 写到 `/data/user/0/tv.danmaku.bili/files/tombstones/*native.crash.gz` 并通过 `upos://feedbackboss/...` 上传。

---

## 6. Frida 环境（复现分析用）

设备上的 frida-server 改名运行以规避反 frida 特征：

```bash
adb -s <serial> shell su -c "/data/local/tmp/android-services -l 0.0.0.0:44444 -D &"
adb -s <serial> forward tcp:44444 tcp:44444
frida -H 127.0.0.1:44444 -f tv.danmaku.bili -l frida/hook_watchdog_intel.js -t 120
```

**插桩要克制**：宽范围 hook libc 会让应用死在 `/memfd:frida-agent-64.so` 里并产生误导性 tombstone。
两个踩过的坑：
- `pthread_create` 的例程参数是 **`args[2]`**，不是 `args[1]`（`args[1]` 是栈上的 `pthread_attr_t*`，往它写跳转 = 写栈内存 = 崩）；
- 不要装 `Process.setExceptionHandler` 并返回 `true`，那会吞掉 ART 自己的 guard-page 缺页，制造成千上万条假异常最后 `abort`。

`frida/` 目录里保留了完整的试错过程，`hook_watchdog_intel.js`（只 hook libbili.so 自己的 PLT 桩）和 `hook_min.js`（只 attach `0x8f1c`）是最终可用的两个。

---

## 7. 目录结构

```
build/       build.ps1 / build.sh        一键 补丁 -> zipalign -> 签名 -> 安装
scripts/     patch_libbili.py            通用补丁器（推荐）
             plt_map.py                  PLT 桩 -> 符号映射
             find_exit_calls.py          扫描 exit 类调用点
             find_watchdog_thread.py     列出 pthread_create 调用点并反汇编创建函数
             disasm_jni_onload.py        JNI_OnLoad 调用图
             disasm.py sections.py libbili_intel.py libbili_exports.py
             manifest_parse.py manifest_attr.py
frida/       16 个 hook 脚本（含失败尝试，便于理解为什么某些做法会崩）
tools/       stress_test.ps1 test_alive.ps1 frida_long_test.ps1 min_test.ps1
             attach_hook.ps1 spawn_hook.ps1 start_frida_server.ps1
             sign_apk.ps1 install_and_log.ps1
docs/logs/   watchdog_behavior.txt       看门狗运行时行为原始记录
docs/screenshots/  home_feed.png video_player.png
FIX_REPORT.md                            完整报告
```

---

## 8. 已知限制

- 只针对 `libbili.so`（该 APK 只有 arm64-v8a，没有 armeabi-v7a 副本）。
- 偏移是 9.5.0 的实测值；其它版本请用 `--locate` 重新定位，通用定位依赖「创建者被 `JNI_OnLoad` 直接调用」这一启发式，新版本若改了调用结构需要人工复核。
- 补丁只压制了这个看门狗。B 站还有其它风控（服务端侧），root 设备上可能出现登录/播放相关的额外校验，这不属于本仓库范围。
- 若你走 apktool 反编译再重打包的路子：原始资源里 `res/layout/activity_following_publish_story.xml`、`activity_following_publish_story_v2.xml`、`item_following_card_ogv_season_single.xml` 各有一处非法的 `0x0` 属性值会让 `apktool b` 报 `'0x0' is incompatible with attribute layout_gravity/gravity`，需要删掉那三个属性；`res/values/attrs.xml` 里的 `value="0x0"` 是合法的 flag/enum，不要动。本仓库的构建脚本直接改 zip 内条目，不走 apktool，所以不受影响。

## 许可证

分析脚本与构建工具见 [LICENSE](LICENSE)。原始 APK 及其全部内容的权利属于其著作权人，本仓库不授予任何再分发权利。
