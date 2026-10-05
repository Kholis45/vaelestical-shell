import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// MODULE F2: Pro gaming & audio overlay — HUD, profil GPU, EQ/DSP,
// Dante, update AUR, meter jaringan, purge shader.
// Kontrak: token Theme, aksi via Theme.exec/execSync, tanpa anchor ke parent.
Item {
    id: root
    width: 560
    height: 600

    property bool hudOn: false
    property string gpuProfile: "Balanced"
    property string eqPreset: "Flat"
    property string aurText: "…"
    property string netText: "mengukur…"
    property string danteText: "mengukur…"
    property string danteTarget: "192.168.1.50"

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.leftMargin: 2
        radius: Theme.cardRadius
        color: Theme.shadow
    }
    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 3
        anchors.rightMargin: 2
        radius: Theme.cardRadius
        color: Theme.surface
        border.color: Theme.outlineVariant
        border.width: 1
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 14
        clip: true
        ColumnLayout {
            width: root.width - 28
            spacing: 10

            Text { text: "Pro Gaming & Audio"; color: Theme.onSurface; font: Theme.titleMedium }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    Text { text: "FPS HUD (MangoHud)"; color: Theme.onSurface; font: Theme.titleSmall; Layout.fillWidth: true }
                    Switch {
                        checked: root.hudOn
                        onToggled: {
                            root.hudOn = checked
                            Theme.exec("sh", ["-c", checked ? "mkdir -p ~/.cache/vxvicfg && echo MANGOHUD=1 > ~/.cache/vxvicfg/hud" : "rm -f ~/.cache/vxvicfg/hud; pkill -f mangohud 2>/dev/null; true"])
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Text { text: "Profil GPU & kipas"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Repeater {
                            model: ["Quiet", "Balanced", "Extreme"]
                            delegate: Button {
                                required property var modelData
                                text: modelData
                                font: Theme.labelMedium
                                Layout.fillWidth: true
                                highlighted: root.gpuProfile === modelData
                                onClicked: {
                                    root.gpuProfile = modelData
                                    Theme.exec("sh", ["-c", "supergfxctl -m " + (modelData === "Quiet" ? "Integrated" : modelData === "Extreme" ? "Vfio" : "Hybrid") + " 2>/dev/null; true"])
                                }
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Kipas"; color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.preferredWidth: 44 }
                        Slider {
                            id: fanSlider
                            Layout.fillWidth: true
                            from: 20; to: 100; value: 46
                            // Terapkan saat dilepas (best-effort via nvidia-settings).
                            onPressedChanged: {
                                if (!pressed && Theme.hasBin("nvidia-settings"))
                                    Theme.exec("nvidia-settings", ["-a", "[gpu:0]/GPUFanControlState=1", "-a", "[fan:0]/GPUTargetFanSpeed=" + Math.round(value)])
                            }
                        }
                        Text { text: Math.round(fanSlider.value) + "%"; color: Theme.onSurface; font: Theme.labelMedium; Layout.preferredWidth: 42 }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Text { text: "PipeWire EQ / DSP"; color: Theme.onSurface; font: Theme.titleSmall }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Repeater {
                            model: ["Flat", "Sub-Bass", "Horeg Live", "Vocals"]
                            delegate: Button {
                                required property var modelData
                                text: modelData
                                font: Theme.labelMedium
                                Layout.fillWidth: true
                                highlighted: root.eqPreset === modelData
                                onClicked: {
                                    root.eqPreset = modelData
                                    Theme.exec("sh", ["-c", "easyeffects -l " + JSON.stringify(modelData) + " 2>/dev/null; true"])
                                }
                            }
                        }
                    }
                    Text { text: "Dante: " + root.danteText; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                    Text { text: "Bufer 4 ms • target " + root.danteTarget; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                radius: Theme.cardRadius
                color: Theme.surfaceContainer
                border.color: Theme.outlineVariant
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Text { text: "Sistem"; color: Theme.onSurface; font: Theme.titleSmall }
                    Text { text: "AUR: " + root.aurText; color: Theme.onSurface; font: Theme.bodyMedium }
                    Text { text: "Net: " + root.netText; color: Theme.onSurfaceVariant; font: Theme.bodySmall; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    Text { id: contText; text: "Containers/VM: —"; color: Theme.onSurfaceVariant; font: Theme.bodySmall; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    RowLayout {
                        Layout.fillWidth: true
                        Button { text: "Upgrade AUR"; font: Theme.labelMedium; onClicked: Theme.exec("sh", ["-c", "kitty yay -Syu &"]) }
                        Button {
                            text: "Purge shader"
                            font: Theme.labelMedium
                            onClicked: Theme.exec("sh", ["-c", "rm -rf ~/.cache/mesa_shader_cache ~/.cache/vkd3d 2>/dev/null; true"])
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!Theme.hasSys())
                return
            // Lewati probe yang binernya tak ada (tanpa spawn sia-sia).
            if (Theme.hasBin("checkupdates")) {
                var a = Theme.execSync("sh", ["-c", "checkupdates 2>/dev/null | wc -l"])
                if (a !== "")
                    root.aurText = a.trim() + " paket"
            }
            if (Theme.hasBin("ping")) {
                var n = Theme.execSync("sh", ["-c", "ping -c1 -W1 1.1.1.1 2>/dev/null | grep time="])
                if (n !== "")
                    root.netText = n.trim()
            }
            // Monitor rute Dante: latensi + loss nyata ke target via ping.
            if (Theme.hasBin("ping")) {
                var dp = Theme.execSync("sh", ["-c", "ping -c3 -W1 " + root.danteTarget + " 2>/dev/null | grep -E 'packet loss|rtt'"])
                if (dp !== "") {
                    var loss = dp.match(/([0-9]+)% packet loss/)
                    var rtt = dp.match(/=\s*[0-9.]+\/([0-9.]+)\//)
                    if (loss)
                        root.danteText = (rtt ? rtt[1] + " ms" : "?") + " • loss " + loss[1] + "%"
                } else {
                    root.danteText = "target tak terjangkau"
                }
            }
            var c = ""
            if (Theme.hasBin("podman"))
                c += Theme.execSync("sh", ["-c", "podman ps --format '{{.Names}} ({{.Status}})' 2>/dev/null | head -3"])
            if (Theme.hasBin("virsh")) {
                var v = Theme.execSync("sh", ["-c", "virsh list --name 2>/dev/null | head -3"])
                if (v !== "")
                    c += (c !== "" ? "\n" : "") + v.trim()
            }
            contText.text = "Containers/VM: " + (c !== "" ? c.split("\n").join(" • ") : "—")
        }
    }
}
