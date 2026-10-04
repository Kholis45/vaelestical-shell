import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE F: Pro gaming, audio & system advanced (demo interaktif).
Item {
    id: root
    property color card: "#1a1b22"
    property color card2: "#262732"
    property color border: "#333545"
    property color txt1: "#e3e2e6"
    property color txt2: "#8e9099"

    width: 680
    height: 620

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

    ScrollView {
        anchors.fill: parent
        anchors.margins: 14
        clip: true
        GridLayout {
            width: root.width - 28
            columns: 2
            columnSpacing: 10
            rowSpacing: 10

            // FPS HUD
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 170
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "FPS HUD (MangoHud)"; color: root.txt1; font.bold: true; font.pointSize: 11; Layout.fillWidth: true }
                        Switch { id: hudSw; checked: true }
                    }
                    Text { id: hudText; text: "144 FPS • CPU 42% • GPU 55%"; color: root.txt1; font.pointSize: 12; visible: hudSw.checked }
                    ComboBox { Layout.fillWidth: true; model: ["Quiet", "Balanced", "Extreme"] }
                }
            }

            // Shader purger + motion
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 170
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Shader cache & motion"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    RowLayout {
                        Layout.fillWidth: true
                        Button { text: "Mesa"; onClicked: purge("Mesa") }
                        Button { text: "Steam"; onClicked: purge("Steam") }
                        Button { text: "VKD3D"; onClicked: purge("VKD3D") }
                    }
                    ProgressBar { id: purgeBar; Layout.fillWidth: true; from: 0; to: 100; value: 0 }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Anim:"; color: root.txt2; font.pointSize: 10 }
                        Slider { Layout.fillWidth: true; from: 50; to: 300; value: 150 }
                    }
                }
            }
            function purge(what) { purgeBar.value = 0; purgeTick.what = what; purgeTick.start() }

            // PipeWire EQ + Dante
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "PipeWire EQ / DSP + Dante"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    ComboBox { Layout.fillWidth: true;
                        model: ["Flat", "Sub-Bass Boost", "Live Sound Horeg"] }
                    Slider { Layout.fillWidth: true; from: -12; to: 12; value: 0 }
                    Text { id: danteText; text: "Dante: 2.1 ms • loss 0.0%"; color: root.txt2; font.pointSize: 10 }
                }
            }

            // AUR + VM + network
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "AUR • VM • Jaringan"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "12 update"; color: "#fbbf24"; font.bold: true; font.pointSize: 11; Layout.fillWidth: true }
                        Button { text: "Upgrade"; font.pointSize: 9; onClicked: console.log("yay -Syu (demo)") }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "arch-vm:"; color: root.txt2; font.pointSize: 10 }
                        Switch { checked: false; onToggled: console.log("vm toggle:", checked) }
                        Text { text: "pihole:"; color: root.txt2; font.pointSize: 10 }
                        Switch { checked: true; onToggled: console.log("container toggle:", checked) }
                    }
                    Text { id: netText; text: "↓ 1.2 MB/s • ↑ 340 KB/s • ping 18 ms"; color: root.txt2; font.pointSize: 10 }
                }
            }
        }
    }

    Timer {
        id: purgeTick
        property string what: ""
        interval: 120; repeat: true
        onTriggered: {
            purgeBar.value += 12
            if (purgeBar.value >= 100) { stop(); console.log(what + " cache purged (demo)") }
        }
    }
    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: {
            hudText.text = (138 + Math.round(Math.random() * 10)) + " FPS • CPU "
                + (38 + Math.round(Math.random() * 8)) + "% • GPU "
                + (52 + Math.round(Math.random() * 8)) + "%"
            netText.text = "↓ " + (0.8 + Math.random()).toFixed(1) + " MB/s • ↑ "
                + Math.round(300 + Math.random() * 80) + " KB/s • ping "
                + Math.round(14 + Math.random() * 10) + " ms"
            danteText.text = "Dante: " + (1.8 + Math.random()).toFixed(1) + " ms • loss "
                + (Math.random() * 0.2).toFixed(1) + "%"
        }
    }
}
