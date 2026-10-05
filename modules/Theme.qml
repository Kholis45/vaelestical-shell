pragma Singleton
import QtQuick

// ============================================================
// Theme — Material 3 Expressive (Google) penuh, SOLID.
// Warna opaque, tanpa blur/transparansi.
//
// Isi: color roles lengkap (primary/secondary/tertiary/error +
// container & on-colors, surface scale, outline, inverse, scrim),
// type scale (display/headline/title/body/label), shape scale
// resmi M3, motion emphasized, dan state-layer opacity.
// ============================================================
QtObject {
    id: theme

    property bool dark: true

    // ================= COLOR: dark baseline (solid) =================
    property color _primaryD: "#d0bcff"
    property color _onPrimaryD: "#381e72"
    property color _primaryContainerD: "#4f378b"
    property color _onPrimaryContainerD: "#eaddff"
    property color _secondaryD: "#ccc2dc"
    property color _onSecondaryD: "#332d41"
    property color _secondaryContainerD: "#4a4458"
    property color _onSecondaryContainerD: "#e8def8"
    property color _tertiaryD: "#efb8c8"
    property color _onTertiaryD: "#492532"
    property color _tertiaryContainerD: "#633b48"
    property color _onTertiaryContainerD: "#ffd8e4"
    property color _errorD: "#f2b8c6"
    property color _onErrorD: "#601410"
    property color _errorContainerD: "#8c1d18"
    property color _onErrorContainerD: "#ffdad6"
    property color _backgroundD: "#131318"
    property color _onBackgroundD: "#e6e0e9"
    property color _surfaceD: "#131318"
    property color _onSurfaceD: "#e6e0e9"
    property color _surfaceDimD: "#131318"
    property color _surfaceBrightD: "#38383c"
    property color _lowestD: "#0d0d12"
    property color _lowD: "#1b1b1f"
    property color _containerD: "#211f26"
    property color _containerHighD: "#2b2930"
    property color _containerHighestD: "#36343b"
    property color _onVariantD: "#cac4d0"
    property color _outlineD: "#938f99"
    property color _outlineVariantD: "#49454f"
    property color _inverseSurfaceD: "#e6e0e9"
    property color _inverseOnSurfaceD: "#313033"
    property color _inversePrimaryD: "#6750a4"

    // ================= COLOR: light baseline (solid) =================
    property color _primaryL: "#6750a4"
    property color _onPrimaryL: "#ffffff"
    property color _primaryContainerL: "#eaddff"
    property color _onPrimaryContainerL: "#4f378b"
    property color _secondaryL: "#625b71"
    property color _onSecondaryL: "#ffffff"
    property color _secondaryContainerL: "#e8def8"
    property color _onSecondaryContainerL: "#4a4458"
    property color _tertiaryL: "#7d5260"
    property color _onTertiaryL: "#ffffff"
    property color _tertiaryContainerL: "#ffd8e4"
    property color _onTertiaryContainerL: "#633b48"
    property color _errorL: "#ba1a1a"
    property color _onErrorL: "#ffffff"
    property color _errorContainerL: "#ffdad6"
    property color _onErrorContainerL: "#410e0b"
    property color _backgroundL: "#fef7ff"
    property color _onBackgroundL: "#1d1b20"
    property color _surfaceL: "#fef7ff"
    property color _onSurfaceL: "#1d1b20"
    property color _surfaceDimL: "#ded8e1"
    property color _surfaceBrightL: "#fef7ff"
    property color _lowestL: "#ffffff"
    property color _lowL: "#f7f2fa"
    property color _containerL: "#f3edf7"
    property color _containerHighL: "#ece6f0"
    property color _containerHighestL: "#e6e0e9"
    property color _onVariantL: "#49454f"
    property color _outlineL: "#79747e"
    property color _outlineVariantL: "#cac4d0"
    property color _inverseSurfaceL: "#313033"
    property color _inverseOnSurfaceL: "#f4eff4"
    property color _inversePrimaryL: "#d0bcff"

    // Aksen khas vxvicfg (di luar baseline M3, konsisten dua mode)
    property color _accentD: "#a8c7fa"
    property color _accentL: "#415f91"
    property color _successD: "#4ade80"
    property color _successL: "#146c2e"
    property color _warningD: "#fbbf24"
    property color _warningL: "#7c4a03"

    // ================= COLOR: token aktif =================
    property color primary: dark ? _primaryD : _primaryL
    property color onPrimary: dark ? _onPrimaryD : _onPrimaryL
    property color primaryContainer: dark ? _primaryContainerD : _primaryContainerL
    property color onPrimaryContainer: dark ? _onPrimaryContainerD : _onPrimaryContainerL
    property color secondary: dark ? _secondaryD : _secondaryL
    property color onSecondary: dark ? _onSecondaryD : _onSecondaryL
    property color secondaryContainer: dark ? _secondaryContainerD : _secondaryContainerL
    property color onSecondaryContainer: dark ? _onSecondaryContainerD : _onSecondaryContainerL
    property color tertiary: dark ? _tertiaryD : _tertiaryL
    property color onTertiary: dark ? _onTertiaryD : _onTertiaryL
    property color tertiaryContainer: dark ? _tertiaryContainerD : _tertiaryContainerL
    property color onTertiaryContainer: dark ? _onTertiaryContainerD : _onTertiaryContainerL
    property color error: dark ? _errorD : _errorL
    property color onError: dark ? _onErrorD : _onErrorL
    property color errorContainer: dark ? _errorContainerD : _errorContainerL
    property color onErrorContainer: dark ? _onErrorContainerD : _onErrorContainerL
    property color background: dark ? _backgroundD : _backgroundL
    property color onBackground: dark ? _onBackgroundD : _onBackgroundL
    property color surface: dark ? _surfaceD : _surfaceL
    property color onSurface: dark ? _onSurfaceD : _onSurfaceL
    property color surfaceDim: dark ? _surfaceDimD : _surfaceDimL
    property color surfaceBright: dark ? _surfaceBrightD : _surfaceBrightL
    property color surfaceContainerLowest: dark ? _lowestD : _lowestL
    property color surfaceContainerLow: dark ? _lowD : _lowL
    property color surfaceContainer: dark ? _containerD : _containerL
    property color surfaceContainerHigh: dark ? _containerHighD : _containerHighL
    property color surfaceContainerHighest: dark ? _containerHighestD : _containerHighestL
    property color onSurfaceVariant: dark ? _onVariantD : _onVariantL
    property color outline: dark ? _outlineD : _outlineL
    property color outlineVariant: dark ? _outlineVariantD : _outlineVariantL
    property color inverseSurface: dark ? _inverseSurfaceD : _inverseSurfaceL
    property color inverseOnSurface: dark ? _inverseOnSurfaceD : _inverseOnSurfaceL
    property color inversePrimary: dark ? _inversePrimaryD : _inversePrimaryL
    property color scrim: "#000000"
    property color shadow: dark ? "#0a0a0f" : "#d9d3e0"
    property color accent: dark ? _accentD : _accentL
    property color active: accent
    property color inactive: outlineVariant
    property color success: dark ? _successD : _successL
    property color warning: dark ? _warningD : _warningL

    // ============ ALIAS SOLID VXVICFG (audit Tahap 3) ============
    // Token solid untuk konsumen yang memakai palet tetap (layer-shell,
    // OSD, HUD): tanpa blur/transparansi, geometri pill r18-32.
    property color baseWindow: "#0d0e12"
    property color surfaceContainerBase: "#1a1b22"
    property color surfaceHigh: "#262732"
    property color borderColor: "#333545"
    property color accentPrimary: "#a8c7fa"
    property color activeFill: "#384661"
    property color textPrimary: "#e3e2e6"
    property color textSecondary: "#8e9099"
    // Durasi gerak pegas standar (ms): OutCubic warna/lebar/opacity,
    // OutBack skala/tinggi.
    property int dColor: 180
    property int dScale: 150
    property int dOpacity: 200
    property int dResize: 220
    // Interval telemetri global (ms); slider SettingsHub/Haku mengubah ini.
    property int telemetryMs: 3000

    // State layer M3: overlay onSurface (hover 8%, focus/press 12%)
    property color stateLayer: onSurface
    property real stateHover: 0.08
    property real stateFocus: 0.12
    property real statePressed: 0.12
    property real stateDragged: 0.16

    // ================= SHAPE: skala resmi M3 =================
    property int shapeExtraSmall: 4
    property int shapeSmall: 8
    property int shapeMedium: 12
    property int shapeLarge: 16
    property int shapeExtraLarge: 28
    property int shapeFull: 999
    // Alias proyek: card & pill
    property int cardRadius: shapeLarge
    property int pillRadius: 99

    // ================= TYPE: skala M3 (font preset) =================
    property font displayLarge: Qt.font({ pointSize: 57, weight: Font.Normal })
    property font displayMedium: Qt.font({ pointSize: 45, weight: Font.Normal })
    property font displaySmall: Qt.font({ pointSize: 36, weight: Font.Normal })
    property font headlineLarge: Qt.font({ pointSize: 32, weight: Font.Normal })
    property font headlineMedium: Qt.font({ pointSize: 28, weight: Font.Normal })
    property font headlineSmall: Qt.font({ pointSize: 24, weight: Font.Normal })
    property font titleLarge: Qt.font({ pointSize: 22, weight: Font.Normal })
    property font titleMedium: Qt.font({ pointSize: 16, weight: Font.Medium })
    property font titleSmall: Qt.font({ pointSize: 14, weight: Font.Medium })
    property font bodyLarge: Qt.font({ pointSize: 16, weight: Font.Normal })
    property font bodyMedium: Qt.font({ pointSize: 14, weight: Font.Normal })
    property font bodySmall: Qt.font({ pointSize: 12, weight: Font.Normal })
    property font labelLarge: Qt.font({ pointSize: 14, weight: Font.Medium })
    property font labelMedium: Qt.font({ pointSize: 12, weight: Font.Medium })
    property font labelSmall: Qt.font({ pointSize: 11, weight: Font.Medium })

    // ================= MOTION: M3 expressive =================
    // Kurva emphasized M3: cubic-bezier(0.05, 0.7, 0.1, 1.0)
    // dipakai sebagai: easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized
    property list<real> emphasized: [0.05, 0.7, 0.1, 1.0, 1.0, 1.0]
    property list<real> emphasizedAccelerate: [0.3, 0.0, 0.8, 0.15, 1.0, 1.0]
    property list<real> emphasizedDecelerate: [0.05, 0.7, 0.1, 1.0, 1.0, 1.0]
    property list<real> standard: [0.2, 0.0, 0.0, 1.0, 1.0, 1.0]
    property int motionShort1: 50
    property int motionShort2: 100
    property int motionShort3: 150
    property int motionShort4: 200
    property int motionMedium1: 250
    property int motionMedium2: 300
    property int motionMedium3: 350
    property int motionMedium4: 400

    function toggle() { dark = !dark }

    // ================= SYSBRIDGE (backend opsional) =================
    // run_shell.py menyediakan objek `Sys`. Di qmlscene, Sys tidak ada
    // → otomatis mode demo (console.log) sehingga UI tetap bisa dibuka.
    // Seluruh aksi sistem WAJIB lewat helper ini, jangan panggil Sys langsung.
    function hasSys() { return typeof Sys !== "undefined" }
    function exec(prog, args) {
        if (hasSys())
            Sys.execDetached(prog, args || [])
        else
            console.log("[demo]", prog, (args || []).join(" "))
    }
    function execSync(prog, args) {
        if (hasSys())
            return Sys.execSync(prog, args || [])
        return ""
    }
    function hasBin(name) { return hasSys() ? Sys.hasBin(name) : false }
    function readText(path) { return hasSys() ? Sys.readText(path) : "" }
}
