import QtQuick
import QtQuick.Layouts

// HAKU-4: Floating Cava visualizer — strip bar spektrum mengambang
// (tepi atas/bawah via properti `edge`). Pola animasi Timer + sinus
// deterministik seperti visualizer dashboard (aman untuk soak test).
Item {
    id: root
    width: 900
    height: 64

    property string edge: "top" // top | bottom
    property int tick: 0

    RowLayout {
        anchors.centerIn: parent
        spacing: 5
        Repeater {
            model: 48
            delegate: Rectangle {
                required property int index
                Layout.alignment: root.edge === "top" ? Qt.AlignTop : Qt.AlignBottom
                width: 10
                height: 6 + 46 * Math.abs(Math.sin((index + root.tick) * 0.5)
                    * Math.sin(index * 0.7 - root.tick * 0.3))
                radius: 3
                color: Theme.onSurfaceVariant
                opacity: 0.85
                Behavior on height {
                    NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                }
            }
        }
    }

    Timer {
        interval: 90; running: true; repeat: true
        onTriggered: root.tick++
    }
}
