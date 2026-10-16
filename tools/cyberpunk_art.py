#!/usr/bin/env python3
"""The cyberpunk dressing for Silico's streets: neon signs, holographic ads,
big screens, steam vents, cables, transit tubes, hover cars, wet asphalt and
puddles, plus the radial light texture the street lights use. Writes into
assets/props (+ props.json) and appends tiles to assets/tiles (+ atlas.json).
Run before gen_maps.py. Everything is drawn here with Pillow; re-run to tweak."""
import json
import math
import os
import random
from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
PROPS_DIR = os.path.join(ROOT, "assets", "props")
TILES_DIR = os.path.join(ROOT, "assets", "tiles")
UI_DIR = os.path.join(ROOT, "assets", "ui")
T = 32

TEAL = (127, 224, 192)
MAGENTA = (232, 72, 180)
PINK = (255, 110, 150)
CYAN = (90, 220, 255)
AMBER = (245, 190, 90)
BLUE = (90, 140, 255)
GREEN = (120, 240, 140)
RED = (224, 69, 58)
PANEL = (16, 14, 22)
OUT = (6, 6, 10)


def glow(img, color, radius=4, strength=0.7):
    """Adds a soft glow around every opaque pixel of `img` (RGBA)."""
    a = img.split()[3].filter(ImageFilter.GaussianBlur(radius))
    layer = Image.new("RGBA", img.size, color + (0,))
    layer.putalpha(a.point(lambda v: int(v * strength)))
    return Image.alpha_composite(layer, img)


def new(w, h):
    return Image.new("RGBA", (w, h), (0, 0, 0, 0))


def save_prop(img, name, solid=0, registry=None):
    img.save(os.path.join(PROPS_DIR, name + ".png"))
    registry[name] = {"w": img.width, "h": img.height, "solid": solid}


def panel(d, box, fill=PANEL, outline=OUT):
    d.rectangle(box, fill=fill, outline=outline)


# ------------------------------------------------------------------ neon signs
def neon_sign(kind, color, registry):
    im = new(64, 32)
    d = ImageDraw.Draw(im)
    panel(d, (2, 4, 61, 29))
    # mounting bracket
    d.rectangle((30, 0, 33, 4), fill=(40, 40, 48))
    # the glowing shape
    g = new(64, 32)
    gd = ImageDraw.Draw(g)
    c = color + (255,)
    if kind == "psyon":        # the eye
        gd.ellipse((14, 9, 49, 25), outline=c, width=2)
        gd.ellipse((26, 12, 37, 23), outline=c, width=2)
        gd.ellipse((30, 16, 33, 19), fill=c)
    elif kind == "nixtra":     # a flame and a bar
        gd.polygon([(24, 25), (32, 8), (40, 25), (32, 19)], outline=c, fill=None)
        gd.line((24, 25, 40, 25), fill=c, width=2)
        gd.line((12, 15, 20, 15), fill=c, width=2); gd.line((44, 15, 52, 15), fill=c, width=2)
    elif kind == "tokz":       # a play triangle in a ring
        gd.ellipse((18, 7, 45, 27), outline=c, width=2)
        gd.polygon([(27, 11), (27, 23), (38, 17)], fill=c)
        gd.line((8, 10, 14, 10), fill=c, width=2); gd.line((49, 24, 55, 24), fill=c, width=2)
    elif kind == "alto":       # a bolt
        gd.polygon([(34, 6), (24, 18), (31, 18), (28, 28), (40, 15), (33, 15)], fill=c)
        gd.line((8, 26, 20, 26), fill=c, width=2); gd.line((44, 8, 56, 8), fill=c, width=2)
    elif kind == "voltx":      # a wave
        pts = [(8 + i * 3, 17 + int(7 * math.sin(i * 0.9))) for i in range(16)]
        gd.line(pts, fill=c, width=2)
        gd.rectangle((52, 10, 56, 24), outline=c, width=2)
    elif kind == "freud":      # a round face with closed eyes
        gd.ellipse((20, 6, 44, 28), outline=c, width=2)
        gd.line((26, 15, 30, 15), fill=c, width=2); gd.line((34, 15, 38, 15), fill=c, width=2)
        gd.arc((26, 16, 38, 25), 20, 160, fill=c, width=2)
    elif kind == "hotel":      # three vertical bars and a dot: a hotel/motel sign
        for x in (16, 28, 40):
            gd.rectangle((x, 8, x + 4, 24), fill=c)
        gd.ellipse((48, 18, 54, 24), fill=c)
    elif kind == "noodle":     # a bowl with steam lines
        gd.arc((18, 10, 46, 30), 0, 180, fill=c, width=2)
        gd.line((18, 20, 46, 20), fill=c, width=2)
        for x in (26, 32, 38):
            gd.line((x, 5, x, 13), fill=c, width=2)
    g = glow(g, color, radius=3, strength=0.8)
    im = Image.alpha_composite(im, g)
    # a dim frame of tube
    d = ImageDraw.Draw(im)
    d.rectangle((2, 4, 61, 29), outline=tuple(int(v * 0.35) for v in color) + (255,))
    save_prop(im, "neon_" + kind, 0, registry)


def neon_tube(color, name, registry):
    im = new(32, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((13, 2, 18, 61), fill=(30, 30, 36, 255))
    g = new(32, 64)
    gd = ImageDraw.Draw(g)
    gd.rectangle((14, 4, 17, 59), fill=color + (255,))
    for y in range(6, 58, 12):
        gd.rectangle((14, y, 17, y + 1), fill=tuple(min(255, v + 60) for v in color) + (255,))
    g = glow(g, color, radius=4, strength=0.8)
    im = Image.alpha_composite(im, g)
    save_prop(im, name, 0, registry)


# -------------------------------------------------------------- holographic ads
def holo(kind, phase, name, registry):
    im = new(32, 96)
    d = ImageDraw.Draw(im)
    # projector base
    d.rectangle((8, 88, 23, 95), fill=(36, 36, 44, 255), outline=(10, 10, 14, 255))
    d.rectangle((12, 86, 19, 88), fill=TEAL + (255,))
    col = TEAL if kind != "pink" else MAGENTA
    body = new(32, 96)
    bd = ImageDraw.Draw(body)
    # the cone of light
    for y in range(10, 86):
        t = (y - 10) / 76
        a = int(60 + 40 * t)
        x0 = int(5 + 5 * (1 - t))
        x1 = 31 - x0
        aa = a if (y + phase) % 3 else int(a * 0.5)
        bd.line((x0, y, x1, y), fill=col + (aa,))
    if kind == "figure" or kind == "pink":
        # a smiling figure in frames, hand raised
        c = tuple(min(255, v + 40) for v in col) + (230,)
        bd.ellipse((11, 16, 21, 28), outline=c, width=2)
        bd.line((12, 22, 20, 22), fill=c, width=2)
        bd.polygon([(10, 32), (22, 32), (24, 60), (8, 60)], outline=c, width=2)
        bd.line((22, 36, 28, 24), fill=c, width=2)
        bd.rectangle((9, 60, 14, 80), outline=c); bd.rectangle((18, 60, 23, 80), outline=c)
    elif kind == "eye":
        c = tuple(min(255, v + 40) for v in col) + (230,)
        bd.ellipse((4, 36, 28, 52), outline=c, width=2)
        bd.ellipse((11, 38, 21, 50), outline=c, width=2)
        bd.ellipse((14, 42, 18, 46), fill=c)
        bd.line((6, 62, 26, 62), fill=c, width=2); bd.line((10, 68, 22, 68), fill=c, width=2)
    body = glow(body, col, radius=3, strength=0.35)
    im = Image.alpha_composite(body, im)
    save_prop(im, name, 0, registry)


# ----------------------------------------------------------------- big screens
def big_screen(frame, name, registry, static=False):
    im = new(96, 64)
    d = ImageDraw.Draw(im)
    panel(d, (0, 0, 95, 63), fill=(20, 20, 26))
    d.rectangle((4, 4, 91, 55), fill=(8, 10, 14, 255))
    d.rectangle((0, 56, 95, 63), fill=(30, 30, 36, 255))
    r = random.Random(frame)
    scr = new(96, 64)
    sd = ImageDraw.Draw(scr)
    if static:
        for y in range(4, 56):
            for x in range(4, 92):
                v = r.randint(40, 170)
                sd.point((x, y), fill=(v, v, v + 8, 255))
    elif frame == 0:    # the eye, teal on black
        sd.ellipse((22, 12, 74, 46), outline=TEAL + (255,), width=3)
        sd.ellipse((38, 18, 58, 40), outline=TEAL + (255,), width=3)
        sd.ellipse((44, 25, 52, 33), fill=TEAL + (255,))
        sd.line((10, 50, 86, 50), fill=TEAL + (140,), width=2)
    elif frame == 1:    # a sleeping face lit by frames, magenta
        sd.rectangle((4, 4, 91, 55), fill=(40, 10, 40, 255))
        sd.ellipse((30, 8, 66, 48), fill=(80, 40, 70, 255))
        sd.line((38, 26, 46, 26), fill=MAGENTA + (255,), width=2); sd.line((50, 26, 58, 26), fill=MAGENTA + (255,), width=2)
        sd.rectangle((36, 22, 60, 30), outline=TEAL + (255,))
        sd.rectangle((10, 44, 40, 48), fill=MAGENTA + (200,)); sd.rectangle((56, 44, 86, 48), fill=MAGENTA + (200,))
    elif frame == 2:    # the tower with every window lit
        sd.rectangle((4, 4, 91, 55), fill=(10, 16, 30, 255))
        sd.rectangle((38, 8, 58, 55), fill=(20, 30, 44, 255))
        for y in range(10, 54, 4):
            for x in range(40, 57, 4):
                sd.rectangle((x, y, x + 1, y + 1), fill=TEAL + (255,))
        sd.rectangle((8, 50, 88, 55), fill=(30, 40, 60, 255))
        sd.line((8, 20, 30, 20), fill=CYAN + (200,), width=2); sd.line((66, 36, 88, 36), fill=CYAN + (200,), width=2)
    elif frame == 3:    # a product: a pair of frames, amber
        sd.rectangle((4, 4, 91, 55), fill=(36, 26, 10, 255))
        sd.ellipse((22, 18, 44, 40), outline=AMBER + (255,), width=3)
        sd.ellipse((52, 18, 74, 40), outline=AMBER + (255,), width=3)
        sd.line((44, 29, 52, 29), fill=AMBER + (255,), width=3)
        sd.line((10, 48, 86, 48), fill=AMBER + (160,), width=2)
    # scanlines
    for y in range(4, 56, 3):
        sd.line((4, y, 91, y), fill=(0, 0, 0, 60))
    im = Image.alpha_composite(im, scr)
    if not static:
        im = glow(im, TEAL if frame in (0, 2) else (MAGENTA if frame == 1 else AMBER), radius=5, strength=0.3)
    save_prop(im, name, 0, registry)


# ------------------------------------------------------------- street furniture
def steam(registry):
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.rectangle((4, 18, 27, 29), fill=(40, 42, 50, 255), outline=OUT + (255,))
    for x in range(7, 26, 4):
        d.line((x, 20, x, 27), fill=(14, 14, 18, 255), width=2)
    d.rectangle((6, 16, 25, 18), fill=(60, 62, 70, 255))
    save_prop(im, "steam_vent", 0, registry)
    for i, name in enumerate(["steam_puff", "steam_puff2"]):
        p = new(32, 48)
        pd = ImageDraw.Draw(p)
        r = random.Random(i + 5)
        for _ in range(9):
            x, y, rr = r.randint(6, 26), r.randint(6, 40), r.randint(5, 10)
            pd.ellipse((x - rr, y - rr, x + rr, y + rr), fill=(200, 210, 220, 70))
        p = p.filter(ImageFilter.GaussianBlur(2))
        save_prop(p, name, 0, registry)


def cables(registry):
    im = new(96, 24)
    d = ImageDraw.Draw(im)
    for k, (y0, sag) in enumerate([(3, 7), (6, 9), (10, 6)]):
        pts = [(x, y0 + int(sag * math.sin(math.pi * x / 95))) for x in range(0, 96, 2)]
        d.line(pts, fill=(14, 14, 18, 255), width=2)
    d.rectangle((44, 0, 52, 10), fill=(40, 40, 48, 255), outline=OUT + (255,))
    d.rectangle((47, 3, 49, 5), fill=RED + (255,))
    d.rectangle((0, 0, 3, 23), fill=(30, 30, 36, 255)); d.rectangle((92, 0, 95, 23), fill=(30, 30, 36, 255))
    save_prop(im, "cables", 0, registry)


def transit_tube(registry):
    im = new(128, 40)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 8, 127, 24), fill=(40, 60, 70, 120), outline=(90, 130, 140, 200))
    d.line((0, 12, 127, 12), fill=(140, 200, 210, 140))
    for x in range(6, 128, 26):
        d.rectangle((x, 14, x + 2, 18), fill=TEAL + (255,))
    for x in (16, 64, 112):
        d.rectangle((x, 24, x + 4, 39), fill=(36, 36, 44, 255), outline=OUT + (255,))
    im = glow(im, TEAL, radius=3, strength=0.25)
    save_prop(im, "transit_tube", 0, registry)


def hover_car(registry):
    im = new(64, 32)
    d = ImageDraw.Draw(im)
    d.polygon([(6, 18), (16, 8), (48, 8), (58, 18), (54, 24), (10, 24)], fill=(34, 30, 48, 255), outline=OUT + (255,))
    d.polygon([(18, 10), (46, 10), (50, 16), (14, 16)], fill=(70, 100, 130, 255))
    d.rectangle((6, 18, 10, 20), fill=AMBER + (255,)); d.rectangle((54, 18, 58, 20), fill=RED + (255,))
    g = new(64, 32)
    gd = ImageDraw.Draw(g)
    gd.rectangle((14, 25, 50, 27), fill=MAGENTA + (255,))
    g = glow(g, MAGENTA, radius=4, strength=0.9)
    im = Image.alpha_composite(im, g)
    save_prop(im, "hover_car", 0, registry)


def puddles(registry):
    for i, (name, col) in enumerate([("puddle", TEAL), ("puddle2", MAGENTA), ("puddle3", AMBER)]):
        im = new(32, 32)
        d = ImageDraw.Draw(im)
        r = random.Random(i + 11)
        d.ellipse((2 + r.randint(0, 4), 8 + r.randint(0, 4), 29 - r.randint(0, 4), 26), fill=(18, 20, 30, 170))
        d.ellipse((6, 12, 26, 24), fill=(24, 28, 40, 120))
        for k in range(3):
            y = 13 + k * 4
            d.line((10 + k, y, 20 - k, y), fill=col + (110 - k * 25,))
        save_prop(im, name, 0, registry)


def light_texture():
    s = 256
    im = Image.new("RGBA", (s, s), (255, 255, 255, 0))
    px = im.load()
    for y in range(s):
        for x in range(s):
            dd = math.hypot(x - s / 2, y - s / 2) / (s / 2)
            a = max(0.0, 1.0 - dd) ** 2
            px[x, y] = (255, 255, 255, int(255 * a))
    os.makedirs(UI_DIR, exist_ok=True)
    im.save(os.path.join(UI_DIR, "light.png"))


# ---------------------------------------------------------------------- tiles
def add_tiles():
    atlas = json.load(open(os.path.join(TILES_DIR, "atlas.json")))
    sheet = Image.open(os.path.join(TILES_DIR, "tiles.png")).convert("RGBA")
    cols = sheet.width // T
    used = set(tuple(v) for v in atlas.values())
    free = [(x, y) for y in range(sheet.height // T + 2) for x in range(cols) if (x, y) not in used]
    need_rows = max(y for _, y in free[:6]) + 1
    if sheet.height < need_rows * T:
        bigger = Image.new("RGBA", (sheet.width, need_rows * T), (0, 0, 0, 0))
        bigger.paste(sheet, (0, 0))
        sheet = bigger
    base = sheet.crop((atlas["asphalt"][0] * T, atlas["asphalt"][1] * T, atlas["asphalt"][0] * T + T, atlas["asphalt"][1] * T + T))

    def wet(seed, streak):
        im = base.copy()
        px = im.load()
        r = random.Random(seed)
        for y in range(T):
            for x in range(T):
                c = px[x, y]
                k = int(c[0] * 0.75), int(c[1] * 0.78), int(c[2] * 0.9)
                px[x, y] = (k[0], k[1], k[2], 255)
        d = ImageDraw.Draw(im)
        if streak:
            col = r.choice([TEAL, MAGENTA, AMBER])
            x = r.randint(6, 24)
            for y in range(r.randint(2, 10), r.randint(20, 30)):
                if r.random() < 0.7:
                    d.point((x + r.randint(-1, 1), y), fill=col + (90,))
        return im

    names = [("asphalt_wet", wet(1, False)), ("asphalt_wet2", wet(2, False)), ("asphalt_wet3", wet(3, True)), ("asphalt_wet4", wet(4, True))]
    i = 0
    for name, im in names:
        if name in atlas:
            x, y = atlas[name]
        else:
            x, y = free[i]; i += 1
            atlas[name] = [x, y]
        sheet.paste(im, (x * T, y * T))
    sheet.save(os.path.join(TILES_DIR, "tiles.png"))
    json.dump(atlas, open(os.path.join(TILES_DIR, "atlas.json"), "w"), indent=1, sort_keys=True)
    print("tiles:", [n for n, _ in names])


def main():
    registry = json.load(open(os.path.join(PROPS_DIR, "props.json")))
    for kind, color in [("psyon", TEAL), ("nixtra", MAGENTA), ("tokz", PINK), ("alto", AMBER), ("voltx", BLUE), ("freud", GREEN), ("hotel", RED), ("noodle", CYAN)]:
        neon_sign(kind, color, registry)
    neon_tube(TEAL, "neon_tube", registry)
    neon_tube(MAGENTA, "neon_tube_pink", registry)
    neon_tube(AMBER, "neon_tube_amber", registry)
    holo("figure", 0, "holo_ad", registry)
    holo("figure", 1, "holo_ad2", registry)
    holo("eye", 0, "holo_eye", registry)
    holo("eye", 1, "holo_eye2", registry)
    holo("pink", 0, "holo_pink", registry)
    holo("pink", 1, "holo_pink2", registry)
    for f in range(4):
        big_screen(f, "bigscreen" if f == 0 else f"bigscreen{f + 1}", registry)
    big_screen(9, "bigscreen_static", registry, static=True)
    steam(registry)
    cables(registry)
    transit_tube(registry)
    hover_car(registry)
    puddles(registry)
    light_texture()
    json.dump(registry, open(os.path.join(PROPS_DIR, "props.json"), "w"), indent=1, sort_keys=True)
    add_tiles()
    print("cyberpunk props written")


if __name__ == "__main__":
    main()
