import QtQuick

// StateLayer — overlay state-layer M3 (hover 8% / press 12%).
// Pemakaian di dalam permukaan interaktif (Rectangle/Card):
//   StateLayer { anchors.fill: parent; cornerRadius: 99; hoverSource: ma }
//   MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; ... }
// Letakkan TEPAT setelah background agar berada di bawah teks.
Rectangle {
    id: root
    property var hoverSource
    property real cornerRadius: 0

    radius: cornerRadius
    color: Theme.stateLayer
    opacity: 0

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.motionShort3
            easing.type: Easing.Bezier
            easing.bezierCurve: Theme.emphasized
        }
    }

    Connections {
        target: root.hoverSource
        function onEntered() { root.opacity = Theme.stateHover }
        function onExited() { root.opacity = 0 }
        function onPressed() { root.opacity = Theme.statePressed }
        function onReleased() { root.opacity = root.hoverSource && root.hoverSource.containsMouse ? Theme.stateHover : 0 }
        function onCanceled() { root.opacity = 0 }
    }
}
