.pragma library

// MathHelpers.js — interpolasi fisika pegas + kurva bezier untuk UI.
// Murni + stateless: semua fungsi numerik aman (NaN → fallback).

function clamp(v, lo, hi) {
    v = Number(v);
    if (isNaN(v))
        return lo;
    return Math.max(lo, Math.min(hi, v));
}

function lerp(a, b, t) {
    a = Number(a);
    b = Number(b);
    t = Number(t);
    if (isNaN(a) || isNaN(b) || isNaN(t))
        return 0;
    return a + (b - a) * t;
}

function smoothstep(e0, e1, x) {
    e0 = Number(e0);
    e1 = Number(e1);
    x = Number(x);
    if (isNaN(e0) || isNaN(e1) || isNaN(x) || e0 === e1)
        return 0;
    var t = clamp((x - e0) / (e1 - e0), 0, 1);
    return t * t * (3 - 2 * t);
}

// Satu langkah pegas redam (semi-implicit Euler, stabil untuk dt kecil).
// stiffness ~ pegas, damping ~ redaman. Kembali {value, velocity}.
function springStep(current, target, velocity, stiffness, damping, dt) {
    current = Number(current);
    target = Number(target);
    velocity = Number(velocity) || 0;
    stiffness = Number(stiffness) || 90;
    damping = Number(damping) || 12;
    dt = Math.min(Math.max(Number(dt) || 0.016, 0.001), 0.05);
    if (isNaN(current) || isNaN(target))
        return { value: 0, velocity: 0 };
    var accel = (target - current) * stiffness - velocity * damping;
    velocity += accel * dt;
    current += velocity * dt;
    return { value: current, velocity: velocity };
}

// Kurva bezier kubik 1D (untuk easing kustom): p0..p3 titik kontrol.
function bezier(p0, p1, p2, p3, t) {
    t = clamp(t, 0, 1);
    var u = 1 - t;
    return u * u * u * p0 + 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t * p3;
}

// Fase gelombang berjalan 0..2π untuk visualizer (t detik, speed Hz).
function wavePhase(t, speed) {
    t = Number(t) || 0;
    speed = Number(speed) || 1;
    return (t * speed * 2 * Math.PI) % (2 * Math.PI);
}
