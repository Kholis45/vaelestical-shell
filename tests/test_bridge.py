"""Unit test SysBridge: slot aman + sinyal polling (tanpa biner asli).

Jalankan:  python tests/test_bridge.py   (exit 0 = lolos semua)
"""
import os
import sys

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, REPO)

from run_shell import SysBridge  # noqa: E402

results = []


def check(name, cond):
    results.append(bool(cond))
    print(("PASS " if cond else "FAIL "), name)


b = SysBridge()
check("hasBin python", b.hasBin(sys.executable) or b.hasBin("python"))
check("hasBin missing->False", b.hasBin("definitely-not-a-binary-xyz") is False)
check("execSync echo 42",
      b.execSync(sys.executable, ["-c", "print(42)"]) == "42")
check("execSync missing->''",
      b.execSync("definitely-not-a-binary-xyz", []) == "")
check("execSync timeout aman",
      b.execSync(sys.executable, ["-c", "import time; time.sleep(30)"]) == "")
try:
    b.execDetached("definitely-not-a-binary-xyz", [])
    check("execDetached missing no-raise", True)
except Exception:
    check("execDetached missing no-raise", False)
check("readText missing->''", b.readText(os.path.join(REPO, "nope.txt")) == "")

# Poller dengan exec stub (simulasi output Linux asli)
got = []
b2 = SysBridge()
b2.polled.connect(lambda d: got.append(d))
b2.execSync = lambda prog, args: {
    "hyprctl": '{"id":2,"name":"2"}',
    "wpctl": "Volume: 0.45",
    "nvidia-smi": "30, 51, 800, 2048",
}.get(prog, "")
b2._poll()
check("poll emit dict", len(got) == 1)
d = got[0] if got else {}
check("poll ws==2", d.get("ws") == 2)
check("poll vol==45 unmuted", d.get("vol") == 45 and d.get("muted") is False)
check("poll gpu load==30",
      isinstance(d.get("gpu"), dict) and d["gpu"]["load"] == 30)

ok = all(results)
print(f"BRIDGE: {sum(results)}/{len(results)}", "PASS" if ok else "FAIL")
sys.exit(0 if ok else 1)
