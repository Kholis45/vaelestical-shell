import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "modules"

// ============================================================
// VXVICFG SHELL REV 2.0 — entry point (runnable di qmlscene)
// Bahasa desain: Material 3 Expressive penuh (token di Theme).
// ============================================================
ApplicationWindow {
    id: root
    visible: true
    width: 1366
    height: 768
    title: "vxvicfg shell REV 2.0"
    color: Theme.background

    // ---- global state ----
    property string gpuDriverStatus: "VMware SVGA 3D (fallback VM)"
    property string activeGpu: "VMware SVGA 3D"
    property real barHeight: 56
    property real cornerRadius: Theme.cardRadius
    property string barPosition: "left" // top | bottom | left | right
    property bool lightMode: false

    // ---- alias token (kompatibilitas) ----
    property color baseWindow: Theme.background
    property color surfaceContainerBase: Theme.surfaceContainer
    property color surfaceHigh: Theme.surfaceContainerHigh
    property color borderColor: Theme.outlineVariant
    property color accentPrimary: Theme.accent
    property color activeFill: Theme.primaryContainer
    property color textPrimary: Theme.onSurface
    property color textSecondary: Theme.onSurfaceVariant

    onLightModeChanged: Theme.dark = !lightMode
    Connections {
        target: Theme
        function onDarkChanged() {
            var want = !Theme.dark
            if (root.lightMode !== want)
                root.lightMode = want
        }
    }

    // ---- test bar (solid pill) ----
    Rectangle {
        id: testBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 8
        height: 44
        radius: Theme.pillRadius
        color: Theme.surfaceContainer
        border.color: Theme.outlineVariant
        border.width: 1
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            spacing: 6
            Text { text: "VXVI TEST"; color: Theme.onSurfaceVariant; font: Theme.labelSmall }
            Button { text: "Dash"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: true;
                onToggled: dash.visible = checked }
            Button { text: "Control"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: control.visible = checked }
            Button { text: "Wallpaper"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: wall.visible = checked }
            Button { text: "Settings"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: settings.visible = checked }
            Button { text: "Utils"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: utils.visible = checked }
            Button { text: "Gaming"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: gaming.visible = checked }
            Button { text: "Lock"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: login.visible = checked }
            Button { text: "Flyout"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: flyout.visible = checked }
            Button { text: "Pro"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: pro.visible = checked }
            Button { text: "LScreen"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8; checkable: true; checked: false;
                onToggled: lock2.visible = checked }
            ComboBox {
                id: posBox
                Layout.preferredWidth: 92
                font: Theme.labelSmall
                model: ["left", "top", "bottom", "right"]
                currentIndex: 0
                onActivated: root.barPosition = currentText
            }
            Button { text: root.lightMode ? "Dark" : "Light"; font: Theme.labelSmall; leftPadding: 8; rightPadding: 8;
                onClicked: root.lightMode = !root.lightMode }
            Item { Layout.fillWidth: true }
            Text { text: "M3E • Qt6"; color: Theme.onSurfaceVariant; font: Theme.labelSmall }
        }
    }

    // ---- Module A: sidebar (posisi mengikuti barPosition) ----
    LeftSidebar {
        id: leftBar
        objectName: "sideBar"
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
        objectName: "dashPanel"
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        z: 100
    }

    // ---- Module C: wallpaper ----
    WallpaperPicker {
        id: wall
        objectName: "wallPanel"
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.bottom: statusBar.top
        anchors.bottomMargin: 10
        visible: false
        z: 120
    }

    // ---- Module D: control center ----
    ControlCenter {
        id: control
        objectName: "controlPanel"
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
        objectName: "settingsPanel"
        anchors.centerIn: parent
        visible: false
        z: 200
    }

    // ---- Module E: utilities ----
    UtilitiesAI {
        id: utils
        objectName: "utilsPanel"
        anchors.centerIn: parent
        visible: false
        z: 200
    }

    // ---- Module F: gaming ----
    GamingAudioAdvanced {
        id: gaming
        objectName: "gamingPanel"
        anchors.centerIn: parent
        visible: false
        z: 200
    }

    // ---- Module IV: login/lockscreen ----
    LoginDashboard {
        id: login
        objectName: "loginPanel"
        anchors.fill: parent
        visible: false
        z: 300
    }

    // ---- Module E2: utilities flyout ----
    UtilitiesFlyout {
        id: flyout
        objectName: "flyoutPanel"
        anchors.centerIn: parent
        visible: false
        z: 200
    }

    // ---- Module F2: pro gaming overlay ----
    ProGamingOverlay {
        id: pro
        objectName: "proPanel"
        anchors.centerIn: parent
        visible: false
        z: 200
    }

    // ---- Module IV2: lockscreen alternatif ----
    Lockscreen {
        id: lock2
        objectName: "lockscreenPanel"
        anchors.fill: parent
        visible: false
        z: 290
    }

    // ---- HAKU: bottom taskbar (visible default) ----
    HakuTaskbar {
        id: hakuBar
        objectName: "hakuTaskbar"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 44
        anchors.horizontalCenter: parent.horizontalCenter
        z: 120
    }

    // ---- HAKU: settings modal ----
    HakuSettings {
        id: hakuSettings
        objectName: "hakuSettingsPanel"
        anchors.centerIn: parent
        visible: false
        z: 210
    }

    // ---- HAKU: desktop clock ----
    HakuClock {
        id: hakuClock
        objectName: "hakuClockPanel"
        anchors.centerIn: parent
        visible: false
        z: 90
    }

    // ---- HAKU: cava strip ----
    HakuCava {
        id: hakuCava
        objectName: "hakuCavaPanel"
        anchors.top: testBar.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        z: 90
    }

    // ---- HAKU: wallpaper grid ----
    HakuWallpaper {
        id: hakuWall
        objectName: "hakuWallPanel"
        anchors.centerIn: parent
        visible: false
        z: 210
    }

    // ---- HAKU: context menu ----
    HakuMenu {
        id: hakuMenu
        objectName: "hakuMenuPanel"
        anchors.centerIn: parent
        visible: false
        z: 220
    }

    // ---- status bar (solid pill) ----
    Rectangle {
        id: statusBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.bottomMargin: 8
        height: 26
        radius: Theme.pillRadius
        color: Theme.surfaceContainer
        border.color: Theme.outlineVariant
        border.width: 1
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            Text { text: "60 FPS • M3 Expressive • QtQuick 6"; color: Theme.onSurfaceVariant; font: Theme.labelSmall }
            Item { Layout.fillWidth: true }
            Text { text: root.gpuDriverStatus; color: Theme.onSurfaceVariant; font: Theme.labelSmall }
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
    Shortcut { sequence: "Ctrl+O"; onActivated: flyout.visible = !flyout.visible }
    Shortcut { sequence: "Ctrl+P"; onActivated: pro.visible = !pro.visible }
    Shortcut { sequence: "Ctrl+Shift+L"; onActivated: lock2.visible = !lock2.visible }
    Shortcut { sequence: "Ctrl+T"; onActivated: hakuBar.visible = !hakuBar.visible }
    Shortcut { sequence: "Ctrl+H"; onActivated: hakuSettings.visible = !hakuSettings.visible }
    Shortcut { sequence: "Ctrl+N"; onActivated: hakuWall.visible = !hakuWall.visible }
    Shortcut { sequence: "Ctrl+V"; onActivated: hakuCava.visible = !hakuCava.visible }
    Shortcut { sequence: "Ctrl+M"; onActivated: hakuMenu.visible = !hakuMenu.visible }
    Shortcut { sequence: "Ctrl+B"; onActivated: hakuClock.visible = !hakuClock.visible }

    // ---- polling telemetri via SysBridge (aktif bila via run_shell.py) ----
    // Aman di qmlscene: sysObj null → Connections inert, tanpa warning.
    property var sysObj: typeof Sys !== "undefined" ? Sys : null
    Component.onCompleted: { if (sysObj) sysObj.startPolling(2000) }
    Connections {
        target: root.sysObj
        function onPolled(d) {
            if (d.ws !== undefined)
                leftBar.currentWorkspace = d.ws
            if (d.gpu !== undefined)
                root.gpuDriverStatus = "NVIDIA " + d.gpu.load + "% • " + d.gpu.temp
                    + "°C • VRAM " + d.gpu.vramUsed + "/" + d.gpu.vramTotal + " MB"
        }
    }

    // ---- IPC Hyprland: perintah Super-key dibaca dari file antrian ----
    // hyprland/vxvicfg-binds.conf menulis kata perintah ke file ini
    // (satu baris per keypress). Timer membaca tiap 250ms dan hanya
    // memproses baris yang belum terlihat. File boleh tidak ada.
    property string cmdFile: Qt.platform.os === "windows"
        ? "file:///C:/Temp/vxvicfg.cmd"
        : "file:///tmp/vxvicfg.cmd"

    function handleCommand(cmd) {
        if (cmd === "dash") dash.visible = !dash.visible
        else if (cmd === "wall") wall.visible = !wall.visible
        else if (cmd === "control") control.visible = !control.visible
        else if (cmd === "settings") settings.visible = !settings.visible
        else if (cmd === "utils") utils.visible = !utils.visible
        else if (cmd === "gaming") gaming.visible = !gaming.visible
        else if (cmd === "lock") login.visible = !login.visible
        else if (cmd === "flyout") flyout.visible = !flyout.visible
        else if (cmd === "pro") pro.visible = !pro.visible
        else if (cmd === "lock2") lock2.visible = !lock2.visible
        else if (cmd === "taskbar") hakuBar.visible = !hakuBar.visible
        else if (cmd === "hakusettings") hakuSettings.visible = !hakuSettings.visible
        else if (cmd === "hakuwall") hakuWall.visible = !hakuWall.visible
        else if (cmd === "cava") hakuCava.visible = !hakuCava.visible
        else if (cmd === "hakumenu") hakuMenu.visible = !hakuMenu.visible
        else if (cmd === "hakuclock") hakuClock.visible = !hakuClock.visible
        else if (cmd === "theme") root.lightMode = !root.lightMode
        else if (cmd === "shot") Theme.exec("sh", ["-c", 'grim -g "$(slurp)" ~/Pictures/vxvicfg-$(date +%s).png 2>/dev/null; true'])
        else if (cmd.indexOf("barpos:") === 0) {
            var pos = cmd.slice(7)
            if (["left", "top", "bottom", "right"].indexOf(pos) !== -1)
                root.barPosition = pos
        }
        else if (cmd.indexOf("gpu:") === 0) {
            root.activeGpu = cmd.slice(4)
            root.gpuDriverStatus = cmd.slice(4) + " (terpilih)"
        }
        else if (cmd !== "") console.log("perintah IPC tak dikenal:", cmd)
    }

    Timer {
        id: ipcTimer
        interval: 250
        running: true
        repeat: true
        property int seen: 0
        onTriggered: {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", root.cmdFile)
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    var t = xhr.responseText
                    if (t === undefined || t === null)
                        return
                    var lines = String(t).split("\n")
                    if (lines.length < ipcTimer.seen)
                        ipcTimer.seen = 0 // file dipotong/di-rotate dari luar
                    for (var i = ipcTimer.seen; i < lines.length; i++) {
                        var cmd = lines[i].trim()
                        if (cmd !== "")
                            root.handleCommand(cmd)
                    }
                    ipcTimer.seen = lines.length
                }
            }
            xhr.send()
        }
    }

    // ---- hook uji otomatis (read-only, aman di produksi) ----
    // Mengembalikan "x y w h" (koordinat window) item ber-objectName,
    // atau "" bila tidak ketemu. Dipakai suite uji QTest.
    // NOTE: traversal mulai dari contentItem karena ApplicationWindow
    // (QWindow) tidak punya properti QML `children`.
    function debugGeom(name) {
        var found = _debugFind(contentItem, name)
        if (!found || found.width === undefined)
            return ""
        var p = found.mapToItem(null, 0, 0)
        return p.x + " " + p.y + " " + found.width + " " + found.height
    }
    function _debugFind(o, name) {
        if (!o)
            return null
        if (o.objectName === name)
            return o
        var kids = o.children
        if (kids === undefined)
            return null // QObject non-visual (Timer, dkk.) tidak punya children
        for (var i = 0; i < kids.length; i++) {
            var r = _debugFind(kids[i], name)
            if (r)
                return r
        }
        return null
    }
}
