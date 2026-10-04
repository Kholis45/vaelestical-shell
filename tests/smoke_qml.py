"""Smoke test: load + exercise seluruh panel, gerbang 0 warning QML.

Jalankan:  python tests/smoke_qml.py   (exit 0 = lolos)
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _harness import boot, warn_filter  # noqa: E402
from PySide6.QtCore import QTimer  # noqa: E402

app, eng, win, logs = boot()
print("ROOTS:", 1 if win else 0)
if not win:
    for _, m in logs[:20]:
        print("QT:", m)
    sys.exit(2)

TABS = (0, 1, 2, 3, 0)
WS = (1, 2, 3, 4, 1)
POS = ("left", "top", "bottom", "right", "left")


def exercise():
    for c in win.children():
        try:
            if c.property("visible") is not None:
                c.setProperty("visible", True)
        except Exception:
            pass
    for c in win.children():
        try:
            if c.property("currentTab") is not None:
                for t in TABS:
                    c.setProperty("currentTab", t)
                    app.processEvents()
            if c.property("currentWorkspace") is not None:
                for w in WS:
                    c.setProperty("currentWorkspace", w)
                    app.processEvents()
        except Exception as e:
            print("PROP-ERR:", e)
    for pos in POS:
        win.setProperty("barPosition", pos)
        app.processEvents()
    for lm in (True, False):
        win.setProperty("lightMode", lm)
        app.processEvents()
    print("EXERCISE DONE")


def finish():
    real = warn_filter(logs)
    print("NON-ENV-WARNINGS:", len(real))
    for w in real[:15]:
        print("QML:", w)
    ok = win is not None and not real
    print("SMOKE:", "PASS" if ok else "FAIL")
    sys.exit(0 if ok else 1)


QTimer.singleShot(800, exercise)
QTimer.singleShot(5000, finish)
sys.exit(app.exec())
