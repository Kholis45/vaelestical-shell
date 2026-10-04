import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE E: Utilities, AI & system extensions (M3E penuh, demo).
Item {
    id: root
    width: 680
    height: 620

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
        GridLayout {
            width: root.width - 28
            columns: 2
            columnSpacing: 10
            rowSpacing: 10

            // Clipboard
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Clipboard history"; color: Theme.onSurface; font: Theme.titleSmall }
                    TextField { id: clipSearch; Layout.fillWidth: true; font: Theme.bodyMedium; placeholderText: "Cari clipboard…" }
                    ListView {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        clip: true
                        model: ["sudo pacman -Syu", "ssh kholis@server", "catatan: beli kopi", "https://contoh.id", "echo hello"]
                        delegate: Text {
                            required property var modelData
                            width: ListView.view.width
                            text: "• " + modelData; color: Theme.onSurfaceVariant; font: Theme.bodySmall; elide: Text.ElideRight
                            visible: clipSearch.text === "" || modelData.toLowerCase().indexOf(clipSearch.text.toLowerCase()) !== -1
                        }
                    }
                }
            }

            // Launcher + kalkulator mini
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Launcher + hitung"; color: Theme.onSurface; font: Theme.titleSmall }
                    TextField { id: launchField; objectName: "launchField"; Layout.fillWidth: true; font: Theme.bodyMedium; placeholderText: "firefox / 12*8-4…" }
                    Text { id: launchOut; text: "Super+K • Enter eksekusi (demo)"; color: Theme.onSurfaceVariant; font: Theme.bodySmall; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Button { text: "Jalankan"; font: Theme.labelLarge; Layout.fillWidth: true; onClicked: {
                        var m = launchField.text.match(/^\s*(-?\d+(?:\.\d+)?)\s*([+\-*/])\s*(-?\d+(?:\.\d+)?)\s*$/)
                        if (m) {
                            var r = m[2] === "+" ? (+m[1] + +m[3]) : m[2] === "-" ? (+m[1] - +m[3])
                                : m[2] === "*" ? (+m[1] * +m[3]) : (+m[3] !== 0 ? (+m[1] / +m[3]) : NaN)
                            launchOut.text = "= " + r
                        } else if (launchField.text === "") launchOut.text = "Ketik perintah / ekspresi dulu."
                        else launchOut.text = "Demo: '" + launchField.text + "' akan dibuka."
                    } }
                }
            }

            // Notifikasi toast + OSD
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Toast & OSD pills"; color: Theme.onSurface; font: Theme.titleSmall }
                    Button { text: "Tampilkan toast"; font: Theme.labelLarge; Layout.fillWidth: true; onClicked: { toastDemo.visible = true; toastHide.start() } }
                    Rectangle {
                        id: toastDemo
                        Layout.fillWidth: true
                        height: 28
                        radius: Theme.pillRadius
                        color: Theme.inverseSurface
                        visible: false
                        Text { anchors.centerIn: parent; text: "Notifikasi DBus (demo)"; color: Theme.inverseOnSurface; font: Theme.labelMedium }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "OSD vol:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                        Slider { id: osdVol; Layout.fillWidth: true; from: 0; to: 100; value: 40 }
                        Text { text: Math.round(osdVol.value) + "%"; color: Theme.onSurface; font: Theme.labelMedium }
                    }
                    Text { text: "CapsLock: OFF • Layout: ID"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                }
            }

            // LLM lokal
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Ollama prompt"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        ComboBox { font: Theme.labelMedium; model: ["llama3", "qwen2", "mistral"] }
                        TextField { id: llmField; Layout.fillWidth: true; font: Theme.bodyMedium; placeholderText: "Tanya model lokal…" }
                    }
                    Text { id: llmOut; text: "Respons muncul di sini (demo)."; color: Theme.onSurfaceVariant; font: Theme.bodySmall; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Button { text: "Kirim"; font: Theme.labelLarge; Layout.fillWidth: true; onClicked:
                        llmOut.text = llmField.text === "" ? "Prompt kosong." : "Demo: '" + llmField.text + "' → OK (42 token)." }
                }
            }

            // Scratchpad + capture + layout
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Scratchpad & capture"; color: Theme.onSurface; font: Theme.titleSmall }
                    TextArea { Layout.fillWidth: true; Layout.preferredHeight: 60; font: Theme.bodyMedium; placeholderText: "Catatan cepat (auto-save demo)…" }
                    RowLayout {
                        Layout.fillWidth: true
                        ComboBox { font: Theme.labelMedium; model: ["Dwindle", "Master", "Floating"] }
                        Button { text: "Screenshot"; font: Theme.labelMedium; onClicked: Theme.exec("sh", ["-c", 'grim -g "$(slurp)" ~/Pictures/vxvicfg-$(date +%s).png']) }
                    }
                }
            }

            // Grafik resource + tray + daya
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: Theme.cardRadius; color: Theme.surfaceContainer
                border.color: Theme.outlineVariant; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Grafik CPU/GPU + tray + daya"; color: Theme.onSurface; font: Theme.titleSmall }
                    Canvas {
                        id: graph
                        Layout.fillWidth: true; Layout.preferredHeight: 70
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.strokeStyle = Theme.outlineVariant; ctx.lineWidth = 1
                            ctx.strokeRect(0.5, 0.5, width - 1, height - 1)
                            ctx.strokeStyle = Theme.accent; ctx.lineWidth = 2
                            ctx.beginPath()
                            for (var i = 0; i < width; i += 6) {
                                var y = height / 2 + Math.sin((i + graphTick.n) * 0.15) * height * 0.3
                                if (i === 0) ctx.moveTo(i, y); else ctx.lineTo(i, y)
                            }
                            ctx.stroke()
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Tray: Discord Steam OBS"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.fillWidth: true }
                        Button { text: "Daya…"; font: Theme.labelMedium; onClicked: powerDlg.open() }
                    }
                }
            }
        }
    }

    Timer { id: toastHide; interval: 3000; repeat: false; onTriggered: toastDemo.visible = false }
    Timer { id: graphTick; property int n: 0; interval: 400; running: true; repeat: true;
        onTriggered: { n += 4; graph.requestPaint() } }

    Dialog {
        id: powerDlg
        title: "Konfirmasi daya (10 dtk)"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        ColumnLayout {
            Text { text: "Shutdown dalam:"; color: Theme.onSurface; font: Theme.bodyMedium }
            Text { id: cdText; text: "10"; color: Theme.onSurface; font: Theme.headlineSmall }
        }
        onOpened: { cdText.text = "10"; cdTimer.start() }
        onClosed: cdTimer.stop()
        onAccepted: console.log("shutdown confirmed (demo)")
    }
    Timer {
        id: cdTimer; interval: 1000; repeat: true
        onTriggered: {
            var v = parseInt(cdText.text) - 1
            cdText.text = v < 0 ? "0" : String(v)
            if (v <= 0) { stop(); powerDlg.close() }
        }
    }
}
