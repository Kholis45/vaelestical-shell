// ============================================================
// VXVICFG SHELL v2.0 ULTIMATE — Quickshell layer-shell entry
// Jalankan (Arch/CachyOS):  quickshell -p shell.qml
// Berbagi modules/ + Theme singleton dengan entry qmlscene/PySide6
// (main.qml). Di Quickshell, objek `Sys` tidak ada → Theme.exec
// otomatis mode demo (console.log); pasang libvxvicfg_core.so
// (import Vxvicfg.Core) untuk telemetri/Aksi native.
// ============================================================
import QtQuick
import Quickshell
import Quickshell.Wayland
import "modules" as Mod

ShellRoot {
    id: root
    property string barPosition: "left" // top | bottom | left | right
    property bool dashboardOpen: true
    property bool controlOpen: false
    property bool wallpaperOpen: false

    Variants {
        model: Quickshell.screens
        delegate: Component {
            Item {
                required property var modelData

                // Bar mengambang (kiri/kanan/atas/bawah mengikuti barPosition)
                PanelWindow {
                    screen: modelData
                    WlrLayershell.layer: WlrLayer.Top
                    WlrLayershell.namespace: "vxvicfg-bar"
                    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                    exclusionMode: ExclusionMode.Ignore
                    color: "transparent"
                    anchors {
                        left: root.barPosition === "left"
                        right: root.barPosition === "right"
                        top: root.barPosition === "top"
                        bottom: root.barPosition === "bottom"
                    }
                    margins {
                        left: 12; right: 12; top: 12; bottom: 12
                    }
                    implicitWidth: bar.width
                    implicitHeight: bar.height
                    Mod.LeftSidebar {
                        id: bar
                        barPosition: root.barPosition
                    }
                }

                // Dashboard tengah-atas
                PanelWindow {
                    visible: root.dashboardOpen
                    screen: modelData
                    WlrLayershell.layer: WlrLayer.Top
                    WlrLayershell.namespace: "vxvicfg-dash"
                    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
                    exclusionMode: ExclusionMode.Ignore
                    color: "transparent"
                    anchors { top: true }
                    margins { top: 12 }
                    implicitWidth: dash.width
                    implicitHeight: dash.height
                    Mod.CentralDashboard { id: dash }
                }

                // Control center kanan
                PanelWindow {
                    visible: root.controlOpen
                    screen: modelData
                    WlrLayershell.layer: WlrLayer.Top
                    WlrLayershell.namespace: "vxvicfg-control"
                    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
                    exclusionMode: ExclusionMode.Ignore
                    color: "transparent"
                    anchors { right: true }
                    margins { right: 12 }
                    implicitWidth: control.width
                    implicitHeight: control.height
                    Mod.ControlCenter { id: control }
                }

                // Wallpaper bawah
                PanelWindow {
                    visible: root.wallpaperOpen
                    screen: modelData
                    WlrLayershell.layer: WlrLayer.Top
                    WlrLayershell.namespace: "vxvicfg-wall"
                    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
                    exclusionMode: ExclusionMode.Ignore
                    color: "transparent"
                    anchors { bottom: true }
                    margins { bottom: 12 }
                    implicitWidth: wall.width
                    implicitHeight: wall.height
                    Mod.WallpaperPicker { id: wall }
                }
            }
        }
    }
}
