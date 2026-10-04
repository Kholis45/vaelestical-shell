"""IPC test: tulis perintah ke file antrian, pastikan UI bereaksi.

Jalankan:  python tests/ipc_qml.py   (exit 0 = lolos)
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _harness import boot, warn_filter, cmd_path  # noqa: E402
from PySide6.QtCore import QTimer  # noqa: E402

CMD = cmd_path()
made_dir = False
parent = os.path.dirname(CMD)
if parent and not os.path.isdir(parent):
    os.makedirs(parent, exist_ok=True)
    made_dir = True
with open(CMD, "w", encoding="utf-8") as f:
    f.write("dash\ntheme\n")

app, eng, win, logs = boot()
assert win, "load gagal"


def dash():
    for c in win.children():
        if c.property("currentTab") is not None:
            return c
    return None


def finish():
    d = dash()
    dv = d.property("visible")
    lm = win.property("lightMode")
    print("dash.visible:", dv, "(expect False)")
    print("lightMode:", lm, "(expect True)")
    real = warn_filter(logs)
    print("NON-ENV-WARNINGS:", len(real))
    for w in real[:10]:
        print("QML:", w)
    ok = (dv is False) and (lm is True) and (len(real) == 0)
    try:
        os.remove(CMD)
        if made_dir and not os.listdir(parent):
            os.rmdir(parent)
    except Exception as e:
        print("CLEANUP:", e)
    print("IPC:", "PASS" if ok else "FAIL")
    sys.exit(0 if ok else 1)


QTimer.singleShot(1500, finish)
sys.exit(app.exec())
