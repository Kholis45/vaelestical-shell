import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils/Formatters.js" as F

// MODULE IV2: Lockscreen alternatif — kartu PAM, sesi, daya cepat.
// (LoginDashboard tetap menjadi lockscreen utama.)
Item {
    id: root
    anchors.fill: parent

    property string errText: ""
    property bool showPass: false

    Rectangle {
        anchors.fill: parent
        color: Theme.scrim
        opacity: 0.85
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 400
        height: 540
        radius: Theme.cardRadius
        color: Theme.surface
        border.color: Theme.outlineVariant
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
                width: 84; height: 84; radius: Theme.pillRadius
                color: Theme.primaryContainer
                border.color: Theme.accent; border.width: 2
                Text { anchors.centerIn: parent; text: "V"; color: Theme.accent; font: Theme.headlineSmall }
                Image {
                    id: lockAvatar
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: status === Image.Ready
                }
            }
            Text { text: "PRIVATE EASTJAVA"; color: Theme.onSurface; font: Theme.titleMedium; Layout.alignment: Qt.AlignHCenter }
            Text { id: lockHandle; text: "@kholis • VXVICFG OS"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.alignment: Qt.AlignHCenter }
            Text { id: lockClock; text: "--:--"; color: Theme.onSurface; font: Theme.displaySmall; Layout.alignment: Qt.AlignHCenter }
            Text { id: lockDate; text: ""; color: Theme.onSurfaceVariant; font: Theme.bodyMedium; Layout.alignment: Qt.AlignHCenter }

            TextField { id: lockUser; Layout.fillWidth: true; font: Theme.bodyLarge; placeholderText: "Username"; text: "kholis" }
            RowLayout {
                Layout.fillWidth: true
                TextField {
                    id: lockPass
                    Layout.fillWidth: true
                    font: Theme.bodyLarge
                    placeholderText: "Password (••••••••)"
                    echoMode: root.showPass ? TextInput.Normal : TextInput.Password
                    onAccepted: root.tryLogin()
                    onTextChanged: root.errText = ""
                }
                Button {
                    text: root.showPass ? "🙈" : "👁"
                    font: Theme.labelLarge
                    onClicked: root.showPass = !root.showPass
                }
            }
            Text { id: capsNote; text: "⚠ Caps Lock menyala?"; color: Theme.warning; font: Theme.labelMedium; visible: /[A-Z]{3,}/.test(lockPass.text) }
            Text { text: root.errText; color: Theme.error; font: Theme.labelMedium; visible: root.errText !== "" }

            Button {
                text: "Masuk"
                font: Theme.labelLarge
                Layout.fillWidth: true
                highlighted: true
                onClicked: root.tryLogin()
            }
            ComboBox {
                Layout.fillWidth: true
                font: Theme.labelMedium
                model: ["Hyprland (Wayland)", "vxvicfg Shell Native"]
            }
            RowLayout {
                Layout.fillWidth: true
                Button { text: "Sleep"; font: Theme.labelMedium; Layout.fillWidth: true; onClicked: Theme.exec("systemctl", ["suspend"]) }
                Button { text: "Restart"; font: Theme.labelMedium; Layout.fillWidth: true; onClicked: Theme.exec("systemctl", ["reboot"]) }
                Button { text: "Shutdown"; font: Theme.labelMedium; Layout.fillWidth: true; onClicked: Theme.exec("systemctl", ["poweroff"]) }
            }
            Text { text: "Auth via PAM (PamAuth C++) • fallback demo"; color: Theme.onSurfaceVariant; font: Theme.labelSmall; Layout.alignment: Qt.AlignHCenter }
        }
    }

    function tryLogin() {
        if (lockPass.text === "") {
            root.errText = "Password kosong."
            shake.start()
            return
        }
        // Tanpa pamtester / tanpa backend → jalur demo (tidak diblokir).
        if (!Theme.hasBin("pamtester") || !Theme.hasSys()) {
            root.errText = ""
            lockPass.text = ""
            root.visible = false
            return
        }
        var out = Theme.execSync("sh", ["-c", "pamtester login '" + lockUser.text.replace(/'/g, "") + "' authenticate 2>&1"])
        if (out !== "" && out.toLowerCase().indexOf("success") >= 0) {
            root.errText = ""
            lockPass.text = ""
            root.visible = false
        } else {
            root.errText = "Autentikasi gagal — coba lagi."
            shake.start()
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var d = new Date()
            lockClock.text = F.formatClock(d)
            lockDate.text = d.toDateString()
        }
    }

    // Identitas asli sistem (no-op aman tanpa backend).
    Component.onCompleted: {
        var u = Theme.execSync("whoami").trim()
        if (u !== "") {
            lockUser.text = u
            var h = Theme.readText("/etc/hostname").trim()
            lockHandle.text = "@" + u + " • " + (h !== "" ? h : "VXVICFG OS")
        }
        var home = Theme.execSync("sh", ["-c", "echo $HOME"]).trim()
        if (home !== "" && Theme.execSync("sh", ["-c", "test -f \"" + home + "/.face\" && echo ok"]).trim() === "ok")
            lockAvatar.source = "file://" + home + "/.face"
    }
}
