import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE C: Wallpaper picker + Material You engine (demo interaktif).
Item {
    id: root
    property color accent: "#a8c7fa"
    property bool darkMode: true
    property int currentIndex: 0
    property var swatches: ["#a8c7fa", "#7f7fff", "#7f00ff", "#2dd4bf", "#fbbf24", "#f078d2"]

    width: 620
    height: 300

    function loadDefaultWallpaper() { root.currentIndex = 0; root.accent = root.swatches[0] }
    function setWallpaper(i) { root.currentIndex = i; root.accent = root.swatches[i % root.swatches.length] }
    function extractAccentColor(i) { root.setWallpaper(i) }

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: "#1a1b22"
        opacity: 0.94
        border.color: "#333545"
        border.width: 1
        layer.enabled: true
        layer.smooth: true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Wallpaper & Material You"; color: "#e3e2e6"; font.bold: true; font.pointSize: 12 }
            Item { Layout.fillWidth: true }
            Text { text: "Aksen:"; color: "#8e9099"; font.pointSize: 10 }
            Rectangle { width: 22; height: 22; radius: 11; color: root.accent;
                border.color: "#ffffff"; border.width: 1 }
            Switch {
                text: "Gelap"
                checked: root.darkMode
                onToggled: root.darkMode = checked
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            orientation: ListView.Horizontal
            spacing: 10
            clip: true
            model: root.swatches
            delegate: Rectangle {
                required property var modelData
                required property int index
                width: 150; height: 110; radius: 14
                color: modelData
                opacity: root.currentIndex === index ? 1.0 : 0.55
                border.color: root.currentIndex === index ? "#ffffff" : "#333545"
                border.width: root.currentIndex === index ? 3 : 1
                scale: root.currentIndex === index ? 1.04 : 1.0
                Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                Text { anchors.centerIn: parent; text: "W" + (index + 1); color: "#0d0e12"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.setWallpaper(index)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Switch { id: videoSw; text: "Video wallpaper (mpvpaper/swww)" }
            Text { text: videoSw.checked ? "Aktif — auto-pause saat fullscreen" : "Nonaktif";
                color: "#8e9099"; font.pointSize: 10; Layout.fillWidth: true }
            Button { text: "Sync cursor+ikon"; font.pointSize: 9
                onClicked: console.log("matugen/pywal sync, aksen:", root.accent) }
        }
    }
}
