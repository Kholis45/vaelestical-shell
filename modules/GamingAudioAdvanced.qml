import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE F: Pro gaming, audio & system advanced (M3E penuh, demo).
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
        border.color: Theme.outlineVariant
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
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "FPS HUD (MangoHud)"; color: Theme.onSurface; font: Theme.titleSmall; Layout.fillWidth: true }
                        Switch { id: hudSw; checked: true }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 36
                        radius: Theme.pillRadius
                        color: Theme.tertiaryContainer
                        border.color: Theme.tertiary
                        border.width: 1
                        visible: hudSw.checked
                        Text { id: hudText; anchors.centerIn: parent; text: "144 FPS • CPU 42% • GPU 55%"; color: Theme.onTertiaryContainer; font: Theme.labelLarge }
                    }
                    ComboBox { Layout.fillWidth: true; font: Theme.labelMedium; model: ["Quiet", "Balanced", "Extreme"] }
                }
            }

            // Shader purger + motion
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 170
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Shader cache & motion"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        Button { text: "Mesa"; font: Theme.labelMedium; onClicked: root.purge("Mesa") }
                        Button { text: "Steam"; font: Theme.labelMedium; onClicked: root.purge("Steam") }
                        Button { text: "VKD3D"; font: Theme.labelMedium; onClicked: root.purge("VKD3D") }
                    }
                    ProgressBar { id: purgeBar; Layout.fillWidth: true; from: 0; to: 100; value: 0 }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Anim:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                        Slider { Layout.fillWidth: true; from: 50; to: 300; value: 150 }
                    }
                }
            }

            // PipeWire EQ + Dante
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "PipeWire EQ / DSP + Dante"; color: Theme.onSurface; font: Theme.titleSmall }
                    ComboBox { Layout.fillWidth: true; font: Theme.labelMedium;
                        model: ["Flat", "Sub-Bass Boost", "Live Sound Horeg"] }
                    Slider { Layout.fillWidth: true; from: -12; to: 12; value: 0 }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 28
                        radius: Theme.pillRadius
                        color: Theme.surfaceContainerHighest
                        border.color: Theme.outlineVariant
                        border.width: 1
                        Text { id: danteText; anchors.centerIn: parent; text: "Dante: 2.1 ms • loss 0.0%"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                    }
                }
            }

            // AUR + VM + network
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "AUR • VM • Jaringan"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        Rectangle {
                            Layout.fillWidth: true
                            height: 30
                            radius: Theme.pillRadius
                            color: Theme.warning
                            Text { anchors.centerIn: parent; text: "12 update"; color: Theme.scrim; font: Theme.labelLarge }
                        }
                        Button { text: "Upgrade"; font: Theme.labelMedium; onClicked: console.log("yay -Syu (demo)") }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "arch-vm:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                        Switch { checked: false; onToggled: console.log("vm toggle:", checked) }
                        Text { text: "pihole:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                        Switch { checked: true; onToggled: console.log("container toggle:", checked) }
                    }
                    Text { id: netText; text: "↓ 1.2 MB/s • ↑ 340 KB/s • ping 18 ms"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
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
