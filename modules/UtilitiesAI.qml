import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts 6.0

// ============================================================
// MODULE E: UTILITIES, AI & SYSTEM EXTENSIONS
//================================================================
// Searchable Clipboard History Flyout
// Minimalist Search & App Launcher
// Floating Notification Toast Banner
// Transient On-Screen Display (OSD) Pills
// Local LLM / Ollama Quick Prompt Flyout
// Smart Contextual Keybindings / Hotkeys Handler
// Terminal Pywal / Matugen Color Harmonization
// Media Playback History Log
// Hyprland Window Layout Switcher
// Screenshots & Screen Recording Tool
// Quick Notes & Scratchpad Sticky Widget
// System Resource Monitor Detailed History Graph
// Dynamic Weather Background Animations
// Custom Avatar & Profile Banner Header
// Real-time Glassmorphic Blur & Noise Slider
// Native DBus System Tray (StatusNotifierItem)
// Safety Power Confirmation Modal
//================================================================

// Utilities & AI Root
UtilsAIRoot {
    id: utilsAiroot
}

// --- 31. SEARCHABLE CLIPBOARD HISTORY FLYOUT ---
ClipboardHistoryFlyout {
    id: clipboardHistory
    // Stack view clipboard manager (wl-clipboard / cliphist)
    // Searchable, with item preview
    // Spring-slide-in physics
}

// --- 32. MINIMALIST SEARCH & APP LAUNCHER ---
SearchAppLauncher {
    id: searchLauncher
    // Floating search bar for applications, terminal commands, math calculations
    // As-you-type filtering
    // Enter to execute, Super+K shortcut
}

// --- 33. FLOATING NOTIFICATION TOAST BANNER ---
ToastBanner {
    id: toastBanner
    // Top-right notification cards driven by DBus events
    // Spring slide-in physics (x: from width to 0 over 300ms)
    // Auto-dismiss after 5 seconds
}

// --- 34. TRANSIENT OSD PILLS ---
OSDPills {
    id: osdPills
    // Center-screen pills for Volume, Brightness, Caps Lock, Num Lock, Input Layouts
    // Transient - fade out after action
    // Spring-based appearance/dismissal
}

// --- 35. LOCAL LLM / OLLAMA QUICK PROMPT FLYOUT ---
LLMPromptFlyout {
    id: llmPrompt
    // Floating prompt input bar for local AI models (Ollama/LM Studio)
    // Send prompt, show response preview
    // Model selection dropdown
}

// --- 36. SMART CONTEXTUAL KEYBINDINGS / HOTKEYS HANDLER ---
HotkeyHandler {
    id: hotkeyHandler
    // Global hotkey shortcuts
    // Super+D for Dashboard
    // Super+W for Wallpaper Switcher
    // Super+T for Terminal
    // Super+L for Lock
    // Customizable keymap
}

// --- 37. TERMINAL PYWAL / MATUGEN COLOR HARMONIZATION ---
TerminalColorSync {
    id: terminalSync
    // Script execution engine syncing active terminal themes
    // Supports Kitty, Alacritty, Foot
    // Executes pywal/Matugen on wallpaper change
}

// --- 38. MEDIA PLAYBACK HISTORY LOG ---
MediaHistoryLog {
    id: mediaHistory
    // Scrollable log of recently played tracks
    // Metadata: artist, album, title
    // Click to replay or add to playlist
}

// --- 39. HYprland WINDOW LAYOUT SWITCHER ---
WindowLayoutSwitcher {
    id: layoutSwitcher
    // On-the-fly switching between Dwindle, Master, Floating layouts
    // Hotkey trigger (Super+Shift+F1/F2 etc.)
    // Preview of current layout
}

// --- 40. SCREENSHOTS & SCREEN RECORDING TOOL ---
ScreenshotRecorder {
    id: screenshotTool
    // Floating trigger for area/fullscreen captures
    // wl-screenrec / OBS recording integration
    // Thumbnail preview, save to clipboard
}

// --- 41. QUICK NOTES & SCRATCHPAD STICKY WIDGET ---
ScratchpadWidget {
    id: scratchpad
    // Floating auto-saving scratchpad for quick command/text notes
    // Persistent across sessions (localStorage or file)
    // Drag to reposition, close button
}

// --- 42. SYSTEM RESOURCE MONITOR HISTORY GRAPH ---
ResourceHistoryGraph {
    id: resourceGraph
    // Historical resource utilization graph showing CPU/GPU/RAM spikes
    // Scrollable history, zoomable
    // Can toggle between CPU, GPU, RAM views
}

// --- 43. DYNAMIC WEATHER BACKGROUND ANIMATIONS ---
WeatherParticles {
    id: weatherParticles
    // Subtle ambient weather particle overlays (rain, snow, clouds)
    // Inside the Dashboard, optional toggle
    // Controlled by weather data integration
}

// --- 44. CUSTOM AVATAR & PROFILE BANNER HEADER ---
ProfileBanner {
    id: profileBanner
    // Customizable profile identity banner ("PRIVATE EASTJAVA" / @kholis)
//    // Color schemes, avatar, tagline
//    // Display in Dashboard header, Settings About section
}

// --- 45. REAL-TIME GLASSMORPHIC BLUR & NOISE SLIDER ---
BlurNoiseSlider {
    id: blurNoiseCtrl
    // Live adjustment sliders for background blur intensity and frosted glass noise
//    // Blur: 0-20px, Noise: 0-100%    // Updates all glassmorphic backgrounds in real-time
}

// --- 46. NATIVE DBUS SYSTEM TRAY (STATUSNOTIFIERITEM) ---
SystemTray {
    id: systemTray
    // Collapsible tray container for background applications
    // Discord, Steam, OBS, Telegram, NetworkManager
    // Right-click menu with show/hide options
}

// --- 47. SAFETY POWER CONFIRMATION MODAL ---
PowerConfirmationModal {
    id: powerModal
    // Floating overlay with 10-second auto-countdown timer
    // Before Shutdown/Reboot execution
    // Cancel button resets timer, Confirm executes action
    // Visual countdown display
}