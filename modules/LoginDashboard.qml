import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE IV: Lockscreen / login manager solid (M3E penuh, demo lokal).
Item {
    id: root
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Theme.scrim
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 420
        height: 580
        radius: Theme.cardRadius
        color: Theme.surface
        border.color: Theme.outlineVariant
        border.width: 1

        SequentialAnimation {
            id: shake
            NumberAnimation { target: card; property: "x"; to: card.x - 12; duration: 60 }
            NumberAnimation { target: card; property: "x"; to: card.x + 12; duration: 60 }
            NumberAnimation { target: card; property: "x"; to: card.x - 8; duration: 60 }
            NumberAnimation { target: card; property: "x"; to: card.x; duration: 80; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 10

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 88; height: 88; radius: Theme.pillRadius
                color: Theme.primaryContainer
                border.color: Theme.accent; border.width: 2
                Text { anchors.centerIn: parent; text: "KE"; color: Theme.accent; font: Theme.headlineSmall }
                Image {
                    id: avatarImg
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: status === Image.Ready
                }
            }
            Text { text: "PRIVATE EASTJAVA"; color: Theme.onSurface; font: Theme.titleMedium;
                Layout.alignment: Qt.AlignHCenter }
            Text { id: handleText; text: "@kholis • VXVICFG OS"; color: Theme.onSurfaceVariant; font: Theme.labelMedium;
                Layout.alignment: Qt.AlignHCenter }
            Text { id: loginClock; text: "--:--"; color: Theme.onSurface; font: Theme.displaySmall;
                Layout.alignment: Qt.AlignHCenter }

            TextField { id: userField; Layout.fillWidth: true; font: Theme.bodyLarge; placeholderText: "Username"; text: "kholis" }
            RowLayout {
                Layout.fillWidth: true
                TextField {
                    id: passField
                    Layout.fillWidth: true
                    font: Theme.bodyLarge
                    placeholderText: "Password (••••••••)"
                    echoMode: TextInput.Password
                }
                Button {
                    text: passField.echoMode === TextInput.Password ? "Show" : "Hide"
                    font: Theme.labelSmall
                    onClicked: passField.echoMode = passField.echoMode === TextInput.Password
                        ? TextInput.Normal : TextInput.Password
                }
            }
            CheckBox { id: capsBox; text: "Simulasikan CapsLock aktif"; font: Theme.labelMedium; checked: false }
            Rectangle {
                Layout.fillWidth: true
                height: 32
                radius: Theme.pillRadius
                color: Theme.warning
                visible: capsBox.checked
                Text { anchors.centerIn: parent; text: "Caps Lock aktif!"; color: Theme.scrim; font: Theme.labelLarge }
            }

            RowLayout {
                Layout.fillWidth: true
                Button {
                    text: "Masuk"
                    font: Theme.labelLarge
                    Layout.fillWidth: true
                    enabled: !busy.running
                    onClicked: {
                        if (passField.text === "") {
                            errText.text = "Password salah — coba lagi."
                            errText.color = Theme.error
                            shake.start()
                        } else if (Theme.hasBin("pamtester") && Theme.hasSys()) {
                            // Auth PAM asli (butuh paket pamtester).
                            var out = Theme.execSync("sh", ["-c", "pamtester login '" + userField.text.replace(/'/g, "") + "' authenticate 2>&1"])
                            if (out.toLowerCase().indexOf("success") >= 0) {
                                errText.text = ""
                                passField.text = ""
                                root.visible = false
                            } else {
                                errText.text = "Autentikasi gagal — coba lagi."
                                errText.color = Theme.error
                                shake.start()
                            }
                        } else {
                            errText.text = ""
                            busy.running = true
                            okTimer.start()
                        }
                    }
                }
                BusyIndicator { id: busy; running: false; width: 28; height: 28 }
            }
            Text { id: errText; text: ""; color: Theme.error; font: Theme.labelMedium }

            Item { Layout.fillHeight: true }

            ComboBox {
                Layout.fillWidth: true
                font: Theme.labelMedium
                model: ["Hyprland (Wayland)", "vxvicfg Shell Native"]
            }
            RowLayout {
                Layout.fillWidth: true
                Button { text: "Sleep"; font: Theme.labelMedium; Layout.fillWidth: true; onClicked: Theme.exec("systemctl", ["suspend"]) }
                Button { text: "Restart"; font: Theme.labelMedium; Layout.fillWidth: true; onClicked: { confirmDlg.powerAction = "reboot"; confirmDlg.open() } }
                Button { text: "Shutdown"; font: Theme.labelMedium; Layout.fillWidth: true; onClicked: { confirmDlg.powerAction = "poweroff"; confirmDlg.open() } }
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

    // Identitas asli sistem (no-op aman tanpa backend).
    Component.onCompleted: {
        var u = Theme.execSync("whoami").trim()
        if (u !== "") {
            userField.text = u
            var h = Theme.readText("/etc/hostname").trim()
            handleText.text = "@" + u + " • " + (h !== "" ? h : "VXVICFG OS")
        }
        var home = Theme.execSync("sh", ["-c", "echo $HOME"]).trim()
        if (home !== "" && Theme.execSync("sh", ["-c", "test -f \"" + home + "/.face\" && echo ok"]).trim() === "ok")
            avatarImg.source = "file://" + home + "/.face"
    }

    Dialog {
        id: confirmDlg
        property string powerAction: ""
        title: "Konfirmasi daya"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        Label { text: "Demo: aksi daya dibatalkan (countdown ada di UtilitiesAI)."; font: Theme.bodyMedium }
        onAccepted: {
            if (powerAction !== "")
                Theme.exec("systemctl", [powerAction])
            else
                console.log("power confirmed (demo)")
        }
    }
}
