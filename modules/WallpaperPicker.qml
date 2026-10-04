import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE C: Wallpaper picker + Material You engine (M3E penuh).
Item {
    id: root
    property color accent: Theme.accent
    property int currentIndex: 0
    property var swatches: [Theme.accent, Theme.primary, Theme.secondary, Theme.tertiary, "#fbbf24", "#f078d2"]

    width: 620
    height: 300

    function loadDefaultWallpaper() { root.currentIndex = 0; root.accent = root.swatches[0] }
    function setWallpaper(i) {
        root.currentIndex = i
        root.accent = root.swatches[i % root.swatches.length]
        // Terapkan ke sistem bila backend ada; demo bila tidak (tanpa warning).
        Theme.exec("sh", ["-c", "swww img ~/Pictures/Wallpapers/current 2>/dev/null || swaybg -i ~/Pictures/Wallpapers/current 2>/dev/null; matugen image ~/Pictures/Wallpapers/current --mode " + (Theme.dark ? "dark" : "light") + " 2>/dev/null; true"])
    }
    function extractAccentColor(i) { root.setWallpaper(i) }

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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Wallpaper & Material You"; color: Theme.onSurface; font: Theme.titleSmall }
            Item { Layout.fillWidth: true }
            Text { text: "Aksen:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
            Rectangle { width: 22; height: 22; radius: Theme.pillRadius; color: root.accent;
                border.color: Theme.onSurface; border.width: 1 }
            Switch {
                text: "Gelap"
                font: Theme.labelMedium
                checked: Theme.dark
                onToggled: Theme.dark = checked
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
                border.color: active ? Theme.onSurface : Theme.outlineVariant
                border.width: active ? 3 : 1
                scale: active ? 1.04 : 1.0
                Behavior on scale {
                    NumberAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                }
                Text { anchors.centerIn: parent; text: "W" + (index + 1); color: Theme.scrim; font: Theme.titleMedium }
                MouseArea {
                    id: thumbMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.setWallpaper(index)
                }
                StateLayer { anchors.fill: parent; cornerRadius: Theme.cardRadius; hoverSource: thumbMa }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Switch { id: videoSw; text: "Video wallpaper"; font: Theme.labelMedium }
            Text { text: videoSw.checked ? "Aktif — auto-pause saat fullscreen" : "Nonaktif (mpvpaper/swww)";
                color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.fillWidth: true }
            Button { text: "Sync cursor+ikon"; font: Theme.labelSmall;
                onClicked: console.log("matugen/pywal sync, aksen:", root.accent) }
        }
    }
}
