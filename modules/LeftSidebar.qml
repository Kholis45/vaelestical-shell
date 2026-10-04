import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE A: Floating pill sidebar solid + workspace switcher (M3E).
Item {
    id: root
    property string barPosition: "left" // top | bottom | left | right
    property real cornerRadius: Theme.cardRadius
    property int currentWorkspace: 1
    property bool isVertical: barPosition === "left" || barPosition === "right"

    width: isVertical ? 76 : 560
    height: isVertical ? 470 : 76

    function toggleVisibility() { root.visible = !root.visible }
    function repositionBar(pos) { root.barPosition = pos }

    // Solid shadow + body solid
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
        border.color: Theme.outlineVariant
        border.width: 1
    }

    // Vertical layout (left / right)
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10
        visible: root.isVertical

        Text { text: "V"; color: Theme.accent; font: Theme.titleMedium;
            Layout.alignment: Qt.AlignHCenter }

        Repeater {
            model: 4
            delegate: Rectangle {
                required property int index
                property bool active: root.currentWorkspace === index + 1
                objectName: "wsDot" + index
                Layout.alignment: Qt.AlignHCenter
                width: active ? 34 : 14
                height: 14
                radius: Theme.pillRadius
                color: active ? Theme.primary : Theme.surfaceContainerHighest
                border.color: active ? Theme.primary : Theme.outlineVariant
                border.width: 1
                Behavior on color {
                    ColorAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                }
                Behavior on width {
                    NumberAnimation { duration: Theme.motionMedium1; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                }
                MouseArea {
                    id: wsMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        root.currentWorkspace = parent.index + 1
                        Theme.exec("hyprctl", ["dispatch", "workspace", String(parent.index + 1)])
                    }
                }
                StateLayer { anchors.fill: parent; cornerRadius: Theme.pillRadius; hoverSource: wsMa }
            }
        }

        Rectangle { Layout.alignment: Qt.AlignHCenter; width: 36; height: 1; color: Theme.outlineVariant }

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
                    width: 30; height: 30; radius: Theme.pillRadius
                    color: Theme.surfaceContainerHighest
                    border.color: Theme.outlineVariant
                    border.width: 1
                    ToolTip.visible: mh.containsMouse
                    ToolTip.text: modelData.tip
                    Text { anchors.centerIn: parent; text: modelData.t; color: Theme.onSurfaceVariant; font: Theme.labelSmall }
                    Behavior on color {
                        ColorAnimation { duration: Theme.motionShort3; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: Theme.motionShort3; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                    }
                    MouseArea { id: mh; anchors.fill: parent; hoverEnabled: true;
                        onClicked: console.log("status:", modelData.tip) }
                    StateLayer { anchors.fill: parent; cornerRadius: Theme.pillRadius; hoverSource: mh }
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6
            Button { text: "Lock"; font: Theme.labelSmall; Layout.preferredWidth: 56; onClicked: Theme.exec("loginctl", ["lock-session"]) }
            Button { text: "Off"; font: Theme.labelSmall; Layout.preferredWidth: 56; onClicked: console.log("power menu requested") }
        }

        // Breathing pulse status dot (solid)
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 10; height: 10; radius: Theme.pillRadius
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

        Text { text: "V"; color: Theme.accent; font: Theme.titleMedium }

        Repeater {
            model: 4
            delegate: Rectangle {
                required property int index
                property bool active: root.currentWorkspace === index + 1
                width: active ? 34 : 14
                height: 14
                radius: Theme.pillRadius
                color: active ? Theme.primary : Theme.surfaceContainerHighest
                border.color: active ? Theme.primary : Theme.outlineVariant
                border.width: 1
                Behavior on color {
                    ColorAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                }
                Behavior on width {
                    NumberAnimation { duration: Theme.motionMedium1; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                }
                MouseArea { id: wsMaH; anchors.fill: parent; hoverEnabled: true;
                    onClicked: {
                        root.currentWorkspace = parent.index + 1
                        Theme.exec("hyprctl", ["dispatch", "workspace", String(parent.index + 1)])
                    } }
                StateLayer { anchors.fill: parent; cornerRadius: Theme.pillRadius; hoverSource: wsMaH }
            }
        }

        Rectangle { width: 1; height: 36; color: Theme.outlineVariant }
        Button { text: "Apps"; font: Theme.labelSmall; onClicked: console.log("launcher requested") }
        Button { text: "Lock"; font: Theme.labelSmall; onClicked: Theme.exec("loginctl", ["lock-session"]) }
        Rectangle {
            width: 10; height: 10; radius: Theme.pillRadius; color: Theme.success
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
