import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE E: Utilities, AI & system extensions (demo interaktif).
Item {
    id: root
    property color card: "#1a1b22"
    property color card2: "#262732"
    property color border: "#333545"
    property color txt1: "#e3e2e6"
    property color txt2: "#8e9099"

    width: 680
    height: 620

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
        GridLayout {
            width: root.width - 28
            columns: 2
            columnSpacing: 10
            rowSpacing: 10

            // Clipboard
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Clipboard history"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    TextField { id: clipSearch; Layout.fillWidth: true; placeholderText: "Cari clipboard…" }
                    ListView {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        clip: true
                        model: ["sudo pacman -Syu", "ssh kholis@server", "catatan: beli kopi", "https://contoh.id", "echo hello"]
                        delegate: Text {
                            required property var modelData
                            width: ListView.view.width
                            text: "• " + modelData; color: root.txt2; font.pointSize: 10; elide: Text.ElideRight
                            visible: clipSearch.text === "" || modelData.toLowerCase().indexOf(clipSearch.text.toLowerCase()) !== -1
                        }
                    }
                }
            }

            // Launcher + kalkulator mini
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Launcher + hitung"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    TextField { id: launchField; Layout.fillWidth: true; placeholderText: "firefox / 12*8-4…" }
                    Text { id: launchOut; text: "Super+K • Enter eksekusi (demo)"; color: root.txt2; font.pointSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Button { text: "Jalankan"; Layout.fillWidth: true; onClicked: {
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
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Toast & OSD pills"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    Button { text: "Tampilkan toast"; Layout.fillWidth: true; onClicked: { toastDemo.visible = true; toastHide.start() } }
                    Text { id: toastDemo; text: "🔔 Notifikasi DBus (demo)"; color: root.txt1; font.pointSize: 10; visible: false }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "OSD vol:"; color: root.txt2; font.pointSize: 10 }
                        Slider { id: osdVol; Layout.fillWidth: true; from: 0; to: 100; value: 40 }
                        Text { text: Math.round(osdVol.value) + "%"; color: root.txt1; font.pointSize: 10 }
                    }
                    Text { text: "CapsLock: OFF • Layout: ID"; color: root.txt2; font.pointSize: 10 }
                }
            }

            // LLM lokal + hotkeys
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Ollama prompt + hotkeys"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    RowLayout {
                        Layout.fillWidth: true
                        ComboBox { model: ["llama3", "qwen2", "mistral"] }
                        TextField { id: llmField; Layout.fillWidth: true; placeholderText: "Tanya model lokal…" }
                    }
                    Text { id: llmOut; text: "Respons muncul di sini (demo)."; color: root.txt2; font.pointSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Button { text: "Kirim"; Layout.fillWidth: true; onClicked:
                        llmOut.text = llmField.text === "" ? "Prompt kosong." : "Demo: '" + llmField.text + "' → OK (42 token)." }
                }
            }

            // Catatan + screenshot/layout
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Scratchpad & capture"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    TextArea { Layout.fillWidth: true; Layout.preferredHeight: 60; placeholderText: "Catatan cepat (auto-save demo)…" }
                    RowLayout {
                        Layout.fillWidth: true
                        ComboBox { model: ["Dwindle", "Master", "Floating"] }
                        Button { text: "Screenshot"; onClicked: console.log("grim/slurp (demo)") }
                    }
                }
            }

            // Grafik resource (Canvas) + tray + daya
            Rectangle {
                Layout.fillWidth: true; Layout.preferredHeight: 190
                radius: 14; color: root.card2; border.color: root.border; border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 10; spacing: 6
                    Text { text: "Grafik CPU/GPU + tray + daya"; color: root.txt1; font.bold: true; font.pointSize: 11 }
                    Canvas {
                        id: graph
                        Layout.fillWidth: true; Layout.preferredHeight: 70
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.strokeStyle = "#333545"; ctx.lineWidth = 1
                            ctx.strokeRect(0.5, 0.5, width - 1, height - 1)
                            ctx.strokeStyle = "#a8c7fa"; ctx.lineWidth = 2
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
                        Text { text: "Tray: Discord Steam OBS"; color: root.txt2; font.pointSize: 10; Layout.fillWidth: true }
                        Button { text: "Daya…"; onClicked: powerDlg.open() }
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
            Text { text: "Shutdown dalam:"; color: root.txt1 }
            Text { id: cdText; text: "10"; color: root.txt1; font.pointSize: 24; font.bold: true }
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
