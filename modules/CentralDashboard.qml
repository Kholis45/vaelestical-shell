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

    width: 620
    height: 660

    function setIslandState(s) { islandState.text = s }

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
                            Text { text: "Kepanjen 28°C • AQI 42 Baik"; color: Theme.onSurfaceVariant; font: Theme.bodyMedium }
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
                            ProgressBar { Layout.fillWidth: true; from: 0; to: 100; value: 52 }
                            Text { text: "RAM 8.4 / 16 GB"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
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
                        Slider { Layout.fillWidth: true; from: 0; to: 150; value: 78 }
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
                            Text { text: "[00:41] sunlight hums through the static…"; color: Theme.onSurfaceVariant; font: Theme.bodySmall }
                            Text { text: "Lirik tersinkron (.lrc) — demo statis"; color: Theme.onSurfaceVariant; font: Theme.bodySmall }
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
                            { label: "CPU Core i7", v: 42, t: "62°C" },
                            { label: "GPU GTX 750 Ti", v: 55, t: "58°C" },
                            { label: "RAM 8.4GB", v: 53, t: "41°C" },
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
    // Visualizer GPU: waktu berjalan + energi dihaluskan via pegas (MathHelpers).
    Timer {
        interval: 50; running: true; repeat: true
        onTriggered: {
            root.spectrumTime += 0.05
            var target = 0.55 + 0.25 * Math.sin(Date.now() / 900)
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
