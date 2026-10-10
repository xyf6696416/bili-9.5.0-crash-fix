import asyncio, json, os, sys
import edge_tts

BASE = r"E:\nx\bili_video"
cfg = json.load(open(os.path.join(BASE, "narration.json"), encoding="utf-8"))
voice = cfg["voice"]; rate = cfg["rate"]
outdir = os.path.join(BASE, "tts")
os.makedirs(outdir, exist_ok=True)

async def main():
    for seg in cfg["segments"]:
        out = os.path.join(outdir, seg["id"] + ".mp3")
        # 数字与英文保持原样朗读，语速略快
        c = edge_tts.Communicate(seg["text"], voice, rate=rate)
        await c.save(out)
        print("OK", seg["id"], os.path.getsize(out))

asyncio.run(main())
