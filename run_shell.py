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
# IPC Hyprland (main.qml membaca /tmp/vaelestical.cmd via XHR):
# baca file lokal via XHR dimatikan default di Qt6 — nyalakan di sini.
os.environ["QML_XHR_ALLOW_FILE_READ"] = "1"

from PySide6.QtGui import QGuiApplication  # noqa: E402
from PySide6.QtQml import QQmlApplicationEngine  # noqa: E402
from PySide6.QtCore import QObject, QUrl, Signal, Slot  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))


class SysBridge(QObject):
    """Jembatan perintah sistem untuk QML (diakses sebagai `Sys`).

    Semua kegagalan aman: execDetached menelan error ke stderr,
    execSync/readText mengembalikan string kosong, hasBin False.
    QML wajib memakai helper Theme.exec* agar tetap jalan di qmlscene
    (tanpa Sys → mode demo console.log).
    """

    polled = Signal(dict)  # {ws?, vol?, muted?, bri?, gpu?}

    @Slot(str, result=bool)
    def hasBin(self, name):
        import shutil
        return shutil.which(name) is not None

    @Slot(str, list)
    def execDetached(self, prog, args):
        import subprocess
        try:
            subprocess.Popen(
                [prog, *(args or [])],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        except Exception as e:
            print(f"[SysBridge] gagal menjalankan {prog}: {e}", file=sys.stderr)

    @Slot(str, list, result=str)
    def execSync(self, prog, args):
        import subprocess
        try:
            out = subprocess.run(
                [prog, *(args or [])],
                capture_output=True, text=True, timeout=3,
            )
            return (out.stdout or "").strip()
        except Exception:
            return ""

    @Slot(str, result=str)
    def readText(self, path):
        try:
            with open(path, encoding="utf-8", errors="replace") as f:
                return f.read().strip()
        except Exception:
            return ""

    # ---------------- polling telemetri ----------------
    @Slot(int)
    def startPolling(self, interval_ms=2000):
        from PySide6.QtCore import QTimer
        if getattr(self, "_poll_timer", None) is None:
            self._poll_timer = QTimer(self)
            self._poll_timer.timeout.connect(self._poll)
        self._poll_timer.start(max(500, int(interval_ms)))

    @Slot()
    def stopPolling(self):
        t = getattr(self, "_poll_timer", None)
        if t is not None:
            t.stop()

    def _poll(self):
        data = {}
        ws = self.parseActiveWorkspace(
            self.execSync("hyprctl", ["activeworkspace", "-j"]))
        if ws is not None:
            data["ws"] = ws
        vol, muted = self.parseWpctlVolume(
            self.execSync("wpctl", ["get-volume", "@DEFAULT_AUDIO_SINK@"]))
        if vol is not None:
            data["vol"] = vol
            data["muted"] = muted
        bri = self.readBrightnessPct()
        if bri is not None:
            data["bri"] = bri
        gpu = self.parseNvidiaSmi(self.execSync("nvidia-smi", [
            "--query-gpu=utilization.gpu,temperature.gpu,"
            "memory.used,memory.total",
            "--format=csv,noheader,nounits"]))
        if gpu is not None:
            data["gpu"] = gpu
        if data:
            self.polled.emit(data)

    # ---- parser murni (statis, unit-testable, tanpa I/O) ----
    @staticmethod
    def parseActiveWorkspace(json_text):
        import json
        try:
            return int(json.loads(json_text).get("id"))
        except Exception:
            return None

    @staticmethod
    def parseWpctlVolume(text):
        # "Volume: 0.78" / "Volume: 0.00 [MUTED]"
        import re
        m = re.search(r"Volume:\s*([0-9.]+)", text or "")
        if not m:
            return None, False
        try:
            pct = int(round(float(m.group(1)) * 100))
        except Exception:
            return None, False
        return pct, ("MUTED" in (text or ""))

    def readBrightnessPct(self):
        import glob
        try:
            cards = sorted(glob.glob("/sys/class/backlight/*"))
            if not cards:
                return None
            cur = self.readText(cards[0] + "/brightness")
            mx = self.readText(cards[0] + "/max_brightness")
            return int(round(float(cur) / float(mx) * 100))
        except Exception:
            return None

    @staticmethod
    def parseNvidiaSmi(csv_text):
        # "55, 58, 1124, 2048\n" -> dict
        try:
            parts = [p.strip() for p in csv_text.strip().split(",")]
            load, temp, used, total = (int(float(p)) for p in parts[:4])
            return {"load": load, "temp": temp,
                    "vramUsed": used, "vramTotal": total}
        except Exception:
            return None


def main() -> int:
    app = QGuiApplication(sys.argv)
    eng = QQmlApplicationEngine()
    eng.addImportPath(HERE)
    eng.rootContext().setContextProperty("Sys", SysBridge(app))
    eng.load(QUrl.fromLocalFile(os.path.join(HERE, "main.qml")))
    if not eng.rootObjects():
        print("Gagal memuat main.qml — lihat pesan Qt di atas.", file=sys.stderr)
        return 2
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
