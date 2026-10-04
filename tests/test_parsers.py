"""Unit test parser telemetri SysBridge (murni Python, tanpa Qt GUI).

Jalankan:  python tests/test_parsers.py   (exit 0 = lolos semua)
"""
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, REPO)

from run_shell import SysBridge

results = []


def check(name, cond):
    results.append(bool(cond))
    print(("PASS " if cond else "FAIL "), name)


P = SysBridge.parseActiveWorkspace
check("hypr ws id 3", P('{"id":3,"name":"3","monitor":"DP-1","windows":2}') == 3)
check("hypr ws kosong->None", P("") is None)
check("hypr ws rusak->None", P("not json") is None)
check("hypr ws tanpa id->None", P('{"name":"x"}') is None)

V = SysBridge.parseWpctlVolume
check("wpctl 0.78", V("Volume: 0.78") == (78, False))
check("wpctl muted", V("Volume: 0.00 [MUTED]") == (0, True))
check("wpctl 1.50 boost", V("Volume: 1.50") == (150, False))
check("wpctl kosong", V("") == (None, False))
check("wpctl sampah", V("blah") == (None, False))

N = SysBridge.parseNvidiaSmi
check("nvidia csv", N("55, 58, 1124, 2048\n")
      == {"load": 55, "temp": 58, "vramUsed": 1124, "vramTotal": 2048})
check("nvidia kosong->None", N("") is None)
check("nvidia pendek->None", N("55, 58\n") is None)

# brightness: sysfs tidak ada di semua mesin → uji rumus via stub
import glob as _glob

b = SysBridge()
b.readText = lambda p: {"cur": "1200", "mx": "1939"}[
    "cur" if p.endswith("brightness") and "max" not in p else "mx"]
_real_glob = _glob.glob
_glob.glob = lambda pat: ["/sys/class/backlight/intel_backlight"] \
    if "backlight" in pat else _real_glob(pat)
try:
    check("brightness 1200/1939->62", b.readBrightnessPct() == 62)
finally:
    _glob.glob = _real_glob
check("brightness tanpa sysfs->None", SysBridge().readBrightnessPct() is None)

ok = all(results)
print(f"PARSER: {sum(results)}/{len(results)}", "PASS" if ok else "FAIL")
sys.exit(0 if ok else 1)
