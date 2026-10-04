import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE C: Wallpaper picker + Material You engine (Solid M3).
Item {
    id: root
    property color accent: Theme.accent
    property bool darkMode: true
    property int currentIndex: 0
    property var swatches: [Theme.accent, Theme.primary, "#7f00ff", "#2dd4bf", "#fbbf24", "#f078d2"]

    width: 620
    height: 300

    function loadDefaultWallpaper() { root.currentIndex = 0; root.accent = root.swatches[0] }
    function setWallpaper(i) { root.currentIndex = i; root.accent = root.swatches[i % root.swatches.length] }
    function extractAccentColor(i) { root.setWallpaper(i) }

    onDarkModeChanged: Theme.dark = darkMode

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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Wallpaper & Material You"; color: Theme.onSurface; font.bold: true; font.pointSize: 12 }
            Item { Layout.fillWidth: true }
            Text { text: "Aksen:"; color: Theme.onSurfaceVariant; font.pointSize: 10 }
            Rectangle { width: 22; height: 22; radius: 99; color: root.accent;
                border.color: Theme.onSurface; border.width: 1 }
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
                property bool active: root.currentIndex === index
                width: 150; height: 110; radius: Theme.cardRadius
                color: modelData
                border.color: active ? Theme.onSurface : Theme.outline
                border.width: active ? 3 : 1
                scale: active ? 1.04 : 1.0
                Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Text { anchors.centerIn: parent; text: "W" + (index + 1); color: "#131318"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.setWallpaper(index)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Switch { id: videoSw; text: "Video wallpaper" }
            Text { text: videoSw.checked ? "Aktif — auto-pause saat fullscreen" : "Nonaktif (mpvpaper/swww)";
                color: Theme.onSurfaceVariant; font.pointSize: 10; Layout.fillWidth: true }
            Button { text: "Sync cursor+ikon"; font.pointSize: 9;
                onClicked: console.log("matugen/pywal sync, aksen:", root.accent) }
        }
    }
}
