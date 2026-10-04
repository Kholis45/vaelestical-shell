import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../utils/Formatters.js" as F

// HAKU-1: Bottom floating pill taskbar (gaya Hakuspace).
// Launcher kiri, ikon terpusat, status pill (vol/wifi/batt/jam) kanan.
// Kontrak: token Theme, aksi via Theme.exec, ukuran eksplisit.
Item {
    id: root
    width: 640
    height: 54

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.leftMargin: 2
        radius: Theme.pillRadius
        color: Theme.shadow
    }
    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 3
        anchors.rightMargin: 2
        radius: Theme.pillRadius
        color: Theme.surface
        border.color: Theme.outlineVariant
        border.width: 1
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 8

        // Launcher kiri
        Rectangle {
            width: 38; height: 38; radius: Theme.pillRadius
            color: launchMa.containsMouse ? Theme.primaryContainer : Theme.surfaceContainerHigh
            border.color: Theme.outlineVariant; border.width: 1
            Behavior on color {
                ColorAnimation { duration: Theme.dColor; easing.type: Easing.OutCubic }
            }
            Text { anchors.centerIn: parent; text: "▦"; color: Theme.onSurface; font.pixelSize: 18 }
            MouseArea {
                id: launchMa
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Theme.exec("sh", ["-c", "rofi -show drun 2>/dev/null || wofi --show drun 2>/dev/null; true"])
            }
            StateLayer { anchors.fill: parent; cornerRadius: Theme.pillRadius; hoverSource: launchMa }
        }

        Rectangle { width: 1; height: 30; color: Theme.outlineVariant }

        // Ikon terpusat
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 6
            Repeater {
                model: [
                    { t: "Z", tip: "Zen Browser", cmd: "zen" },
                    { t: "C", tip: "Code", cmd: "code" },
                    { t: ">_", tip: "kitty", cmd: "kitty" },
                    { t: "F", tip: "Thunar", cmd: "thunar" },
                    { t: "S", tip: "Steam", cmd: "steam" },
                    { t: "D", tip: "Discord", cmd: "discord" }
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: 38; height: 38; radius: 14
                    color: appMa.containsMouse ? Theme.primaryContainer : "transparent"
                    Behavior on color {
                        ColorAnimation { duration: Theme.dColor; easing.type: Easing.OutCubic }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: modelData.t
                        color: Theme.onSurface
                        font.family: "monospace"
                        font.pixelSize: 15
                    }
                    MouseArea {
                        id: appMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Theme.exec(modelData.cmd, [])
                    }
                    StateLayer { anchors.fill: parent; cornerRadius: 14; hoverSource: appMa }
                }
            }
        }

        Rectangle { width: 1; height: 30; color: Theme.outlineVariant }

        // Status pill kanan
        Rectangle {
            Layout.preferredHeight: 38
            Layout.preferredWidth: statusRow.implicitWidth + 24
            radius: Theme.pillRadius
            color: Theme.surfaceContainerHigh
            border.color: Theme.outlineVariant
            border.width: 1
            Row {
                id: statusRow
                anchors.centerIn: parent
                spacing: 10
                Text { text: "◉ 61%"; color: Theme.onSurfaceVariant; font.family: "monospace"; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter }
                Text { text: "♪ 43%"; color: Theme.onSurfaceVariant; font.family: "monospace"; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter }
                Text { text: ""; color: Theme.onSurfaceVariant; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter }
                Text { id: taskClock; text: "--:--"; color: Theme.onSurface; font.family: "monospace"; font.pixelSize: 13; anchors.verticalCenter: parent.verticalCenter }
            }
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: taskClock.text = F.formatClock(new Date())
    }
}
