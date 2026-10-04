import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE F: Pro gaming, audio & system advanced solid (demo interaktif).
Item {
    id: root
    width: 680
    height: 620

    function purge(what) { purgeBar.value = 0; purgeTick.what = what; purgeTick.start() }

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
        border.color: Theme.outline
        border.width: 1
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

            // FPS HUD + profil GPU
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 170
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outline; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "FPS HUD (MangoHud)"; color: Theme.onSurface; font.bold: true; font.pointSize: 11; Layout.fillWidth: true }
                        Switch { id: hudSw; checked: true }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 34
                        radius: Theme.pillRadius
                        color: Theme.primaryContainer
                        border.color: Theme.primary
                        border.width: 1
                        visible: hudSw.checked
                        Text { id: hudText; anchors.centerIn: parent; text: "144 FPS • CPU 42% • GPU 55%"; color: Theme.onSurface; font.pointSize: 11 }
                    }
                    ComboBox { Layout.fillWidth: true; model: ["Quiet", "Balanced", "Extreme"] }
                }
            }

            // Shader purger + motion
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 170
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outline; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Shader cache & motion"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
                    RowLayout {
                        Layout.fillWidth: true
                        Button { text: "Mesa"; onClicked: root.purge("Mesa") }
                        Button { text: "Steam"; onClicked: root.purge("Steam") }
                        Button { text: "VKD3D"; onClicked: root.purge("VKD3D") }
                    }
                    ProgressBar { id: purgeBar; Layout.fillWidth: true; from: 0; to: 100; value: 0 }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Anim:"; color: Theme.onSurfaceVariant; font.pointSize: 10 }
                        Slider { Layout.fillWidth: true; from: 50; to: 300; value: 150 }
                    }
                }
            }

            // PipeWire EQ + Dante
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outline; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "PipeWire EQ / DSP + Dante"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
                    ComboBox { Layout.fillWidth: true;
                        model: ["Flat", "Sub-Bass Boost", "Live Sound Horeg"] }
                    Slider { Layout.fillWidth: true; from: -12; to: 12; value: 0 }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 26
                        radius: Theme.pillRadius
                        color: Theme.surfaceContainerHighest
                        border.color: Theme.outline
                        border.width: 1
                        Text { id: danteText; anchors.centerIn: parent; text: "Dante: 2.1 ms • loss 0.0%"; color: Theme.onSurfaceVariant; font.pointSize: 10 }
                    }
                }
            }

            // AUR + VM + network
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outline; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "AUR • VM • Jaringan"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
                    RowLayout {
                        Layout.fillWidth: true
                        Rectangle {
                            Layout.fillWidth: true
                            height: 28
                            radius: Theme.pillRadius
                            color: Theme.warning
                            Text { anchors.centerIn: parent; text: "12 update"; color: "#131318"; font.bold: true; font.pointSize: 11 }
                        }
                        Button { text: "Upgrade"; font.pointSize: 9; onClicked: console.log("yay -Syu (demo)") }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "arch-vm:"; color: Theme.onSurfaceVariant; font.pointSize: 10 }
                        Switch { checked: false; onToggled: console.log("vm toggle:", checked) }
                        Text { text: "pihole:"; color: Theme.onSurfaceVariant; font.pointSize: 10 }
                        Switch { checked: true; onToggled: console.log("container toggle:", checked) }
                    }
                    Text { id: netText; text: "↓ 1.2 MB/s • ↑ 340 KB/s • ping 18 ms"; color: Theme.onSurfaceVariant; font.pointSize: 10 }
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
