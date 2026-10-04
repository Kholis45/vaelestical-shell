// SpectrumWave.frag — visualizer gelombang audio prosedural (GPU).
// Tiga lapis sinus bertumpuk; amplitudo mengikuti uniform `energy` (0..1)
// yang dihaluskan di QML via MathHelpers.springStep. Tanpa tekstur.
// Uniform di-bind otomatis: time/energy (real), accent/base (color).
uniform lowp float qt_Opacity;
uniform highp float time;
uniform highp float energy;
uniform lowp vec4 accent;
uniform lowp vec4 base;
varying highp vec2 qt_TexCoord0;

void main() {
    highp vec2 uv = qt_TexCoord0;
    highp float x = uv.x;
    highp float e = clamp(energy, 0.0, 1.0);

    highp float y = 0.5
        + sin(x * 9.0 + time * 2.1) * 0.10 * (0.35 + e)
        + sin(x * 17.0 - time * 3.2) * 0.06 * (0.35 + e)
        + sin(x * 31.0 + time * 4.7) * 0.03 * e;

    highp float d = abs(uv.y - y);
    highp float line = 1.0 - smoothstep(0.0, 0.035, d);
    highp float glow = (1.0 - smoothstep(0.0, 0.22, d)) * 0.45;
    highp float fill = (1.0 - smoothstep(y - 0.25, y + 0.015, uv.y)) * 0.30;

    highp float m = clamp(line + glow + fill, 0.0, 1.0);
    lowp vec3 col = mix(base.rgb, accent.rgb, m);
    gl_FragColor = vec4(col, 1.0) * qt_Opacity;
}
