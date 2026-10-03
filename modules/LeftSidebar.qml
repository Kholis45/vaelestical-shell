import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts 6.0

// ============================================================
// MODULE A: FLOATING LEFT VERTICAL BAR & DYNAMIC POSITIONING ENGINE
//================================================================
// Universal Start Menu / App Launcher Trigger Icon
// Interactive Workspace Dots Switcher
// Quick Status Indicators Capsule
// Quick Session Action Menu
// Dynamic Bar Position Engine (supports top/bottom/left/right)
// Breathing Pulse Status Dot
//================================================================

// Left Sidebar Root - positioned anchor object
QtObject {
    id: leftSidebar
    property real barWidth: 56
    property int currentWorkspace: 1
    property bool visible: true

    // Appearance based on barPosition from main.qml
    property variant barPosition: "left"

    // --- START TRIGGER ICON ---
    StartTriggerIcon {
        id: startTrigger
        anchors.leftMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        // Super+D equivalent - click triggers menu
    }

    // --- WORKSPACE DOTS SWITCHER ---
    RowLayout {
        id: workspaceDotsRow
        anchors { left: leftTrigger.right; leftMargin: 12; verticalCenter: parent.verticalCenter }
        spacing: 6

        // Pill indicators for each workspace (4 workspaces typical)
        Repeater {
            model: 4
            Component {
                Item {
                    id: dotItem
                    width: 8
                    height: 8
                    // Circular dot with spring physics
                    Rectangle {
                        anchors.centerIn: parent
                        width: 8
                        height: 8
                        radius: 4
                        color: leftSidebar.currentWorkspace === model.index ? leftSidebar.accentPrimary : leftSidebar.textSecondary
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // Dispatch hyprctl to switch workspace
                                // hyprctl dispatch workspace [id]
                                leftSidebar.currentWorkspace = model.index + 1
                            }
                        }
                    }

                    // Active/hover state with scale feedback
                    states: [
                        State {
                            name: "active"
                            PropertyChanges { target: dotRectangle; color: leftSidebar.accentPrimary }
                        }
                    ]
                    Transitions {
                        Transition {
                            from: ""
                            to: "active"
                            NumberAnimation {
                                target: dotRectangle
                                property: "color"
                                duration: 150
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }
            }
        }

        // Breathing Pulse Status Dot (8px circle, opacity loop 1.0 to 0.3 over 1500ms)
        Item {
            id: breathingDot
            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 8 }
            width: 8
            height: 8
            opacity: 1
            Behavior on opacity {
                NumberAnimation {
                    duration: 1500
                    easing.type: Easing.InOutSine
                    loops: Animation.Infinite
                    from: 1
                    to: 0.3
                }
            }
            // Pulse color alternation
            Rectangle {
                anchors.centerIn: parent
                width: 8
                height: 8
                radius: 4
                color: leftSidebar.textSecondary
            }
        }
    }

    // --- QUICK STATUS INDICATORS CAPSULE ---
    RowLayout {
        id: statusIndicatorsRow
        anchors { left: leftTrigger.right; leftMargin: 12; verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 24 }
        spacing: 8

        // Capsule-style status pills for Wi-Fi, Bluetooth, Audio Volume, Power Profile
        // Each is a clickable/interactive pill with spring physics

        StatusPill {
            text: "Wi-Fi"
            icon: "wifi"
            // Connection status visualization
        }

        StatusPill {
            text: "Bluetooth"
            icon: "bluetooth"
        }

        StatusPill {
            text: "Audio"
            icon: "volume-high"
            // Volume level indicator
        }

        StatusPill {
            text: "Power"
            icon: "power"
            // Power profile indicator
        }
    }

    // --- QUICK SESSION ACTION MENU ---
    PopupMenu {
        id: sessionActionMenu
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 8 }
        // Pop-up triggers for Lock, Sleep, Reboot, Shutdown
        // Triggered via click on session action icon in sidebar
    }

    // --- DYNAMIC POSITION ENGINE ---
    // Supports 4 orientations: "top", "bottom", "left", "right"
    // Auto-morphing layouts between RowLayout and ColumnLayout

    function toggleVisibility() {
        visible = !visible
        // Animate position shift based on new visibility state
    }

    function repositionBar(newPosition) {
        barPosition = newPosition
        // Re-layout based on new position
        // If "top" or "bottom" -> RowLayout
        // If "left" or "right" -> ColumnLayout
    }
}

// --- STATUS PILL COMPONENT ---
StatusPill {
    property string text
    property string icon
    property real pillRadius: 20
    property color background: leftSidebar.surfaceContainerBase
    property color textColor: leftSidebar.textSecondary
    property bool isActive: false

    // Pill-shaped background with glassmorphism
    RoundedRectangle {
        id: pillBg
        anchors.centerIn: parent
        width: 48
        height: 32
        radius: leftSidebar.cornerRadius
        color: background
        // subtle shadow/glow
        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }
    }

    // Text label
    Label {
        anchors { verticalCenter: pillBg.verticalCenter; horizontalCenter: pillBg.horizontalCenter }
        text: pillar.text
        color: textColor
        font.pixelSize: 11
        font.weight: Font.Medium
    }

    // Icon source
    Label {
        anchors { verticalCenter: pillBg.verticalCenter; horizontalCenter: pillBg.horizontalCenter }
        // Would use appropriate icon font or SVG
        text: "●"  // Placeholder
        color: textColor
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Toggle respective feature
            console.log("Status pill clicked: " + pillar.text)
        }
    }
}