.pragma library

// ColorUtils.js — blending Material You + konversi HEX/RGB.
// Murni + stateless: input rusak → fallback aman, tidak pernah throw.

function isHex(s) {
    return /^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/.test(s || "");
}

function normalizeHex(s, fallback) {
    if (isHex(s))
        return s.length === 9 ? s : s + "ff";
    return fallback || "#a8c7faff";
}

function hexToRgb(hex) {
    var h = normalizeHex(hex, null);
    if (!h)
        return null;
    return {
        r: parseInt(h.slice(1, 3), 16),
        g: parseInt(h.slice(3, 5), 16),
        b: parseInt(h.slice(5, 7), 16),
        a: h.length === 9 ? parseInt(h.slice(7, 9), 16) / 255 : 1
    };
}

function rgbToHex(r, g, b) {
    function c(v) {
        v = Math.max(0, Math.min(255, Math.round(Number(v))));
        if (isNaN(v))
            v = 0;
        var s = v.toString(16);
        return s.length === 1 ? "0" + s : s;
    }
    return "#" + c(r) + c(g) + c(b);
}

function clamp01(t) {
    t = Number(t);
    if (isNaN(t))
        return 0;
    return Math.max(0, Math.min(1, t));
}

// Blend dua warna HEX: t=0 → h1, t=1 → h2.
function mix(h1, h2, t) {
    var a = hexToRgb(h1) || { r: 168, g: 199, b: 250 };
    var b = hexToRgb(h2) || { r: 56, g: 70, b: 97 };
    t = clamp01(t);
    return rgbToHex(
        a.r + (b.r - a.r) * t,
        a.g + (b.g - a.g) * t,
        a.b + (b.b - a.b) * t
    );
}

function withAlpha(hex, alpha) {
    var c = hexToRgb(hex);
    if (!c)
        return "#a8c7fa";
    var a = Math.max(0, Math.min(255, Math.round(clamp01(alpha) * 255)));
    var s = a.toString(16);
    return rgbToHex(c.r, c.g, c.b) + (s.length === 1 ? "0" + s : s);
}

// Luminansi relatif 0..1 (WCAG).
function luminance(hex) {
    var c = hexToRgb(hex);
    if (!c)
        return 0;
    function lin(v) {
        v /= 255;
        return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
    }
    return 0.2126 * lin(c.r) + 0.7152 * lin(c.g) + 0.0722 * lin(c.b);
}

// Warna teks kontras (hitam/putih) untuk latar hex.
function contrastOn(hex) {
    return luminance(hex) > 0.45 ? "#1a1c22" : "#e3e2e6";
}
