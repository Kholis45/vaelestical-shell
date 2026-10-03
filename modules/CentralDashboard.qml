import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts 6.0

// ============================================================
// MODULE B: TOP CENTRAL MULTI-TAB DASHBOARD & DYNAMIC ISLAND
//================================================================
// Dynamic Island Morphing Pill
// Multi-Tab Navigation Bar: [Dashboard] [Media] [Performance] [Workspaces]
// Tab 1 - Live Weather & Info Module
// Tab 1 - Interactive Calendar & Clock
// Tab 2 - Extended Media Suite (MPRIS, Lyrics, Volume Boost, Spectrum)
// Tab 3 - Telemetry Dashboard (CPU/GPU/VRAM/RAM gauges)
// Tab 4 - Visual Workspace Overview
//================================================================

// Central Dashboard Root
DashboardRoot {
    id: dashboardRoot
}

// --- DYNAMIC ISLAND MORPHING PILL ---
// Central floating bar expanding on hover, MPRIS track change, or notification event
DynamicIslandPill {
    id: dynamicIsland
    anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 24 }
    // Expands on hover or when media changes/notification arrives
    // Morphs between compact and expanded state
}

// --- MULTI-TAB NAVIGATION BAR ---
// Top-pinned selectors: [Dashboard] [Media] [Performance] [Workspaces]
TabNavigationBar {
    id: tabNavigation
    anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 8 }
    // Tab buttons with spring-based feedback
    // Clicking switches dashboard tabs

    // Tab definitions
    Repeater {
        model: 4  // Dashboard, Media, Performance, Workspaces
        delegate: TabButton {
            text: model.data
            // Spring-based press feedback
            Behavior on pressed {
                NumberAnimation { duration: 150; easing.type: Easing.OutBack }
            }
            onClicked: {
                dashboardRoot.currentTab = model.index
                // Update dynamic island state based on tab
            }
        }
    }
}

// --- TAB 1: LIVE WEATHER & INFO MODULE ---
// Location-aware Weather mini-widget, AQI index, System Stat Badge (Distro, Kernel, Uptime)
TabContentArea {
    id: tab1Area
    text: "Dashboard"
    // Background with glassmorphism
    // Weather widget integration
    // Calendar & Clock
    // System Stat Badge
}

// Sub-module: Interactive Calendar & Clock
CalendarClockArea {
    anchors.fill: tab1Area
    // Full interactive monthly calendar grid
    // Large Material You Digital Clock
}

// Sub-module: System Stat Badge
SystemStatBadge {
    // Distro name, Kernel uname -r, Uptime display
    // Styled as compact badge with spring physics
}

// --- TAB 2: EXTENDED MEDIA SUITE ---
// MPRIS player with album art, Marquee text, progress scrubber, Volume Boost (150%),
// Spectrum Audio Visualizer, Synced Lyrics Engine
MediaSuiteArea {
    anchors.fill: tab1Area
    // MPRIS player integration via playerctl
    // Album art display with asynchronous loading
    // Progress scrubber
    // Volume Boost switch
    // Spectrum Audio Visualizer (GPU-accelerated)
    // Synced Lyrics Engine (.lrc file parsing or API)
}

// --- TAB 3: TELEMETRY DASHBOARD ---
// Circular gauge progress bars for:
// CPU Load %, Multi-GPU Load % (NVIDIA/AMD/iGPU/VMware),
// VRAM, RAM, and Temperatures (°C)
TelemetryDashboard {
    anchors.fill: tab1Area
    // Circular progress gauges
    // GPU load from detected hardware
    // Temperature readings
    // RAM and VRAM usage bars
}

// --- TAB 4: VISUAL WORKSPACE OVERVIEW ---
// Live window preview grid for Hyprland workspace management
WorkspaceOverview {
    anchors.fill: tab1Area
    // Grid of window previews
    // Workspace switching integration
    // Drag-and-drop reordering
}

// --- TAB NAVIGATION INTERACTION ---
// When tab changes, dynamic island updates its state
// and content area morphs accordingly
onTabChanged: {
    switch (currentTab) {
        case 0: // Dashboard
            dynamicIsland.setState("compact")
            break
        case 1: // Media
            dynamicIsland.setState("media")
            break
        case 2: // Performance
            dynamicIsland.setState("telemetry")
            break
        case 3: // Workspaces
            dynamicIsland.setState("overview")
            break
    }
}