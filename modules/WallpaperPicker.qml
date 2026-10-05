import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

// MODULE C: Wallpaper picker + Material You engine (M3E penuh).
Item {
    id: root
    property color accent: Theme.accent
    property int currentIndex: 0
    property var swatches: [Theme.accent, Theme.primary, Theme.secondary, Theme.tertiary, "#fbbf24", "#f078d2"]

    width: 620
    height: 300

    function loadDefaultWallpaper() { root.currentIndex = 0; root.accent = root.swatches[0] }
    function setWallpaper(i) {
        root.currentIndex = i
        root.accent = root.swatches[i % root.swatches.length]
        // Terapkan ke sistem bila backend ada; demo bila tidak (tanpa warning).
        Theme.exec("sh", ["-c", "swww img ~/Pictures/Wallpapers/current 2>/dev/null || swaybg -i ~/Pictures/Wallpapers/current 2>/dev/null; matugen image ~/Pictures/Wallpapers/current --mode " + (Theme.dark ? "dark" : "light") + " 2>/dev/null; true"])
    }
    function extractAccentColor(i) { root.setWallpaper(i) }

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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Wallpaper & Material You"; color: Theme.onSurface; font: Theme.titleSmall }
            Item { Layout.fillWidth: true }
            Text { text: "Aksen:"; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
            Rectangle { width: 22; height: 22; radius: Theme.pillRadius; color: root.accent;
                border.color: Theme.onSurface; border.width: 1 }
            Switch {
                text: "Gelap"
                font: Theme.labelMedium
                checked: Theme.dark
                onToggled: Theme.dark = checked
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            orientation: ListView.Horizontal
            spacing: 10
            clip: true
            model: root.swatches
            delegate: Rectangle {
                required property var modelData
                required property int index
                property bool active: root.currentIndex === index
                width: 150; height: 110; radius: Theme.cardRadius
                color: modelData
                border.color: active ? Theme.onSurface : Theme.outlineVariant
                border.width: active ? 3 : 1
                scale: active ? 1.04 : 1.0
                Behavior on scale {
                    NumberAnimation { duration: Theme.motionShort4; easing.type: Easing.Bezier; easing.bezierCurve: Theme.emphasized }
                }
                Text { anchors.centerIn: parent; text: "W" + (index + 1); color: Theme.scrim; font: Theme.titleMedium }
                MouseArea {
                    id: thumbMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.setWallpaper(index)
                }
                StateLayer { anchors.fill: parent; cornerRadius: Theme.cardRadius; hoverSource: thumbMa }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Switch { id: videoSw; text: "Video wallpaper"; font: Theme.labelMedium }
            Text { text: videoSw.checked ? "Aktif — auto-pause saat fullscreen" : "Nonaktif (mpvpaper/swww)";
                color: Theme.onSurfaceVariant; font: Theme.labelMedium; Layout.fillWidth: true }
            Button { text: "Pilih file…"; font: Theme.labelSmall; onClicked: fileDlg.open() }
            Button { text: "Sync cursor+ikon"; font: Theme.labelSmall;
                onClicked: {
                    Theme.exec("sh", ["-c", "matugen image ~/Pictures/Wallpapers/current --mode " + (Theme.dark ? "dark" : "light") + " 2>/dev/null; true"])
                    syncText.text = "Sync matugen dikirim."
                } }
        }
        Text { id: syncText; text: ""; color: Theme.onSurfaceVariant; font: Theme.labelMedium }
    }

    FileDialog {
        id: fileDlg
        title: "Pilih wallpaper"
        nameFilters: ["Images (*.jpg *.png *.webp)", "Videos (*.mp4)"]
        onAccepted: root.applyWallpaper(String(selectedFile).replace(/^file:\/\//, ""))
    }

    // Sampling gambar tersembunyi untuk ekstraksi aksen (tidak dirender).
    Image {
        id: extractorImg
        width: 48; height: 48
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        visible: false
        onStatusChanged: {
            if (status === Image.Ready)
                sampler.requestPaint()
        }
    }
    Canvas {
        id: sampler
        width: 32; height: 32
        visible: false
        renderTarget: Canvas.Image
        onPaint: {
            var ctx = getContext("2d")
            ctx.drawImage(extractorImg, 0, 0, width, height)
            var px = ctx.getImageData(0, 0, width, height).data
            var hist = {}
            for (var i = 0; i < px.length; i += 16) {
                var r = px[i] & 0xF0, g = px[i + 1] & 0xF0, b = px[i + 2] & 0xF0
                if (Math.abs(r - g) < 16 && Math.abs(g - b) < 16)
                    continue
                var k = (r << 16) | (g << 8) | b
                hist[k] = (hist[k] || 0) + 1
            }
            var best = -1, bc = 0
            for (var key in hist) {
                if (hist[key] > bc) {
                    bc = hist[key]
                    best = key
                }
            }
            if (best >= 0) {
                var hex = "#" + ("000000" + best.toString(16)).slice(-6)
                root.accent = hex
                syncText.text = "Aksen diekstrak: " + hex
            }
        }
    }

    // Ekstraksi aksen asli dari file wallpaper (no-op tanpa backend).
    function extractFromFile(path) {
        if (path === "" || !Theme.hasSys())
            return
        extractorImg.source = "file://" + path
    }

    function applyWallpaper(path) {
        if (path === "")
            return
        if (path.endsWith(".mp4"))
            Theme.exec("sh", ["-c", "pkill mpvpaper 2>/dev/null; mpvpaper -o 'no-audio loop' '*' " + JSON.stringify(path) + " & pkill swww-daemon 2>/dev/null; true"])
        else {
            Theme.exec("sh", ["-c", "pkill mpvpaper 2>/dev/null; (swww img " + JSON.stringify(path) + " --transition-type grow 2>/dev/null || swaybg -i " + JSON.stringify(path) + " &); matugen image " + JSON.stringify(path) + " 2>/dev/null; true"])
            root.extractFromFile(path)
        }
    }
}
