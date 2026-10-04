"""Soak test: interaksi acak + semua timer selama N detik.

Env SOAK_SECONDS (default 90; CI memakai 20).
Jalankan:  python tests/soak_qml.py   (exit 0 = lolos, 0 warning)
"""
import os
import random
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _harness import boot, warn_filter  # noqa: E402
from PySide6.QtCore import QObject, QPoint, QTimer, Qt  # noqa: E402
from PySide6.QtTest import QTest  # noqa: E402

SECS = int(os.environ.get("SOAK_SECONDS", "90"))
random.seed(20260517)

app, eng, win, logs = boot()
assert win, "load gagal"
PANELS = ("dashPanel", "controlPanel", "wallPanel", "settingsPanel",
          "utilsPanel", "gamingPanel", "loginPanel")


def by_name(n):
    return win.findChild(QObject, n)


def rnd_click():
    # klik acak di area aman (tengah jendela) + toggle acak
    QTest.mouseClick(win, Qt.LeftButton, Qt.NoModifier,
                     QPoint(random.randint(100, 1266), random.randint(100, 700)))
    dash = by_name("dashPanel")
    if dash is not None and random.random() < 0.5:
        dash.setProperty("visible", not dash.property("visible"))
    bar = None
    for c in win.children():
        if c.property("currentWorkspace") is not None:
            bar = c
    if bar is not None:
        bar.setProperty("currentWorkspace", random.randint(1, 4))
    for c in win.children():
        if c.property("currentTab") is not None:
            c.setProperty("currentTab", random.randint(0, 3))
    win.setProperty("barPosition",
                    random.choice(["left", "top", "bottom", "right"]))
    app.processEvents()


ticks = {"n": 0}


def tick():
    ticks["n"] += 1
    rnd_click()
    if ticks["n"] * 500 >= SECS * 1000:
        storm.stop()
        real = warn_filter(logs)
        print(f"SOAK {SECS}s ticks={ticks['n']} NON-ENV={len(real)}")
        for w in real[:15]:
            print("QML:", w)
        ok = len(real) == 0
        print("SOAK:", "PASS" if ok else "FAIL")
        sys.exit(0 if ok else 1)


storm = QTimer()
storm.setInterval(500)
storm.timeout.connect(tick)

QTimer.singleShot(1000, lambda: (print("soak start"), storm.start()))
QTimer.singleShot((SECS + 30) * 1000, app.quit)
sys.exit(app.exec())
