"""Interaction test: klik mouse & ketikan keyboard beneran via QTest.

Memakai hook debugGeom() di main.qml untuk koordinat ( engineered
karena PySide tidak melihat delegate Repeater via findChild ).
Jalankan:  python tests/interact_qml.py   (exit 0 = lolos)
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _harness import boot, warn_filter  # noqa: E402
from PySide6.QtCore import QObject, QPoint, QTimer, Qt  # noqa: E402
from PySide6.QtTest import QTest  # noqa: E402

app, eng, win, logs = boot()
assert win, "load gagal"
results = []


def check(name, cond):
    results.append(bool(cond))
    print(("PASS " if cond else "FAIL "), name)


def by_name(n):
    return win.findChild(QObject, n)


def center_of(name):
    g = win.debugGeom(name)
    if not g:
        return None
    x, y, w, h = (float(v) for v in g.split())
    return QPoint(int(x + w / 2), int(y + h / 2))


def click(name):
    p = center_of(name)
    if p is None:
        return False
    QTest.mouseClick(win, Qt.LeftButton, Qt.NoModifier, p)
    QTest.qWait(150)
    return True


def show_only(*names):
    for n in ("dashPanel", "controlPanel", "wallPanel", "settingsPanel",
              "utilsPanel", "gamingPanel", "loginPanel"):
        o = by_name(n)
        if o is not None:
            o.setProperty("visible", n in names)
    app.processEvents()
    QTest.qWait(200)


def find_text_start(prefix):
    for o in win.findChildren(QObject):
        try:
            if o.metaObject().className() == "QQuickText":
                t = o.property("text") or ""
                if isinstance(t, str) and t.startswith(prefix):
                    return o
        except Exception:
            pass
    return None


def go():
    dash = by_name("dashPanel")
    bar = by_name("sideBar")

    show_only("dashPanel")
    if click("wsDot2"):
        check("ws click -> currentWorkspace==3",
              bar.property("currentWorkspace") == 3)
    else:
        check("geom wsDot2", False)
    if click("tabPill2"):
        check("tab click -> currentTab==2", dash.property("currentTab") == 2)
    else:
        check("geom tabPill2", False)
    if click("tabPill0"):
        check("tab click -> currentTab==0", dash.property("currentTab") == 0)
    else:
        check("geom tabPill0", False)

    show_only("controlPanel")
    g = win.debugGeom("volSlider")
    check("geom volSlider", bool(g))
    if g:
        x, y, w, h = (float(v) for v in g.split())
        QTest.mouseClick(win, Qt.LeftButton, Qt.NoModifier,
                         QPoint(int(x + w * 0.75), int(y + h / 2)))
        QTest.qWait(200)
        v = float(by_name("volSlider").property("value"))
        check(f"vol groove click -> value~75 (dapat {v:.1f})", abs(v - 75) < 10)

    show_only("utilsPanel")
    win.requestActivate()
    if click("launchField"):
        lf = by_name("launchField")
        lf.setProperty("focus", True)
        for key in (Qt.Key_1, Qt.Key_2, Qt.Key_Asterisk, Qt.Key_8):
            QTest.keyClick(win, key)
            QTest.qWait(30)
        check("typing -> '12*8'", lf.property("text") == "12*8")
        btn = None
        for o in win.findChildren(QObject):
            try:
                cn = o.metaObject().className()
                if cn.startswith("Button") and o.property("text") == "Jalankan":
                    btn = o
                    break
            except Exception:
                pass
        check("find Jalankan", btn is not None)
        if btn is not None:
            p = btn.mapToScene(QPoint(float(btn.property("width")) / 2.0,
                                      float(btn.property("height")) / 2.0))
            QTest.mouseClick(win, Qt.LeftButton, Qt.NoModifier,
                             QPoint(int(p.x()), int(p.y())))
            QTest.qWait(150)
            out = find_text_start("= ")
            check("calc -> '= 96'",
                  out is not None and out.property("text") == "= 96")
    else:
        check("geom launchField", False)

    show_only("dashPanel")
    for _ in range(25):
        dash.setProperty("visible", not dash.property("visible"))
        app.processEvents()
    dash.setProperty("visible", True)
    check("storm 25x tanpa crash", True)

    real = warn_filter(logs)
    print("REAL-WARNINGS:", len(real))
    for w in real[:10]:
        print("QML:", w)
    check("nol warning QML", len(real) == 0)
    ok = all(results)
    print("INTERACT:", "PASS" if ok else "FAIL")
    sys.exit(0 if ok else 1)


QTimer.singleShot(1200, go)
QTimer.singleShot(60000, app.quit)
sys.exit(app.exec())
