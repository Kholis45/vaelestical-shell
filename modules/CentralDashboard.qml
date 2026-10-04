import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE B: Central multi-tab dashboard + dynamic island.
// Single-root Item. Built-in types only.
Item {
    id: root
    property int currentTab: 0
    property string song: "ODESZA - Falls"
    property string songSub: "In Return (2014)"
    property real playPos: 72
    property color accent: "#a8c7fa"
    property color card: "#1a1b22"
    property color card2: "#262732"
    property color border: "#333545"
    property color txt1: "#e3e2e6"
    property color txt2: "#8e9099"

    width: 620
    height: 660

    function setIslandState(s) { islandState.text = s }

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: root.card
        opacity: 0.94
        border.color: root.border
        border.width: 1
        layer.enabled: true
        layer.smooth: true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        // Dynamic island
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            radius: 28
            color: root.card2
            border.color: root.border
            border.width: 1
            visible: true
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 14
                spacing: 10
                Rectangle {
                    width: 40; height: 40; radius: 12
                    color: "#384661"
                    border.color: root.accent; border.width: 1
                    Text { anchors.centerIn: parent; text: "♪"; color: root.accent; font.pointSize: 16 }
                    Layout.alignment: Qt.AlignVCenter
                }
                ColumnLayout {
                    spacing: 0
                    Layout.fillWidth: true
                    Text { text: root.song; color: root.txt1; font.bold: true; font.pointSize: 11; elide: Text.ElideRight }
                    Text { text: root.songSub; color: root.txt2; font.pointSize: 9; elide: Text.ElideRight }
                }
                Text { id: islandClock; text: "10:30"; color: root.txt1; font.pointSize: 12 }
                Text { id: islandState; text: "compact"; color: root.txt2; font.pointSize: 9; visible: false }
            }
            Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }
        }

        TabBar {
            id: tabs
            Layout.fillWidth: true
            currentIndex: root.currentTab
            onCurrentIndexChanged: root.currentTab = currentIndex
            TabButton { text: "Dashboard" }
            TabButton { text: "Media" }
            TabButton { text: "Performance" }
            TabButton { text: "Workspaces" }
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
                        Layout.fillWidth: true; Layout.preferredHeight: 120
                        radius: 14; color: root.card2; border.color: root.border; border.width: 1
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 2
                            Text { id: bigClock; text: "--:--"; color: root.txt1; font.pointSize: 34; font.bold: true }
                            Text { id: bigDate; text: ""; color: root.txt2; font.pointSize: 11 }
                            Text { text: "Kepanjen 28°C • AQI 42 Baik"; color: root.txt2; font.pointSize: 11 }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        radius: 14; color: root.card2; border.color: root.border; border.width: 1
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 4
                            Text { text: "CachyOS • Kernel 6.6.15-1 • Hyprland/Wayland"; color: root.txt1; font.pointSize: 11 }
                            Text { id: uptimeText; text: "Uptime 0h 00m"; color: root.txt2; font.pointSize: 11 }
                            ProgressBar { Layout.fillWidth: true; from: 0; to: 100; value: 52 }
                            Text { text: "RAM 8.4 / 16 GB"; color: root.txt2; font.pointSize: 10 }
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
                        radius: 14; color: root.card2; border.color: root.border; border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 12
                            Rectangle {
                                width: 96; height: 96; radius: 14; color: "#384661"
                                border.color: root.accent; border.width: 1
                                Text { anchors.centerIn: parent; text: "♪"; color: root.accent; font.pointSize: 34 }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true; spacing: 4
                                Text { text: root.song; color: root.txt1; font.bold: true; font.pointSize: 13 }
                                Text { text: root.songSub; color: root.txt2; font.pointSize: 10 }
                                Slider { Layout.fillWidth: true; from: 0; to: 259; value: root.playPos
                                    onMoved: root.playPos = value }
                                RowLayout {
                                    Text { text: "1:12"; color: root.txt2; font.pointSize: 10 }
                                    Item { Layout.fillWidth: true }
                                    Button { text: "|◀"; font.pointSize: 10; onClicked: console.log("prev") }
                                    Button { text: "▶"; font.pointSize: 10; onClicked: console.log("play/pause") }
                                    Button { text: "▶|"; font.pointSize: 10; onClicked: console.log("next") }
                                    Item { Layout.fillWidth: true }
                                    Text { text: "4:19"; color: root.txt2; font.pointSize: 10 }
                                }
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Volume (boost s/d 150%)"; color: root.txt2; font.pointSize: 10 }
                        Slider { Layout.fillWidth: true; from: 0; to: 150; value: 78 }
                        Switch { id: boostSw; text: "Boost" }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        radius: 14; color: root.card2; border.color: root.border; border.width: 1
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 4
                            Text { text: "Spectrum visualizer (simulasi)"; color: root.txt2; font.pointSize: 10 }
                            RowLayout {
                                spacing: 4
                                Repeater {
                                    model: 28
                                    delegate: Rectangle {
                                        required property int index
                                        Layout.alignment: Qt.AlignBottom
                                        width: 10
                                        height: 8 + 34 * Math.abs(Math.sin((index + eqTick.n) * 0.55))
                                        radius: 3
                                        color: index % 3 === 0 ? root.accent : (index % 3 === 1 ? "#7f7fff" : "#7f00ff")
                                        Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
                                    }
                                }
                            }
                            Text { text: "[00:41] sunlight hums through the static…"; color: root.txt2; font.pointSize: 10 }
                            Text { text: "Lirik tersinkron (.lrc) — demo statis"; color: root.txt2; font.pointSize: 10 }
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
                            radius: 14; color: root.card2; border.color: root.border; border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 10; spacing: 4
                                Text { text: modelData.label; color: root.txt1; font.bold: true; font.pointSize: 10 }
                                ProgressBar { Layout.fillWidth: true; from: 0; to: 100; value: modelData.v }
                                Text { text: modelData.v + "% • " + modelData.t; color: root.txt2; font.pointSize: 10 }
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
                            Layout.fillWidth: true; Layout.fillHeight: true
                            radius: 14
                            color: root.currentWs === index + 1 ? "#384661" : root.card2
                            border.color: root.currentWs === index + 1 ? root.accent : root.border
                            border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 10
                                Text { text: "Workspace " + (index + 1); color: root.txt1; font.bold: true; font.pointSize: 11 }
                                Text { text: index === 0 ? "2 jendela" : "kosong"; color: root.txt2; font.pointSize: 10 }
                                Button { text: "Pindah"; font.pointSize: 9; onClicked: console.log("workspace", index + 1) }
                            }
                        }
                    }
                }
            }
        }
    }

    property int currentWs: 1
    Timer { id: eqTick; property int n: 0; interval: 220; running: true; repeat: true; onTriggered: n++ }
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
        onTriggered: uptimeText.text = "Uptime 2h 14m"
    }
}
