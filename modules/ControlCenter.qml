import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE D: Hardware control center & audio routing (demo interaktif).
Item {
    id: root
    property color accent: "#a8c7fa"
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

            Text { text: "Control Center"; color: root.txt1; font.bold: true; font.pointSize: 13 }

            GridLayout {
                columns: 2
                columnSpacing: 8; rowSpacing: 8
                Layout.fillWidth: true
                Switch { text: "Wi-Fi — Casa-5G"; checked: true }
                Switch { text: "Bluetooth — 2 perangkat"; checked: true }
                Switch { text: "Do Not Disturb"; checked: false }
                Switch { text: "GameMode (gamemoded)"; checked: false }
                Switch { text: "Flight mode"; checked: false }
                Switch { text: "Night light"; checked: true }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { text: "Output:"; color: root.txt2; font.pointSize: 11 }
                ComboBox {
                    Layout.fillWidth: true
                    model: ["Laptop Speakers", "Headphones / DAC", "Dante Network Audio"]
                }
            }
            Button { text: "Swap sink utama"; Layout.fillWidth: true;
                onClicked: console.log("audio sink hot-swap") }

            RowLayout {
                Layout.fillWidth: true
                Text { text: "Vol"; color: root.txt2; font.pointSize: 11 }
                Slider { Layout.fillWidth: true; from: 0; to: 100; value: 78 }
                Text { text: "78%"; color: root.txt1; font.pointSize: 11 }
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Layar"; color: root.txt2; font.pointSize: 11 }
                Slider { Layout.fillWidth: true; from: 0; to: 100; value: 65 }
                Text { text: "65%"; color: root.txt1; font.pointSize: 11 }
            }

            Text { text: "Mixer per aplikasi"; color: root.txt1; font.bold: true; font.pointSize: 11 }
            Repeater {
                model: ["Firefox", "Spotify", "OBS"]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Text { text: modelData; color: root.txt2; font.pointSize: 11; Layout.preferredWidth: 70 }
                    Slider { Layout.fillWidth: true; from: 0; to: 100; value: 60 }
                }
            }

            Text { text: "Launcher game & daya"; color: root.txt1; font.bold: true; font.pointSize: 11 }
            RowLayout {
                Layout.fillWidth: true
                Button { text: "Steam"; onClicked: console.log("launch steam") }
                Button { text: "Prism"; onClicked: console.log("launch prism") }
                Button { text: "Heroic"; onClicked: console.log("launch heroic") }
                Button { text: "Discord"; onClicked: console.log("launch discord") }
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "VPN: aktif (10.8.0.2)"; color: "#34d399"; font.pointSize: 11 }
                Item { Layout.fillWidth: true }
                Rectangle { width: 10; height: 10; radius: 5; color: "red" }
                Text { text: "REC"; color: root.txt2; font.pointSize: 11 }
            }
        }
    }
}
