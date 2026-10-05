import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// HAKU-6: Desktop context menu — menu klik-kanan dark minimalis.
// Toggle (Cava/Taskbar/Waybar/Rounded...) + aksi (terminal, wallpaper...).
// Diposisikan via openAt(x, y); default tersembunyi.
Item {
    id: root
    width: 300
    height: 600

    property bool waybarExpanded: false

    function openAt(x, y) {
        root.x = Math.max(0, x)
        root.y = Math.max(0, y)
        root.visible = true
    }

    function cmdPath() {
        return Qt.platform.os === "windows" ? "C:/Temp/vxvicfg.cmd" : "/tmp/vxvicfg.cmd"
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.leftMargin: 2
        radius: 14
        color: Theme.shadow
    }
    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 3
        anchors.rightMargin: 2
        radius: 14
        color: Theme.surface
        border.color: Theme.outlineVariant
        border.width: 1
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 10
        clip: true
        ColumnLayout {
            width: root.width - 20
            spacing: 2

            Text { text: "Menu"; color: Theme.onSurfaceVariant; font.family: "monospace"; font.pixelSize: 11; Layout.leftMargin: 10 }

            Repeater {
                model: [
                    { label: "Space", sub: true },
                    { label: "Reload", act: true, c: [] },
                    { label: "Sort By", sub: true },
                    { label: "Show Desktop Icons", on: true },
                    { label: "Desktop Icons", sub: true },
                    { label: "Create Folder", act: true, c: ["sh", "-c", "mkdir -p ~/Desktop/'Untitled Folder' 2>/dev/null; true"] },
                    { label: "Create Document", act: true, c: [] },
                    { label: "Add Shortcut", act: true, c: [] },
                    { label: "Paste", act: true, c: [] },
                    { label: "Open Terminal Here", act: true, c: ["kitty"] },
                    { label: "Open Code", act: true, c: ["code"] },
                    { label: "Open in Thunar", act: true, c: ["thunar"] },
                    { label: "Cava Underbar", on: true, c: ["sh", "-c", "pgrep -x cava >/dev/null || (cava &); true"] },
                    { label: "Random Wallpaper", on: false, c: [] },
                    { label: "Rounded Screen", on: true, c: [] },
                    { label: "Change Wallpaper", act: true, c: ["sh", "-c", "swww img ~/Pictures/Wallpapers/current 2>/dev/null; true"] },
                    { label: "Change Lively Wallpaper", act: true, c: [] },
                    { label: "Change Theme", act: true, c: [] },
                    { label: "Accent Color Picker", act: true, c: [] },
                    { label: "Taskbar", on: true, c: [] }
                ]
                delegate: Rectangle {
                    required property var modelData
                    property bool isOn: modelData.on === true
                    property bool isAct: modelData.act === true
                    property bool isSub: modelData.sub === true
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    radius: 8
                    color: mMa.containsMouse ? Theme.surfaceContainerHigh : "transparent"
                    Behavior on color {
                        ColorAnimation { duration: Theme.dColor; easing.type: Easing.OutCubic }
                    }
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 6
                        spacing: 8
                        Text {
                            text: isAct || isSub ? "" : (isOn ? "☑" : "☐")
                            color: Theme.onSurfaceVariant
                            font.family: "monospace"
                            font.pixelSize: 12
                            Layout.preferredWidth: 16
                        }
                        Text {
                            text: modelData.label
                            color: Theme.onSurface
                            font.family: "monospace"
                            font.pixelSize: 12
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: isSub ? "▸" : ""
                            color: Theme.onSurfaceVariant
                            font.pixelSize: 11
                        }
                    }
                    MouseArea {
                        id: mMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            var L = modelData.label
                            if (L === "Change Theme") {
                                Theme.dark = !Theme.dark
                                return
                            }
                            if (L === "Taskbar" || L === "Change Wallpaper" || L === "Settings") {
                                if (!isAct && !isSub)
                                    isOn = !isOn
                                var cmd = L === "Taskbar" ? "taskbar" : (L === "Change Wallpaper" ? "hakuwall" : "hakusettings")
                                Theme.exec("sh", ["-c", "echo " + cmd + " >> " + root.cmdPath()])
                                return
                            }
                            if (L === "Random Wallpaper") {
                                isOn = !isOn
                                Theme.exec("sh", ["-c", "W=$(ls ~/Pictures/Wallpapers/*.{jpg,png,webp} 2>/dev/null | shuf -n1); [ -n \"$W\" ] && (swww img \"$W\" 2>/dev/null || swaybg -i \"$W\" &); true"])
                                return
                            }
                            if (L === "Cava Underbar") {
                                isOn = !isOn
                                Theme.exec("sh", ["-c", isOn ? "pgrep -x cava >/dev/null || (cava &)" : "pkill -x cava 2>/dev/null; true"])
                                return
                            }
                            if (L === "Rounded Screen") {
                                isOn = !isOn
                                Theme.exec("hyprctl", ["keyword", "decoration:rounding", isOn ? "16" : "0"])
                                return
                            }
                            if (!isAct && !isSub)
                                isOn = !isOn
                            if (modelData.c !== undefined && modelData.c.length > 0)
                                Theme.exec(modelData.c[0], modelData.c.slice(1))
                        }
                    }
                }
            }

            // Submenu Waybar (expandable)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                radius: 8
                color: wbMa.containsMouse ? Theme.surfaceContainerHigh : "transparent"
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    Text { text: "Waybar"; color: Theme.onSurface; font.family: "monospace"; font.pixelSize: 12; Layout.fillWidth: true }
                    Text { text: root.waybarExpanded ? "▾" : "▸"; color: Theme.onSurfaceVariant; font.pixelSize: 11 }
                }
                MouseArea { id: wbMa; anchors.fill: parent; hoverEnabled: true; onClicked: root.waybarExpanded = !root.waybarExpanded }
            }
            ColumnLayout {
                Layout.fillWidth: true
                visible: root.waybarExpanded
                spacing: 2
                Repeater {
                    model: ["Waybar Toggle", "Waybar Select Mode", "Waybar Cycle Mode"]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.leftMargin: 16
                        Layout.preferredHeight: 28
                        radius: 8
                        color: "transparent"
                        Text { anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 10; text: "☐  " + modelData; color: Theme.onSurfaceVariant; font.family: "monospace"; font.pixelSize: 11 }
                        MouseArea { anchors.fill: parent; onClicked: Theme.exec("sh", ["-c", "pkill waybar 2>/dev/null || (waybar &); true"]) }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                radius: 8
                color: "transparent"
                Text { anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 10; text: "Open Widget"; color: Theme.onSurface; font.family: "monospace"; font.pixelSize: 12 }
                MouseArea { anchors.fill: parent; onClicked: console.log("widget requested") }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                radius: 8
                color: "transparent"
                Text { anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 10; text: "Settings"; color: Theme.onSurface; font.family: "monospace"; font.pixelSize: 12 }
                MouseArea { anchors.fill: parent; onClicked: Theme.exec("sh", ["-c", "echo hakusettings >> " + root.cmdPath()]) }
            }
        }
    }
}
