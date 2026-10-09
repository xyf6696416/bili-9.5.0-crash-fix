#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
libbili.so 看门狗补丁器（通用定位版）

对 libbili.so 做两处等长补丁：
  A) 看门狗线程例程入口  -> ret     （线程一启动就返回，root/frida 探测与自杀全部不执行）
  B) 唯一的 `bl exit`    -> ret     （兜底）

补丁点不写死偏移，而是从 ELF 动态定位，因此可跨小版本复用：
  B: .text 中所有 `bl <PLT(exit)>`
  A: `bl <PLT(pthread_create)>` 之前，追踪 adrp/add 得到 x2（start_routine）的值

用法:
  python patch_libbili.py <input.apk> <output.apk>
  python patch_libbili.py --verify <libbili.so>
  python patch_libbili.py --locate <libbili.so>
"""
import argparse
import io
import shutil
import sys
import zipfile

try:
    from elftools.elf.elffile import ELFFile
    from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM, CS_OP_IMM, CS_OP_REG
except ImportError:
    sys.exit("缺少依赖: pip install pyelftools capstone")

RET = bytes.fromhex("c0035fd6")          # ret
EXIT_FUNCS = {"exit", "_exit", "abort", "_Exit", "quick_exit"}
THREAD_FUNCS = {"pthread_create"}


# ---------- ELF 解析 ----------
def load_elf(path):
    """先整体读入再构造 ELFFile：ELFFile 是惰性读取的，构造后再 f.read() 会拿到错位数据"""
    import io
    with open(path, "rb") as f:
        data = f.read()
    return ELFFile(io.BytesIO(data)), data


def plt_maps(elf):
    """返回 stub_addr -> 符号名, 以及 符号名 -> stub_addr"""
    dynsym = elf.get_section_by_name(".dynsym")
    rela = elf.get_section_by_name(".rela.plt")
    plt = elf.get_section_by_name(".plt")
    stub2sym, sym2stub = {}, {}
    if not (dynsym and rela and plt):
        return stub2sym, sym2stub
    base = plt["sh_addr"]
    entsz = plt["sh_entsize"] or 16
    for i, r in enumerate(rela.iter_relocations()):
        try:
            nm = dynsym.get_symbol(r.entry.r_info_sym).name
        except Exception:
            continue
        a = base + 16 * (i + 2)          # .plt 前两项是 .plt.hdr
        stub2sym[a] = nm
        sym2stub.setdefault(nm, a)
    return stub2sym, sym2stub


def text_range(elf):
    t = elf.get_section_by_name(".text")
    return t["sh_addr"], t["sh_offset"], t["sh_size"]


# ---------- 补丁点定位 ----------
def jni_onload_direct_calls(data, elf, window=0x1000):
    """JNI_OnLoad 函数体内直接 bl 到的 .text 地址集合（用于判定哪个线程属于看门狗）"""
    dynsym = elf.get_section_by_name(".dynsym")
    if not dynsym:
        return set()
    jn = None
    for s in dynsym.iter_symbols():
        if s.name == "JNI_OnLoad":
            jn = s["st_value"]
            break
    if jn is None:
        return set()
    taddr, toff, tsize = text_range(elf)
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    md.detail = True
    out = set()
    for ins in md.disasm(data[toff:toff + tsize], taddr):
        if ins.mnemonic == "bl" and jn <= ins.address <= jn + window:
            tgt = ins.operands[0].imm
            if taddr <= tgt < taddr + tsize:      # 排除 PLT 桩
                out.add(tgt)
    return out


def locate(data, elf, all_threads=False):
    stub2sym, sym2stub = plt_maps(elf)
    taddr, toff, tsize = text_range(elf)
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    md.detail = True
    code = data[toff:toff + tsize]

    exit_stubs = {a for a, s in stub2sym.items() if s in EXIT_FUNCS}
    pc_stubs = {a for a, s in stub2sym.items() if s in THREAD_FUNCS}

    ins_list = list(md.disasm(code, taddr))
    bl_targets = {ins.operands[0].imm for ins in ins_list if ins.mnemonic == "bl"}
    onload_calls = jni_onload_direct_calls(data, elf)

    def containing_func(addr):
        cands = [t for t in bl_targets if t <= addr]
        return max(cands) if cands else None

    sites = []
    for idx, ins in enumerate(ins_list):
        if ins.mnemonic != "bl":
            continue
        tgt = ins.operands[0].imm
        if tgt in exit_stubs:
            sites.append({"vaddr": ins.address, "kind": "exit-call",
                          "sym": stub2sym.get(tgt, "?")})
        elif tgt in pc_stubs:
            creator = containing_func(ins.address)
            routine = find_routine_x2(md, ins_list, idx)
            if routine is None:
                continue
            owned_by_onload = creator in onload_calls
            sites.append({"vaddr": routine, "kind": "watchdog-routine-entry",
                          "sym": f"pthread_create@0x{ins.address:x} <- 0x{creator:x}",
                          "from_jni_onload": owned_by_onload})

    seen, out = {}, []
    for s in sites:
        if s["vaddr"] in seen:
            continue
        seen[s["vaddr"]] = True
        out.append(s)
    return sorted(out, key=lambda x: x["vaddr"])


def find_routine_x2(md, ins_list, bl_idx, window=80):
    """回溯 bl pthread_create 之前的 adrp/add/mov 链，取 x2（start_routine）的值"""
    regs = {}

    def rn(op):
        return md.reg_name(op.reg)

    for j in range(max(0, bl_idx - window), bl_idx):
        ins = ins_list[j]
        m = ins.mnemonic
        ops = ins.operands
        try:
            if m == "adrp" and len(ops) == 2 and ops[1].type == CS_OP_IMM:
                regs[rn(ops[0])] = ops[1].imm
            elif m == "add" and len(ops) == 3 and ops[2].type == CS_OP_IMM:
                src = rn(ops[1])
                if src in regs:
                    regs[rn(ops[0])] = regs[src] + ops[2].imm
            elif m in ("mov", "orr") and len(ops) == 2 and ops[1].type == CS_OP_IMM:
                regs[rn(ops[0])] = ops[1].imm
        except Exception:
            continue
    for name in ("x2", "w2"):
        if name in regs:
            return regs[name]
    return None


# ---------- 校验 ----------
def read_so(path):
    """既接受 .so，也接受 APK（自动取出里面的 libbili.so）"""
    if zipfile.is_zipfile(path):
        with zipfile.ZipFile(path) as z:
            for n in z.namelist():
                if n.rsplit("/", 1)[-1] == "libbili.so":
                    return n, z.read(n)
        raise FileNotFoundError(f"{path} 里没有 libbili.so")
    with open(path, "rb") as f:
        return path, f.read()


def verify(path):
    name, data = read_so(path)
    elf = ELFFile(io.BytesIO(data))
    taddr, toff, _ = text_range(elf)
    print(f"[i] {path} :: {name}  .text vaddr=0x{taddr:x} off=0x{toff:x}")
    sites = locate(data, elf, all_threads=True)
    if not sites:
        print("[!] 未定位到任何补丁点（so 可能已被整体替换或版本差异过大）")
        return 1
    for s in sites:
        off = toff + (s["vaddr"] - taddr)
        cur = data[off:off + 4]
        state = "PATCHED (ret)" if cur == RET else "unpatched"
        tag = ""
        if s["kind"] == "watchdog-routine-entry":
            tag = "" if s.get("from_jni_onload") else "  [默认不停用]"
        print(f"  0x{s['vaddr']:x}  {s['kind']:24s} bytes={cur.hex()}  -> {state}{tag}")
    return 0


# ---------- 打补丁 ----------
def patch_so(data, kill_threads=True, all_threads=False):
    import io
    elf = ELFFile(io.BytesIO(data))
    taddr, toff, _ = text_range(elf)
    sites = locate(data, elf, all_threads=all_threads)
    if not sites:
        raise RuntimeError("未定位到补丁点")
    raw = data
    log = []
    for s in sites:
        if s["kind"] == "watchdog-routine-entry":
            if not kill_threads:
                continue
            if not all_threads and not s.get("from_jni_onload"):
                print(f"[SKIP] 0x{s['vaddr']:x} 线程例程不由 JNI_OnLoad 直接创建，"
                       f"停用它会破坏功能（用 --all-threads 强制）")
                continue
        off = toff + (s["vaddr"] - taddr)
        cur = raw[off:off + 4]
        if cur == RET:
            log.append((s["vaddr"], s["kind"], "already patched"))
            continue
        raw = raw[:off] + RET + raw[off + 4:]
        log.append((s["vaddr"], s["kind"], f"{cur.hex()} -> {RET.hex()}"))
    return raw, log


def patch_apk(src, dst, kill_threads=True, all_threads=False):
    zin = zipfile.ZipFile(src, "r")
    zout = zipfile.ZipFile(dst, "w", zipfile.ZIP_DEFLATED)
    total = 0
    for item in zin.infolist():
        data = zin.read(item.filename)
        base = item.filename.rsplit("/", 1)[-1]
        if base == "libbili.so":
            try:
                data, log = patch_so(data, kill_threads, all_threads)
                for v, kind, desc in log:
                    print(f"[PATCH] {item.filename} @0x{v:x}  {kind}: {desc}")
                    total += 1
            except Exception as e:
                print(f"[WARN] {item.filename} 补丁失败: {e}")
        zi = zipfile.ZipInfo(item.filename, date_time=item.date_time)
        zi.compress_type = item.compress_type
        zi.external_attr = item.external_attr
        zi.flag_bits = item.flag_bits & ~0x8
        zout.writestr(zi, data)
    zout.close()
    zin.close()
    print(f"[OK] 共打 {total} 处补丁 -> {dst}")
    return total


def main():
    ap = argparse.ArgumentParser(description="libbili.so 看门狗补丁器")
    ap.add_argument("input", nargs="?", help="输入 APK")
    ap.add_argument("output", nargs="?", help="输出 APK（未签名，需再 zipalign + apksigner）")
    ap.add_argument("--verify", metavar="SO", help="校验某个 libbili.so 的补丁状态")
    ap.add_argument("--locate", metavar="SO", help="只打印定位结果，不修改")
    ap.add_argument("--exit-only", action="store_true",
                    help="只把 bl exit 改成 ret（最小改动），不停用看门狗线程")
    ap.add_argument("--all-threads", action="store_true",
                    help="停用所有 pthread_create 例程（危险：可能打死应用，仅用于分析）")
    a = ap.parse_args()

    if a.verify:
        sys.exit(verify(a.verify))
    if a.locate:
        elf, data = load_elf(a.locate)
        for s in locate(data, elf, all_threads=True):
            tag = ""
            if s["kind"] == "watchdog-routine-entry":
                tag = "  [由 JNI_OnLoad 直接创建]" if s.get("from_jni_onload") else "  [非 JNI_OnLoad 直连 -> 默认不动]"
            print(f"  0x{s['vaddr']:x}  {s['kind']}  ({s['sym']}){tag}")
        return
    if not a.input or not a.output:
        ap.print_help()
        sys.exit(2)
    if not zipfile.is_zipfile(a.input):
        sys.exit(f"[!] {a.input} 不是有效的 APK/zip")
    n = patch_apk(a.input, a.output, kill_threads=not a.exit_only, all_threads=a.all_threads)
    if n == 0:
        sys.exit("[!] 该 APK 内没有找到 libbili.so，未做任何修改")


if __name__ == "__main__":
    main()
