# Vaelestical Shell REV 2.0

![Version](https://img.shields.io/badge/Version-REV%202.0-blue)
![Qt6](https://img.shields.io/badge/Qt%20Quick%206-Functional-brightgreen)
![Platform](https://img.shields.io/badge/Platform-Linux%20Universal-orange)
![Style](https://img.shields.io/badge/Style-Solid%20Material%20You%20M3-purple)

> Shell desktop Qt Quick 6 berestetika Caelestia dengan bahasa desain
> **Solid Material You M3 Expressive** — tanpa glassmorphism/blur,
> kontras tajam, rendering ringan.

---

## 📋 Kebutuhan Sistem

| Komponen | Minimal | Disarankan |
|----------|---------|------------|
| OS | Linux apa pun (CachyOS, Ubuntu 20.04+, Fedora 35+, Arch) | CachyOS / Arch |
| RAM | 4 GB | 8 GB |
| GPU | OpenGL 3.3+ | Akselerasi hardware aktif |
| Display | X11 / Wayland | Wayland (Hyprland) |

Dependensi runtime hanya **Qt 6**: `QtQuick`, `QtQuick.Controls`, `QtQuick.Layouts`.
Tidak ada plugin C++ — murni QML sehingga langsung jalan di `qmlscene`.

---

## 🚀 Instalasi

### 1. Install Qt 6 + Git sesuai distro

| Distro | Perintah |
|--------|----------|
| **CachyOS / Arch / Manjaro** | `sudo pacman -S --needed qt6-base qt6-declarative qt6-shadertools git` |
| **Ubuntu / Debian / Linux Mint** | `sudo apt install -y qmlscene qt6-base-dev qt6-declarative-dev git` |
| **Fedora / RHEL / CentOS** | `sudo dnf install -y qt6-qtbase qt6-qtdeclarative git` |
| **openSUSE** | `sudo zypper install -y qt6-base qt6-declarative git` |

> Paket `qmlscene` biasanya ikut dalam `qt6-declarative` / `qt6-base-dev`.
> Cek dengan: `qmlscene --version` (harus 6.x).

### 2. Clone repositori

```bash
git clone https://github.com/Kholis45/vaelestical-shell.git
cd vaelestical-shell
```

### 3. Jalankan — pilih salah satu metode

**Metode 1 — `qmlscene` (utama, Linux/CachyOS):**

```bash
qmlscene main.qml
```

> Jika slider custom tampil seperti slider bawaan (tidak tebal),
> paksa style yang mendukung kustomisasi:
> ```bash
> QT_QUICK_CONTROLS_STYLE=Basic qmlscene main.qml
> ```
> (Di Linux umumnya tidak perlu — default-nya sudah Basic.)

**Metode 2 — `run_shell.py` (PySide6, lintas platform):**

```bash
pip install PySide6
python run_shell.py
```

> Butuh Python 3.10+ dan `pip`. Launcher ini otomatis menangani
> pencarian DLL plugin QML di Windows, memaksa style Basic, dan
> menyalakan IPC Hyprland. Cocok untuk uji coba di Windows.

### 4. Verifikasi instalasi

```bash
qmlscene --version        # harus 6.x
python run_shell.py       # jendela shell terbuka = instalasi beres
```

Lanjut ke bagian Uji Coba Pertama dan Shortcut di bawah.

---

## ▶️ Uji Coba Pertama

Saat jendela terbuka (1366×768):

1. **Test-bar atas** — tombol toggle tiap panel:
   `Dash` • `Control` • `Wallpaper` • `Settings` • `Utils` • `Gaming` • `Lock`,
   plus ComboBox posisi bar (`left/top/bottom/right`) dan tombol `Light/Dark`.
2. **Sidebar kiri** — titik workspace 1–4 (klik untuk pindah), status pill,
   dan dot hijau berdenyut.
3. **Dashboard kanan** — Dynamic Island + 4 tab pill:
   `Dashboard` (jam live, cuaca, info sistem) • `Media` (kontrol + boost 150%)
   • `Performance` (CPU/GPU/RAM) • `Workspaces`.
4. **Shortcut keyboard** — tabel lengkap ada di bagian Shortcut di bawah:
   `Ctrl+D/W/C/S/U/G/L` saat window fokus, atau `Super+…` global via Hyprland.

Panel lain (`ControlCenter`, `WallpaperPicker`, `SettingsHub`, `UtilitiesAI`,
`GamingAudioAdvanced`, `LoginDashboard`) default tersembunyi — nyalakan
dari test-bar sesuai kebutuhan agar tidak bertumpuk.

---

## ⌨️ Shortcut

Dua lapis shortcut, sesuai konteks fokus:

### A. Dalam window shell (`Ctrl+…`, selalu tersedia)

Aktif saat window shell fokus. Toggle show/hide tiap panel
(terdaftar di `main.qml`, bisa diubah di blok `Shortcut`):

| Shortcut | Panel |
|----------|-------|
| `Ctrl+D` | Dashboard |
| `Ctrl+W` | Wallpaper picker |
| `Ctrl+C` | Control center |
| `Ctrl+S` | Settings |
| `Ctrl+U` | Utilities (+ launcher & kalkulator) |
| `Ctrl+G` | Gaming & audio advanced |
| `Ctrl+L` | Lockscreen / login |

### B. Global di Hyprland (`Super+…`, perlu didaftarkan)

**1. Source file binds yang sudah disediakan:**

```bash
# Tambahkan ke ~/.config/hypr/hyprland.conf (sesuaikan path clone):
source = ~/vaelestical-shell/hyprland/vaelestical-binds.conf
```

Isinya (`hyprland/vaelestical-binds.conf`):

| Bind | Perintah terkirim |
|------|-------------------|
| `Super+D` / `Super+K` | toggle dashboard / panel launcher (Utils) |
| `Super+W` | toggle wallpaper picker |
| `Super+C` | toggle control center |
| `Super+S` | toggle settings |
| `Super+U` | toggle utilities |
| `Super+G` | toggle gaming |
| `Super+L` | toggle lockscreen |
| `Super+Shift+T` | toggle tema gelap/terang |

**2. Cara kerja (IPC file-based, QML murni):** tiap bind menulis satu kata
ke `/tmp/vaelestical.cmd`; shell membaca file itu tiap 250ms dan toggle
panel yang sesuai. Tanpa shell yang jalan, bind tidak ngapa-ngapain
(terverifikasi end-to-end via smoke test).

**3. Wajib untuk metode `qmlscene`:** baca file lokal via XHR dimatikan
default di Qt6 — aktifkan di `hyprland.conf`:

```conf
env = QML_XHR_ALLOW_FILE_READ,1
```

(`python run_shell.py` sudah mengaturnya otomatis.)

**4. Autostart shell (opsional, di `hyprland.conf`):**

```conf
exec-once = qmlscene ~/vaelestical-shell/main.qml
# atau:
# exec-once = python ~/vaelestical-shell/run_shell.py
```

### C. Kustomisasi shortcut

- **Ubah/hapus bind global:** edit `hyprland/vaelestical-binds.conf`
  (format `bind = SUPER, <tombol>, exec, sh -c 'echo <perintah> >> /tmp/vaelestical.cmd'`),
  lalu `hyprctl reload`. Daftar perintah valid: `dash wall control settings
  utils gaming lock theme` (diterima di `handleCommand()` pada `main.qml`).
- **Ubah shortcut dalam window:** edit blok `Shortcut` di akhir `main.qml`
  (properti `sequence`), mis. `"Ctrl+D"` → `"F12"`.
- **Cek konflik:** bind menimpa bind default Hyprland untuk tombol yang sama;
  hapus baris yang bentrok dengan workflow-mu.

---

## 🎨 Kustomisasi Tema (Solid M3)

Semua warna, bentuk, tipografi & motion terpusat di **`modules/Theme.qml`**
(singleton Material 3 Expressive, otomatis dipakai semua modul):

| Kategori | Token | Contoh |
|----------|-------|--------|
| Warna | `primary…tertiary…error` + `Container`/`on…`, `surfaceContainer*`, `outline(Variant)`, `inverse*`, `scrim` | dark & light baseline M3 |
| Aksen proyek | `accent`, `active`, `success`, `warning` | `#a8c7fa` dkk. |
| Bentuk (resmi M3) | `shapeExtraSmall 4` → `shapeExtraLarge 28`, `shapeFull` | card = `shapeLarge` (16), pill = 99 |
| Tipografi | `displayMedium/Large`, `headlineSmall/Medium`, `titleSmall/Medium`, `bodySmall/Medium`, `labelSmall/Medium/Large` | dipakai via `font: Theme.titleSmall` |
| Motion M3 | `emphasized` cubic-bezier(0.05, 0.7, 0.1, 1.0), durasi `motionShort3/Short4…` | `easing.type: Easing.Bezier` |
| State layer | `stateHover 8%` / `statePressed 12%` via komponen `StateLayer` | overlay hover bawaan M3 |

Ganti mode gelap/terang dari UI (tombol `Light/Dark` atau switch di
`WallpaperPicker`) — seluruh shell ikut berubah via binding `Theme.dark`.
Tidak ada efek blur/kaca di mana pun; elevasi diganti shadow solid tipis.
Catatan: ikon masih glyph teks (font Material Symbols belum dibundel) —
satu-satunya bagian yang belum 100% M3.

---

## 📁 Struktur Proyek

```
vaelestical-shell/
├── main.qml                    # Entry point (test-bar + semua panel)
├── run_shell.py                # Launcher PySide6 (pengganti qmlscene)
├── hyprland/
│   └── vaelestical-binds.conf  # Keybind Super (source dari hyprland.conf)
├── generate_preview.py         # Generator mockup ui_preview.png (Pillow)
├── ui_preview.png              # Mockup 1920x1080
├── modules/
│   ├── qmldir                  # Registrasi modul + singleton Theme
│   ├── Theme.qml               # Singleton token M3E (warna, type, shape, motion)
│   ├── StateLayer.qml          # Overlay state-layer hover/press M3
│   ├── LeftSidebar.qml         # Module A - pill sidebar + workspace
│   ├── CentralDashboard.qml    # Module B - dashboard 4 tab + island
│   ├── WallpaperPicker.qml     # Module C - wallpaper + aksen M3
│   ├── ControlCenter.qml       # Module D - quick settings + slider tebal
│   ├── LoginDashboard.qml      # Module IV - lockscreen + form login
│   ├── SettingsHub.qml         # Module V - settings + readout sistem
│   ├── UtilitiesAI.qml         # Module E - clipboard, launcher, OSD, LLM…
│   └── GamingAudioAdvanced.qml # Module F - FPS HUD, EQ, AUR, VM, net…
└── README.md                   # File ini
```

---

## 🔧 Troubleshooting

| Gejala | Solusi |
|--------|--------|
| `command not found: qmlscene` | Install paket Qt 6 declarative sesuai tabel distro di atas |
| Layar hitam/blank | Cek driver GPU: `glxinfo \| grep "OpenGL renderer"` |
| Slider tampil bawaan (tidak tebal) | Jalankan dengan `QT_QUICK_CONTROLS_STYLE=Basic` |
| Error `Cannot load library ... qtquick*plugin.dll` (Windows) | Jangan pakai `pyside6-qml` mentah — gunakan `python run_shell.py` |
| `file ... Expected token` saat load | Pastikan `git status` bersih dari edit setengah jalan; file QML wajib 1 root object |
| Animasi patah-patah | Tutup aplikasi berat; shell ini tanpa blur/GPU-cache jadi ringan |
| Wayland gagal | Coba `QT_QPA_PLATFORM=xcb qmlscene main.qml` |

> Catatan backend: aksi sistem lewat **`Sys` (SysBridge di `run_shell.py`)**
> via helper `Theme.exec*` — mode `qmlscene` (tanpa `Sys`) otomatis fallback
> demo `console.log`. Yang sudah tersambung nyata: workspace Hyprland
> (`hyprctl dispatch`), kontrol media (`playerctl`), lock (`loginctl`),
> sleep/power (`systemctl`), screenshot (`grim`+`slurp`), volume (`wpctl`),
> brightness (`brightnessctl`), launcher aplikasi, plus polling telemetri
> (workspace aktif, volume/mute, brightness, NVIDIA) yang tersinkron ke UI.
> Sisanya (nmcli, bluetoothctl, PAM, AUR, dsb.) masih stub bertahap.

---

## ✅ Pengujian (tests/)

Suite otomatis di `tests/` (headless via Qt offscreen, jalan di CI):

| Suite | Isi | Perintah |
|-------|-----|----------|
| `test_parsers.py` | 14 unit test parser telemetri (hyprctl, wpctl, nvidia-smi, brightness + kasus rusak) | `python tests/test_parsers.py` |
| `test_bridge.py` | 11 unit test `SysBridge` (kegagalan aman, sinyal polling) | `python tests/test_bridge.py` |
| `smoke_qml.py` | Load + exercise semua panel/tab/workspace/posisi-bar/mode, gerbang 0 warning | `python tests/smoke_qml.py` |
| `interact_qml.py` | Klik mouse & ketikan keyboard beneran (QTest + hook `debugGeom`) | `python tests/interact_qml.py` |
| `ipc_qml.py` | IPC file → UI end-to-end | `python tests/ipc_qml.py` |
| `soak_qml.py` | Interaksi acak N detik (`SOAK_SECONDS`, default 90) | `SOAK_SECONDS=20 python tests/soak_qml.py` |

CI GitHub Actions (`.github/workflows/ci.yml`) menjalankan semuanya di
Ubuntu + PySide6 setiap push/PR. Status terakhir di mesin dev:
parsers 14/14, bridge 11/11, smoke/interact/ipc/soak: **PASS, 0 warning QML**.

---

## 🛠️ Tools Opsional (fitur penuh di Linux)

| Fitur | Tool | Install (contoh Arch) |
|-------|------|------------------------|
| Telemetri NVIDIA | `nvidia-smi` | driver NVIDIA resmi |
| Telemetri AMD | `amdgpu_top` / `rocm-smi` | `sudo pacman -S amdgpu_top` |
| Kontrol media (MPRIS) | `playerctl` | `sudo pacman -S playerctl` |
| Sinkron tema terminal | `pywal` / `matugen` | `pip install pywal` |
| Screenshot/record | `grim`, `slurp`, `wl-screenrec` / OBS | `sudo pacman -S grim slurp wl-screenrec` |
| Update AUR | `yay` / `paru` | AUR helper pilihanmu |

---

## 📜 License

```
MIT License

Copyright (c) 2026 Vaelestical Project

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🤝 Contributing

1. Fork repositori
2. Buat branch fitur (`git checkout -b feature/NamaFitur`)
3. Commit (`git commit -m 'Tambah NamaFitur'`)
4. Push (`git push origin feature/NamaFitur`)
5. Buka Pull Request

Aturan main: pertahankan gaya M3 Expressive (token dari `Theme.qml` —
jangan hardcode warna/font/easing), tanpa blur/transparansi, QML murni
tanpa plugin C++, dan pastikan `main.qml` lolos load tanpa warning
sebelum PR.

---

## 💬 Support

- **GitHub Issues**: lapor bug & request fitur
- **Discussions**: tanya-jawab & berbagi konfigurasi

---

<div align="center">

**Made with ❤️ for the Linux Qt Community**

</div>
