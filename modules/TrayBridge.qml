import QtQuick
import QtQuick.Layouts
import Vxvicfg.Core 1.0

// Jembatan tray native (C++ StatusNotifierTray).
// DIMUAT HANYA on-demand via Loader (lihat UtilitiesFlyout): bila plugin
// libvxvicfg_core belum terpasang, file ini tidak pernah di-load sehingga
// tidak ada warning/error — daftar statis tetap dipakai.
ColumnLayout {
    spacing: 4
    Repeater {
        model: Tray.items
        delegate: Rectangle {
            required property var modelData
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            radius: 10
            color: Tray.items.length > 0 ? Theme.surfaceContainerHigh : "transparent"
            border.color: Theme.outlineVariant
            border.width: 1
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: "◉ " + String(modelData).replace("org.kde.StatusNotifierItem", "").replace(".", "").trim() || String(modelData)
                color: Theme.onSurface
                font.pixelSize: 11
                elide: Text.ElideRight
                width: parent.width - 20
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Tray.activate(modelData)
            }
        }
    }
    Text {
        Layout.fillWidth: true
        visible: Tray.items.length === 0
        text: "Tidak ada ikon tray (butuh libvxvicfg_core)."
        color: Theme.onSurfaceVariant
        font.pixelSize: 11
        wrapMode: Text.Wrap
    }
}
