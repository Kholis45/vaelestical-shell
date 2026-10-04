.pragma library

// Formatters.js — format data telemetri/UI di luar QML.
// Murni + stateless (.pragma library): aman dipanggil dari binding apa pun,
// tidak pernah throw — input rusak menghasilkan string fallback.

function pad2(n) {
    n = Math.floor(Math.abs(Number(n)));
    if (isNaN(n))
        return "00";
    return (n < 10 ? "0" : "") + n;
}

function formatClock(d) {
    if (!(d instanceof Date))
        d = new Date();
    return pad2(d.getHours()) + ":" + pad2(d.getMinutes());
}

function formatClockSeconds(d) {
    if (!(d instanceof Date))
        d = new Date();
    return formatClock(d) + ":" + pad2(d.getSeconds());
}

function formatBytes(bytes) {
    var b = Number(bytes);
    if (isNaN(b) || b < 0)
        return "—";
    var units = ["B", "KB", "MB", "GB", "TB"];
    var i = 0;
    while (b >= 1024 && i < units.length - 1) {
        b /= 1024;
        i++;
    }
    return (i === 0 ? Math.round(b) : b.toFixed(1)) + " " + units[i];
}

function formatDuration(totalMinutes) {
    var m = Math.floor(Number(totalMinutes));
    if (isNaN(m) || m < 0)
        return "—";
    var d = Math.floor(m / 1440);
    var h = Math.floor((m % 1440) / 60);
    var mm = m % 60;
    if (d > 0)
        return d + "d " + h + "h";
    if (h > 0)
        return h + "h " + pad2(mm) + "m";
    return mm + "m";
}

function formatTemp(celsius) {
    var c = Number(celsius);
    if (isNaN(c))
        return "—";
    return Math.round(c) + "°C";
}

function formatPing(ms) {
    var v = Number(ms);
    if (isNaN(v) || v < 0)
        return "—";
    if (v < 1)
        return "<1 ms";
    return Math.round(v) + " ms";
}

function formatPercent(v) {
    var x = Number(v);
    if (isNaN(x))
        return "—";
    return Math.round(x) + "%";
}

function formatUptime(bootSeconds) {
    var s = Math.floor(Number(bootSeconds));
    if (isNaN(s) || s < 0)
        return "—";
    return formatDuration(Math.floor(s / 60));
}
