import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE A: Floating pill sidebar + workspace switcher.
// Single-root Item. Only built-in QtQuick types.
Item {
    id: root
    property string barPosition: "left" // top | bottom | left | right
    property real cornerRadius: 20
    property int currentWorkspace: 1
    property color accent: "#a8c7fa"
    property color card: "#1a1b22"
    property color border: "#333545"
    property color txt1: "#e3e2e6"
    property color txt2: "#8e9099"
    property bool isVertical: barPosition === "left" || barPosition === "right"

    width: isVertical ? 76 : 560
    height: isVertical ? 620 : 76

    function toggleVisibility() { root.visible = !root.visible }
    function repositionBar(pos) { root.barPosition = pos }

    Rectangle {
        id: pill
        anchors.fill: parent
        radius: isVertical ? width / 2 : height / 2
        color: root.card
        opacity: 0.92
        border.color: root.border
        border.width: 1
        layer.enabled: true
        layer.smooth: true
    }

    // Vertical layout (left / right)
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10
        visible: root.isVertical

        Text { text: "V"; color: root.accent; font.bold: true; font.pointSize: 16
            Layout.alignment: Qt.AlignHCenter }

        Repeater {
            model: 4
            delegate: Rectangle {
                required property int index
                Layout.alignment: Qt.AlignHCenter
                width: root.currentWorkspace === index + 1 ? 34 : 14
                height: 14
                radius: 7
                color: root.currentWorkspace === index + 1 ? root.accent : "#3a3d4d"
                Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentWorkspace = parent.index + 1
                }
            }
        }

        Rectangle { Layout.alignment: Qt.AlignHCenter; width: 36; height: 1; color: root.border }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6
            Repeater {
                model: [
                    { t: "WiFi", tip: "Wi-Fi" },
                    { t: "BT", tip: "Bluetooth" },
                    { t: "VOL", tip: "Audio" },
                    { t: "PWR", tip: "Power" }
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: 30; height: 30; radius: 15
                    color: "#262732"; border.color: root.border; border.width: 1
                    ToolTip.visible: mh.containsMouse
                    ToolTip.text: modelData.tip
                    Text { anchors.centerIn: parent; text: modelData.t; color: root.txt2; font.pointSize: 7 }
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                    MouseArea { id: mh; anchors.fill: parent; hoverEnabled: true
                        onClicked: console.log("status:", modelData.tip) }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            Button { text: "Lock"; font.pointSize: 8; onClicked: console.log("lock requested") }
            Button { text: "Off"; font.pointSize: 8; onClicked: console.log("power menu requested") }
        }

        // Breathing pulse status dot
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 8; height: 8; radius: 4
            color: root.accent
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 1500; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.3; to: 1.0; duration: 1500; easing.type: Easing.InOutSine }
            }
        }
    }

    // Horizontal layout (top / bottom)
    RowLayout {
        anchors.centerIn: parent
        spacing: 10
        visible: !root.isVertical

        Text { text: "V"; color: root.accent; font.bold: true; font.pointSize: 16 }

        Repeater {
            model: 4
            delegate: Rectangle {
                required property int index
                width: root.currentWorkspace === index + 1 ? 34 : 14
                height: 14
                radius: 7
                color: root.currentWorkspace === index + 1 ? root.accent : "#3a3d4d"
                Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                MouseArea { anchors.fill: parent; onClicked: root.currentWorkspace = parent.index + 1 }
            }
        }

        Rectangle { width: 1; height: 36; color: root.border }
        Button { text: "Apps"; font.pointSize: 8; onClicked: console.log("launcher requested") }
        Button { text: "Lock"; font.pointSize: 8; onClicked: console.log("lock requested") }
        Rectangle {
            width: 8; height: 8; radius: 4; color: root.accent
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 1500; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.3; to: 1.0; duration: 1500; easing.type: Easing.InOutSine }
            }
        }
    }
}
