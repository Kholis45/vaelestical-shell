import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// HAKU-2: Settings modal tengah — sidebar [General][Theme][Setting].
// Kontrak: token Theme, aksi via Theme.exec, ukuran eksplisit.
Item {
    id: root
    width: 720
    height: 520

    property int currentSection: 1 // 0 General | 1 Theme | 2 Setting

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

        // Header: pill judul + search
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Rectangle {
                width: 110; height: 36; radius: 10
                color: Theme.secondaryContainer
                Text {
                    anchors.centerIn: parent
                    text: ["General", "Theme", "Setting"][root.currentSection]
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
                    id: hakuSearch
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

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            // Kolom preview
            Rectangle {
                Layout.preferredWidth: 190
                Layout.fillHeight: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 6
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        radius: 10
                        color: Theme.primaryContainer
                        Text { anchors.centerIn: parent; text: "◍"; color: Theme.accent; font.pixelSize: 40 }
                    }
                    Text { text: "Haku-Space"; color: Theme.onSurface; font.family: "monospace"; font.pixelSize: 13 }
                    Text { text: Theme.dark ? "dark • matte" : "light • matte"; color: Theme.onSurfaceVariant; font.family: "monospace"; font.pixelSize: 11 }
                }
            }

            // Sidebar navigasi
            ColumnLayout {
                Layout.preferredWidth: 130
                Layout.fillHeight: true
                spacing: 6
                Repeater {
                    model: ["General", "Theme", "Setting"]
                    delegate: Rectangle {
                        required property int index
                        required property var modelData
                        property bool active: root.currentSection === index
                        Layout.fillWidth: true
                        Layout.preferredHeight: 52
                        radius: 10
                        color: active ? Theme.secondaryContainer : "transparent"
                        Behavior on color {
                            ColorAnimation { duration: Theme.dColor; easing.type: Easing.OutCubic }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: active ? Theme.onSecondaryContainer : Theme.onSurfaceVariant
                            font.family: "monospace"
                            font.pixelSize: 13
                        }
                        MouseArea {
                            id: secMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.currentSection = index
                        }
                        StateLayer { anchors.fill: parent; cornerRadius: 10; hoverSource: secMa }
                    }
                }
                Item { Layout.fillHeight: true }
            }

            // Konten per seksi
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: root.currentSection

                // General
                ScrollView {
                    clip: true
                    ColumnLayout {
                        width: parent.width
                        spacing: 4
                        Repeater {
                            model: [
                                { label: "Show Desktop Icons", on: true, c: [] },
                                { label: "Taskbar", on: true, c: [] },
                                { label: "Waybar", on: false, c: [] },
                                { label: "Rounded Screen", on: true, c: [] }
                            ]
                            delegate: hakuToggleRow
                        }
                    }
                }

                // Theme
                ScrollView {
                    clip: true
                    ColumnLayout {
                        id: themeRows
                        width: parent.width
                        spacing: 4
                        Text {
                            text: "Change Theme"
                            color: Theme.onSurface
                            font.family: "monospace"
                            font.pixelSize: 14
                            Layout.leftMargin: 8
                        }
                        Repeater {
                            model: [
                                { label: "Desktop (OFF)", on: false, c: [] },
                                { label: "Taskbar (OFF)", on: false, c: [] },
                                { label: "Rounded Screen (ON)", on: true, c: [] },
                                { label: "Cava Underbar (ON)", on: true, c: ["sh", "-c", "pgrep -x cava >/dev/null || (cava &); true"] },
                                { label: "Auto Random Wallpaper (OFF)", on: false, c: [] },
                                { label: "Change Wallpaper", on: false, act: true, c: ["sh", "-c", "swww img ~/Pictures/Wallpapers/current 2>/dev/null; true"] },
                                { label: "Change Lively Wallpaper", on: false, act: true, c: ["sh", "-c", "mpvpaper -o 'no-audio loop' '*' ~/Videos/lively.mp4 2>/dev/null & true"] },
                                { label: "Kill Lively Wallpaper", on: false, act: true, c: ["sh", "-c", "pkill mpvpaper 2>/dev/null; true"] }
                            ]
                            delegate: hakuToggleRow
                        }
                    }
                }

                // Setting
                ScrollView {
                    clip: true
                    ColumnLayout {
                        width: parent.width
                        spacing: 8
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Poll interval"; color: Theme.onSurfaceVariant; font.family: "monospace"; font.pixelSize: 12; Layout.preferredWidth: 120 }
                            Slider { id: hakuPoll; Layout.fillWidth: true; from: 1; to: 5; stepSize: 1; value: 2 }
                            Text { text: hakuPoll.value + "s"; color: Theme.onSurface; font.family: "monospace"; font.pixelSize: 12 }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Autohide bar"; color: Theme.onSurfaceVariant; font.family: "monospace"; font.pixelSize: 12; Layout.fillWidth: true }
                            Switch { font.pixelSize: 12 }
                        }
                        Button {
                            text: "Reload shell"
                            font.family: "monospace"
                            Layout.fillWidth: true
                            onClicked: Theme.exec("sh", ["-c", "pkill -f 'qmlscene|run_shell' 2>/dev/null; true"])
                        }
                    }
                }
            }
        }
    }

    // Baris toggle/action generik (filter search untuk seksi Theme).
    Component {
        id: hakuToggleRow
        Rectangle {
            required property var modelData
            property bool isOn: modelData.on === true
            property bool isAct: modelData.act === true
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            radius: 10
            visible: root.currentSection !== 1 || hakuSearch.text === ""
                || modelData.label.toLowerCase().indexOf(hakuSearch.text.toLowerCase()) !== -1
            color: rowMa.containsMouse ? Theme.surfaceContainerHigh : "transparent"
            Behavior on color {
                ColorAnimation { duration: Theme.dColor; easing.type: Easing.OutCubic }
            }
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 10
                Text {
                    text: isAct ? "▸" : (isOn ? "☑" : "☐")
                    color: Theme.onSurfaceVariant
                    font.family: "monospace"
                    font.pixelSize: 13
                }
                Text {
                    text: modelData.label
                    color: Theme.onSurface
                    font.family: "monospace"
                    font.pixelSize: 13
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
            MouseArea {
                id: rowMa
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (!isAct)
                        isOn = !isOn
                    if (modelData.c !== undefined && modelData.c.length > 0)
                        Theme.exec(modelData.c[0], modelData.c.slice(1))
                }
            }
        }
    }
}
