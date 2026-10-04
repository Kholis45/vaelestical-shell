import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils/ColorUtils.js" as C

// MODULE V: Settings & system readout hub (M3E penuh, demo lokal).
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

            Text { text: "vxvicfg Settings"; color: Theme.onSurface; font: Theme.titleMedium }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    Text { text: "Layout & posisi"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Bar:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                        ComboBox { id: posBox; Layout.fillWidth: true; font: Theme.labelMedium;
                            model: ["left", "top", "bottom", "right"] }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Tinggi:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 60 }
                        Slider { id: hSlider; Layout.fillWidth: true; from: 40; to: 96; value: 56 }
                        Text { text: Math.round(hSlider.value); color: Theme.onSurface; font: Theme.labelMedium }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Radius:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 60 }
                        Slider { id: rSlider; Layout.fillWidth: true; from: Theme.shapeSmall; to: Theme.shapeExtraLarge; value: Theme.cardRadius }
                        Text { text: Math.round(rSlider.value); color: Theme.onSurface; font: Theme.labelMedium }
                    }
                    Switch { text: "Autohide bar"; font: Theme.labelMedium }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    Text { text: "Personalisasi & Material You"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        TextField { id: accentField; Layout.fillWidth: true; font: Theme.bodyMedium; placeholderText: "#a8c7fa"; text: "#a8c7fa" }
                        Rectangle { width: 28; height: 28; radius: Theme.pillRadius;
                            color: C.isHex(accentField.text) ? accentField.text : Theme.accent }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Skala bentuk:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 90 }
                        ComboBox { Layout.fillWidth: true; font: Theme.labelMedium;
                            model: ["ExtraSmall 4", "Small 8", "Medium 12", "Large 16", "ExtraLarge 28", "Full"] }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    Text { text: "Hardware & telemetri"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "GPU:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 60 }
                        ComboBox { Layout.fillWidth: true; font: Theme.labelMedium;
                            model: ["NVIDIA", "AMD Radeon", "iGPU / APU", "VMware SVGA 3D"] }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Poll:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 60 }
                        Slider { id: pollSlider; Layout.fillWidth: true; from: 1; to: 5; stepSize: 1; value: 1 }
                        Text { text: pollSlider.value + "s"; color: Theme.onSurface; font: Theme.labelMedium }
                    }
                    GridLayout {
                        columns: 2
                        Layout.fillWidth: true
                        Switch { text: "Dynamic Island"; font: Theme.labelMedium; checked: true }
                        Switch { text: "Lirik tersinkron"; font: Theme.labelMedium; checked: true }
                        Switch { text: "Game launcher"; font: Theme.labelMedium; checked: true }
                        Switch { text: "OSD pills"; font: Theme.labelMedium; checked: true }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    Text { text: "Tentang vxvicfg"; color: Theme.onSurface; font: Theme.titleSmall }
                    Text { text: "VXVICFG.REV Shell v2.0 Ultimate • PRIVATE EASTJAVA"; color: Theme.onSurfaceVariant; font: Theme.bodySmall; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Text { text: "Kernel 6.6.15-1 • CachyOS • CPU i7 • RAM 16GB • GPU: fallback VM"; color: Theme.onSurfaceVariant; font: Theme.bodySmall; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    RowLayout {
                        Layout.fillWidth: true
                        Button { text: "Check updates"; font: Theme.labelMedium; onClicked: updText.text = "12 update tersedia (demo)." }
                        Button { text: "Reload shell"; font: Theme.labelMedium; onClicked: updText.text = "Shell reload (demo)." }
                    }
                    Text { id: updText; text: ""; color: Theme.onSurface; font: Theme.labelMedium }
                    Text { text: "Catatan: posisi bar global diatur dari test-bar utama. Pilihan di sini hanya preview lokal: " + posBox.currentText;
                        color: Theme.onSurfaceVariant; font: Theme.bodySmall; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                }
            }
        }
    }
}
