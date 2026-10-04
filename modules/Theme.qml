pragma Singleton
import QtQuick

// ============================================================
// Theme — skema warna terpusat Material You M3 Expressive.
// SOLID: semua warna opaque (tanpa transparansi/blur) agar
// kontras teks tajam dan rendering ringan.
// Daftarkan sebagai singleton di modules/qmldir:
//     singleton Theme Theme.qml
// ============================================================
QtObject {
    id: theme

    property bool dark: true

    // ---------- M3 dark (solid) ----------
    property color _bgD: "#131318"
    property color _surfaceD: "#1d1b20"
    property color _containerD: "#211f26"
    property color _containerHighD: "#2b2930"
    property color _containerHighestD: "#36343b"
    property color _onSurfaceD: "#e6e0e9"
    property color _onVariantD: "#cac4d0"
    property color _outlineD: "#49454f"
    property color _primaryD: "#d0bcff"
    property color _onPrimaryD: "#381e72"
    property color _primaryContainerD: "#4f378b"
    property color _accentD: "#a8c7fa"
    property color _successD: "#4ade80"
    property color _warningD: "#fbbf24"
    property color _errorD: "#f2b8c6"

    // ---------- M3 light (solid) ----------
    property color _bgL: "#fef7ff"
    property color _surfaceL: "#fef7ff"
    property color _containerL: "#f3edf7"
    property color _containerHighL: "#ece6f0"
    property color _containerHighestL: "#e6e0e9"
    property color _onSurfaceL: "#1d1b20"
    property color _onVariantL: "#49454f"
    property color _outlineL: "#79747e"
    property color _primaryL: "#6750a4"
    property color _onPrimaryL: "#ffffff"
    property color _primaryContainerL: "#eaddff"
    property color _accentL: "#415f91"
    property color _successL: "#146c2e"
    property color _warningL: "#7c4a03"
    property color _errorL: "#ba1a1a"

    // ---------- token aktif (mengikuti mode) ----------
    property color background: dark ? _bgD : _bgL
    property color surface: dark ? _surfaceD : _surfaceL
    property color surfaceContainer: dark ? _containerD : _containerL
    property color surfaceContainerHigh: dark ? _containerHighD : _containerHighL
    property color surfaceContainerHighest: dark ? _containerHighestD : _containerHighestL
    property color onSurface: dark ? _onSurfaceD : _onSurfaceL
    property color onSurfaceVariant: dark ? _onVariantD : _onVariantL
    property color outline: dark ? _outlineD : _outlineL
    property color primary: dark ? _primaryD : _primaryL
    property color onPrimary: dark ? _onPrimaryD : _onPrimaryL
    property color primaryContainer: dark ? _primaryContainerD : _primaryContainerL
    property color accent: dark ? _accentD : _accentL
    property color active: accent
    property color inactive: outline
    property color success: dark ? _successD : _successL
    property color warning: dark ? _warningD : _warningL
    property color error: dark ? _errorD : _errorL
    property color shadow: dark ? "#0a0a0f" : "#d9d3e0"

    // ---------- shape scale M3 Expressive ----------
    property int cardRadius: 18
    property int pillRadius: 99

    function toggle() { dark = !dark }
}
