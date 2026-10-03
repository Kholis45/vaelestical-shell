import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts 6.0

// ============================================================
// MODULE D: HARDWARE CONTROL CENTER & AUDIO ROUTING
//================================================================
// Network Switcher, Bluetooth Manager, DND Toggle
// Feral GameMode Switch, Flight Mode & Night Light
// PipeWire Audio Route Switcher, Master Volume & Backlight Sliders
// Per-App Volume Mixer, Audio Sink Hot-Swapping Widget
// Integrated Game Launcher & Power Grid
// VPN & OBS Recording Status Indicators
//================================================================

// Control Center Root
ControlCenterRoot {
    id: controlCenterRoot
}

// --- NETWORK SWITCHER ---
// Toggle and select Wi-Fi access points (nmcli)
NetworkSwitcher {
    id: networkSwitcher
    // Wi-Fi access point list scanning
    // Connect/disconnect functionality
    // Visual SSID indicators
}

// --- BLUETOOTH MANAGER ---
// Controller power and device connection panel (bluetoothctl)
BluetoothManager {
    id: bluetoothManager
    // Device discovery
    // Pairing/unpairing
    // Connection status display
}

// --- DO NOT DISTURB TOGGLE ---
// System-wide pop-up notification muting
DNDToggle {
    id: dndToggle
    // Global DND mode
    // Exceptions management
    // Visual indicator
}

// --- FERAL GAMEMODE SWITCH ---
// High-performance CPU/GPU allocation trigger (gamemoded -t)
GameModeSwitch {
    id: gameModeSwitch
    // Quick toggles: Quiet, Balanced, Extreme
    // GPU profile switching
    // Performance mode activation
}

// --- FLIGHT MODE & NIGHT LIGHT SWITCHES ---
// Airplane mode and display blue-light filter toggles
FlightModeNightLight {
    id: flightModeNightLight
    // Airplane mode toggle
    // Night light / blue-light filter
    // Color temperature adjustment
}

// --- PIPEWIRE AUDIO ROUTE SWITCHER ---
// Dropdown for instant hot-swapping (Laptop Speakers, Headphones/DAC, Dante Network Audio)
AudioRouteSwitcher {
    id: audioRouteSwitcher
    // Available sinks/outputs list
    // One-click primary audio sink toggle
    // Hot-swapping functionality
}

// --- MASTER VOLUME & BACKLIGHT SLIDERS ---
// Precision control over wpctl and brightnessctl
VolumeBacklightSliders {
    id: volumeBacklightSliders
    // Master volume slider (wpctl)
    // Display backlight slider (brightnessctl)
    // Value displays
}

// --- PER-APP VOLUME MIXER ---
// Individual volume control sliders for active running applications
PerAppVolumeMixer {
    id: perAppVolumeMixer
    // Lists running applications
    // Individual volume sliders per app
    // Priority/ mute per app
}

// --- AUDIO SINK HOT-SWAPPING WIDGET ---
// One-click primary audio sink toggle
AudioSinkToggle {
    id: audioSinkToggle
    // Primary sink selection
    // Quick switch UI
}

// --- INTEGRATED GAME LAUNCHER & POWER GRID ---
// Shortcuts for Steam, Prism Launcher, Heroic, Discord, and Power actions
GameLauncherPowerGrid {
    id: gameLauncherGrid
    // Game launcher icons: Steam, Prism, Heroic
    // Power actions: Sleep, Restart, Shutdown
    // VPN/OBS status indicators
}

// --- VPN & OBS RECORDING STATUS INDICATORS ---
// Active VPN tunnel readout and glowing recording dot indicator
VPNObsIndicators {
    id: vpnObsIndicators
    // VPN tunnel status display
    // Recording dot indicator with glow effect
    // Connection speed meter
}