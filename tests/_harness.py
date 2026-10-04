"""Helper bersama suite uji headless (offscreen, tanpa display).

Pakai:
    from _harness import boot, REPO, warn_filter
    app, eng, win, logs = boot("main.qml")
    ...
    real = warn_filter(logs)   # [] berarti bersih
"""
import os
import sys

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
os.environ.setdefault("QT_QUICK_BACKEND", "software")
os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")
os.environ.setdefault("QML_XHR_ALLOW_FILE_READ", "1")

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, REPO)

import PySide6  # noqa: E402

if os.name == "nt":
    os.add_dll_directory(os.path.dirname(PySide6.__file__))

from PySide6.QtWidgets import QApplication  # noqa: E402
from PySide6.QtQuick import QQuickWindow  # noqa: E402,F401 (registrasi wrapper)
from PySide6.QtQml import QQmlApplicationEngine  # noqa: E402
from PySide6.QtCore import QUrl, qInstallMessageHandler  # noqa: E402
from PySide6.QtGui import QFontDatabase, QFont  # noqa: E402

_ENV_NOISE = ("QFontDatabase", "OpenThemeData")


def install_fonts(app):
    """Daftarkan font bila ada; di Linux CI dari paket fonts-dejavu."""
    cands = [
        os.path.join(os.environ.get("SystemRoot", r"C:\Windows"), "Fonts", "segoeui.ttf"),
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ]
    for p in cands:
        if not os.path.exists(p):
            continue
        try:
            fid = QFontDatabase.addApplicationFont(p)
            fams = QFontDatabase.applicationFontFamilies(fid) if fid >= 0 else []
            if fams:
                app.setFont(QFont(fams[0], 10))
                return True
        except Exception:
            continue
    return False


def boot(qml="main.qml"):
    logs = []

    def handler(mode, ctx, msg):
        logs.append((int(mode), f"{ctx.file}:{ctx.line} {msg}"))

    qInstallMessageHandler(handler)
    app = QApplication(sys.argv[:1])
    install_fonts(app)
    eng = QQmlApplicationEngine()
    eng.load(QUrl.fromLocalFile(os.path.join(REPO, qml)))
    roots = eng.rootObjects()
    return app, eng, (roots[0] if roots else None), logs


def warn_filter(logs):
    """Warning/error QML asli (mode>=Warning), minus noise environment."""
    return [m for (md, m) in logs
            if md >= 2 and not any(n in m for n in _ENV_NOISE)]


def cmd_path():
    """Samakan logika cmdFile di main.qml."""
    if os.name == "nt":
        return r"C:\Temp\vxvicfg.cmd"
    return "/tmp/vxvicfg.cmd"
