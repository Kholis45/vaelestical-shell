"""Vaelestical Shell REV 2.0 - Rich UI preview generator.
Caelestia x Material You Expressive, Cyberpunk glassmorphism.
Output: ui_preview.png (1920x1080)
"""
import os
import math
import random
from PIL import Image, ImageDraw, ImageFont, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "ui_preview.png")

W, H = 1920, 1080
random.seed(7)

# ---------- palette ----------
BG = (13, 14, 21)
BG_TOP = (19, 20, 32)
CYAN = (0, 242, 254)
VIOLET = (127, 0, 255)
VIOLET_LT = (167, 139, 250)
PINK = (240, 120, 210)
TEAL = (45, 212, 191)
GREEN = (52, 211, 153)
AMBER = (251, 191, 36)
ORANGE = (251, 146, 60)
CARD_FILL = (21, 23, 35, 218)
CARD_FILL2 = (26, 28, 43, 225)
CARD_BORDER = (255, 255, 255, 34)
TRACK = (48, 51, 72)
TXT1 = (237, 238, 244)
TXT2 = (148, 152, 170)
TXT3 = (102, 106, 128)

# ---------- canvas ----------
base = Image.new("RGBA", (W, H), BG + (255,))
d_bg = ImageDraw.Draw(base)
# vertical gradient
for y in range(H):
    t = y / max(1, H - 1)
    r = int(BG_TOP[0] + (BG[0] - BG_TOP[0]) * t)
    g = int(BG_TOP[1] + (BG[1] - BG_TOP[1]) * t)
    b = int(BG_TOP[2] + (BG[2] - BG_TOP[2]) * t)
    d_bg.line([(0, y), (W, y)], fill=(r, g, b, 255))

# ambient neon washes
wash = Image.new("RGBA", (W, H), (0, 0, 0, 0))
wd = ImageDraw.Draw(wash)
wd.ellipse([-320, -260, 700, 520], fill=(127, 0, 255, 58))
wd.ellipse([1250, -320, 2150, 560], fill=(0, 242, 254, 44))
wd.ellipse([420, 700, 1500, 1350], fill=(127, 0, 255, 38))
wd.ellipse([-200, 650, 500, 1250], fill=(0, 242, 254, 26))
wash = wash.filter(ImageFilter.GaussianBlur(110))
base.alpha_composite(wash)

# faint grid dots (Material You texture)
dot_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
dd = ImageDraw.Draw(dot_layer)
for x in range(0, W, 48):
    for y in range(0, H, 48):
        dd.ellipse([x, y, x + 2, y + 2], fill=(255, 255, 255, 10))
base.alpha_composite(dot_layer)

d = ImageDraw.Draw(base)

# ---------- fonts ----------
def font(size, bold=False):
    cands = []
    if bold:
        cands = [
            r"C:\Windows\Fonts\segoeuib.ttf",
            r"C:\Windows\Fonts\arialbd.ttf",
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        ]
    else:
        cands = [
            r"C:\Windows\Fonts\segoeui.ttf",
            r"C:\Windows\Fonts\arial.ttf",
            "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        ]
    for p in cands:
        if os.path.exists(p):
            try:
                return ImageFont.truetype(p, size)
            except Exception:
                continue
    try:
        return ImageFont.load_default(size=size)
    except Exception:
        return ImageFont.load_default()

F11 = font(11); F12 = font(12); F13 = font(13); F14 = font(14)
F15 = font(15); F16 = font(16); F18 = font(18); F20 = font(20)
F22 = font(22); F24 = font(24); F28 = font(28); F34 = font(34)
F11B = font(11, True); F13B = font(13, True); F14B = font(14, True)
F15B = font(15, True); F16B = font(16, True); F18B = font(18, True)
F20B = font(20, True); F24B = font(24, True); F28B = font(28, True)
F44B = font(44, True); F64B = font(64, True); F96B = font(96, True)
F30B = font(30, True)

def lerp(a, b, t):
    return (int(a[0]+(b[0]-a[0])*t), int(a[1]+(b[1]-a[1])*t), int(a[2]+(b[2]-a[2])*t))

def glow_rect(box, radius, color, alpha=60, blur=26, expand=10):
    gl = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(gl)
    e = [box[0]-expand, box[1]-expand, box[2]+expand, box[3]+expand]
    gd.rounded_rectangle(e, radius+expand, fill=color+(alpha,))
    gl = gl.filter(ImageFilter.GaussianBlur(blur))
    base.alpha_composite(gl)

def glow_dot(cx, cy, r, color, alpha=90, blur=18):
    gl = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(gl)
    gd.ellipse([cx-r, cy-r, cx+r, cy+r], fill=color+(alpha,))
    gl = gl.filter(ImageFilter.GaussianBlur(blur))
    base.alpha_composite(gl)

def glass(box, radius=18, fill=CARD_FILL, border=CARD_BORDER, glow=None, glow_alpha=42):
    if glow is not None:
        glow_rect(box, radius, glow, alpha=glow_alpha, blur=28, expand=12)
    # drop shadow
    sh = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    sd = ImageDraw.Draw(sh)
    sd.rounded_rectangle([box[0], box[1]+10, box[2], box[3]+10], radius, fill=(0, 0, 0, 110))
    sh = sh.filter(ImageFilter.GaussianBlur(18))
    base.alpha_composite(sh)
    d.rounded_rectangle(box, radius, fill=fill, outline=border, width=2)
    # top highlight
    d.line([(box[0]+radius, box[1]+2), (box[2]-radius, box[1]+2)], fill=(255, 255, 255, 40), width=2)
    # bottom inner shade
    d.line([(box[0]+radius, box[3]-2), (box[2]-radius, box[3]-2)], fill=(0, 0, 0, 50), width=1)

def inner_card(box, radius=14, fill=(16, 18, 29, 220)):
    d.rounded_rectangle(box, radius, fill=fill, outline=(255, 255, 255, 20), width=1)

def pill(box, fill, border, text="", fnt=F14B, tcol=TXT1, anchor_center=None):
    d.rounded_rectangle(box, (box[3]-box[1])//2, fill=fill, outline=border, width=2)
    if text and anchor_center:
        d.text(anchor_center, text, font=fnt, fill=tcol, anchor="mm")

# ================================================================
# LEFT BAR - floating pill sidebar
# ================================================================
SB = [20, 140, 96, 940]
glass(SB, radius=38, fill=CARD_FILL2, glow=CYAN, glow_alpha=22)
# logo dot top
glow_dot(58, 182, 20, VIOLET, 90, 16)
d.ellipse([38, 162, 78, 202], fill=(32, 33, 52), outline=(150, 140, 255, 160), width=2)
d.text((58, 182), "V", font=F18B, fill=(200, 190, 255), anchor="mm")

ws_y = [262, 334, 406, 478]
for i, y in enumerate(ws_y, start=1):
    if i == 1:
        glow_dot(58, y, 24, CYAN, 95, 14)
        d.ellipse([34, y-24, 82, y+24], fill=CYAN, outline=(200, 255, 255, 200), width=2)
        d.text((58, y), str(i), font=F16B, fill=(8, 20, 24), anchor="mm")
    else:
        d.ellipse([36, y-22, 80, y+22], fill=(34, 36, 52, 255), outline=(80, 83, 105, 180), width=2)
        d.text((58, y), str(i), font=F14B, fill=TXT2, anchor="mm")

# divider
d.line([(40, 522), (76, 522)], fill=(70, 73, 95, 200), width=2)
# quick settings (sliders icon)
glow_dot(58, 572, 22, VIOLET, 70, 14)
d.ellipse([36, 550, 80, 594], fill=(36, 34, 58), outline=VIOLET_LT+(170,), width=2)
for yy, kx in [(563, 52), (572, 64), (581, 50)]:
    d.line([(44, yy), (72, yy)], fill=(200, 200, 215), width=2)
    d.ellipse([kx-4, yy-4, kx+4, yy+4], fill=VIOLET_LT)
# app drawer 3x3
d.ellipse([36, 612, 80, 656], fill=(34, 36, 52, 255), outline=(80, 83, 105, 180), width=2)
for r in range(3):
    for c in range(3):
        x = 50 + c * 8
        y = 624 + r * 8
        d.ellipse([x-2, y-2, x+2, y+2], fill=(190, 192, 205))
d.line([(40, 676), (76, 676)], fill=(70, 73, 95, 200), width=2)
# power
d.ellipse([36, 696, 80, 740], fill=(46, 28, 34), outline=(255, 130, 130, 150), width=2)
d.arc([48, 706, 68, 728], start=300, end=240, fill=(255, 150, 150), width=2)
d.line([(58, 704), (58, 716)], fill=(255, 150, 150), width=2)
# breathing pulse dot
glow_dot(58, 880, 12, GREEN, 100, 12)
d.ellipse([52, 874, 64, 886], fill=GREEN, outline=(220, 255, 235), width=1)
d.text((58, 908), "60", font=F11, fill=TXT3, anchor="mm")

# ================================================================
# TOP BAR - Dynamic Island
# ================================================================
ISL = [650, 18, 1270, 88]
glass(ISL, radius=35, fill=(24, 26, 40, 235), border=(255, 255, 255, 44), glow=CYAN, glow_alpha=30)
# album art
AA = [664, 28, 712, 76]
glow_rect(AA, 12, VIOLET, alpha=70, blur=12, expand=4)
# art gradient
art = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
ad = ImageDraw.Draw(art)
for yy in range(48):
    t = yy / 47
    ad.line([(0, yy), (48, yy)], fill=lerp(VIOLET, CYAN, t)+(255,))
ad.ellipse([14, 14, 34, 34], fill=(12, 13, 22, 255))
ad.ellipse([20, 20, 28, 28], fill=(240, 240, 245, 255))
base.paste(art, (664, 28), art)
d.rounded_rectangle(AA, 12, outline=(255, 255, 255, 60), width=1)
# song texts
d.text((724, 36), "ODESZA - Falls", font=F16B, fill=TXT1, anchor="lm")
d.text((724, 58), "In Return  •  Flume Remix", font=F12, fill=TXT2, anchor="lm")
# mini eq next to text
for i in range(4):
    h = [10, 16, 8, 13][i]
    x = 880 + i * 7
    d.rounded_rectangle([x, 62 - h, x + 4, 62], 2, fill=CYAN if i % 2 == 0 else VIOLET_LT)
# progress mini
d.rounded_rectangle([724, 68, 900, 72], 2, fill=(52, 55, 78))
d.rounded_rectangle([724, 68, 792, 72], 2, fill=CYAN)
# time pill
d.rounded_rectangle([1010, 30, 1096, 76], 23, fill=(40, 42, 60), outline=(255, 255, 255, 30), width=1)
glow_dot(1028, 53, 6, CYAN, 90, 6)
d.ellipse([1024, 49, 1032, 57], fill=CYAN)
d.text((1062, 53), "10:30", font=F14B, fill=TXT1, anchor="mm")
# battery pill
d.rounded_rectangle([1104, 30, 1256, 76], 23, fill=(40, 42, 60), outline=(255, 255, 255, 30), width=1)
# battery outline
d.rounded_rectangle([1116, 44, 1152, 62], 5, outline=(230, 232, 240), width=2)
d.rounded_rectangle([1119, 47, 1119 + int(30 * 0.85), 59], 3, fill=CYAN)
d.line([(1154, 48), (1154, 58)], fill=(230, 232, 240), width=3)
d.text((1192, 53), "85%", font=F14B, fill=TXT1, anchor="mm")

# top-right small pills (updates / net / temp) - slim, right aligned
def top_pill(x0, label, val, accent):
    x1 = x0 + 190
    d.rounded_rectangle([x0, 28, x1, 68], 20, fill=(22, 24, 36, 220), outline=(255, 255, 255, 26), width=1)
    glow_dot(x0 + 26, 48, 8, accent, 70, 8)
    d.ellipse([x0+20, 42, x0+32, 54], fill=accent)
    d.text((x0+42, 48), label, font=F13B, fill=TXT1, anchor="lm")
    d.text((x0+42+d.textlength(label, font=F13B)+8, 48), val, font=F12, fill=TXT2, anchor="lm")
    return x1 + 12

xx = 1310
xx = top_pill(xx, "12", "Updates", AMBER)
xx = top_pill(xx, "1.2", "MB/s down", CYAN)
top_pill(xx, "62°C", "CPU PKG", VIOLET_LT)

# top-left profile pill
d.rounded_rectangle([120, 18, 430, 88], 35, fill=(22, 24, 36, 220), outline=(255, 255, 255, 28), width=1)
glow_dot(156, 53, 20, CYAN, 60, 12)
av = Image.new("RGBA", (48, 48), (0, 0, 0, 0))
avd = ImageDraw.Draw(av)
for yy in range(48):
    avd.line([(0, yy), (48, yy)], fill=lerp(VIOLET, CYAN, yy / 47)+(255,))
avd.ellipse([16, 10, 32, 26], fill=(245, 245, 250))
avd.ellipse([10, 28, 38, 50], fill=(245, 245, 250))
mask = Image.new("L", (48, 48), 0)
ImageDraw.Draw(mask).ellipse([0, 0, 47, 47], fill=255)
base.paste(av, (132, 29), mask)
d.text((190, 42), "PRIVATE EASTJAVA", font=F14B, fill=TXT1, anchor="lm")
d.text((190, 62), "@kholis  •  VAELESTICAL OS", font=F12, fill=TXT2, anchor="lm")
# search pill
d.rounded_rectangle([442, 18, 638, 88], 35, fill=(18, 20, 30, 210), outline=(255, 255, 255, 22), width=1)
d.ellipse([458-9, 53-9, 458+9, 53+9], outline=TXT3, width=2)
d.line([(465, 60), (472, 67)], fill=TXT3, width=2)
d.text((482, 53), "Search  Super+K", font=F13, fill=TXT3, anchor="lm")

# ================================================================
# ROW 1 - Clock / Media / System
# ================================================================
CLOCK = [120, 120, 640, 390]
MEDIA = [660, 120, 1400, 390]
SYS = [1420, 120, 1900, 390]
glass(CLOCK, glow=VIOLET, glow_alpha=30)
glass(MEDIA, glow=CYAN, glow_alpha=26)
glass(SYS, glow=VIOLET, glow_alpha=24)

# ---- Clock widget ----
d.text((148, 142), "●  LOCAL TIME", font=F12, fill=CYAN, anchor="lm")
d.text((148, 250), "10:30", font=F96B, fill=TXT1, anchor="lm")
w10 = d.textlength("10:30", font=F96B)
d.text((148 + w10 + 12, 232), "AM", font=F30B, fill=VIOLET_LT, anchor="lm")
d.text((150, 300), "Sabtu, 17 Mei 2026  •  Kepanjen", font=F16, fill=TXT2, anchor="lm")
# chips
d.rounded_rectangle([148, 326, 330, 362], 18, fill=(22, 52, 62), outline=CYAN+(120,), width=1)
d.text((239, 344), "Hyprland  •  Wayland", font=F12, fill=CYAN, anchor="mm")
d.rounded_rectangle([340, 326, 452, 362], 18, fill=(46, 34, 72), outline=VIOLET_LT+(120,), width=1)
d.text((396, 344), "●  60 FPS", font=F12, fill=VIOLET_LT, anchor="mm")
# decorative orb
glow_dot(548, 242, 46, VIOLET, 80, 22)
orb = Image.new("RGBA", (110, 110), (0, 0, 0, 0))
od = ImageDraw.Draw(orb)
for yy in range(110):
    od.line([(0, yy), (110, yy)], fill=lerp(VIOLET, CYAN, yy / 109)+(255,))
m = Image.new("L", (110, 110), 0)
ImageDraw.Draw(m).ellipse([0, 0, 109, 109], fill=255)
orb.putalpha(m)
base.paste(orb, (493, 187), orb)
d.ellipse([510, 210, 536, 236], fill=(40, 20, 90, 200))
d.ellipse([560, 270, 576, 286], fill=(20, 90, 110, 200))
d.ellipse([483, 177, 613, 307], outline=CYAN+(70,), width=1)
glow_dot(496, 196, 7, CYAN, 90, 6)
d.ellipse([492, 192, 500, 200], fill=CYAN)
d.rounded_rectangle([528, 146, 612, 172], 13, fill=(22, 52, 62), outline=CYAN+(140,), width=1)
d.text((570, 159), "REV 2.0", font=F11B, fill=CYAN, anchor="mm")

# ---- Media + equalizer ----
d.text((688, 142), "●  NOW PLAYING", font=F12, fill=PINK, anchor="lm")
d.rounded_rectangle([1150, 136, 1372, 164], 14, fill=(26, 54, 46), outline=GREEN+(110,), width=1)
glow_dot(1168, 150, 5, GREEN, 80, 5)
d.ellipse([1163, 145, 1173, 155], fill=GREEN)
d.text((1270, 150), "PIPEWIRE • DSP LIVE", font=F11B, fill=GREEN, anchor="mm")
# album big
ALB = [688, 178, 828, 318]
glow_rect(ALB, 18, VIOLET, 60, 16, 4)
alb = Image.new("RGBA", (140, 140), (0, 0, 0, 0))
abd = ImageDraw.Draw(alb)
for yy in range(140):
    abd.line([(0, yy), (140, yy)], fill=lerp(VIOLET, CYAN, yy / 139)+(255,))
for r in (52, 44, 36):
    abd.ellipse([70-r, 70-r, 70+r, 70+r], outline=(10, 12, 22, 90), width=2)
abd.ellipse([56, 56, 84, 84], fill=(12, 13, 22))
abd.ellipse([66, 66, 74, 74], fill=(240, 240, 245))
mm = Image.new("L", (140, 140), 0)
ImageDraw.Draw(mm).rounded_rectangle([0, 0, 139, 139], 18, fill=255)
alb.putalpha(mm)
base.paste(alb, (688, 178), alb)
d.rounded_rectangle(ALB, 18, outline=(255, 255, 255, 50), width=1)
# texts
d.text((848, 188), "Falls", font=F28B, fill=TXT1, anchor="lm")
d.text((848, 218), "ODESZA  •  In Return (2014)", font=F14, fill=TXT2, anchor="lm")
# transport
d.text((848, 252), "SHUF", font=F11, fill=TXT3, anchor="lm")
d.polygon([(900, 244), (900, 262), (884, 253)], fill=TXT1)
d.line([(880, 244), (880, 262)], fill=TXT1, width=2)
glow_dot(964, 253, 26, CYAN, 90, 12)
d.ellipse([938, 227, 990, 279], fill=CYAN, outline=(220, 255, 255), width=2)
d.polygon([(956, 240), (956, 266), (976, 253)], fill=(8, 20, 24))
d.polygon([(1010, 244), (1010, 262), (1026, 253)], fill=TXT1)
d.line([(1030, 244), (1030, 262)], fill=TXT1, width=2)
d.text((1052, 253), "REPT", font=F11, fill=TXT3, anchor="lm")
# progress
d.rounded_rectangle([848, 286, 1372, 292], 3, fill=TRACK)
d.rounded_rectangle([848, 286, 848 + int(524 * 0.38), 292], 3, fill=CYAN)
glow_dot(848 + int(524 * 0.38), 289, 8, CYAN, 80, 6)
d.ellipse([848+int(524*0.38)-6, 283, 848+int(524*0.38)+6, 295], fill=(255, 255, 255))
d.text((848, 304), "1:12", font=F12, fill=TXT3, anchor="lm")
d.text((1372, 304), "4:19", font=F12, fill=TXT3, anchor="rm")
# equalizer waveform
EQ_Y = 368
EQ_X0, EQ_N, EQ_P, EQ_W = 688, 48, 15, 9
for i in range(EQ_N):
    v = abs(math.sin(i * 0.55)) * (0.55 + 0.45 * math.sin(i * 0.23 + 1.2))
    v = min(1.0, v * 1.1 + random.random() * 0.08)
    h = 10 + int(34 * v)
    col = lerp(CYAN, VIOLET, i / max(1, EQ_N - 1))
    x = EQ_X0 + i * EQ_P
    glow_dot(x + EQ_W // 2, EQ_Y - h // 2, 8, col, 28, 6)
    d.rounded_rectangle([x, EQ_Y - h, x + EQ_W, EQ_Y], 4, fill=col)
    # reflection
    d.rounded_rectangle([x, EQ_Y + 3, x + EQ_W, EQ_Y + 3 + int(h * 0.28)], 3, fill=col + (46,))

# ---- System info ----
d.text((1448, 142), "●  SYSTEM INFO", font=F12, fill=VIOLET_LT, anchor="lm")
rows = [
    (CYAN, "CachyOS", "Rolling  •  x86_64"),
    (VIOLET_LT, "Kernel 6.6.15-1", "cachyos-lts"),
    (PINK, "Hyprland 0.42", "Wayland  •  144Hz"),
]
yy = 184
for col, a, b in rows:
    glow_dot(1466, yy, 8, col, 70, 6)
    d.ellipse([1460, yy-6, 1472, yy+6], fill=col)
    d.text((1486, yy-2), a, font=F15B, fill=TXT1, anchor="lm")
    d.text((1486, yy+18), b, font=F12, fill=TXT2, anchor="lm")
    yy += 56
# ram bar
d.rounded_rectangle([1448, 340-14, 1872, 340+32], 12, fill=(16, 18, 29, 220), outline=(255, 255, 255, 20), width=1)
d.text((1462, 340), "RAM  8.4 / 16 GB", font=F12, fill=TXT2, anchor="lm")
d.rounded_rectangle([1462, 356, 1858, 362], 3, fill=TRACK)
# gradient fill bar
bar = Image.new("RGBA", (208, 6), (0, 0, 0, 0))
bd = ImageDraw.Draw(bar)
for x in range(208):
    bd.line([(x, 0), (x, 6)], fill=lerp(CYAN, VIOLET, x / 207)+(255,))
bmask = Image.new("L", (208, 6), 0)
ImageDraw.Draw(bmask).rounded_rectangle([0, 0, 207, 5], 3, fill=255)
bar.putalpha(bmask)
base.paste(bar, (1462, 356), bar)

# ================================================================
# ROW 2 - Weather / Performance / Sensors
# ================================================================
WEA = [120, 410, 640, 670]
PERF = [660, 410, 1400, 670]
SENS = [1420, 410, 1900, 670]
glass(WEA, glow=AMBER, glow_alpha=20)
glass(PERF, glow=CYAN, glow_alpha=26)
glass(SENS, glow=VIOLET, glow_alpha=22)

# ---- Weather ----
d.text((148, 432), "●  KEPANJEN - EAST JAVA", font=F12, fill=CYAN, anchor="lm")
# sun
glow_dot(206, 516, 30, AMBER, 80, 16)
d.ellipse([184, 494, 228, 538], fill=AMBER, outline=(255, 230, 160), width=2)
for a in range(0, 360, 30):
    r1, r2 = 30, 38
    x1 = 206 + int(r1 * math.cos(math.radians(a))); y1 = 516 + int(r1 * math.sin(math.radians(a)))
    x2 = 206 + int(r2 * math.cos(math.radians(a))); y2 = 516 + int(r2 * math.sin(math.radians(a)))
    d.line([(x1, y1), (x2, y2)], fill=AMBER, width=2)
# cloud
d.ellipse([176, 538, 214, 566], fill=(225, 228, 238))
d.ellipse([198, 530, 240, 564], fill=(232, 235, 244))
d.ellipse([222, 540, 256, 566], fill=(218, 221, 232))
d.rounded_rectangle([176, 554, 256, 570], 8, fill=(225, 228, 238))
d.text((286, 522), "28°", font=F64B, fill=TXT1, anchor="lm")
d.text((286+d.textlength("28°", font=F64B)+6, 530), "C", font=F24B, fill=TXT2, anchor="lm")
d.text((288, 572), "Berawan  •  H:30°  L:24°", font=F14, fill=TXT2, anchor="lm")
# right details
for (lab, val, y) in [("Humidity", "78%", 486), ("Wind", "12 km/h", 518), ("Tekanan", "1010 hPa", 550)]:
    d.text((560, y), lab, font=F13, fill=TXT3, anchor="rm")
    d.text((572, y), val, font=F14B, fill=TXT1, anchor="lm")
d.rounded_rectangle([420, 600, 612, 644], 22, fill=(26, 54, 46), outline=GREEN+(130,), width=1)
glow_dot(448, 622, 8, GREEN, 70, 6)
d.ellipse([442, 616, 454, 628], fill=GREEN)
d.text((528, 622), "AQI 42 - Baik", font=F14B, fill=GREEN, anchor="mm")
# hourly strip
hours = [("Skr", "28°", True), ("11", "29°", False), ("12", "30°", False), ("13", "29°", False)]
x = 148
for h_, t_, on in hours:
    box = [x, 600, x + 62, 644]
    if on:
        d.rounded_rectangle(box, 12, fill=(24, 58, 68), outline=CYAN+(110,), width=1)
    else:
        d.rounded_rectangle(box, 12, fill=(36, 38, 54), outline=(90, 93, 115), width=1)
    d.text((x+31, 614), h_, font=F11, fill=TXT2, anchor="mm")
    d.text((x+31, 630), t_, font=F13B, fill=TXT1, anchor="mm")
    x += 70

# ---- Performance gauges ----
d.text((688, 432), "●  PERFORMANCE MONITOR", font=F12, fill=CYAN, anchor="lm")
d.rounded_rectangle([1170, 426, 1372, 452], 13, fill=(38, 40, 58), outline=(90, 93, 115), width=1)
d.text((1271, 439), "i7  •  GTX 750 Ti", font=F11B, fill=TXT2, anchor="mm")

def gauge(cx, cy, r, pct, col, big, small, label):
    bbox = [cx-r, cy-r, cx+r, cy+r]
    d.arc(bbox, 0, 360, fill=TRACK, width=14)
    # glow arc
    gl = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(gl)
    gd.arc(bbox, -90, -90 + pct * 3.6, fill=col+(70,), width=24)
    gl = gl.filter(ImageFilter.GaussianBlur(10))
    base.alpha_composite(gl)
    d.arc(bbox, -90, -90 + pct * 3.6, fill=col, width=14)
    ang = math.radians(-90 + pct * 3.6)
    tx = cx + r * math.cos(ang); ty = cy + r * math.sin(ang)
    glow_dot(tx, ty, 9, col, 85, 8)
    d.ellipse([tx-5, ty-5, tx+5, ty+5], fill=(255, 255, 255))
    d.text((cx, cy-6), big, font=F28B, fill=TXT1, anchor="mm")
    d.text((cx, cy+22), small, font=F13, fill=TXT2, anchor="mm")
    d.text((cx, cy+r+26), label, font=F14B, fill=TXT1, anchor="mm")

gauge(830, 540, 74, 42, CYAN, "42%", "62°C", "Core i7")
gauge(1030, 540, 74, 55, VIOLET_LT, "55%", "58°C", "GTX 750 Ti")
gauge(1230, 540, 74, 53, PINK, "53%", "41°C", "RAM 8.4GB")
# history sparkline
pts_c, pts_g = [], []
for i in range(64):
    t = i / 63
    vc = 42 + 14*math.sin(t*20) + 6*math.sin(t*47+2)
    vg = 55 + 12*math.sin(t*16+0.8) + 5*math.sin(t*43)
    pts_c.append((700 + t * 660, 648 - vc * 0.42))
    pts_g.append((700 + t * 660, 648 - vg * 0.42))
for gy in (620, 634, 648):
    d.line([(700, gy), (1360, gy)], fill=(52, 55, 78), width=1)
d.line(pts_g, fill=VIOLET_LT+(200,), width=2, joint="curve")
d.line(pts_c, fill=CYAN+(220,), width=2, joint="curve")
glow_dot(*pts_c[-1], 7, CYAN, 80, 6)
glow_dot(*pts_g[-1], 7, VIOLET_LT, 80, 6)
d.ellipse([pts_c[-1][0]-4, pts_c[-1][1]-4, pts_c[-1][0]+4, pts_c[-1][1]+4], fill=CYAN)
d.ellipse([pts_g[-1][0]-4, pts_g[-1][1]-4, pts_g[-1][0]+4, pts_g[-1][1]+4], fill=VIOLET_LT)

# ---- Sensors ----
d.text((1448, 432), "●  SENSORS", font=F12, fill=CYAN, anchor="lm")
sens = [("CPU PKG", "62°C", 0.62, CYAN), ("GPU HOT", "58°C", 0.58, VIOLET_LT),
        ("VRAM", "1.1 / 2GB", 0.55, PINK), ("KIPAS", "1820 RPM", 0.46, TEAL)]
y = 476
for lab, val, p, col in sens:
    d.text((1462, y), lab, font=F12, fill=TXT3, anchor="lm")
    d.text((1858, y), val, font=F13B, fill=TXT1, anchor="rm")
    d.rounded_rectangle([1462, y+20, 1858, y+26], 3, fill=TRACK)
    d.rounded_rectangle([1462, y+20, 1462+int(396*p), y+26], 3, fill=col)
    y += 52
# net mini
inner_card([1448, 620-8, 1872, 620+34])
d.text((1462, 628), "▼ 1.2 MB/s   ▲ 340 KB/s   •   Dante Standby", font=F12, fill=TXT2, anchor="lm")
glow_dot(1850, 628, 6, GREEN, 80, 5)
d.ellipse([1846, 624, 1854, 632], fill=GREEN)

# ================================================================
# CONTROL CENTER
# ================================================================
CC = [120, 690, 1900, 1010]
glass(CC, glow=CYAN, glow_alpha=20)
d.text((148, 714), "●  CONTROL CENTER", font=F12, fill=GREEN, anchor="lm")
d.text((1872, 714), "PIPEWIRE ROUTE: SPEAKERS  •  DANTE STANDBY", font=F11, fill=TXT3, anchor="rm")

toggles = [
    ("W", "Wi-Fi", "Terhubung • 5GHz", CYAN, True),
    ("B", "Bluetooth", "2 Perangkat", VIOLET_LT, True),
    ("D", "PipeWire DSP", "Live Sound • ON", TEAL, True),
    ("G", "GameMode", "Performance", PINK, True),
]
tx = 148
TW = 405
for (ic, title, sub, col, on) in toggles:
    box = [tx, 740, tx + TW, 852]
    if on:
        glow_rect(box, 28, col, alpha=42, blur=20, expand=6)
        d.rounded_rectangle(box, 28, fill=(20, 22, 36, 235), outline=col+(170,), width=2)
        d.rounded_rectangle([box[0]+2, box[1]+2, box[2]-2, box[1]+34], 26, fill=col+(26,))
    else:
        d.rounded_rectangle(box, 28, fill=(24, 26, 38, 220), outline=(90, 93, 115, 140), width=2)
    # icon circle
    glow_dot(box[0]+56, 796, 22, col, 70, 10)
    d.ellipse([box[0]+28, 768, box[0]+84, 824], fill=col, outline=(255, 255, 255, 160), width=2)
    d.text((box[0]+56, 796), ic, font=F18B, fill=(10, 16, 20), anchor="mm")
    d.text((box[0]+100, 788), title, font=F16B, fill=TXT1, anchor="lm")
    d.text((box[0]+100, 810), sub, font=F12, fill=lerp(col, (255,255,255), 0.35) if on else TXT3, anchor="lm")
    # status dot
    d.ellipse([box[2]-28, 788, box[2]-16, 800], fill=col if on else (90, 93, 115))
    tx += TW + 20

# sliders
def slider(box, label, pct, col, ic):
    inner_card(box, 24, fill=(17, 19, 30, 225))
    d.ellipse([box[0]+22, 906, box[0]+66, 950], fill=(36, 38, 54), outline=col+(140,), width=2)
    d.text(((box[0]+22+box[0]+66)//2, 928), ic, font=F15B, fill=col, anchor="mm")
    d.text((box[0]+78, 908), label, font=F12, fill=TXT3, anchor="lm")
    tr = [box[0]+78, 928, box[2]-76, 936]
    d.rounded_rectangle(tr, 4, fill=TRACK)
    fw = int((tr[2]-tr[0]) * pct)
    # gradient fill
    fimg = Image.new("RGBA", (max(1, fw), 8), (0, 0, 0, 0))
    fd = ImageDraw.Draw(fimg)
    for x in range(max(1, fw)):
        fd.line([(x, 0), (x, 8)], fill=lerp(col, (255, 255, 255), x / max(1, fw) * 0.25)+(255,))
    fmask = Image.new("L", (max(1, fw), 8), 0)
    ImageDraw.Draw(fmask).rounded_rectangle([0, 0, max(1, fw)-1, 7], 4, fill=255)
    fimg.putalpha(fmask)
    base.paste(fimg, (tr[0], tr[1]), fimg)
    kx = tr[0] + fw
    glow_dot(kx, 932, 10, col, 80, 8)
    d.ellipse([kx-9, 923, kx+9, 941], fill=(255, 255, 255), outline=col, width=2)
    d.text((box[2]-30, 928), f"{int(pct*100)}%", font=F14B, fill=TXT1, anchor="mm")

slider([148, 872, 1008, 982], "VOLUME • PipeWire", 0.78, CYAN, "V")
slider([1028, 872, 1872, 982], "BRIGHTNESS", 0.65, AMBER, "S")

# footer hint
d.text((960, 1032), "Super+D Dashboard   •   Super+W Wallpaper   •   Super+M Media   •   VAELESTICAL SHELL REV 2.0", font=F12, fill=TXT3, anchor="mm")

base.convert("RGB").save(OUT, "PNG")
print("SUCCESS: ui_preview.png overwritten (1920x1080 Caelestia rich mockup)")
