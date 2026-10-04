import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE D: Hardware control center & audio routing (M3E penuh).
// Toggle pill solid + state layer + slider tebal custom.
Item {
    id: root
    width: 560
    height: 640

    // SysBridge opsional (run_shell.py). Null di qmlscene → sinkronisasi mati.
    property var sysObj: typeof Sys !== "undefined" ? Sys : null

    // Toggle cepat → perintah sistem nyata bila backend ada (demo bila tidak).
    function runToggle(m, on) {
        if (m.c !== undefined && m.c.length > 0)
            Theme.exec(m.c[0], m.c.slice(1))
        console.log(m.label, on)
    }
    Connections {
        target: sysObj
        function onPolled(d) {
            // Jangan ganggu slider yang sedang di-drag pengguna.
            if (d.vol !== undefined && !volSlider.pressed)
                volSlider.value = d.vol
            if (d.bri !== undefined && !briSlider.pressed)
                briSlider.value = d.bri
            if (d.muted !== undefined)
                volTitle.text = d.muted ? "Vol (muted)" : "Vol"
        }
    }

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
        ColumnLayout {
            width: root.width - 28
            spacing: 10

            Text { text: "Control Center"; color: Theme.onSurface; font: Theme.titleMedium }

            // Quick-settings grid: toggle card solid
            GridLayout {
                columns: 2
                columnSpacing: 8; rowSpacing: 8
                Layout.fillWidth: true
                Repeater {
                    model: [
                        { label: "Wi-Fi", sub: "Casa-5G", on: true, c: ["nmcli", "radio", "wifi", "toggle"] },
                        { label: "Bluetooth", sub: "2 perangkat", on: true, c: ["bluetoothctl", "power", "toggle"] },
                        { label: "Mute", sub: "Semua output", on: false, c: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"] },
                        { label: "DND", sub: "Jangan ganggu", on: false, c: [] },
                        { label: "GameMode", sub: "gamemoded", on: false, c: ["sh", "-c", "gamemoded -t 2>/dev/null || pkill -f gamemoded 2>/dev/null; true"] },
                        { label: "Night light", sub: "Filter biru", on: true, c: ["sh", "-c", "pgrep -x hyprsunset >/dev/null && pkill -x hyprsunset || (hyprsunset --temperature 3500 &); true"] }
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        property bool on: modelData.on
                        Layout.fillWidth: true
                        height: 66
                        radius: Theme.cardRadius
                        color: on ? Theme.primary : Theme.surfaceContainerHigh
                        border.color: on ? Theme.primary : Theme.outlineVariant
                        border.width: 1
                        Behavior on color {
                            ColorAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                        }
                        MouseArea { id: togMa; anchors.fill: parent; hoverEnabled: true;
                            onClicked: { parent.on = !parent.on; root.runToggle(modelData, parent.on) } }
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 10
                            Rectangle {
                                width: 34; height: 34; radius: Theme.pillRadius
                                color: on ? Theme.onPrimary : Theme.surfaceContainerHighest
                                border.color: on ? Theme.onPrimary : Theme.outlineVariant
                                border.width: 1
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.label.charAt(0)
                                    color: on ? Theme.primary : Theme.onSurfaceVariant
                                    font: Theme.titleSmall
                                }
                                Behavior on color {
                                    ColorAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                                }
                                Layout.alignment: Qt.AlignVCenter
                            }
                            ColumnLayout {
                                spacing: 0
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                Text { text: modelData.label; color: on ? Theme.onPrimary : Theme.onSurface; font: Theme.titleSmall }
                                Text { text: modelData.sub; color: on ? Theme.onPrimary : Theme.onSurfaceVariant; font: Theme.labelSmall }
                            }
                            Switch {
                                checked: on
                                onToggled: { parent.parent.parent.on = checked; root.runToggle(modelData, checked) }
                            }
                        }
                        StateLayer { anchors.fill: parent; cornerRadius: Theme.cardRadius; hoverSource: togMa }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { text: "Output:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                ComboBox {
                    Layout.fillWidth: true
                    font: Theme.labelMedium
                    model: ["Laptop Speakers", "Headphones / DAC", "Dante Network Audio"]
                }
            }
            Button { text: "Swap sink utama"; font: Theme.labelLarge; Layout.fillWidth: true;
                onClicked: console.log("audio sink hot-swap") }

            // Slider tebal custom: volume
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10
                    Text { id: volTitle; text: "Vol"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 30 }
                    Slider {
                        id: volSlider
                        objectName: "volSlider"
                        Layout.fillWidth: true
                        from: 0; to: 100; value: 78
                        // Terapkan saat dilepas agar tidak spam proses per-pixel.
                        onPressedChanged: {
                            if (!pressed)
                                Theme.exec("wpctl", ["set-volume", "@DEFAULT_AUDIO_SINK@", String(Math.round(value)) + "%"])
                        }
                        background: Rectangle {
                            x: volSlider.leftPadding
                            y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 12
                            width: volSlider.availableWidth
                            height: 12
                            radius: Theme.pillRadius
                            color: Theme.surfaceContainerHighest
                            Rectangle {
                                width: volSlider.visualPosition * parent.width
                                height: parent.height
                                radius: Theme.pillRadius
                                color: Theme.active
                            }
                        }
                        handle: Rectangle {
                            x: volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width)
                            y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                            implicitWidth: 24
                            implicitHeight: 24
                            width: 24; height: 24; radius: Theme.pillRadius
                            color: Theme.primary
                            border.color: Theme.onPrimary
                            border.width: 2
                        }
                    }
                    Text { text: Math.round(volSlider.value) + "%"; color: Theme.onSurface; font: Theme.labelMedium; Layout.preferredWidth: 40 }
                }
            }

            // Slider tebal custom: brightness
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10
                    Text { text: "Layar"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 30 }
                    Slider {
                        id: briSlider
                        objectName: "briSlider"
                        Layout.fillWidth: true
                        from: 0; to: 100; value: 65
                        // Terapkan saat dilepas agar tidak spam proses per-pixel.
                        onPressedChanged: {
                            if (!pressed)
                                Theme.exec("brightnessctl", ["set", String(Math.round(value)) + "%"])
                        }
                        background: Rectangle {
                            x: briSlider.leftPadding
                            y: briSlider.topPadding + briSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 12
                            width: briSlider.availableWidth
                            height: 12
                            radius: Theme.pillRadius
                            color: Theme.surfaceContainerHighest
                            Rectangle {
                                width: briSlider.visualPosition * parent.width
                                height: parent.height
                                radius: Theme.pillRadius
                                color: Theme.warning
                            }
                        }
                        handle: Rectangle {
                            x: briSlider.leftPadding + briSlider.visualPosition * (briSlider.availableWidth - width)
                            y: briSlider.topPadding + briSlider.availableHeight / 2 - height / 2
                            implicitWidth: 24
                            implicitHeight: 24
                            width: 24; height: 24; radius: Theme.pillRadius
                            color: Theme.primary
                            border.color: Theme.onPrimary
                            border.width: 2
                        }
                    }
                    Text { text: Math.round(briSlider.value) + "%"; color: Theme.onSurface; font: Theme.labelMedium; Layout.preferredWidth: 40 }
                }
            }

            Text { text: "Mixer per aplikasi"; color: Theme.onSurface; font: Theme.titleSmall }
            Repeater {
                model: ["Firefox", "Spotify", "OBS"]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Text { text: modelData; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 70 }
                    Slider { Layout.fillWidth: true; from: 0; to: 100; value: 60 }
                }
            }

            Text { text: "Launcher game & daya"; color: Theme.onSurface; font: Theme.titleSmall }
            RowLayout {
                Layout.fillWidth: true
                Button { text: "Steam"; font: Theme.labelMedium; onClicked: Theme.exec("steam", []) }
                Button { text: "Prism"; font: Theme.labelMedium; onClicked: Theme.exec("prismlauncher", []) }
                Button { text: "Heroic"; font: Theme.labelMedium; onClicked: Theme.exec("heroic", []) }
                Button { text: "Discord"; font: Theme.labelMedium; onClicked: Theme.exec("discord", []) }
            }
            RowLayout {
                Layout.fillWidth: true
                Rectangle { width: 10; height: 10; radius: Theme.pillRadius; color: Theme.success }
                Text { text: "VPN aktif (10.8.0.2)"; color: Theme.success; font: Theme.labelMedium }
                Item { Layout.fillWidth: true }
                Rectangle { width: 10; height: 10; radius: Theme.pillRadius; color: Theme.error }
                Text { text: "REC"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
            }
        }
    }
}
