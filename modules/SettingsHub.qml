import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE V: Settings & system readout hub solid (demo lokal).
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

            Text { text: "Vaelestical Settings"; color: Theme.onSurface; font.bold: true; font.pointSize: 13 }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outline
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    Text { text: "Layout & posisi"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Bar:"; color: Theme.onSurfaceVariant; font.pointSize: 11 }
                        ComboBox { id: posBox; Layout.fillWidth: true;
                            model: ["left", "top", "bottom", "right"] }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Tinggi:"; color: Theme.onSurfaceVariant; font.pointSize: 11; Layout.preferredWidth: 60 }
                        Slider { id: hSlider; Layout.fillWidth: true; from: 40; to: 96; value: 56 }
                        Text { text: Math.round(hSlider.value); color: Theme.onSurface; font.pointSize: 11 }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Radius:"; color: Theme.onSurfaceVariant; font.pointSize: 11; Layout.preferredWidth: 60 }
                        Slider { id: rSlider; Layout.fillWidth: true; from: 12; to: 32; value: 18 }
                        Text { text: Math.round(rSlider.value); color: Theme.onSurface; font.pointSize: 11 }
                    }
                    Switch { text: "Autohide bar" }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outline
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    Text { text: "Personalisasi & Material You"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
                    RowLayout {
                        Layout.fillWidth: true
                        TextField { id: accentField; Layout.fillWidth: true; placeholderText: "#a8c7fa"; text: "#a8c7fa" }
                        Rectangle { width: 28; height: 28; radius: 99;
                            color: accentField.text.match(/^#[0-9a-fA-F]{6}$/) ? accentField.text : Theme.accent }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Soliditas:"; color: Theme.onSurfaceVariant; font.pointSize: 11; Layout.preferredWidth: 60 }
                        Slider { Layout.fillWidth: true; from: 0; to: 100; value: 100 }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outline
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    Text { text: "Hardware & telemetri"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "GPU:"; color: Theme.onSurfaceVariant; font.pointSize: 11; Layout.preferredWidth: 60 }
                        ComboBox { Layout.fillWidth: true;
                            model: ["NVIDIA", "AMD Radeon", "iGPU / APU", "VMware SVGA 3D"] }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Poll:"; color: Theme.onSurfaceVariant; font.pointSize: 11; Layout.preferredWidth: 60 }
                        Slider { id: pollSlider; Layout.fillWidth: true; from: 1; to: 5; stepSize: 1; value: 1 }
                        Text { text: pollSlider.value + "s"; color: Theme.onSurface; font.pointSize: 11 }
                    }
                    GridLayout {
                        columns: 2
                        Layout.fillWidth: true
                        Switch { text: "Dynamic Island"; checked: true }
                        Switch { text: "Lirik tersinkron"; checked: true }
                        Switch { text: "Game launcher"; checked: true }
                        Switch { text: "OSD pills"; checked: true }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outline
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    Text { text: "Tentang Vaelestical"; color: Theme.onSurface; font.bold: true; font.pointSize: 11 }
                    Text { text: "VAELESTICAL.REV Shell v2.0 Ultimate • PRIVATE EASTJAVA"; color: Theme.onSurfaceVariant; font.pointSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Text { text: "Kernel 6.6.15-1 • CachyOS • CPU i7 • RAM 16GB • GPU: fallback VM"; color: Theme.onSurfaceVariant; font.pointSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    RowLayout {
                        Layout.fillWidth: true
                        Button { text: "Check updates"; onClicked: updText.text = "12 update tersedia (demo)." }
                        Button { text: "Reload shell"; onClicked: updText.text = "Shell reload (demo)." }
                    }
                    Text { id: updText; text: ""; color: Theme.onSurface; font.pointSize: 10 }
                    Text { text: "Catatan: posisi bar global diatur dari test-bar utama. Pilihan di sini hanya preview lokal: " + posBox.currentText;
                        color: Theme.onSurfaceVariant; font.pointSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                }
            }
        }
    }
}
