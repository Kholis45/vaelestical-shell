import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils/ColorUtils.js" as C

// MODULE V: Settings & system readout hub (M3E penuh, demo lokal).
Item {
    id: root
    width: 560
    height: 640

    // Preferensi persisten (JSON di ~/.cache/vxvicfg/prefs.json).
    function savePrefs() {
        var p = JSON.stringify({ island: swIsland.checked, lyrics: swLyrics.checked,
                                 games: swGames.checked, osd: swOsd.checked })
        Theme.exec("sh", ["-c", "mkdir -p ~/.cache/vxvicfg && printf %s " + JSON.stringify(p) + " > ~/.cache/vxvicfg/prefs.json"])
    }
    function loadPrefs() {
        try {
            var raw = Theme.execSync("sh", ["-c", "cat ~/.cache/vxvicfg/prefs.json 2>/dev/null"])
            if (raw === "")
                return
            var p = JSON.parse(raw)
            if (p.island !== undefined) swIsland.checked = p.island
            if (p.lyrics !== undefined) swLyrics.checked = p.lyrics
            if (p.games !== undefined) swGames.checked = p.games
            if (p.osd !== undefined) swOsd.checked = p.osd
        } catch (e) {}
    }
    Component.onCompleted: loadPrefs()

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
                            model: ["left", "top", "bottom", "right"]
                            onActivated: Theme.exec("sh", ["-c", "echo 'barpos:" + currentText + "' >> " + (Qt.platform.os === "windows" ? "C:/Temp/vxvicfg.cmd" : "/tmp/vxvicfg.cmd")]) }
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
                            model: ["NVIDIA", "AMD Radeon", "iGPU / APU", "VMware SVGA 3D"]
                            onActivated: Theme.exec("sh", ["-c", "echo 'gpu:" + currentText + "' >> " + (Qt.platform.os === "windows" ? "C:/Temp/vxvicfg.cmd" : "/tmp/vxvicfg.cmd")]) }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Poll:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 60 }
                        Slider {
                            id: pollSlider
                            Layout.fillWidth: true
                            from: 1; to: 5; stepSize: 1; value: 3
                            onValueChanged: Theme.telemetryMs = Math.round(value) * 1000
                        }
                        Text { text: pollSlider.value + "s"; color: Theme.onSurface; font: Theme.labelMedium }
                    }
                    GridLayout {
                        columns: 2
                        Layout.fillWidth: true
                        Switch { id: swIsland; text: "Dynamic Island"; font: Theme.labelMedium; checked: true; onToggled: root.savePrefs() }
                        Switch { id: swLyrics; text: "Lirik tersinkron"; font: Theme.labelMedium; checked: true; onToggled: root.savePrefs() }
                        Switch { id: swGames; text: "Game launcher"; font: Theme.labelMedium; checked: true; onToggled: root.savePrefs() }
                        Switch { id: swOsd; text: "OSD pills"; font: Theme.labelMedium; checked: true; onToggled: root.savePrefs() }
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
                    Text { text: "Kompositor Hyprland"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Gaps:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 70 }
                        Slider {
                            Layout.fillWidth: true
                            from: 0; to: 30; value: 8
                            onPressedChanged: {
                                if (!pressed) {
                                    Theme.exec("hyprctl", ["keyword", "general:gaps_in", String(Math.round(value))])
                                    Theme.exec("hyprctl", ["keyword", "general:gaps_out", String(Math.round(value * 2))])
                                }
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Rounding:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 70 }
                        Slider {
                            Layout.fillWidth: true
                            from: 0; to: 30; value: 16
                            onPressedChanged: {
                                if (!pressed)
                                    Theme.exec("hyprctl", ["keyword", "decoration:rounding", String(Math.round(value))])
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Blur:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 70 }
                        Slider {
                            Layout.fillWidth: true
                            from: 0; to: 12; value: 6
                            onPressedChanged: {
                                if (!pressed)
                                    Theme.exec("hyprctl", ["keyword", "decoration:blur:size", String(Math.round(value))])
                            }
                        }
                        Switch {
                            text: "On"
                            font: Theme.labelMedium
                            checked: true
                            onToggled: Theme.exec("hyprctl", ["keyword", "decoration:blur:enabled", checked ? "true" : "false"])
                        }
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
                    Text { text: "Posisi diterapkan global via IPC (lihat juga test-bar utama): " + posBox.currentText;
                        color: Theme.onSurfaceVariant; font: Theme.bodySmall; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                }
            }
        }
    }
}
