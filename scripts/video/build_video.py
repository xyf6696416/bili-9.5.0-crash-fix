# -*- coding: utf-8 -*-
"""把录屏素材 + 证据卡 + 解说配音合成成一支 1920x1080 的演示视频。"""
import json, os, re, subprocess, sys

BASE = r"E:\nx\bili_video"
FFMPEG = r"C:\ProgramData\chocolatey\bin\ffmpeg.exe"
CFG = json.load(open(os.path.join(BASE, "narration.json"), encoding="utf-8"))

FPS = 30
W, H = 1920, 1080
VH = 900          # 手机画面高度，底部留出字幕带

# 每段的目标画面时长（视频段用素材切片长度，卡片段用配音长度）
SLICE = {
    "s03_cold":   ("seg1.mp4", 3.0, 12.0),
    "s04_feed":   ("seg2.mp4", 0.0, 11.0),
    "s05_detail": ("seg4.mp4", 6.0, 14.0),
    "s06_related":("seg4.mp4", 14.0, 23.5),
    "s07_story":  ("seg3.mp4", 2.0, 10.0),
}
LABEL = {
    "s03_cold":   "冷启动 进首页",
    "s04_feed":   "首页推荐信息流",
    "s05_detail": "播放页",
    "s06_related": "相关推荐列表",
    "s07_story":  "story 竖屏视频",
}


def probe_dur(path):
    out = subprocess.run([FFMPEG.replace("ffmpeg", "ffprobe"), "-v", "error",
                          "-show_entries", "format=duration",
                          "-of", "default=nw=1:nk=1", path],
                         capture_output=True, text=True).stdout.strip()
    return float(out)


def run(args):
    p = subprocess.run(args, capture_output=True, text=True, cwd=BASE)
    if p.returncode != 0:
        print("FFMPEG FAIL:", " ".join(args)[:400])
        print(p.stderr[-2500:])
        sys.exit(1)


def clause_split(text):
    """按标点切句，长句再按空格/斜杠拆，保证每条字幕不太长。"""
    parts = re.split(r"(?<=[，。：；、])", text)
    parts = [p.strip() for p in parts if p.strip()]
    out = []
    for p in parts:
        if len(p) <= 26:
            out.append(p)
            continue
        # 再按空格拆
        words, cur = p.split(), ""
        for w in words:
            if len(cur) + len(w) + 1 > 26:
                if cur:
                    out.append(cur)
                cur = w
            else:
                cur = (cur + " " + w).strip()
        if cur:
            out.append(cur)
    return out


def main():
    segs = CFG["segments"]
    tts = {s["id"]: os.path.join(BASE, "tts", s["id"] + ".mp3") for s in segs}
    adur = {k: probe_dur(v) for k, v in tts.items()}

    timeline = []   # (id, kind, dur, start)
    t = 0.0
    for s in segs:
        sid = s["id"]
        if sid in SLICE:
            dur = SLICE[sid][2] - SLICE[sid][1]
            if dur < adur[sid] + 0.6:      # 素材太短就拉长
                dur = adur[sid] + 0.6
        else:
            dur = adur[sid] + 0.4
        timeline.append((sid, s, dur, t))
        t += dur
    total = t
    print("total = %.2f s" % total)

    # ---- 逐段生成 clip ----
    clips = []
    for sid, s, dur, start in timeline:
        clip = os.path.join(BASE, "clips", sid + ".mp4")
        os.makedirs(os.path.dirname(clip), exist_ok=True)
        audio = tts[sid]

        if sid in SLICE:
            src, a, b = SLICE[sid]
            # 每段一个小标签文件
            lf = os.path.join(BASE, "clips", sid + ".label")
            open(lf, "w", encoding="utf-8").write(LABEL[sid])
            vf = (
                "[0:v]split=2[bg][fg];"
                "[bg]scale=%d:%d:force_original_aspect_ratio=increase,"
                "crop=%d:%d,boxblur=24:3,eq=brightness=-0.14:saturation=1.15[bgb];"
                "[fg]scale=-2:%d[fgs];"
                "[bgb][fgs]overlay=(W-w)/2:%d,"
                "drawtext=fontfile=msyh.ttc:"
                "textfile=clips/%s.label:fontsize=34:fontcolor=white:"
                "box=1:boxcolor=black@0.45:boxborderw=12:x=48:y=44,"
                "format=yuv420p[v]"
            ) % (W, H, W, H, VH, 20, sid)
            args = [FFMPEG, "-y", "-v", "error",
                    "-ss", "%.3f" % a, "-t", "%.3f" % dur,
                    "-i", os.path.join(BASE, src),
                    "-i", audio,
                    "-filter_complex", vf,
                    "-map", "[v]", "-map", "1:a",
                    "-af", "apad,aresample=44100",
                    "-t", "%.3f" % dur,
                    "-r", str(FPS), "-c:v", "libx264", "-preset", "medium",
                    "-crf", "20", "-pix_fmt", "yuv420p",
                    "-video_track_timescale", "30000",
                    "-c:a", "aac", "-b:a", "160k", "-ar", "44100", "-ac", "2",
                    clip]
        else:
            card = os.path.join(BASE, "cards", s["card"] + ".png")
            vf = ("scale=1968:1108,"
                  "crop=%d:%d:x='24*(1+sin(2*PI*t/17))':y='14*(1+cos(2*PI*t/17))',"
                  "format=yuv420p") % (W, H)
            args = [FFMPEG, "-y", "-v", "error",
                    "-loop", "1", "-t", "%.3f" % dur, "-i", card,
                    "-i", audio,
                    "-vf", vf,
                    "-r", str(FPS), "-c:v", "libx264", "-preset", "medium",
                    "-crf", "20", "-pix_fmt", "yuv420p",
                    "-video_track_timescale", "30000",
                    "-af", "apad,aresample=44100",
                    "-t", "%.3f" % dur,
                    "-c:a", "aac", "-b:a", "160k", "-ar", "44100", "-ac", "2",
                    clip]
        run(args)
        d = probe_dur(clip)
        print("clip %-12s target %.2f actual %.2f" % (sid, dur, d))
        clips.append(clip)

    # ---- concat ----
    lst = os.path.join(BASE, "clips", "list.txt")
    with open(lst, "w", encoding="utf-8") as f:
        for c in clips:
            f.write("file '%s'\n" % c.replace("\\", "/"))
    merged = os.path.join(BASE, "merged.mp4")
    run([FFMPEG, "-y", "-v", "error", "-f", "concat", "-safe", "0",
         "-i", lst, "-c", "copy", merged])

    # ---- ASS 字幕 ----
    ass = os.path.join(BASE, "subs.ass")
    with open(ass, "w", encoding="utf-8") as f:
        f.write("[Script Info]\nTitle: bili adblock demo\nScriptType: v4.00+\n"
                "PlayResX: %d\nPlayResY: %d\nWrapStyle: 0\nScaledBorderAndShadow: yes\n\n"
                % (W, H))
        f.write("[V4 Styles]\n"
                "Format: Name,Fontname,Fontsize,PrimaryColour,SecondaryColour,"
                "OutlineColour,BackColour,Bold,Italic,Underline,StrikeOut,"
                "ScaleX,ScaleY,Spacing,Angle,BorderStyle,Outline,Shadow,"
                "Alignment,MarginL,MarginR,MarginV,Layer\n"
                "Style: Default,Microsoft YaHei,48,&H00FFFFFF,&H00FFFFFF,"
                "&H00000000,&H80000000,-1,0,0,0,100,100,0,0,1,3,1,2,"
                "110,110,30,0\n\n")
        f.write("[Events]\nFormat: Layer,Start,End,Style,Name,MarginL,MarginR,MarginV,Effect,Text\n")
        for sid, s, dur, start in timeline:
            subs = s.get("sub") or s["text"]
            clauses = clause_split(subs)
            tot = sum(len(c) for c in clauses)
            # 配音结束后不再显示字幕：字幕只覆盖配音区间
            span = min(dur, adur[sid] + 0.3)
            cur = start
            for i, c in enumerate(clauses):
                d = span * len(c) / tot
                if d < 1.6:
                    d = 1.6
                end = min(start + span, cur + d) if i < len(clauses) - 1 else start + span
                if end <= cur:
                    end = cur + 0.4
                f.write("Dialogue: 0,%s,%s,Default,,0,0,0,,%s\n"
                        % (ass_time(cur), ass_time(end), c))
                cur = end
    print("ass written")

    final = os.path.join(BASE, "bili_adblock_demo.mp4")
    run([FFMPEG, "-y", "-v", "error", "-i", merged,
         "-vf", "ass=subs.ass",
         "-c:v", "libx264", "-preset", "slow", "-crf", "20",
         "-pix_fmt", "yuv420p", "-c:a", "copy", "-movflags", "+faststart",
         final])
    print("FINAL", final, os.path.getsize(final), "dur %.2f" % probe_dur(final))


def ass_time(sec):
    ms = int(round(sec * 100))
    h = ms // 360000
    ms -= h * 360000
    m = ms // 6000
    ms -= m * 6000
    s = ms // 100
    ms -= s * 100
    return "%d:%02d:%02d.%02d" % (h, m, s, ms)


main()
