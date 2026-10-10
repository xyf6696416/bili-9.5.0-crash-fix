# -*- coding: utf-8 -*-
"""生成视频里用到的静态证据卡（1920x1080）。"""
import json, os
from PIL import Image, ImageDraw, ImageFont

BASE = r"E:\nx\bili_video"
CARDS = os.path.join(BASE, "cards")
os.makedirs(CARDS, exist_ok=True)

W, H = 1920, 1080
BG = (14, 17, 23)
FG = (233, 238, 245)
DIM = (140, 150, 165)
ACC = (0, 191, 165)      # 青绿
ACC2 = (255, 122, 145)   # 粉红
CODEBG = (22, 27, 36)

F = r"C:\Windows\Fonts\msyh.ttc"
FB = r"C:\Windows\Fonts\msyhbd.ttc"
FM = r"C:\Windows\Fonts\consolab.ttf"


def font(path, size):
    return ImageFont.truetype(path, size)


def base():
    im = Image.new("RGB", (W, H), BG)
    d = ImageDraw.Draw(im)
    # 顶部渐变条
    for x in range(W):
        t = x / W
        c = (int(ACC[0] * (1 - t) + ACC2[0] * t),
             int(ACC[1] * (1 - t) + ACC2[1] * t),
             int(ACC[2] * (1 - t) + ACC2[2] * t))
        d.line([(x, 0), (x, 6)], fill=c)
    return im, d


def header(d, kicker, title):
    d.text((90, 70), kicker, font=font(F, 30), fill=ACC)
    d.text((90, 118), title, font=font(FB, 62), fill=FG)
    d.line([(90, 210), (W - 90, 210)], fill=(45, 52, 66), width=2)


def footer(d, note):
    d.text((90, H - 168), note, font=font(F, 28), fill=DIM)


def has_cjk(s):
    return any(ord(ch) > 0x2E7F for ch in s)


def code_font(s, size):
    # Consolas 没有中文字形，含中文的行改用雅黑，避免豆腐块
    return font(F if has_cjk(s) else FM, size)


def code_block(d, y, lines, size=34):
    lh = size + 16
    h = len(lines) * lh + 36
    d.rounded_rectangle([90, y, W - 90, y + h], radius=14, fill=CODEBG)
    for i, ln in enumerate(lines):
        col = FG
        if ln.startswith("+"):
            col = (120, 226, 170)
        elif ln.startswith("-"):
            col = (240, 130, 140)
        elif ln.startswith("#") or ln.startswith("//"):
            col = DIM
        d.text((124, y + 22 + i * lh), ln, font=code_font(ln, size), fill=col)
    return y + h


def bullets(d, y, items, size=36):
    for it in items:
        d.ellipse([96, y + 14, 112, y + 30], fill=ACC)
        d.text((136, y), it, font=font(F, size), fill=FG)
        y += size + 26
    return y


def build():
    # 1 开场
    im, d = base()
    d.text((90, 250), "BILIBILI 9.5.0", font=font(FB, 110), fill=FG)
    d.text((90, 380), "去广告版 · 模拟器实测", font=font(FB, 66), fill=ACC)
    bullets(d, 520, [
        "开屏广告  ColdSplashWrapper / HotSplashActivity",
        "信息流广告  PegasusGsonParser 卡片丢弃",
        "播放页广告  /x/v2/view/ad/ 请求拦截",
        "暂停广告  AdPanelRepository.showPanel 关闭",
    ], 40)
    footer(d, "Android 15 emulator · tv.danmaku.bili 9.5.0")
    im.save(os.path.join(CARDS, "open.png"))

    # 2 背景
    im, d = base()
    header(d, "背景", "先修闪退，再谈去广告")
    y = bullets(d, 250, [
        "样本 versionCode 9050300，30 个 dex，minSdk 24 / targetSdk 35",
        "原始包里没有任何去广告代码：无注入 dex，无 xposed / frida / zygisk 库",
        "闪退来自 libbili.so 的 native 看门狗，两处等长补丁修好",
    ], 36)
    code_block(d, y + 20, [
        "lib/arm64-v8a/libbili.so",
        "0x0a71c   fc 6f ba a9  ->  c0 03 5f d6",
        "0x08f1c   09 fd ff 97  ->  c0 03 5f d6",
        "0x24570   不动（改了会崩）",
    ], 34)
    footer(d, "Release v9.5.0-fixed")
    im.save(os.path.join(CARDS, "bg.png"))

    # 3 暂停广告
    im, d = base()
    header(d, "暂停广告", "所有面板只过一个总闸")
    code_block(d, 250, [
        "// classes14: 显示闸门直接关闭",
        "AdPanelRepository.showPanel(int, IPanelData, IAdPanelListener)",
        "+   return-void        # ADKILL_PAUSED_PANEL",
        "",
        "// AdRepository$a 实现 IPanelCallback，同样关闭",
        "AdRepository$a.showPanel(...)",
        "+   return-void        # ADKILL_PAUSED_PANEL_CB",
    ], 32)
    y = bullets(d, 620, [
        "DDConfig.getPausePageEnable() 写死 false，暂停页流程第一步就退出",
        "getVdEndPageKntr() / getPanelEnableGameWeb() 一并置 false",
    ], 34)
    footer(d, "PausedPageService.o() 首条指令即读取该开关")
    im.save(os.path.join(CARDS, "paused.png"))

    # 4 开屏
    im, d = base()
    header(d, "开屏广告", "冷启动与热启动两条路都断")
    code_block(d, 250, [
        "// classes21: 冷启动广告是在 MainActivity 里挂上来的",
        "ColdSplashWrapper.a(AppCompatActivity, ViewGroup): boolean",
        "+   return false       # ADKILL_COLD_SPLASH",
        "",
        "// 热启动开屏页直接结束",
        "HotSplashActivity.onCreate(Bundle)",
        "+   finish(); return;  # ADKILL_HOT_SPLASH",
    ], 32)
    y = bullets(d, 620, [
        "调用方只有 MainActivityV2 与 b0 两处，改动面很小",
        "配合 /x/v2/splash/* 请求拦截，缓存素材也不会再展示",
    ], 34)
    footer(d, "InterceptUserProtocolActivity 是隐私协议页，不动")
    im.save(os.path.join(CARDS, "splash.png"))

    # 5 日志证据
    im, d = base()
    header(d, "证据", "整轮测试的拦截统计")
    stats = [("BLOCK", "125"), ("ADROP", "4"), ("splash 接口", "4 个")]
    x = 90
    for name, val in stats:
        d.rounded_rectangle([x, 250, x + 540, 420], radius=16, fill=CODEBG)
        d.text((x + 34, 280), val, font=font(FB, 76), fill=ACC)
        d.text((x + 34, 366), name, font=font(F, 32), fill=DIM)
        x += 570
    code_block(d, 470, [
        "/data/data/tv.danmaku.bili/files/adblock_obs.log",
        "BLOCK  https://cm.bilibili.com/...",
        "BLOCK  /x/v2/splash/show      /x/v2/splash/list",
        "BLOCK  /x/v2/splash/brand/list  /x/v2/splash/event/list2",
        "ADROP  large_cover_v9   small_cover_v2 x3",
    ], 32)
    footer(d, "这个应用里 Log.i 不进 logcat，验证走自建日志文件")
    im.save(os.path.join(CARDS, "log.png"))

    # 6 交付
    im, d = base()
    header(d, "交付", "源码可编译，包可直接下")
    y = bullets(d, 250, [
        "github.com/xyf6696416/bili-9.5.0-crash-fix",
        "Release v9.5.0-adblock-beta2  ·  220 MB  ·  v2 + v3 签名",
        "补丁脚本与改过的 smali 全部在仓库里，可自己重编译",
        "去广告是逐方法关闭，不整包删 ad 模块：147 处引用会直接 NoClassDefFoundError",
    ], 36)
    code_block(d, y + 20, [
        "apktool b  ->  patch_libbili.py  ->  zipalign -p 4",
        "  ->  apksigner sign --v2 --v3  ->  adb install -r -t",
    ], 32)
    footer(d, "仅用于自有设备与实验环境")
    im.save(os.path.join(CARDS, "ship.png"))

    print("cards:", os.listdir(CARDS))


build()
