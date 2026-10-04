import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// HAKU-3: Desktop clock widget — jam digital besar monospace/retro.
// Kontrak: token Theme, ukuran eksplisit, tanpa anchor ke parent.
Item {
    id: root
    width: 560
    height: 240

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 2
        Text {
            id: bigTime
            Layout.alignment: Qt.AlignHCenter
            text: "--:--"
            color: Theme.onSurface
            font.family: "monospace"
            font.pixelSize: 120
            font.weight: Font.DemiBold
        }
        Text {
            id: bigDate
            Layout.alignment: Qt.AlignHCenter
            text: ""
            color: Theme.onSurfaceVariant
            font.family: "monospace"
            font.pixelSize: 18
            font.letterSpacing: 4
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var d = new Date()
            var hh = ("0" + d.getHours()).slice(-2)
            var mm = ("0" + d.getMinutes()).slice(-2)
            bigTime.text = hh + ":" + mm
            try {
                bigDate.text = d.toLocaleDateString(Qt.locale(), "dddd, dd/MM/yyyy")
            } catch (e) {
                bigDate.text = d.toDateString()
            }
        }
    }
}
