import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE V: Settings & system readout hub (demo lokal).
Item {
    id: root
    property color card: "#1a1b22"
    property color border: "#333545"
    property color txt1: "#e3e2e6"
    property color txt2: "#8e9099"

    width: 560
    height: 640

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
        ColumnLayout {
            width: root.width - 28
            spacing: 10

            Text { text: "Vaelestical Settings"; color: root.txt1; font.bold: true; font.pointSize: 13 }

            Text { text: "Layout & posisi"; color: root.txt1; font.bold: true; font.pointSize: 11 }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Bar:"; color: root.txt2; font.pointSize: 11 }
                ComboBox { id: posBox; Layout.fillWidth: true;
                    model: ["left", "top", "bottom", "right"] }
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Tinggi:"; color: root.txt2; font.pointSize: 11; Layout.preferredWidth: 60 }
                Slider { id: hSlider; Layout.fillWidth: true; from: 40; to: 96; value: 56 }
                Text { text: Math.round(hSlider.value); color: root.txt1; font.pointSize: 11 }
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Radius:"; color: root.txt2; font.pointSize: 11; Layout.preferredWidth: 60 }
                Slider { id: rSlider; Layout.fillWidth: true; from: 12; to: 32; value: 20 }
                Text { text: Math.round(rSlider.value); color: root.txt1; font.pointSize: 11 }
            }
            Switch { text: "Autohide bar" }

            Text { text: "Personalisasi & Material You"; color: root.txt1; font.bold: true; font.pointSize: 11 }
            RowLayout {
                Layout.fillWidth: true
                TextField { id: accentField; Layout.fillWidth: true; placeholderText: "#a8c7fa"; text: "#a8c7fa" }
                Rectangle { width: 28; height: 28; radius: 14; color: accentField.text.match(/^#[0-9a-fA-F]{6}$/) ? accentField.text : "#a8c7fa" }
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Blur:"; color: root.txt2; font.pointSize: 11; Layout.preferredWidth: 60 }
                Slider { Layout.fillWidth: true; from: 0; to: 100; value: 60 }
            }

            Text { text: "Hardware & telemetri"; color: root.txt1; font.bold: true; font.pointSize: 11 }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "GPU:"; color: root.txt2; font.pointSize: 11; Layout.preferredWidth: 60 }
                ComboBox { Layout.fillWidth: true;
                    model: ["NVIDIA", "AMD Radeon", "iGPU / APU", "VMware SVGA 3D"] }
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Poll:"; color: root.txt2; font.pointSize: 11; Layout.preferredWidth: 60 }
                Slider { id: pollSlider; Layout.fillWidth: true; from: 1; to: 5; stepSize: 1; value: 1 }
                Text { text: pollSlider.value + "s"; color: root.txt1; font.pointSize: 11 }
            }

            Text { text: "Komponen"; color: root.txt1; font.bold: true; font.pointSize: 11 }
            GridLayout {
                columns: 2
                Layout.fillWidth: true
                Switch { text: "Dynamic Island"; checked: true }
                Switch { text: "Lirik tersinkron"; checked: true }
                Switch { text: "Game launcher"; checked: true }
                Switch { text: "OSD pills"; checked: true }
            }

            Text { text: "Tentang Vaelestical"; color: root.txt1; font.bold: true; font.pointSize: 11 }
            Text { text: "VAELESTICAL.REV Shell v2.0 Ultimate • PRIVATE EASTJAVA"; color: root.txt2; font.pointSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
            Text { text: "Kernel 6.6.15-1 • CachyOS • CPU i7 • RAM 16GB • GPU: fallback VM"; color: root.txt2; font.pointSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
            RowLayout {
                Layout.fillWidth: true
                Button { text: "Check updates"; onClicked: updText.text = "12 update tersedia (demo)." }
                Button { text: "Reload shell"; onClicked: updText.text = "Shell reload (demo)." }
            }
            Text { id: updText; text: ""; color: root.txt1; font.pointSize: 10 }
            Text { text: "Catatan: posisi bar global diatur dari test-bar utama (atas). Pilihan di sini hanya preview lokal: " + posBox.currentText;
                color: root.txt2; font.pointSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
        }
    }
}
