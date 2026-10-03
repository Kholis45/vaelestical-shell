# Vaelestical Shell REV 2.0

![Version](https://img.shields.io/badge/Version-REV%202.0-blue)
![Qt6](https://img.shields.io/badge/Qt%20Quick%206-Functional-brightgreen)
![Platform](https://img.shields.io/badge/Platform-Linux%20Universal-orange)

> A fully integrated Qt Quick 6 desktop experience shell combining Caelestia floating aesthetics with Android 17 Material You Expressive UI.

---

## 🚀 Quick Installation (Universal Linux)

### One-Liner Install (Ubuntu/Debian)

```bash
sudo apt update && \
sudo apt install -y qt6-qmlscene git && \
git clone https://github.com/your-username/vaelestical-shell.git && \
cd vaelestical-shell && \
chmod +x start-vaelestical.sh && \
./start-vaelestical.sh
```

### Manual Steps

```bash
# 1. Install Qt 6 (universal)
# Ubuntu/Debian/Fedora/Arch - see distro-specific commands below

# 2. Clone the repository
git clone https://github.com/your-username/vaelestical-shell.git

# 3. Enter directory
cd vaelestical-shell

# 4. Make launch script executable
chmod +x start-vaelestical.sh

# 5. Run the shell
./start-vaelestical.sh
```

### Distro-Specific Qt Installation

| Distro | Command |
|--------|---------|
| **Ubuntu/Debian/Linux Mint** | `sudo apt install -y qt6-qmlscene` |
| **Fedora/RHEL/CentOS** | `sudo dnf install -y qt6-qmlscene` |
| **Arch Linux/Manjaro** | `sudo pacman -S --needed qt6-qmlscene` |
| **openSUSE** | `sudo zypper install -y qt6-qmlscene` |
| **Void Linux** | `sudo xbps-install -Sy qt6-qmlscene` |

---

## ▶️ Running the Shell

### Method 1: qmlscene (Recommended)

```bash
qmlscene main.qml
```

### Method 2: PySide6 (Python)

```bash
pip3 install PySide6
pyside6-qml main.qml
```

### Method 3: Launch Script

```bash
./start-vaelestical.sh
```

---

## ⚙️ First Run Configuration

Upon first execution, the shell will:

1. Auto-detect GPU hardware (NVIDIA/AMD/iGPU/VMware)
2. Load default Material You wallpaper
3. Initialize color tokens (#0d0e12 base, #a8c7fa accent)
4. Display the main UI with all 8 modules

### Custom Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `VAEL_BAR_POSITION` | Sidebar position | `left` |
| `VAEL_CORNER_RADIUS` | Corner radius (px) | `20` |
| `VAEL_ENABLE_BLUR` | Glassmorphism blur | `true` |
| `VAEL_LIGHT_MODE` | Force light mode | `false` |

**Example:**
```bash
VAEL_BAR_POSITION="top" VAEL_CORNER_RADIUS="24" qmlscene main.qml
```

---

## 📁 Project Structure

```
vaelestical-shell/
├── main.qml              # Entry point (14KB)
├── modules/
│   ├── qmldir            # Module registration
│   ├── LeftSidebar.qml   # Module A - Floating left bar
│   ├── CentralDashboard.qml  # Module B - Multi-tab dashboard
│   ├── WallpaperPicker.qml   # Module C - Material You engine
│   ├── ControlCenter.qml       # Module D - Hardware control center
│   ├── LoginDashboard.qml      # Module IV - Authentication
│   ├── SettingsHub.qml         # Module V - Settings & readout
│   ├── UtilitiesAI.qml         # Module E - Utilities & AI
│   └── GamingAudioAdvanced.qml # Module F - Pro gaming/audio
└── README.md             # This file
```

---

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| `command not found: qmlscene` | Install Qt 6 for your distro (see table above) |
| Blank black screen | Check: `glxinfo | grep "OpenGL renderer"` |
| "import VaelesticalModules not found" | Ensure `modules/qmldir` exists |
| Jerky animations | Enable: `export QT_ENABLE_HIGHDPI_SCALING=1` |
| GPU shows "Unknown" | Install: `nvidia-smi`, `playerctl`, etc. |
| Wayland session fails | Try: `QT_QPA_PLATFORM=xcb` |

---

## ⚠️ Requirements

- **OS**: Linux (Ubuntu 20.04+, Fedora 35+, Arch, or any Qt-compatible distro)
- **RAM**: 4 GB minimum (8 GB recommended)
- **Disk**: 200 MB free space
- **GPU**: OpenGL 3.3+ capable with hardware acceleration
- **Display**: Wayland preferred, X11 supported

---

## 🛠️ Optional Tools for Full Features

| Feature | Tool | Install |
|---------|------|---------|
| NVIDIA telemetry | `nvidia-smi` | `sudo apt install nvidia-smi` |
| AMD Radeon telemetry | `amd-gpu-utils` | `sudo apt install amd-gpu-utils` |
| Media control | `playerctl` | `sudo apt install playerctl` |
| Terminal color sync | `pywal` | `pip3 install pywal` |
| Screenshot/record | `grim, slurp, wl-recorder` | `sudo apt install grim slurp wl-recorder` |
| AUR package management | `yay, pacman` | Distro-specific |

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

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 💬 Support

- **GitHub Issues**: Report bugs & feature requests
- **Discussions**: Ask questions & share configurations

---

<div align="center">

**Made with ❤️ for the Linux Qt Community**

</div>