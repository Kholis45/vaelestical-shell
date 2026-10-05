# vxvicfg shell REV 2.0 Ultimate

![Version](https://img.shields.io/badge/Version-REV%202.0-blue)
![Qt6](https://img.shields.io/badge/Qt%20Quick%206-Functional-brightgreen)
![Backend](https://img.shields.io/badge/Backend-C%2B%2B20%20%2B%20Quickshell-orange)
![Style](https://img.shields.io/badge/Style-Solid%20Material%20You%20M3-purple)
![Tests](https://img.shields.io/badge/Tests-PASS%20%7C%200%20warnings-brightgreen)

> Desktop shell Qt Quick 6 berestetika Caelestia dengan bahasa desain
> **Solid Material You M3 Expressive** — tanpa glassmorphism/blur,
> kontras tajam, rendering ringan.
>
> Dua entry point berbagi `modules/` + singleton `Theme` yang sama:
> **`main.qml`** (qmlscene / PySide6 — untuk dev & test) dan
> **`shell.qml`** (Quickshell layer-shell — untuk produksi di Hyprland),
> didukung **C++20 native core** (`src/` → plugin `Vxvicfg.Core`).

---

## 📋 Kebutuhan Sistem

| Komponen | Minimal | Disarankan |
|----------|---------|------------|
| OS | Linux apa pun (CachyOS, Ubuntu 20.04+, Fedora 35+, Arch) | CachyOS / Arch + Hyprland |
| RAM | 4 GB | 8 GB |
| GPU | OpenGL 3.3+ | Akselerasi hardware aktif |
| Display | X11 / Wayland | Wayland (Hyprland) |

| Lapisan | Dependensi |
|---------|-----------|
| UI dev/test | `qt6-base qt6-declarative` (qmlscene) atau `pip install PySide6` |
| Produksi Wayland | `quickshell-git`, `hyprland`, `pipewire`, `wireplumber`, `networkmanager`, `bluez`, `matugen-bin`, `brightnessctl`, `playerctl` |
| Build C++ core | `cmake`, `ninja`, `qt6-base`, `qt6-declarative` (PipeWire/NVML/PAM opsional — selalu bisa build) |

---

## 🚀 Instalasi & Menjalankan

### 1. Install Qt 6 + Git sesuai distro

| Distro | Perintah |
|--------|----------|
| **CachyOS / Arch / Manjaro** | `sudo pacman -S --needed qt6-base qt6-declarative qt6-shadertools git` |
| **Ubuntu / Debian / Linux Mint** | `sudo apt install -y qmlscene qt6-base-dev qt6-declarative-dev git` |
| **Fedora / RHEL / CentOS** | `sudo dnf install -y qt6-qtbase qt6-qtdeclarative git` |
| **openSUSE** | `sudo zypper install -y qt6-base qt6-declarative git` |

### 2. Clone repositori

```bash
git clone https://github.com/Kholis45/vxvicfg-shell.git
cd vxvicfg-shell
```

### 3. Jalankan — pilih mode

**Mode dev/test — `qmlscene` (Linux):**

```bash
qmlscene main.qml
```

> Jika slider custom tampil seperti slider bawaan, paksa style Basic:
> `QT_QUICK_CONTROLS_STYLE=Basic qmlscene main.qml`

**Mode dev/test — `run_shell.py` (PySide6, lintas platform incl. Windows):**

```bash
pip install PySide6
python run_shell.py
```

> Menangani DLL plugin QML di Windows, memaksa style Basic, menyalakan
> IPC Hyprland, dan menyediakan objek `Sys` (SysBridge: eksekusi aman +
> polling telemetri). Tanpa `Sys` (qmlscene mentah), shell otomatis
> fallback mode demo `console.log` — tetap bisa dibuka.

**Mode produksi — Quickshell layer-shell (Hyprland/Wayland):**

```bash
quickshell -p shell.qml
```

> `shell.qml` = `ShellRoot` + `PanelWindow` per layar (`Top` layer,
> namespace `vxvicfg-*`, `ExclusionMode.Ignore`, fokus keyboard
> `OnDemand` hanya untuk panel interaktif). Pasang `libvxvicfg_core`
> (lihat Build C++ Core) untuk telemetri/Aksi native.

**Mode produksi — paket distro:**

```bash
# Arch / CachyOS (AUR): paket vxvicfg-shell-git
makepkg -si  # memakai PKGBUILD

# NixOS / Home Manager (flake):
# programs.vxvicfg-shell.enable = true;
```

### 4. Build C++ core (opsional, untuk telemetri native)

```bash
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

Menghasilkan `libvxvicfg_core.so` → `import Vxvicfg.Core 1.0`
(`Gpu`, `Audio`, `Net`, `Bt`, `Tray`, `Notifs`, `Matugen`, `Pam`).
Seluruh modul QML tetap jalan **tanpa** plugin ini (mode demo).

### 5. Verifikasi instalasi

```bash
qmlscene --version        # harus 6.x
python run_shell.py       # jendela shell terbuka = instalasi beres
python tests/smoke_qml.py # SMOKE: PASS, 0 warning = sehat
```

---

## ▶️ Uji Coba Pertama

Saat jendela terbuka (1366×768):

1. **Test-bar atas** — toggle tiap panel:
   `Dash` • `Control` • `Wallpaper` • `Settings` • `Utils` • `Gaming` •
   `Lock` • `Flyout` • `Pro` • `LScreen`,
   plus ComboBox posisi bar (`left/top/bottom/right`) dan tombol `Light/Dark`.
2. **Sidebar kiri** — titik workspace 1–4 (klik untuk pindah), status pill,
   dan dot hijau berdenyut.
3. **Dashboard kanan** — Dynamic Island + 4 tab pill:
   `Dashboard` (jam live, cuaca, info sistem) • `Media` (kontrol + boost 150%)
   • `Performance` (CPU/GPU/RAM) • `Workspaces`.
4. **Shortcut keyboard** — `Ctrl+D/W/C/S/U/G/L/O/P` dan `Ctrl+Shift+L`
   saat window fokus (tabel lengkap di bawah), atau `Super+…` global
   via Hyprland.

Semua panel default tersembunyi kecuali Dashboard dan Haku taskbar bawah —
nyalakan sisanya dari shortcut (`Ctrl+T/H/N/V/M/B`) atau bind `Super+…`
sesuai kebutuhan agar tidak bertumpuk.

---

## ⌨️ Shortcut

### A. Dalam window shell (`Ctrl+…`, selalu tersedia)

| Shortcut | Panel |
|----------|-------|
| `Ctrl+D` | Dashboard |
| `Ctrl+W` | Wallpaper picker |
| `Ctrl+C` | Control center |
| `Ctrl+S` | Settings |
| `Ctrl+U` | Utilities (+ launcher & kalkulator) |
| `Ctrl+G` | Gaming & audio advanced |
| `Ctrl+L` | Lockscreen / login (utama) |
| `Ctrl+O` | Utilities flyout (toast/OSD/Ollama/catatan) |
| `Ctrl+P` | Pro gaming overlay (HUD/GPU/EQ/Dante/AUR) |
| `Ctrl+Shift+L` | Lockscreen alternatif (PAM) |
| `Ctrl+T` | Haku taskbar bawah |
| `Ctrl+H` | Haku settings modal |
| `Ctrl+N` | Haku wallpaper grid |
| `Ctrl+V` | Haku cava visualizer |
| `Ctrl+M` | Haku context menu |
| `Ctrl+B` | Haku desktop clock |

### B. Global di Hyprland (`Super+…`, perlu didaftarkan)

**1. Source file binds yang sudah disediakan:**

```bash
# Tambahkan ke ~/.config/hypr/hyprland.conf (sesuaikan path clone):
source = ~/vxvicfg-shell/hyprland/vxvicfg-binds.conf
```

| Bind | Perintah terkirim |
|------|-------------------|
| `Super+D` / `Super+K` | toggle dashboard / panel launcher (Utils) |
| `Super+W` | toggle wallpaper picker |
| `Super+C` | toggle control center |
| `Super+S` | toggle settings |
| `Super+U` | toggle utilities |
| `Super+G` | toggle gaming |
| `Super+L` | toggle lockscreen |
| `Super+P` | screenshot area langsung (`grim`+`slurp`) |
| `Super+T` | toggle Haku taskbar |
| `Super+H` | toggle Haku settings modal |
| `Super+N` | toggle Haku wallpaper grid |
| `Super+V` | toggle Haku cava visualizer |
| `Super+M` | toggle Haku context menu |
| `Super+B` | toggle Haku desktop clock |
| `Super+Shift+T` | toggle tema gelap/terang |

**2. Cara kerja (IPC file-based, QML murni):** tiap bind menulis satu kata
ke `/tmp/vxvicfg.cmd`; shell membaca file itu tiap 250ms dan toggle
panel yang sesuai (`dash wall control settings utils gaming lock theme
flyout pro lock2 taskbar hakusettings hakuwall cava hakumenu hakuclock shot`
(+ internal `barpos:left|top|bottom|right` untuk posisi bar, dipakai
SettingsHub; tidak perlu bind)
via `handleCommand()` di `main.qml`). Tanpa shell yang
jalan, bind tidak ngapa-ngapain (terverifikasi end-to-end via smoke test).

**3. Wajib untuk metode `qmlscene`:** baca file lokal via XHR dimatikan
default di Qt6 — aktifkan di `hyprland.conf`:

```conf
env = QML_XHR_ALLOW_FILE_READ,1
```

(`python run_shell.py` sudah mengaturnya otomatis.)

**4. Autostart shell (opsional, di `hyprland.conf`):**

```conf
exec-once = quickshell -p ~/vxvicfg-shell/shell.qml
# atau mode dev:
# exec-once = qmlscene ~/vxvicfg-shell/main.qml
# exec-once = python ~/vxvicfg-shell/run_shell.py
```

### C. Kustomisasi shortcut

- **Ubah/hapus bind global:** edit `hyprland/vxvicfg-binds.conf`
  (format `bind = SUPER, <tombol>, exec, sh -c 'echo <perintah> >> /tmp/vxvicfg.cmd'`),
  lalu `hyprctl reload`.
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
| Alias solid | `baseWindow #0d0e12`, `surfaceContainerBase #1a1b22`, `surfaceHigh #262732`, `borderColor #333545`, `accentPrimary #a8c7fa`, `activeFill #384661` | untuk OSD/HUD/layer-shell |
| Bentuk (resmi M3) | `shapeExtraSmall 4` → `shapeExtraLarge 28`, `shapeFull` | card = `shapeLarge` (16), pill = 99 |
| Tipografi | `display…`, `headline…`, `title…`, `body…`, `label…` | dipakai via `font: Theme.titleSmall` |
| Motion | `emphasized` cubic-bezier M3 + durasi pegas `dColor 180` / `dScale 150` / `dOpacity 200` / `dResize 220` | `OutCubic` warna/lebar, `OutBack` skala/tinggi |
| State layer | `stateHover 8%` / `statePressed 12%` via komponen `StateLayer` | overlay hover bawaan M3 |

Ganti mode gelap/terang dari UI (tombol `Light/Dark` atau switch di
`WallpaperPicker`) — seluruh shell ikut berubah via binding `Theme.dark`.
Tidak ada efek blur/kaca di mana pun; elevasi diganti shadow solid tipis.
Catatan: ikon masih glyph teks (font Material Symbols belum dibundel) —
satu-satunya bagian yang belum 100% M3.

---

## 🧩 Modul UI (`modules/`)

| File | Isi |
|------|-----|
| `Theme.qml` | Singleton token M3E (wajib diimpor implisit semua modul) |
| `StateLayer.qml` | Overlay hover/press M3 |
| `LeftSidebar.qml` | Bar apung + workspace switcher + status pill + sesi daya |
| `CentralDashboard.qml` | Dynamic Island + 4 tab (info, media+lirik, telemetri, workspace) |
| `WallpaperPicker.qml` | Wallpaper carousel + aksen Material You + `swww`/`matugen` |
| `ControlCenter.qml` | Wi-Fi/BT/DND/GameMode/Night + audio PipeWire + slider + game launcher |
| `LoginDashboard.qml` | Lockscreen utama (kartu login + daya) |
| `Lockscreen.qml` | Lockscreen alternatif (PAM + pemilih sesi + CapsLock warning) |
| `SettingsHub.qml` | Layout/posisi, personalisasi, hardware, modul, tentang |
| `UtilitiesAI.qml` | Clipboard, launcher+kalkulator (`launchField`), toast/OSD, Ollama, scratchpad |
| `UtilitiesFlyout.qml` | Flyout cepat: OSD ganda, toast, prompt Ollama, catatan, screenshot |
| `GamingAudioAdvanced.qml` | Modul gaming/audio tingkat lanjut |
| `ProGamingOverlay.qml` | HUD MangoHud, profil GPU/kipas, EQ/DSP, Dante, AUR, meter net, purge shader |
| `HakuTaskbar.qml` | Bottom pill taskbar: launcher + ikon tengah + status pill (Hakuspace) |
| `HakuSettings.qml` | Center modal [General][Theme][Setting] + search + toggle rows |
| `HakuClock.qml` | Jam desktop monospace raksasa + tanggal |
| `HakuCava.qml` | Strip bar visualizer mengambang (top/bottom) |
| `HakuWallpaper.qml` | Grid thumbnail wallpaper + search |
| `HakuMenu.qml` | Context menu dark + submenu Waybar (`openAt(x, y)`) |

> `modules/bar|dashboard|launcher|lock|osd|…/`, `components/`, `services/`,
> `plugin/`, `utils/`, `scripts/`, `nix/`, `extras/`, `assets/` adalah
> **pohon referensi Caelestia** (butuh plugin `Caelestia.*` + Quickshell) —
> pasif terhadap test-suite dan tidak terdaftar di `modules/qmldir`.
> Lihat “Peta Integrasi” di bawah bila ingin mem-porting-nya.

---

## ⚙️ Backend C++ (`src/` → `Vxvicfg.Core`)

| Service | Sumber data | Fallback |
|---------|------------|----------|
| `GpuTelemetry` | `nvidia-smi` (async) / sysfs AMD (`gpu_busy_percent`, `hwmon`) | VMware SVGA (`0x15ad`) → beban emulasi CPU; default valid, tak pernah throw |
| `PipeWireService` | `wpctl` get-volume/status (async paralel) | Nilai terakhir dipertahankan; nama sink disanitasi anti-injeksi |
| `NetworkManager` / `BluetoothService` | `nmcli` / `bluetoothctl` via D-Bus + CLI (async, watchdog) | Parse defensif (SSID ber-kolon aman); argv langsung tanpa shell |
| `NotificationDaemon` | `org.freedesktop.Notifications` di D-Bus sesi | Gagal registrasi → no-op anggun + DND switch |
| `StatusNotifierTray` | `org.kde.StatusNotifierWatcher` (async) + enumerasi lokal | Switch "Native tray" memuat `TrayBridge.qml` bila plugin ada; fallback statis |
| `MatugenEngine` | Sampling `QImage` di worker thread + `matugen` fire-and-forget | Counter generasi anti-race; warna default `#a8c7fa` |
| `PamAuth` | `libpam` bila ada (`HAS_PAM`), `QtConcurrent` + `QPointer` guard | Build tanpa PAM → accept (mode demo) |

**Aturan audit Tahap 3 yang berlaku untuk semua kode baru:** tidak ada
`waitForFinished()`/DBus `.call()` sinkron di thread UI, tidak ada raw
pointer tanpa parent/`QPointer`, tidak ada interpolasi shell tanpa sanitasi,
dan setiap kegagalan backend mengembalikan default valid.

---

## 📜 JavaScript & 🎆 Shader GLSL

Logika non-visual dipisah dari QML ke modul JS murni (`.pragma library`,
stateless, tidak pernah throw — input rusak → fallback):

| File | API |
|------|-----|
| `utils/Formatters.js` | `pad2`, `formatClock`, `formatBytes`, `formatDuration`, `formatTemp`, `formatPing`, `formatPercent` |
| `utils/ColorUtils.js` | `isHex`, `normalizeHex`, `hexToRgb`/`rgbToHex`, `mix`, `withAlpha`, `luminance`, `contrastOn` |
| `utils/MathHelpers.js` | `clamp`, `lerp`, `smoothstep`, `springStep` (pegas redam), `bezier`, `wavePhase` |

Dipakai via `import "../utils/Formatters.js" as F` (path relatif dari
`modules/`). Contoh nyata: jam lockscreen (`F.formatClock`), validasi hex
aksen (`C.isHex`), energi visualizer yang dihaluskan pegas
(`M.springStep` tiap 50ms).

Efek GPU via `ShaderEffect` + GLSL ES (`shaders/*.frag`, uniform
di-bind otomatis dari properti QML senama):

| Shader | Fungsi | Dipakai di |
|--------|--------|-----------|
| `M3ExpressiveBorder.frag` | Ring aksen SDF anti-aliased + glow luar (tengah transparan) | Glow cover art `CentralDashboard` tab Media |
| `SpectrumWave.frag` | 3 lapis sinus prosedural, amplitudo ikut uniform `energy` | Strip visualizer 56px di kartu visualizer |

Aturan keras shader (ditengakkan `check_shader_conventions.py`):
**jangan deklarasikan properti/uniform bernama** `x y z width height
opacity visible enabled scale rotation` (+ properti `ShaderEffect`:
`fragmentShader status …`) — menimpa member `Item` (sebagian FINAL)
membuat engine **gagal load total**. Kasus nyata yang pernah terjadi:
`property real width` → di-rename ke `borderWidth`. Selalu guard
`visible: status !== ShaderEffect.Error`; di backend software shader
diam-tidak-render (aman untuk test), animasi hidup di GL hardware.

---

## 📁 Struktur Proyek

```
vxvicfg-shell/
├── main.qml                    # Entry dev/test (test-bar + semua panel)
├── shell.qml                   # Entry produksi Quickshell layer-shell
├── run_shell.py                # Launcher PySide6 + SysBridge (Sys.*)
├── CMakeLists.txt              # Build libvxvicfg_core.so
├── PKGBUILD                    # Paket AUR vxvicfg-shell-git
├── flake.nix                   # Flake Nix + Home Manager module
├── hyprland/
│   └── vxvicfg-binds.conf  # Keybind Super (source dari hyprland.conf)
├── modules/                    # Modul QML aktif (terdaftar di qmldir)
│   ├── qmldir / Theme.qml / StateLayer.qml
│   ├── LeftSidebar / CentralDashboard / WallpaperPicker / ControlCenter
│   ├── LoginDashboard / Lockscreen / SettingsHub
│   └── UtilitiesAI / UtilitiesFlyout / GamingAudioAdvanced / ProGamingOverlay
├── src/                        # C++20 core (services/ + engine/ + plugin)
├── utils/                      # Helper JS murni: Formatters, ColorUtils, MathHelpers
│                               # (+ *.qml referensi Caelestia di folder yang sama, pasif)
├── shaders/                    # GLSL: M3ExpressiveBorder + SpectrumWave (ShaderEffect)
├── components/ services/       # Kit UI + singleton referensi Caelestia (pasif)
├── plugin/                     # C++ Caelestia.* referensi (pasif)
├── scripts/ extras/ nix/ assets/
├── tests/                      # Suite otomatis (lihat bawah)
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
| Wayland gagal (mode dev) | Coba `QT_QPA_PLATFORM=xcb qmlscene main.qml` |
| Quickshell: modul tak ditemukan | Pastikan working dir = root repo atau install via CMake ke prefix Quickshell |
| `Cannot override FINAL property` (width/height/…) | Properti QML/uniform shader menabrak member `Item` — rename (mis. `width` → `borderWidth`); lihat aturan shader di atas |

> Catatan backend: aksi sistem lewat **`Sys` (SysBridge di `run_shell.py`)**
> via helper `Theme.exec*` — mode `qmlscene` (tanpa `Sys`) otomatis fallback
> demo `console.log`. Tersambung nyata: workspace Hyprland (`hyprctl
> dispatch`), kontrol media (`playerctl`), lock (`loginctl`),
> sleep/power (`systemctl`), screenshot (`grim`+`slurp`), volume (`wpctl`),
> brightness (`brightnessctl`), Wi-Fi/BT toggle (`nmcli`/`bluetoothctl`),
> wallpaper (`swww`/`matugen`), launcher aplikasi, plus polling telemetri
> (workspace aktif, volume/mute, brightness, NVIDIA) yang tersinkron ke UI.
> PAM asli aktif bila `libvxvicfg_core` terpasang; form login juga menerima
> `pamtester` (`Theme.hasBin`) sebagai jalur auth PAM asli tanpa plugin.

---

## ✅ Pengujian (tests/)

Suite otomatis di `tests/` (headless via Qt offscreen, jalan di CI):

| Suite | Isi | Perintah |
|-------|-----|----------|
| `test_parsers.py` | 14 unit test parser telemetri (hyprctl, wpctl, nvidia-smi, brightness + kasus rusak) | `python tests/test_parsers.py` |
| `test_bridge.py` | 11 unit test `SysBridge` (kegagalan aman, sinyal polling) | `python tests/test_bridge.py` |
| `check_shader_conventions.py` | Regression: properti/uniform `ShaderEffect` tidak menimpa member reserved | `python tests/check_shader_conventions.py` |
| `smoke_qml.py` | Load + exercise semua panel/tab/workspace/posisi-bar/mode, gerbang 0 warning | `python tests/smoke_qml.py` |
| `interact_qml.py` | Klik mouse & ketikan keyboard beneran (QTest + hook `debugGeom`) | `python tests/interact_qml.py` |
| `ipc_qml.py` | IPC file → UI end-to-end | `python tests/ipc_qml.py` |
| `soak_qml.py` | Interaksi acak N detik (`SOAK_SECONDS`, default 90) | `SOAK_SECONDS=20 python tests/soak_qml.py` |

CI GitHub Actions (`.github/workflows/ci.yml`) menjalankan semuanya di
Ubuntu + PySide6 setiap push/PR, plus job `build-core` (CMake+Ninja+Qt6)
untuk memastikan C++ ikut terkompilasi. Status terakhir di mesin dev:
parsers 14/14, bridge 11/11, shader-conv PASS,
smoke/interact/ipc/soak: **PASS, 0 warning QML**.

> Workflow upstream Caelestia (`build`, `lint`, `check-format`, `release`,
> `update-*`) sengaja di-`workflow_dispatch` karena butuh infra GHCR/nix
> milik upstream — lihat komentar di tiap file. Jangan aktifkan sebelum
> pohon referensi di-porting.

---

## 🗺️ Peta Integrasi (pohon Caelestia → vxvicfg)

| Sumber referensi | Status | Jalur porting bila dibutuhkan |
|------------------|--------|-------------------------------|
| `modules/bar|dashboard|…/` | Pasif | Port per-modul ke Token `Theme`, ganti `import Caelestia/qs` → relatif, daftarkan di `modules/qmldir`, wajib lolos `smoke_qml.py` 0 warning |
| `services/*.qml` | Pasif | Ganti singleton bertahap dengan `Vxvicfg.Core` C++ (API sudah sejajar: audio, net, notif, tray) |
| `plugin/` (C++ Caelestia) | Pasif | Referensi arsitektur untuk `src/`; jangan campur dua plugin dalam satu engine |
| `components/` | Pasif | Ambil pola (StyledSlider, StateLayer setara) bila dibutuhkan |
| `nix/hm-module.nix` | Referensi | Contoh modul Home Manager (sudah ada versi aktif di `flake.nix`) |

---

## 🛠️ Tools Opsional (fitur penuh di Linux)

| Fitur | Tool | Install (contoh Arch) |
|-------|------|------------------------|
| Telemetri NVIDIA | `nvidia-smi` | driver NVIDIA resmi |
| Media (MPRIS) | `playerctl` | `sudo pacman -S playerctl` |
| Tema wallpaper | `swww`, `matugen-bin`, `mpvpaper` | `sudo pacman -S swww matugen-bin mpvpaper` |
| Screenshot/record | `grim`, `slurp`, `wl-screenrec` / OBS | `sudo pacman -S grim slurp wl-screenrec` |
| GameMode | `gamemode` | `sudo pacman -S gamemode` |
| Update AUR | `yay` / `paru` | AUR helper pilihanmu |
| Produksi Wayland | `quickshell-git`, `hyprland`, `pipewire`, `wireplumber` | `yay -S quickshell-git hyprland pipewire wireplumber` |

---

## 📜 License

```
MIT License

Copyright (c) 2026 vxvicfg Project

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

Aturan main (ditegakkan audit Tahap 3 + CI):

- Gaya M3 Expressive dari token `Theme.qml` — jangan hardcode warna/font/easing;
  modul baru memakai `OutCubic` (warna/lebar/opacity) dan `OutBack` (skala/tinggi).
- Tanpa blur/transparansi; tanpa plugin C++ di jalur QML dev (`main.qml`
  harus lolos load **0 warning** sebelum PR — jalankan `smoke_qml.py`).
- Backend C++: dilarang blocking call di thread UI (`waitForFinished`,
  DBus `.call()` sinkron) — selalu async + watchdog; sanitasi setiap
  interpolasi shell; `QPointer`/parent untuk semua pointer lintas thread.
- Shader/JS baru: uniform shader tidak boleh bernama reserved (cek via
  `python tests/check_shader_conventions.py`); helper JS wajib
  `.pragma library` + null-safe.
- Jangan mengaktifkan workflow `workflow_dispatch` upstream sebelum
  dependensinya di-porting.

---

## 💬 Support

- **GitHub Issues**: lapor bug & request fitur
- **Discussions**: tanya-jawab & berbagi konfigurasi

---

<div align="center">

**Made with ❤️ for the Linux Qt Community**

</div>
