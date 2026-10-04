import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "modules"

// ============================================================
// VAELESTICAL SHELL REV 2.0 — entry point (runnable di qmlscene)
// Harness uji: test-bar atas untuk toggle tiap panel + status bawah.
// ============================================================
ApplicationWindow {
    id: root
    visible: true
    width: 1366
    height: 768
    title: "Vaelestical Shell REV 2.0"
    color: "transparent"

    // ---- global state ----
    property string gpuDriverStatus: "VMware SVGA 3D (fallback VM)"
    property string activeGpu: "VMware SVGA 3D"
    property real barHeight: 56
    property real cornerRadius: 20
    property string barPosition: "left" // top | bottom | left | right
    property bool lightMode: false

    // ---- Material You tokens ----
    property color baseWindow: "#0d0e12"
    property color surfaceContainerBase: "#1a1b22"
    property color surfaceHigh: "#262732"
    property color borderColor: "#333545"
    property color accentPrimary: "#a8c7fa"
    property color activeFill: "#384661"
    property color textPrimary: "#e3e2e6"
    property color textSecondary: "#8e9099"

    // ---- backdrop (agar terlihat saat diuji di window) ----
    Rectangle {
        anchors.fill: parent
        color: root.lightMode ? "#f5f6fa" : root.baseWindow
        Behavior on color { ColorAnimation { duration: 300; easing.type: Easing.OutCubic } }
    }

    // ---- test bar ----
    Rectangle {
        id: testBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 44
        color: "#1a1b22"
        opacity: 0.96
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 6
            Text { text: "VAELESTICAL TEST"; color: root.textSecondary; font.pointSize: 9; font.bold: true }
            Button { text: "Dash"; font.pointSize: 9; checkable: true; checked: true;
                onToggled: dash.visible = checked }
            Button { text: "Control"; font.pointSize: 9; checkable: true; checked: false;
                onToggled: control.visible = checked }
            Button { text: "Wallpaper"; font.pointSize: 9; checkable: true; checked: false;
                onToggled: wall.visible = checked }
            Button { text: "Settings"; font.pointSize: 9; checkable: true; checked: false;
                onToggled: settings.visible = checked }
            Button { text: "Utils"; font.pointSize: 9; checkable: true; checked: false;
                onToggled: utils.visible = checked }
            Button { text: "Gaming"; font.pointSize: 9; checkable: true; checked: false;
                onToggled: gaming.visible = checked }
            Button { text: "Lock"; font.pointSize: 9; checkable: true; checked: false;
                onToggled: login.visible = checked }
            ComboBox {
                id: posBox
                Layout.preferredWidth: 110
                font.pointSize: 9
                model: ["left", "top", "bottom", "right"]
                currentIndex: 0
                onActivated: root.barPosition = currentText
            }
            Button { text: root.lightMode ? "Dark" : "Light"; font.pointSize: 9;
                onClicked: root.lightMode = !root.lightMode }
            Item { Layout.fillWidth: true }
            Text { text: root.activeGpu; color: root.textSecondary; font.pointSize: 9 }
        }
    }

    // ---- Module A: sidebar (posisi mengikuti barPosition) ----
    LeftSidebar {
        id: leftBar
        anchors.left: root.barPosition === "left" ? parent.left : undefined
        anchors.right: root.barPosition === "right" ? parent.right : undefined
        anchors.top: root.barPosition === "top" ? testBar.bottom : undefined
        anchors.bottom: root.barPosition === "bottom" ? statusBar.top : undefined
        anchors.horizontalCenter: (root.barPosition === "top" || root.barPosition === "bottom") ? parent.horizontalCenter : undefined
        anchors.verticalCenter: (root.barPosition === "left" || root.barPosition === "right") ? parent.verticalCenter : undefined
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        barPosition: root.barPosition
        cornerRadius: root.cornerRadius
        z: 110
    }

    // ---- Module B: dashboard ----
    CentralDashboard {
        id: dash
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        z: 100
    }

    // ---- Module C: wallpaper ----
    WallpaperPicker {
        id: wall
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.bottom: statusBar.top
        anchors.bottomMargin: 10
        visible: false
        z: 120
        onAccentChanged: console.log("aksen wallpaper:", accent)
    }

    // ---- Module D: control center ----
    ControlCenter {
        id: control
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: testBar.bottom
        anchors.topMargin: 8
        visible: false
        z: 150
    }

    // ---- Module V: settings ----
    SettingsHub {
        id: settings
        anchors.centerIn: parent
        visible: false
        z: 200
    }

    // ---- Module E: utilities ----
    UtilitiesAI {
        id: utils
        anchors.centerIn: parent
        visible: false
        z: 200
    }

    // ---- Module F: gaming ----
    GamingAudioAdvanced {
        id: gaming
        anchors.centerIn: parent
        visible: false
        z: 200
    }

    // ---- Module IV: login/lockscreen ----
    LoginDashboard {
        id: login
        anchors.fill: parent
        visible: false
        z: 300
    }

    // ---- status bar ----
    Rectangle {
        id: statusBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 26
        color: "#1a1b22"
        opacity: 0.96
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            Text { text: "60 FPS • GPU layer cached • QtQuick 6"; color: root.textSecondary; font.pointSize: 9 }
            Item { Layout.fillWidth: true }
            Text { text: root.gpuDriverStatus; color: root.textSecondary; font.pointSize: 9 }
        }
    }

    // ---- shortcuts uji (Ctrl+…) ----
    Shortcut { sequence: "Ctrl+L"; onActivated: login.visible = !login.visible }
    Shortcut { sequence: "Ctrl+D"; onActivated: dash.visible = !dash.visible }
    Shortcut { sequence: "Ctrl+W"; onActivated: wall.visible = !wall.visible }
    Shortcut { sequence: "Ctrl+C"; onActivated: control.visible = !control.visible }
    Shortcut { sequence: "Ctrl+S"; onActivated: settings.visible = !settings.visible }
    Shortcut { sequence: "Ctrl+U"; onActivated: utils.visible = !utils.visible }
    Shortcut { sequence: "Ctrl+G"; onActivated: gaming.visible = !gaming.visible }
}
