#!/usr/bin/env bash
# 一键构建：打补丁 -> zipalign -> apksigner 签名（Linux / macOS）
#
# 依赖:
#   python3 -m pip install pyelftools capstone
#   Android SDK build-tools（zipalign + apksigner）与 JDK 17
#   可通过环境变量 ANDROID_BUILD_TOOLS 指定 build-tools 目录
#
# 用法:
#   ./build.sh /path/to/哔哩哔哩.apk [输出目录]
set -euo pipefail

INPUT="${1:?用法: ./build.sh <输入APK> [输出目录]}"
OUTDIR="${2:-.}"
KEYPASS="${KEYPASS:-android}"
KEYALIAS="${KEYALIAS:-androiddebugkey}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PATCHER="$REPO_ROOT/scripts/patch_libbili.py"
NAME="$(basename "$INPUT")"; NAME="${NAME%.*}"

mkdir -p "$OUTDIR"
PATCHED="$OUTDIR/$NAME.patched.apk"
ALIGNED="$OUTDIR/$NAME.aligned.apk"
FINAL="$OUTDIR/$NAME.fixed.apk"

echo "[1/4] 打补丁 ..."
python3 "$PATCHER" "$INPUT" "$PATCHED"

echo "[2/4] 定位 build-tools ..."
BT="${ANDROID_BUILD_TOOLS:-}"
if [ -z "$BT" ]; then
  for c in "$HOME/Android/Sdk/build-tools" "$ANDROID_HOME/build-tools" "$HOME/Library/Android/sdk/build-tools"; do
    if [ -d "$c" ]; then
      BT="$(ls -d "$c"/* 2>/dev/null | sort | tail -1)"; break
    fi
  done
fi
if [ -z "$BT" ] || [ ! -x "$BT/zipalign" ]; then
  echo "未找到 zipalign。请安装 Android build-tools 或设置 ANDROID_BUILD_TOOLS。" >&2
  exit 1
fi
echo "     build-tools = $BT"

echo "[3/4] zipalign ..."
"$BT/zipalign" -f -v 4 "$PATCHED" "$ALIGNED" | tail -1

echo "[4/4] 签名 ..."
KS="$OUTDIR/debug.keystore"
if [ ! -f "$KS" ]; then
  echo "     生成临时 debug keystore: $KS"
  keytool -genkeypair -v -keystore "$KS" -alias "$KEYALIAS" \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass "$KEYPASS" -keypass "$KEYPASS" \
    -dname "CN=Android Debug,O=Android,C=US" 2>/dev/null
fi
cp -f "$ALIGNED" "$FINAL"
apksigner sign --ks "$KS" --ks-key-alias "$KEYALIAS" \
  --ks-pass "pass:$KEYPASS" --key-pass "pass:$KEYPASS" \
  --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true "$FINAL"
apksigner verify -v "$FINAL" | head -6

echo ""
echo "完成: $FINAL"
