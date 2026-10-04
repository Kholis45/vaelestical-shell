"""Regression check: properti/uniform ShaderEffect tidak boleh menimpa
member Item/QML yang sudah ada (kasus: `property real width` menimpa
FINAL Item.width -> load gagal total, booth engine).

Aturan: di dalam blok `ShaderEffect { ... }`, deklarasi
`property <type> <nama>:` dengan <nama> anggota reserved -> FAIL.
Uniform GLSL di shaders/*.frag dengan nama yang sama -> FAIL
(uniform tak akan bisa di-bind dari properti QML senama).

Jalankan:  python tests/check_shader_conventions.py   (exit 0 = lolos)
"""
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Member Item/ShaderEffect yang tidak boleh dideklarasikan ulang.
# x/y/width/height bersifat FINAL (load error); sisanya menimpa perilaku
# (opacity/visible/enabled/scale/...) atau properti ShaderEffect sendiri.
RESERVED = {
    "x", "y", "z", "width", "height", "opacity", "visible", "enabled",
    "scale", "rotation", "anchors", "children", "parent", "data",
    "fragmentShader", "vertexShader", "blending", "cullMode", "status",
    "mesh", "supportsAtlasTextures", "log",
}

PROP_RE = re.compile(r"^\s*(?:readonly\s+)?property\s+\S+\s+([A-Za-z_]\w*)\s*:")
UNIFORM_RE = re.compile(r"^\s*uniform\s+\S+\s+([A-Za-z_]\w*)\s*;")
SCAN_DIRS = ("modules", "components", "services")
SHADER_DIR = "shaders"

results = []


def check(name, cond, detail=""):
    results.append(bool(cond))
    print(("PASS " if cond else "FAIL "), name, detail)


def shader_blocks(text):
    """Yield isi blok setiap `ShaderEffect { ... }` (brace-counted)."""
    out = []
    for m in re.finditer(r"ShaderEffect\s*\{", text):
        depth = 0
        i = m.end() - 1
        while i < len(text):
            if text[i] == "{":
                depth += 1
            elif text[i] == "}":
                depth -= 1
                if depth == 0:
                    out.append(text[m.end():i])
                    break
            i += 1
    return out


def main():
    qml_files = []
    for d in SCAN_DIRS:
        root = os.path.join(REPO, d)
        if not os.path.isdir(root):
            continue
        for base, _dirs, files in os.walk(root):
            for f in files:
                if f.endswith(".qml"):
                    qml_files.append(os.path.join(base, f))

    bad = 0
    for path in sorted(qml_files):
        try:
            with open(path, encoding="utf-8") as fh:
                text = fh.read()
        except OSError:
            continue
        for block in shader_blocks(text):
            for line in block.splitlines():
                pm = PROP_RE.match(line)
                if pm and pm.group(1) in RESERVED:
                    print(f"FAIL  {os.path.relpath(path, REPO)}: "
                          f"properti '{pm.group(1)}' menimpa member reserved")
                    bad += 1
    check("QML ShaderEffect tanpa properti reserved", bad == 0, f"({bad} temuan)")

    frag_dir = os.path.join(REPO, SHADER_DIR)
    bad_u = 0
    if os.path.isdir(frag_dir):
        for f in sorted(os.listdir(frag_dir)):
            if not f.endswith(".frag"):
                continue
            with open(os.path.join(frag_dir, f), encoding="utf-8") as fh:
                for line in fh:
                    um = UNIFORM_RE.match(line)
                    if um and um.group(1) in RESERVED:
                        print(f"FAIL  {SHADER_DIR}/{f}: "
                              f"uniform '{um.group(1)}' tak bisa di-bind")
                        bad_u += 1
    check("GLSL tanpa uniform reserved", bad_u == 0, f"({bad_u} temuan)")

    ok = all(results)
    print("SHADER-CONV:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
