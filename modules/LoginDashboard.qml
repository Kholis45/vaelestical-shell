import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE IV: Lockscreen / login manager solid (demo lokal).
Item {
    id: root
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 420
        height: 560
        radius: Theme.cardRadius
        color: Theme.surface
        border.color: Theme.outline
        border.width: 1

        SequentialAnimation {
            id: shake
            NumberAnimation { target: card; property: "x"; to: card.x - 12; duration: 60 }
            NumberAnimation { target: card; property: "x"; to: card.x + 12; duration: 60 }
            NumberAnimation { target: card; property: "x"; to: card.x - 8; duration: 60 }
            NumberAnimation { target: card; property: "x"; to: card.x; duration: 80; easing.type: Easing.OutCubic }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 10

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 88; height: 88; radius: 99
                color: Theme.primaryContainer
                border.color: Theme.accent; border.width: 2
                Text { anchors.centerIn: parent; text: "KE"; color: Theme.accent; font.bold: true; font.pointSize: 24 }
            }
            Text { text: "PRIVATE EASTJAVA"; color: Theme.onSurface; font.bold: true; font.pointSize: 14;
                Layout.alignment: Qt.AlignHCenter }
            Text { text: "@kholis • VAELESTICAL OS"; color: Theme.onSurfaceVariant; font.pointSize: 11;
                Layout.alignment: Qt.AlignHCenter }
            Text { id: loginClock; text: "--:--"; color: Theme.onSurface; font.pointSize: 22; font.bold: true;
                Layout.alignment: Qt.AlignHCenter }

            TextField { id: userField; Layout.fillWidth: true; placeholderText: "Username"; text: "kholis" }
            RowLayout {
                Layout.fillWidth: true
                TextField {
                    id: passField
                    Layout.fillWidth: true
                    placeholderText: "Password (••••••••)"
                    echoMode: TextInput.Password
                }
                Button {
                    text: passField.echoMode === TextInput.Password ? "Show" : "Hide"
                    font.pointSize: 9
                    onClicked: passField.echoMode = passField.echoMode === TextInput.Password
                        ? TextInput.Normal : TextInput.Password
                }
            }
            CheckBox { id: capsBox; text: "Simulasikan CapsLock aktif"; checked: false }
            Rectangle {
                Layout.fillWidth: true
                height: 30
                radius: Theme.pillRadius
                color: Theme.warning
                visible: capsBox.checked
                Text { anchors.centerIn: parent; text: "Caps Lock aktif!"; color: "#131318"; font.pointSize: 11; font.bold: true }
            }

            RowLayout {
                Layout.fillWidth: true
                Button {
                    text: "Masuk"
                    Layout.fillWidth: true
                    enabled: !busy.running
                    onClicked: {
                        if (passField.text === "") {
                            errText.text = "Password salah — coba lagi."
                            errText.color = Theme.error
                            shake.start()
                        } else {
                            errText.text = ""
                            busy.running = true
                            okTimer.start()
                        }
                    }
                }
                BusyIndicator { id: busy; running: false; width: 28; height: 28 }
            }
            Text { id: errText; text: ""; color: Theme.error; font.pointSize: 11 }

            Item { Layout.fillHeight: true }

            ComboBox {
                Layout.fillWidth: true
                model: ["Hyprland (Wayland)", "Vaelestical Shell Native"]
            }
            RowLayout {
                Layout.fillWidth: true
                Button { text: "Sleep"; Layout.fillWidth: true; onClicked: console.log("sleep") }
                Button { text: "Restart"; Layout.fillWidth: true; onClicked: confirmDlg.open() }
                Button { text: "Shutdown"; Layout.fillWidth: true; onClicked: confirmDlg.open() }
            }
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var d = new Date()
            loginClock.text = ("0" + d.getHours()).slice(-2) + ":" + ("0" + d.getMinutes()).slice(-2)
        }
    }
    Timer {
        id: okTimer; interval: 1200; repeat: false
        onTriggered: { busy.running = false; errText.text = "Login demo berhasil."; errText.color = Theme.success }
    }

    Dialog {
        id: confirmDlg
        title: "Konfirmasi daya"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        Label { text: "Demo: aksi daya dibatalkan (countdown ada di UtilitiesAI)." }
        onAccepted: console.log("power confirmed (demo)")
    }
}
