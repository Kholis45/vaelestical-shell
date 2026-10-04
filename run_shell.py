"""Launcher Vaelestical Shell REV 2.0 (setara pyside6-qml main.qml).

Pakai:  python run_shell.py
Di Windows perlu os.add_dll_directory agar plugin QML (Controls/Layouts)
ketemu oleh loader — ditangani di sini.
"""
import os
import sys

import PySide6

os.add_dll_directory(os.path.dirname(PySide6.__file__))
# Gaya kontrol yang mendukung kustomisasi (slider tebal custom).
# Di Linux/CachyOS default-nya sudah Basic; dipaksa di sini agar
# hasil di Windows identik dan tanpa warning native-style.
os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")

from PySide6.QtGui import QGuiApplication  # noqa: E402
from PySide6.QtQml import QQmlApplicationEngine  # noqa: E402
from PySide6.QtCore import QUrl  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))


def main() -> int:
    app = QGuiApplication(sys.argv)
    eng = QQmlApplicationEngine()
    eng.addImportPath(HERE)
    eng.load(QUrl.fromLocalFile(os.path.join(HERE, "main.qml")))
    if not eng.rootObjects():
        print("Gagal memuat main.qml — lihat pesan Qt di atas.", file=sys.stderr)
        return 2
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
