# Maintainer: PRIVATE EASTJAVA <kholis@vxvicfg.os>
pkgname=vxvicfg-shell-git
pkgver=2.0.0.r0.g0000000
pkgrel=1
pkgdesc="vxvicfg Shell Ultimate (Caelestia Rev 2.0) - Quickshell + C++ Wayland desktop shell"
arch=('x86_64')
url="https://github.com/vxvicfg/vxvicfg-shell"
license=('GPL3')
depends=('quickshell-git' 'qt6-base' 'qt6-declarative' 'pipewire' 'wireplumber'
         'networkmanager' 'bluez' 'matugen-bin' 'hyprland'
         'brightnessctl' 'wl-clipboard' 'cliphist' 'playerctl' 'gamemode' 'mpvpaper')
makedepends=('git' 'cmake' 'ninja' 'qt6-tools')
optdepends=('ollama: local LLM flyout'
            'mangoHud: FPS HUD overlay'
            'wl-screenrec: screen recording'
            'swww: image wallpaper daemon')
source=("git+https://github.com/vxvicfg/vxvicfg-shell.git")
sha256sums=('SKIP')

pkgver() {
  cd "$srcdir/vxvicfg-shell"
  git describe --long --tags 2>/dev/null | sed 's/^v//;s/-/.r/;s/-/./g' || echo "2.0.0.r0.g$(git rev-parse --short HEAD)"
}

build() {
  cmake -B build -S "$srcdir/vxvicfg-shell" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr
  cmake --build build
}

package() {
  DESTDIR="$pkgdir" cmake --install build
  install -Dm644 "$srcdir/vxvicfg-shell/shell.qml" "$pkgdir/usr/share/quickshell/modules/vxvicfg/shell.qml"
}
