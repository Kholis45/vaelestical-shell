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
    // Berdenyut hanya saat ada audio diputar (playerctl); default animasi.
    property bool isPlaying: true

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
        interval: 90; running: root.isPlaying; repeat: true
        onTriggered: root.tick++
    }
    // Status playback MPRIS (murah: 1x per 2 detik, diam tanpa playerctl).
    Timer {
        interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            if (!Theme.hasBin("playerctl"))
                return
            var s = Theme.execSync("playerctl", ["status"])
            if (s !== "")
                root.isPlaying = (s.trim() === "Playing")
        }
    }
}
