import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// HAKU-5: Wallpaper picker modal — grid thumbnail + search.
// Thumb berupa kartu warna (tanpa file eksternal agar bebas warning);
// klik menerapkan via swww/matugen bila backend ada.
Item {
    id: root
    width: 760
    height: 500

    property int currentIndex: 0
    // Basis thumbnail asli (diisi probeWalls bila folder ada; fallback tint).
    property string wallBase: ""
    property string wallList: ""
    function probeWalls() {
        if (!Theme.hasSys())
            return
        var home = Theme.execSync("sh", ["-c", "echo $HOME"]).trim()
        if (home === "")
            return
        root.wallBase = home + "/Pictures/Wallpapers"
        root.wallList = Theme.execSync("sh", ["-c", "ls " + home + "/Pictures/Wallpapers 2>/dev/null"])
    }
    Component.onCompleted: probeWalls()
    onVisibleChanged: if (visible) probeWalls()

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
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Rectangle {
                width: 120; height: 36; radius: 10
                color: Theme.secondaryContainer
                Text {
                    anchors.centerIn: parent
                    text: "Wallpaper"
                    color: Theme.onSecondaryContainer
                    font.family: "monospace"
                    font.pixelSize: 13
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 36
                radius: 10
                color: Theme.surfaceContainerHigh
                border.color: Theme.outlineVariant
                border.width: 1
                TextField {
                    id: wpSearch
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    font.family: "monospace"
                    font.pixelSize: 13
                    placeholderText: "Search..."
                    background: null
                }
            }
        }

        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            cellWidth: 236
            cellHeight: 190
            model: [
                { file: "148301065_p0.jpg", tint: "#2b3a4a" },
                { file: "149066615_p0.jpg", tint: "#4a3a52" },
                { file: "149339442_p0.jpg", tint: "#3a4a44" },
                { file: "149536036_p0.jpg", tint: "#5a4a35" },
                { file: "27610.jpg", tint: "#8a8a8a" },
                { file: "79083147_p0.jpg", tint: "#2a3a5a" }
            ]
            delegate: Item {
                required property var modelData
                required property int index
                property bool active: root.currentIndex === index
                property bool match: wpSearch.text === ""
                    || modelData.file.toLowerCase().indexOf(wpSearch.text.toLowerCase()) !== -1
                visible: match
                width: 236 - 12
                height: 190 - 8
                opacity: match ? 1 : 0
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 4
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 140
                        radius: 10
                        color: modelData.tint
                        border.color: active ? Theme.accent : Theme.outlineVariant
                        border.width: active ? 2 : 1
                        scale: active ? 1.03 : 1.0
                        Behavior on scale {
                            NumberAnimation { duration: Theme.dScale; easing.type: Easing.OutBack }
                        }
                        Behavior on border.color {
                            ColorAnimation { duration: Theme.dColor; easing.type: Easing.OutCubic }
                        }
                        Text { anchors.centerIn: parent; text: "◍"; color: Theme.onSurface; font.pixelSize: 30 }
                        Image {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            source: root.wallList.indexOf(modelData.file) !== -1 ? "file://" + root.wallBase + "/" + modelData.file : ""
                            visible: status === Image.Ready
                        }
                        MouseArea {
                            id: wpMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                root.currentIndex = index
                                Theme.exec("sh", ["-c", "swww img ~/Pictures/Wallpapers/" + modelData.file + " --transition-type grow 2>/dev/null; matugen image ~/Pictures/Wallpapers/" + modelData.file + " 2>/dev/null; true"])
                            }
                        }
                        StateLayer { anchors.fill: parent; cornerRadius: 10; hoverSource: wpMa }
                    }
                    Text {
                        text: modelData.file
                        color: Theme.onSurfaceVariant
                        font.family: "monospace"
                        font.pixelSize: 11
                        Layout.alignment: Qt.AlignHCenter
                        elide: Text.ElideMiddle
                        Layout.preferredWidth: parent.width
                    }
                }
            }
        }
    }
}
