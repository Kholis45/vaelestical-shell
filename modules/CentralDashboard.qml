import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils/Formatters.js" as F
import "../utils/MathHelpers.js" as M

// MODULE B: Central multi-tab dashboard + dynamic island (M3E penuh).
Item {
    id: root
    property int currentTab: 0
    property int currentWs: 1
    property string song: "ODESZA - Falls"
    property string songSub: "In Return (2014)"
    property real playPos: 72
    // State visualizer GPU (di-update Timer 50ms di bawah).
    property real spectrumTime: 0
    property real spectrumEnergy: 0.5
    property real spectrumEnergyVel: 0
    // State live: telemetri, MPRIS, kalender (di-update Timer di bawah).
    property bool hasPlayerctl: false
    property real cpuPct: 42
    property string cpuTemp: "62°C"
    property real memPct: 53
    property string memText: "8.4 / 16 GB"
    property var lyricLines: ["[00:41] sunlight hums through the static…", "Lirik tersinkron (.lrc) — demo statis"]
    property int monthOffset: 0
    property var calDays: []
    property bool mprisPlaying: false

    width: 620
    height: 660

    function setIslandState(s) { islandState.text = s }

    function refreshCal() {
        var now = new Date()
        var d = new Date(now.getFullYear(), now.getMonth() + root.monthOffset, 1)
        var year = d.getFullYear(), mon = d.getMonth()
        var first = (new Date(year, mon, 1).getDay() + 6) % 7 // Senin awal
        var dim = new Date(year, mon + 1, 0).getDate()
        var arr = []
        for (var i = 0; i < first; i++)
            arr.push({ d: "", today: false })
        for (var day = 1; day <= dim; day++)
            arr.push({ d: String(day), today: root.monthOffset === 0 && day === now.getDate() })
        root.calDays = arr
        var names = ["Januari", "Februari", "Maret", "April", "Mei", "Juni",
                     "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
        calTitle.text = names[mon] + " " + year
    }

    function loadLyrics(track) {
        var safe = track.replace(/[^A-Za-z0-9 _.,()-]/g, "").slice(0, 60)
        var raw = Theme.execSync("sh", ["-c", "cat \"$HOME/Music/" + safe + ".lrc\" 2>/dev/null | head -20"])
        if (raw === "") {
            root.lyricLines = ["♪ " + track.slice(0, 60), "Lirik .lrc tidak ditemukan di ~/Music"]
            return
        }
        var out = []
        var lines = raw.split("\n")
        for (var i = 0; i < lines.length && out.length < 3; i++) {
            var t = lines[i].replace(/^\[\d+:\d+(\.\d+)?\]/, "").trim()
            if (t !== "")
                out.push("♪ " + t)
        }
        root.lyricLines = out.length > 0 ? out : ["(lrc kosong)"]
    }

    // Solid shadow + body solid
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.leftMargin: 2
        radius: Theme.cardRadius
        color: Theme.shadow
    }
    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 3
        anchors.rightMargin: 2
        radius: Theme.cardRadius
        color: Theme.surface
        border.color: Theme.outlineVariant
        border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Dynamic island (solid pill + progress lagu)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            radius: Theme.pillRadius
            color: Theme.surfaceContainerHigh
            border.color: Theme.outlineVariant
            border.width: 1
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 14
                spacing: 10
                Rectangle {
                    width: 44; height: 44; radius: Theme.shapeMedium
                    color: Theme.primaryContainer
                    border.color: Theme.accent; border.width: 1
                    Text { anchors.centerIn: parent; text: "♪"; color: Theme.accent; font: Theme.titleMedium }
                    Layout.alignment: Qt.AlignVCenter
                }
                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    Text { text: root.song; color: Theme.onSurface; font: Theme.titleSmall; elide: Text.ElideRight }
                    Text { text: root.songSub; color: Theme.onSurfaceVariant; font: Theme.labelSmall; elide: Text.ElideRight }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 4
                        radius: Theme.pillRadius
                        color: Theme.surfaceContainerHighest
                        Rectangle {
                            width: parent.width * Math.min(1, root.playPos / 259)
                            height: 4
                            radius: Theme.pillRadius
                            color: Theme.accent
                            Behavior on width {
                                NumberAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                            }
                        }
                    }
                }
                Text { id: islandClock; text: "10:30"; color: Theme.onSurface; font: Theme.labelLarge }
                Text { id: islandState; text: "compact"; color: Theme.onSurfaceVariant; font: Theme.labelSmall; visible: false }
            }
            Behavior on height {
                NumberAnimation { duration: Theme.motionMedium1; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
            }
        }

        // Tab bar M3: indikator pill penuh
        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            Repeater {
                model: ["Dashboard", "Media", "Performance", "Workspaces"]
                delegate: Rectangle {
                    required property int index
                    required property var modelData
                    property bool active: root.currentTab === index
                    objectName: "tabPill" + index
                    Layout.fillWidth: true
                    height: 40
                    radius: Theme.pillRadius
                    color: active ? Theme.secondaryContainer : Theme.surfaceContainerHigh
                    border.color: active ? Theme.secondaryContainer : Theme.outlineVariant
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: active ? Theme.onSecondaryContainer : Theme.onSurfaceVariant
                        font: Theme.labelLarge
                    }
                    Behavior on color {
                        ColorAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                    }
                    MouseArea { id: tabMa; anchors.fill: parent; hoverEnabled: true; onClicked: root.currentTab = index }
                    StateLayer { anchors.fill: parent; cornerRadius: Theme.pillRadius; hoverSource: tabMa }
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.currentTab

            // TAB 0: dashboard
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 8
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 132
                        radius: Theme.cardRadius; color: Theme.surfaceContainer
                        border.color: Theme.outlineVariant; border.width: 1
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 2
                            Text { id: bigClock; text: "--:--"; color: Theme.onSurface; font: Theme.displaySmall }
                            Text { id: bigDate; text: ""; color: Theme.onSurfaceVariant; font: Theme.bodyMedium }
                            Text { id: wxText; text: "Kepanjen 28°C • AQI 42 Baik"; color: Theme.onSurfaceVariant; font: Theme.bodyMedium }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        radius: Theme.cardRadius; color: Theme.surfaceContainer
                        border.color: Theme.outlineVariant; border.width: 1
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 4
                            Text { text: "CachyOS • Kernel 6.6.15-1 • Hyprland/Wayland"; color: Theme.onSurface; font: Theme.titleSmall }
                            Text { id: uptimeText; text: "Uptime 0h 00m"; color: Theme.onSurfaceVariant; font: Theme.bodyMedium }
                            ProgressBar { Layout.fillWidth: true; from: 0; to: 100; value: root.memPct }
                            Text { text: "RAM " + root.memText; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 172
                        radius: Theme.cardRadius; color: Theme.surfaceContainer
                        border.color: Theme.outlineVariant; border.width: 1
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 2
                            RowLayout {
                                Layout.fillWidth: true
                                Button { text: "‹"; font: Theme.labelMedium; onClicked: root.monthOffset-- }
                                Text {
                                    id: calTitle
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignHCenter
                                    text: ""
                                    color: Theme.onSurface; font: Theme.titleSmall
                                }
                                Button { text: "›"; font: Theme.labelMedium; onClicked: root.monthOffset++ }
                            }
                            Grid {
                                columns: 7; spacing: 3
                                Layout.alignment: Qt.AlignHCenter
                                Repeater {
                                    model: root.calDays
                                    delegate: Rectangle {
                                        required property var modelData
                                        width: 24; height: 20; radius: 7
                                        color: modelData.today ? Theme.accent : "transparent"
                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.d
                                            font.pixelSize: 10
                                            color: modelData.today ? Theme.onPrimary : Theme.onSurface
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // TAB 1: media
            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 8
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 150
                        radius: Theme.cardRadius; color: Theme.surfaceContainer
                        border.color: Theme.outlineVariant; border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 12
                            Rectangle {
                                id: coverArt
                                width: 96; height: 96; radius: Theme.shapeMedium; color: Theme.primaryContainer
                                border.color: Theme.accent; border.width: 1
                                Text { anchors.centerIn: parent; text: "♪"; color: Theme.accent; font: Theme.headlineLarge }
                                // Glow aksen GPU (M3ExpressiveBorder.frag); sembunyi bila shader error.
                                ShaderEffect {
                                    anchors.fill: parent
                                    anchors.margins: -10
                                    z: -1
                                    visible: status !== ShaderEffect.Error
                                    fragmentShader: "../shaders/M3ExpressiveBorder.frag"
                                    property color accent: Theme.accent
                                    property vector2d res: Qt.vector2d(width, height)
                                    property real radius: 30
                                    property real borderWidth: 2.0
                                    property real glow: 0.6
                                }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true; spacing: 4
                                Text { text: root.song; color: Theme.onSurface; font: Theme.headlineSmall }
                                Text { text: root.songSub; color: Theme.onSurfaceVariant; font: Theme.bodySmall }
                                Slider { Layout.fillWidth: true; from: 0; to: 259; value: root.playPos;
                                    onMoved: root.playPos = value }
                                RowLayout {
                                    Text { text: "1:12"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                                    Item { Layout.fillWidth: true }
                                    Button { text: "|◀"; font: Theme.labelMedium; onClicked: Theme.exec("playerctl", ["previous"]) }
                                    Button { text: "▶"; font: Theme.labelMedium; onClicked: Theme.exec("playerctl", ["play-pause"]) }
                                    Button { text: "▶|"; font: Theme.labelMedium; onClicked: Theme.exec("playerctl", ["next"]) }
                                    Item { Layout.fillWidth: true }
                                    Text { text: "4:19"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                                }
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Volume (boost s/d 150%)"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                        Slider {
                            Layout.fillWidth: true
                            from: 0; to: 150; value: 78
                            // Terapkan saat dilepas agar tidak spam proses.
                            onPressedChanged: {
                                if (!pressed)
                                    Theme.exec("wpctl", ["set-volume", "@DEFAULT_AUDIO_SINK@", String(value / 100)])
                            }
                        }
                        Switch { text: "Boost"; font: Theme.labelMedium }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        radius: Theme.cardRadius; color: Theme.surfaceContainer
                        border.color: Theme.outlineVariant; border.width: 1
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 4
                            Text { text: "Spectrum visualizer (simulasi)"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                            RowLayout {
                                spacing: 4
                                Repeater {
                                    model: 28
                                    delegate: Rectangle {
                                        required property int index
                                        Layout.alignment: Qt.AlignBottom
                                        width: 10
                                        height: 8 + 34 * Math.abs(Math.sin((index + eqTick.n) * 0.55))
                                        radius: Theme.shapeExtraSmall
                                        color: index % 3 === 0 ? Theme.accent : (index % 3 === 1 ? Theme.primary : Theme.primaryContainer)
                                        Behavior on height {
                                            NumberAnimation { duration: Theme.motionShort3; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                                        }
                                    }
                                }
                            }
                            // Visualizer gelombang GPU (SpectrumWave.frag); aditif di bawah bar.
                            ShaderEffect {
                                id: waveShader
                                Layout.fillWidth: true
                                Layout.preferredHeight: 56
                                visible: status !== ShaderEffect.Error
                                fragmentShader: "../shaders/SpectrumWave.frag"
                                property real time: root.spectrumTime
                                property real energy: root.spectrumEnergy
                                property color accent: Theme.accent
                                property color base: Theme.surfaceContainer
                            }
                            Text { text: "Riwayat putar"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                            ListView {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 56
                                clip: true
                                model: trackHistory
                                delegate: Text {
                                    required property var modelData
                                    width: ListView.view.width
                                    text: "• " + modelData.t
                                    color: Theme.onSurfaceVariant; font: Theme.bodySmall; elide: Text.ElideRight
                                }
                            }
                            Repeater {
                                model: root.lyricLines
                                delegate: Text {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    text: modelData
                                    color: Theme.onSurfaceVariant; font: Theme.bodySmall; elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }

            // TAB 2: performance
            Item {
                GridLayout {
                    anchors.fill: parent
                    columns: 3
                    columnSpacing: 8; rowSpacing: 8
                    Repeater {
                        model: [
                            { label: "CPU Core i7", v: root.cpuPct, t: root.cpuTemp },
                            { label: "GPU GTX 750 Ti", v: 55, t: "58°C" },
                            { label: "RAM", v: root.memPct, t: root.memText },
                            { label: "VRAM 1.1/2GB", v: 55, t: "—" },
                            { label: "Kipas", v: 46, t: "1820 RPM" },
                            { label: "Jaringan", v: 30, t: "1.2 MB/s" }
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true; Layout.fillHeight: true
                            radius: Theme.cardRadius; color: Theme.surfaceContainer
                            border.color: Theme.outlineVariant; border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 10; spacing: 4
                                Text { text: modelData.label; color: Theme.onSurface; font: Theme.titleSmall }
                                ProgressBar { Layout.fillWidth: true; from: 0; to: 100; value: modelData.v }
                                Text { text: modelData.v + "% • " + modelData.t; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                            }
                        }
                    }
                }
            }

            // TAB 3: workspaces
            Item {
                GridLayout {
                    anchors.fill: parent
                    columns: 2
                    columnSpacing: 8; rowSpacing: 8
                    Repeater {
                        model: 4
                        delegate: Rectangle {
                            required property int index
                            property bool active: root.currentWs === index + 1
                            Layout.fillWidth: true; Layout.fillHeight: true
                            radius: Theme.cardRadius
                            color: active ? Theme.primaryContainer : Theme.surfaceContainer
                            border.color: active ? Theme.primary : Theme.outlineVariant
                            border.width: active ? 2 : 1
                            Behavior on color {
                                ColorAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                            }
                            MouseArea { id: wsCardMa; anchors.fill: parent; hoverEnabled: true;
                                onClicked: {
                                    root.currentWs = index + 1
                                    Theme.exec("hyprctl", ["dispatch", "workspace", String(index + 1)])
                                } }
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 10
                                Text { text: "Workspace " + (index + 1); color: Theme.onSurface; font: Theme.titleSmall }
                                Text { text: index === 0 ? "2 jendela" : "kosong"; color: Theme.onSurfaceVariant; font: Theme.bodySmall }
                                Button { text: "Pindah"; font: Theme.labelMedium;
                                    onClicked: {
                                        root.currentWs = index + 1
                                        Theme.exec("hyprctl", ["dispatch", "workspace", String(index + 1)])
                                    } }
                            }
                            StateLayer { anchors.fill: parent; cornerRadius: Theme.cardRadius; hoverSource: wsCardMa }
                        }
                    }
                }
            }
        }
    }

    Timer { id: eqTick; property int n: 0; interval: 220; running: true; repeat: true; onTriggered: n++ }
    ListModel { id: trackHistory }
    onMonthOffsetChanged: refreshCal()
    Component.onCompleted: {
        root.hasPlayerctl = Theme.hasBin("playerctl")
        root.refreshCal()
    }
    // Telemetri live via sysfs (readText murah, tanpa subprocess).
    Timer {
        interval: Theme.telemetryMs; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var la = Theme.readText("/proc/loadavg")
            if (la !== "") {
                var l1 = parseFloat(la.split(" ")[0])
                if (!isNaN(l1))
                    root.cpuPct = Math.min(100, Math.round(l1 * 25))
            }
            var mem = Theme.readText("/proc/meminfo")
            if (mem !== "") {
                var tot = 0, av = 0
                var lines = mem.split("\n")
                for (var i = 0; i < lines.length; i++) {
                    var p = lines[i].split(/\s+/)
                    if (p[0] === "MemTotal:") tot = parseInt(p[1])
                    else if (p[0] === "MemAvailable:") av = parseInt(p[1])
                }
                if (tot > 0) {
                    var used = tot - av
                    root.memPct = Math.round(used / tot * 100)
                    root.memText = (used / 1048576).toFixed(1) + " / " + (tot / 1048576).toFixed(1) + " GB"
                }
            }
            var th = Theme.readText("/sys/class/thermal/thermal_zone0/temp")
            if (th !== "") {
                var c = parseInt(th.trim()) / 1000
                if (!isNaN(c) && c > 0 && c < 150)
                    root.cpuTemp = Math.round(c) + "°C"
            }
        }
    }
    // MPRIS live + riwayat putar + lirik.
    Timer {
        interval: 5000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            if (!root.hasPlayerctl)
                return
            var st = Theme.execSync("playerctl", ["status"])
            if (st !== "")
                root.mprisPlaying = (st.trim() === "Playing")
            var m = Theme.execSync("playerctl", ["metadata", "--format", "{{artist}} - {{title}}"])
            if (m !== "") {
                m = m.slice(0, 80)
                if (m !== root.song) {
                    root.song = m
                    trackHistory.append({ t: m })
                    if (trackHistory.count > 8)
                        trackHistory.remove(0)
                    root.loadLyrics(m)
                }
            }
            var pos = parseFloat(Theme.execSync("playerctl", ["position"]))
            if (!isNaN(pos))
                root.playPos = pos
        }
    }
    // Cuaca + AQI live (wttr.in / Open-Meteo, tanpa API key) tiap 10 menit.
    Timer {
        interval: 600000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            if (!Theme.hasBin("curl"))
                return
            var w = Theme.execSync("curl", ["-s", "--max-time", "3", "wttr.in/Malang?format=%t"])
            var aqi = Theme.execSync("curl", ["-s", "--max-time", "3", "https://api.open-meteo.com/v1/air-quality?latitude=-7.77&longitude=112.57&hourly=us_aqi&forecast_days=1"])
            var aqiText = "AQI 42 Baik"
            if (aqi !== "") {
                var m = aqi.match(/"us_aqi":\[([0-9]+)/)
                if (m) {
                    var v = parseInt(m[1])
                    aqiText = "AQI " + v + (v <= 50 ? " Baik" : v <= 100 ? " Sedang" : " Buruk")
                }
            }
            if (w !== "")
                wxText.text = "Kepanjen " + w.trim() + " • " + aqiText
        }
    }
    // Visualizer GPU: waktu berjalan + energi dihaluskan via pegas (MathHelpers).
    Timer {
        interval: 50; running: true; repeat: true
        onTriggered: {
            root.spectrumTime += 0.05
            // Redup saat tidak ada audio (playerctl), penuh saat Playing.
            var gate = !root.hasPlayerctl || root.mprisPlaying ? 1.0 : 0.15
            var target = (0.55 + 0.25 * Math.sin(Date.now() / 900)) * gate
            var s = M.springStep(root.spectrumEnergy, target, root.spectrumEnergyVel, 90, 12, 0.05)
            root.spectrumEnergy = s.value
            root.spectrumEnergyVel = s.velocity
        }
    }
    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var d = new Date()
            var hh = ("0" + d.getHours()).slice(-2)
            var mm = ("0" + d.getMinutes()).slice(-2)
            bigClock.text = hh + ":" + mm
            islandClock.text = hh + ":" + mm
            bigDate.text = d.toDateString()
        }
    }
    Timer {
        interval: 60000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: uptimeText.text = "Uptime " + F.formatDuration(134)
    }
}
