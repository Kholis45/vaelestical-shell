import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE D: Hardware control center & audio routing (Solid M3).
// Toggle pill solid + slider tebal custom yang responsif.
Item {
    id: root
    width: 560
    height: 640

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
        ColumnLayout {
            width: root.width - 28
            spacing: 10

            Text { text: "Control Center"; color: Theme.onSurface; font.bold: true; font.pointSize: 13 }

            // Quick-settings grid: toggle pill solid
            GridLayout {
                columns: 2
                columnSpacing: 8; rowSpacing: 8
                Layout.fillWidth: true
                Repeater {
                    model: [
                        { label: "Wi-Fi", sub: "Casa-5G", on: true },
                        { label: "Bluetooth", sub: "2 perangkat", on: true },
                        { label: "Mute", sub: "Semua output", on: false },
                        { label: "DND", sub: "Jangan ganggu", on: false },
                        { label: "GameMode", sub: "gamemoded", on: false },
                        { label: "Night light", sub: "Filter biru", on: true }
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        property bool on: modelData.on
                        Layout.fillWidth: true
                        height: 62
                        radius: Theme.cardRadius
                        color: on ? Theme.primary : Theme.surfaceContainerHigh
                        border.color: on ? Theme.primary : Theme.outline
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 10
                            Rectangle {
                                width: 34; height: 34; radius: 99
                                color: on ? Theme.onPrimary : Theme.surfaceContainerHighest
                                border.color: on ? Theme.onPrimary : Theme.outline
                                border.width: 1
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.label.charAt(0)
                                    color: on ? Theme.primary : Theme.onSurfaceVariant
                                    font.bold: true
                                    font.pointSize: 13
                                }
                                Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
                            }
                            ColumnLayout {
                                spacing: 0
                                Layout.fillWidth: true
                                Text { text: modelData.label; color: on ? Theme.onPrimary : Theme.onSurface; font.bold: true; font.pointSize: 11 }
                                Text { text: modelData.sub; color: on ? Theme.onPrimary : Theme.onSurfaceVariant; font.pointSize: 9 }
                            }
                            Switch {
                                checked: on
                                onToggled: { parent.parent.on = checked; console.log(modelData.label, checked) }
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { text: "Output:"; color: Theme.onSurfaceVariant; font.pointSize: 11 }
                ComboBox {
                    Layout.fillWidth: true
                    model: ["Laptop Speakers", "Headphones / DAC", "Dante Network Audio"]
                }
            }
            Button { text: "Swap sink utama"; Layout.fillWidth: true;
                onClicked: console.log("audio sink hot-swap") }

            // Slider tebal custom: volume
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outline
                border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10
                    Text { text: "Vol"; color: Theme.onSurfaceVariant; font.pointSize: 11; Layout.preferredWidth: 30 }
                    Slider {
                        id: volSlider
                        Layout.fillWidth: true
                        from: 0; to: 100; value: 78
                        background: Rectangle {
                            x: volSlider.leftPadding
                            y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 12
                            width: volSlider.availableWidth
                            height: 12
                            radius: 99
                            color: Theme.surfaceContainerHighest
                            Rectangle {
                                width: volSlider.visualPosition * parent.width
                                height: parent.height
                                radius: 99
                                color: Theme.active
                            }
                        }
                        handle: Rectangle {
                            x: volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width)
                            y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                            implicitWidth: 24
                            implicitHeight: 24
                            width: 24; height: 24; radius: 99
                            color: Theme.primary
                            border.color: Theme.onPrimary
                            border.width: 2
                        }
                    }
                    Text { text: Math.round(volSlider.value) + "%"; color: Theme.onSurface; font.pointSize: 11; Layout.preferredWidth: 40 }
                }
            }

            // Slider tebal custom: brightness
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outline
                border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10
                    Text { text: "Layar"; color: Theme.onSurfaceVariant; font.pointSize: 11; Layout.preferredWidth: 30 }
                    Slider {
                        id: briSlider
                        Layout.fillWidth: true
                        from: 0; to: 100; value: 65
                        background: Rectangle {
                            x: briSlider.leftPadding
                            y: briSlider.topPadding + briSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 12
                            width: briSlider.availableWidth
                            height: 12
                            radius: 99
                            color: Theme.surfaceContainerHighest
                            Rectangle {
                                width: briSlider.visualPosition * parent.width
                                height: parent.height
                                radius: 99
                                color: Theme.warning
                            }
                        }
                        handle: Rectangle {
                            x: briSlider.leftPadding + briSlider.visualPosition * (briSlider.availableWidth - width)
                            y: briSlider.topPadding + briSlider.availableHeight / 2 - height / 2
                            implicitWidth: 24
                            implicitHeight: 24
                            width: 24; height: 24; radius: 99
                            color: Theme.primary
                            border.color: Theme.onPrimary
                            border.width: 2
                        }
                    }
                    Text { text: Math.round(briSlider.value) + "%"; color: Theme.onSurface; font.pointSize: 11; Layout.preferredWidth: 40 }
                }
            }

            Text { text: "Mixer per aplikasi"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
            Repeater {
                model: ["Firefox", "Spotify", "OBS"]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Text { text: modelData; color: Theme.onSurfaceVariant; font.pointSize: 11; Layout.preferredWidth: 70 }
                    Slider { Layout.fillWidth: true; from: 0; to: 100; value: 60 }
                }
            }

            Text { text: "Launcher game & daya"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
            RowLayout {
                Layout.fillWidth: true
                Button { text: "Steam"; onClicked: console.log("launch steam") }
                Button { text: "Prism"; onClicked: console.log("launch prism") }
                Button { text: "Heroic"; onClicked: console.log("launch heroic") }
                Button { text: "Discord"; onClicked: console.log("launch discord") }
            }
            RowLayout {
                Layout.fillWidth: true
                Rectangle { width: 10; height: 10; radius: 99; color: Theme.success }
                Text { text: "VPN aktif (10.8.0.2)"; color: Theme.success; font.pointSize: 11 }
                Item { Layout.fillWidth: true }
                Rectangle { width: 10; height: 10; radius: 99; color: Theme.error }
                Text { text: "REC"; color: Theme.onSurfaceVariant; font.pointSize: 11 }
            }
        }
    }
}
