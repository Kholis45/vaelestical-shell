import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE A: Floating pill sidebar solid + workspace switcher (M3).
Item {
    id: root
    property string barPosition: "left" // top | bottom | left | right
    property real cornerRadius: Theme.cardRadius
    property int currentWorkspace: 1
    property bool isVertical: barPosition === "left" || barPosition === "right"

    width: isVertical ? 76 : 560
    height: isVertical ? 620 : 76

    function toggleVisibility() { root.visible = !root.visible }
    function repositionBar(pos) { root.barPosition = pos }

    // Soft drop shadow (solid, tanpa blur) + body solid
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.leftMargin: 2
        radius: isVertical ? width / 2 : height / 2
        color: Theme.shadow
    }
    Rectangle {
        id: pill
        anchors.fill: parent
        anchors.bottomMargin: 3
        anchors.rightMargin: 2
        radius: isVertical ? width / 2 : height / 2
        color: Theme.surfaceContainer
        border.color: Theme.outline
        border.width: 1
    }

    // Vertical layout (left / right)
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10
        visible: root.isVertical

        Text { text: "V"; color: Theme.accent; font.bold: true; font.pointSize: 16;
            Layout.alignment: Qt.AlignHCenter }

        Repeater {
            model: 4
            delegate: Rectangle {
                required property int index
                property bool active: root.currentWorkspace === index + 1
                Layout.alignment: Qt.AlignHCenter
                width: active ? 34 : 14
                height: 14
                radius: 99
                color: active ? Theme.active : Theme.surfaceContainerHighest
                border.color: active ? Theme.active : Theme.outline
                border.width: 1
                Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentWorkspace = parent.index + 1
                }
            }
        }

        Rectangle { Layout.alignment: Qt.AlignHCenter; width: 36; height: 1; color: Theme.outline }

        GridLayout {
            columns: 2
            Layout.alignment: Qt.AlignHCenter
            columnSpacing: 6
            rowSpacing: 6
            Repeater {
                model: [
                    { t: "WiFi", tip: "Wi-Fi" },
                    { t: "BT", tip: "Bluetooth" },
                    { t: "VOL", tip: "Audio" },
                    { t: "PWR", tip: "Power" }
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: 30; height: 30; radius: 99
                    color: Theme.surfaceContainerHighest
                    border.color: Theme.outline
                    border.width: 1
                    ToolTip.visible: mh.containsMouse
                    ToolTip.text: modelData.tip
                    Text { anchors.centerIn: parent; text: modelData.t; color: Theme.onSurfaceVariant; font.pointSize: 7 }
                    Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                    MouseArea { id: mh; anchors.fill: parent; hoverEnabled: true;
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

        // Breathing pulse status dot (solid)
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 10; height: 10; radius: 99
            color: Theme.success
            border.color: Theme.onSurface
            border.width: 1
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

        Text { text: "V"; color: Theme.accent; font.bold: true; font.pointSize: 16 }

        Repeater {
            model: 4
            delegate: Rectangle {
                required property int index
                property bool active: root.currentWorkspace === index + 1
                width: active ? 34 : 14
                height: 14
                radius: 99
                color: active ? Theme.active : Theme.surfaceContainerHighest
                border.color: active ? Theme.active : Theme.outline
                border.width: 1
                Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                MouseArea { anchors.fill: parent; onClicked: root.currentWorkspace = parent.index + 1 }
            }
        }

        Rectangle { width: 1; height: 36; color: Theme.outline }
        Button { text: "Apps"; font.pointSize: 8; onClicked: console.log("launcher requested") }
        Button { text: "Lock"; font.pointSize: 8; onClicked: console.log("lock requested") }
        Rectangle {
            width: 10; height: 10; radius: 99; color: Theme.success
            border.color: Theme.onSurface
            border.width: 1
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 1500; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.3; to: 1.0; duration: 1500; easing.type: Easing.InOutSine }
            }
        }
    }
}
