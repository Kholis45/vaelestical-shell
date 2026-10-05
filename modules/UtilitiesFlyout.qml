import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE E2: Utilities flyout — toast/OSD cepat, Ollama, catatan, capture.
// Kontrak: token Theme, aksi via Theme.exec/execSync, tanpa anchor ke parent.
Item {
    id: root
    width: 560
    height: 540

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

            Text { text: "Flyout Cepat"; color: Theme.onSurface; font: Theme.titleMedium }

            // OSD pills (volume / kecerahan / status kunci)
            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Text { text: "OSD pills"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Vol"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 34 }
                        Slider {
                            id: osdSlider
                            Layout.fillWidth: true
                            from: 0; to: 100; value: 40
                            onPressedChanged: {
                                if (!pressed)
                                    Theme.exec("wpctl", ["set-volume", "@DEFAULT_AUDIO_SINK@", String(Math.round(value)) + "%"])
                            }
                        }
                        Text { text: Math.round(osdSlider.value) + "%"; color: Theme.onSurface; font: Theme.labelMedium; Layout.preferredWidth: 42 }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Cerah"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 34 }
                        Slider {
                            id: osdBri
                            Layout.fillWidth: true
                            from: 5; to: 100; value: 80
                            onPressedChanged: {
                                if (!pressed)
                                    Theme.exec("brightnessctl", ["set", String(Math.round(value)) + "%"])
                            }
                        }
                        Text { text: Math.round(osdBri.value) + "%"; color: Theme.onSurface; font: Theme.labelMedium; Layout.preferredWidth: 42 }
                    }
                    Text { id: lockKeysText; text: "CapsLock: ? • NumLock: ? • Layout: ID"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                }
            }

            // Toast demo
            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Text { text: "Notifikasi"; color: Theme.onSurface; font: Theme.titleSmall }
                    Button {
                        text: "Kirim toast uji"
                        font: Theme.labelLarge
                        Layout.fillWidth: true
                        onClicked: {
                            // Hormati flag DND dari Control Center.
                            var dnd = Theme.execSync("sh", ["-c", "cat ~/.cache/vxvicfg/dnd 2>/dev/null"]).trim()
                            flyToastText.text = dnd === "1" ? "DND aktif — notifikasi ditahan." : "Halo dari vxvicfg shell."
                            flyToast.visible = true
                            flyToastHide.restart()
                        }
                    }
                    Rectangle {
                        id: flyToast
                        Layout.fillWidth: true
                        height: 30
                        radius: Theme.pillRadius
                        color: Theme.inverseSurface
                        visible: false
                        Text { id: flyToastText; anchors.centerIn: parent; text: "Halo dari vxvicfg shell."; color: Theme.inverseOnSurface; font: Theme.labelMedium }
                        Behavior on opacity {
                            NumberAnimation { duration: Theme.dOpacity; easing.type: Easing.OutQuad }
                        }
                    }
                }
            }

            // Ollama quick prompt
            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Text { text: "Ollama lokal"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        ComboBox { id: modelBox; font: Theme.labelMedium; model: ["llama3.1", "qwen2", "mistral"] }
                        TextField { id: flyPrompt; Layout.fillWidth: true; font: Theme.bodyMedium; placeholderText: "Tanya model lokal…" }
                    }
                    Text {
                        id: flyAnswer
                        Layout.fillWidth: true
                        text: "Jawaban muncul di sini."
                        color: Theme.onSurfaceVariant
                        font: Theme.bodySmall
                        wrapMode: Text.WordWrap
                    }
                    Button {
                        text: "Tanya"
                        font: Theme.labelLarge
                        Layout.fillWidth: true
                        onClicked: {
                            if (flyPrompt.text === "") {
                                flyAnswer.text = "Prompt kosong."
                                return
                            }
                            var out = Theme.execSync("ollama", ["run", modelBox.currentText, flyPrompt.text])
                            flyAnswer.text = out !== "" ? out.slice(0, 400) : "Demo: '" + flyPrompt.text + "' → 42 token."
                        }
                    }
                }
            }

            // Catatan cepat + capture + clipboard
            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Text { text: "Catatan & clipboard"; color: Theme.onSurface; font: Theme.titleSmall }
                    TextArea { id: flyNotes; Layout.fillWidth: true; Layout.preferredHeight: 56; font: Theme.bodyMedium; placeholderText: "Catatan cepat…" }
                    Text { id: flySaved; text: "Belum disimpan."; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                    RowLayout {
                        Layout.fillWidth: true
                        Button {
                            text: "Simpan"
                            font: Theme.labelMedium
                            onClicked: {
                                try {
                                    var b64 = Qt.btoa(unescape(encodeURIComponent(flyNotes.text)))
                                    Theme.exec("sh", ["-c", "mkdir -p ~/.cache/vxvicfg && printf %s " + JSON.stringify(b64) + " | base64 -d > ~/.cache/vxvicfg/notes.txt"])
                                    flySaved.text = "Tersimpan ~/.cache/vxvicfg/notes.txt"
                                } catch (e) {
                                    flySaved.text = "Gagal menyimpan."
                                }
                            }
                        }
                        Button {
                            text: "Screenshot area"
                            font: Theme.labelMedium
                            onClicked: Theme.exec("sh", ["-c", 'grim -g "$(slurp)" ~/Pictures/vxvicfg-$(date +%s).png'])
                        }
                    }
                    Repeater {
                        model: ["sudo pacman -Syu", "ssh kholis@server", "echo halo"]
                        delegate: Text {
                            required property var modelData
                            text: "• " + modelData
                            color: Theme.onSurfaceVariant
                            font: Theme.bodySmall
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Theme.exec("sh", ["-c", "printf %s " + JSON.stringify(parent.text.slice(2)) + " | wl-copy"])
                            }
                        }
                    }
                }
            }
        }
    }

    Timer { id: flyToastHide; interval: 3000; repeat: false; onTriggered: flyToast.visible = false }

    // Status LED keyboard asli via sysfs (tetap "?" bila tak ada LED).
    Timer {
        interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            if (!Theme.hasSys())
                return
            var caps = Theme.execSync("sh", ["-c", "cat /sys/class/leds/*capslock*/brightness 2>/dev/null | head -1"]).trim()
            var num = Theme.execSync("sh", ["-c", "cat /sys/class/leds/*numlock*/brightness 2>/dev/null | head -1"]).trim()
            lockKeysText.text = "CapsLock: " + (caps === "" ? "?" : (caps === "0" ? "OFF" : "ON"))
                + " • NumLock: " + (num === "" ? "?" : (num === "0" ? "OFF" : "ON")) + " • Layout: ID"
        }
    }

    // Muat catatan tersimpan (no-op aman tanpa backend: execSync → "").
    Component.onCompleted: {
        var t = Theme.execSync("sh", ["-c", "cat ~/.cache/vxvicfg/notes.txt 2>/dev/null"])
        if (t !== "")
            flyNotes.text = t
    }
}
