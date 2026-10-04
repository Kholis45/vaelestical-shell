// M3ExpressiveBorder.frag — ring aksen anti-aliased + glow luar lembut.
// Dipakai sebagai overlay transparan di atas kartu/cover (tengah kosong).
// Uniform di-bind otomatis dari properti QML ber-nama sama:
//   accent (color), res (vector2d px), radius/width/glow (real).
uniform lowp float qt_Opacity;
uniform lowp vec4 accent;
uniform highp vec2 res;
uniform highp float radius;
uniform highp float borderWidth;
uniform highp float glow;
varying highp vec2 qt_TexCoord0;

float roundedBox(highp vec2 p, highp vec2 b, highp float r) {
    highp vec2 q = abs(p) - b + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

void main() {
    highp vec2 p = (qt_TexCoord0 - 0.5) * res;
    highp vec2 b = res * 0.5;
    highp float d = roundedBox(p, b, radius);

    // Pita ring tepat di tepi (d ≈ 0), tepi dilembutkan 1.5px.
    highp float w = max(borderWidth, 1.0);
    highp float ring = 1.0 - smoothstep(w - 1.5, w, abs(d));

    // Glow hanya di LUAR bentuk (d > 0), meluruh ~30px.
    highp float g = 0.0;
    if (d > 0.0)
        g = (1.0 - smoothstep(0.0, 30.0, d)) * glow;

    highp float a = clamp(ring * 0.9 + g * 0.5, 0.0, 1.0);
    gl_FragColor = vec4(accent.rgb, a * accent.a) * qt_Opacity;
}
