#!/usr/bin/env python3
"""Red Rock Plaza: the art for the mall of Silico (chapter 19 of the book).
Sandstone paving and red-stone storefronts, the gigantic red pillar, the
casino's slot machines, Lushon Tavern's red lanterns and round table, the
dusty Psyon drink dispenser, the smoothie stand, the basement club stairs,
the wet-paint graffiti of the chant. Writes into assets/props (+ props.json)
and appends tiles to assets/tiles (+ atlas.json). Run before gen_maps.py."""
import json
import os
import random
from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
PROPS_DIR = os.path.join(ROOT, "assets", "props")
TILES_DIR = os.path.join(ROOT, "assets", "tiles")
T = 32

RED_ROCK = (168, 72, 52)
RED_ROCK_D = (120, 48, 36)
RED_ROCK_L = (204, 104, 74)
SANDSTONE = (196, 142, 104)
SANDSTONE_D = (160, 110, 80)
OUT = (6, 6, 10)
LANTERN = (230, 60, 40)
AMBER = (245, 190, 90)
TEAL = (127, 224, 192)
MAGENTA = (232, 72, 180)
PAINT = (200, 30, 40)


def new(w, h):
    return Image.new("RGBA", (w, h), (0, 0, 0, 0))


def glow(img, color, radius=4, strength=0.7):
    a = img.split()[3].filter(ImageFilter.GaussianBlur(radius))
    layer = Image.new("RGBA", img.size, color + (0,))
    layer.putalpha(a.point(lambda v: int(v * strength)))
    return Image.alpha_composite(layer, img)


def save_prop(img, name, solid, registry):
    img.save(os.path.join(PROPS_DIR, name + ".png"))
    registry[name] = {"w": img.width, "h": img.height, "solid": solid}


def stone_noise(d, box, base, r, n=40, dark=None):
    x0, y0, x1, y1 = box
    for _ in range(n):
        x = r.randint(x0, x1); y = r.randint(y0, y1)
        k = r.randint(-14, 14)
        d.point((x, y), fill=tuple(max(0, min(255, c + k)) for c in base) + (255,))


# ------------------------------------------------------------------ the pillar
def red_pillar(registry):
    """A gigantic pillar of red stone, three tiles wide and six tall."""
    im = new(96, 192)
    d = ImageDraw.Draw(im)
    r = random.Random(5)
    # body, tapering slightly
    d.polygon([(14, 190), (82, 190), (74, 14), (22, 14)], fill=RED_ROCK + (255,), outline=OUT + (255,))
    d.polygon([(22, 14), (74, 14), (66, 4), (30, 4)], fill=RED_ROCK_L + (255,), outline=OUT + (255,))
    # strata
    for y in range(20, 186, 9):
        xa = 14 + int((190 - y) * 0.045); xb = 82 - int((190 - y) * 0.045)
        d.line((xa + 2, y, xb - 2, y), fill=RED_ROCK_D + (255,))
        if r.random() < 0.5:
            d.line((xa + 6, y + 4, xa + 18 + r.randint(0, 20), y + 4), fill=RED_ROCK_L + (160,))
    stone_noise(d, (18, 16, 78, 186), RED_ROCK, r, n=500)
    # shadow side
    for y in range(16, 190):
        xb = 82 - int((190 - y) * 0.045)
        d.line((xb - 10, y, xb - 1, y), fill=RED_ROCK_D + (120,))
    # base plinth
    d.rectangle((6, 176, 90, 191), fill=SANDSTONE_D + (255,), outline=OUT + (255,))
    d.rectangle((8, 178, 88, 181), fill=SANDSTONE + (255,))
    # a plaque and the eye sprayed over it
    d.rectangle((38, 150, 58, 162), fill=(70, 60, 56, 255), outline=OUT + (255,))
    g = new(96, 192)
    gd = ImageDraw.Draw(g)
    gd.ellipse((36, 120, 60, 136), outline=PAINT + (255,), width=2)
    gd.ellipse((44, 125, 52, 131), outline=PAINT + (255,), width=2)
    g = glow(g, PAINT, radius=2, strength=0.5)
    im = Image.alpha_composite(im, g)
    save_prop(im, "red_pillar", 1, registry)


# ------------------------------------------------------------------ the casino
def slot_machine(name, on, registry):
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((4, 12, 27, 46), fill=(44, 40, 58, 255), outline=OUT + (255,))
    d.rectangle((6, 4, 25, 14), fill=(60, 30, 40, 255), outline=OUT + (255,))
    d.rectangle((7, 18, 24, 28), fill=(14, 12, 20, 255), outline=(90, 80, 100, 255))
    # reels
    for i, x in enumerate((9, 14, 19)):
        col = [AMBER, TEAL, MAGENTA][i] if on else (60, 60, 70)
        d.rectangle((x, 20, x + 3, 26), fill=col + (255,))
    d.rectangle((8, 32, 23, 36), fill=(30, 28, 40, 255), outline=(80, 70, 90, 255))
    d.rectangle((28, 20, 30, 30), fill=(120, 120, 130, 255))  # the arm
    d.ellipse((27, 17, 31, 21), fill=(200, 40, 40, 255))
    if on:
        g = new(32, 48)
        gd = ImageDraw.Draw(g)
        gd.rectangle((8, 6, 23, 12), fill=AMBER + (255,))
        gd.text((9, 5), "WIN", fill=(40, 20, 10, 255))
        g = glow(g, AMBER, radius=3, strength=0.8)
        im = Image.alpha_composite(im, g)
    else:
        d.rectangle((8, 6, 23, 12), fill=(50, 40, 40, 255))
    save_prop(im, name, 1, registry)


def cashier_cage(registry):
    im = new(64, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 20, 61, 46), fill=(70, 50, 40, 255), outline=OUT + (255,))
    d.rectangle((2, 20, 61, 24), fill=(110, 80, 60, 255))
    for x in range(6, 60, 6):
        d.line((x, 2, x, 20), fill=(150, 140, 120, 255))
    d.line((2, 2, 61, 2), fill=(150, 140, 120, 255)); d.line((2, 11, 61, 11), fill=(150, 140, 120, 255))
    d.rectangle((26, 12, 38, 19), fill=(20, 18, 24, 255))
    d.text((27, 11), "0", fill=AMBER + (255,))
    save_prop(im, "cashier_cage", 1, registry)


# ------------------------------------------------------------------ Lushon's
def lantern(registry):
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.line((16, 0, 16, 6), fill=(60, 50, 40, 255))
    g = new(32, 32)
    gd = ImageDraw.Draw(g)
    gd.ellipse((7, 6, 25, 26), fill=LANTERN + (255,), outline=(120, 20, 20, 255))
    for y in (10, 14, 18, 22):
        gd.line((8, y, 24, y), fill=(255, 120, 90, 200))
    gd.rectangle((13, 26, 19, 30), fill=AMBER + (255,))
    g = glow(g, (255, 90, 60), radius=5, strength=0.8)
    im = Image.alpha_composite(im, g)
    save_prop(im, "lantern_red", 0, registry)


def round_table(registry):
    im = new(64, 48)
    d = ImageDraw.Draw(im)
    d.ellipse((4, 20, 59, 46), fill=(60, 36, 28, 255), outline=OUT + (255,))
    d.ellipse((2, 10, 61, 40), fill=(96, 58, 40, 255), outline=OUT + (255,))
    d.ellipse((8, 14, 55, 36), fill=(110, 68, 46, 255))
    d.ellipse((26, 20, 38, 28), fill=(40, 30, 30, 255))  # the table's tap pad
    d.ellipse((29, 22, 35, 26), fill=TEAL + (160,))
    save_prop(im, "round_table", 1, registry)


def dispenser(registry):
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((3, 2, 28, 46), fill=(52, 50, 60, 255), outline=OUT + (255,))
    d.rectangle((6, 6, 25, 18), fill=(20, 24, 30, 255), outline=(80, 80, 90, 255))
    for i, y in enumerate((22, 28, 34)):
        for x in (7, 13, 19):
            d.rectangle((x, y, x + 4, y + 3), fill=(90, 88, 96, 255))
    d.rectangle((9, 40, 22, 45), fill=(20, 20, 24, 255))
    # dust
    r = random.Random(3)
    for _ in range(70):
        d.point((r.randint(5, 26), r.randint(20, 40)), fill=(140, 130, 110, 140))
    d.ellipse((12, 9, 19, 15), outline=TEAL + (120,), width=1)
    save_prop(im, "dispenser", 1, registry)


def bar_counter(registry):
    im = new(96, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 16, 95, 46), fill=(70, 42, 30, 255), outline=OUT + (255,))
    d.rectangle((0, 12, 95, 18), fill=(110, 70, 48, 255), outline=OUT + (255,))
    for x in range(6, 90, 12):
        d.rectangle((x, 24, x + 4, 40), fill=(56, 32, 24, 255))
    for x, c in ((14, AMBER), (34, TEAL), (60, LANTERN), (80, MAGENTA)):
        d.rectangle((x, 4, x + 4, 14), fill=c + (200,))
    save_prop(im, "bar_counter", 1, registry)


# --------------------------------------------------------------- the plaza
def smoothie_stand(registry):
    im = new(64, 64)
    d = ImageDraw.Draw(im)
    d.polygon([(0, 18), (63, 18), (56, 4), (7, 4)], fill=(230, 80, 120, 255), outline=OUT + (255,))
    for x in range(10, 60, 12):
        d.polygon([(x, 18), (x + 6, 18), (x + 5, 5), (x + 1, 5)], fill=(250, 240, 230, 255))
    d.rectangle((4, 30, 59, 62), fill=(80, 60, 50, 255), outline=OUT + (255,))
    d.rectangle((4, 28, 59, 34), fill=(120, 90, 70, 255))
    d.rectangle((20, 36, 44, 56), fill=(40, 36, 44, 255))  # the Psyon blender unit
    d.ellipse((28, 40, 36, 48), outline=TEAL + (255,), width=1)
    for i, x in enumerate((8, 14, 50)):
        d.rectangle((x, 20, x + 4, 28), fill=[(255, 180, 60), (120, 220, 120), (240, 90, 140)][i] + (255,))
    d.line((2, 18, 2, 30), fill=OUT + (255,)); d.line((61, 18, 61, 30), fill=OUT + (255,))
    save_prop(im, "smoothie_stand", 1, registry)


def club_stairs(registry):
    """Stairs down into a basement club, with a neon arrow and a speaker."""
    im = new(64, 32)
    d = ImageDraw.Draw(im)
    d.rectangle((8, 4, 55, 30), fill=(14, 12, 18, 255), outline=OUT + (255,))
    for i, y in enumerate((8, 14, 20, 26)):
        d.rectangle((10 + i, y, 53 - i, y + 3), fill=(40 - i * 6, 36 - i * 6, 46 - i * 6, 255))
    d.rectangle((0, 0, 6, 30), fill=(60, 56, 70, 255), outline=OUT + (255,))
    d.rectangle((57, 0, 63, 30), fill=(60, 56, 70, 255), outline=OUT + (255,))
    g = new(64, 32)
    gd = ImageDraw.Draw(g)
    gd.polygon([(28, 2), (36, 2), (36, 10), (40, 10), (32, 18), (24, 10), (28, 10)], fill=MAGENTA + (255,))
    g = glow(g, MAGENTA, radius=3, strength=0.8)
    im = Image.alpha_composite(im, g)
    save_prop(im, "club_stairs", 0, registry)


def speaker_stack(registry):
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    for y in (4, 26):
        d.rectangle((5, y, 26, y + 20), fill=(26, 24, 30, 255), outline=OUT + (255,))
        d.ellipse((9, y + 4, 22, y + 17), fill=(50, 46, 56, 255), outline=(90, 86, 100, 255))
        d.ellipse((13, y + 8, 18, y + 13), fill=(20, 18, 24, 255))
    d.rectangle((14, 1, 17, 3), fill=TEAL + (255,))
    save_prop(im, "speaker_stack", 1, registry)


def neon_word(name, text, color, registry):
    im = new(64, 32)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 4, 61, 29), fill=(16, 14, 22, 255), outline=OUT + (255,))
    d.rectangle((30, 0, 33, 4), fill=(40, 40, 48, 255))
    g = new(64, 32)
    gd = ImageDraw.Draw(g)
    w = gd.textlength(text)
    gd.text(((64 - w) / 2, 10), text, fill=color + (255,))
    if name == "neon_lushon":
        gd.ellipse((6, 9, 14, 21), outline=color + (255,), width=1)
        gd.ellipse((49, 9, 57, 21), outline=color + (255,), width=1)
    else:
        gd.polygon([(6, 20), (10, 10), (14, 20)], outline=color + (255,))
        gd.rectangle((50, 10, 57, 20), outline=color + (255,))
    g = glow(g, color, radius=3, strength=0.9)
    im = Image.alpha_composite(im, g)
    save_prop(im, name, 0, registry)


def graffiti(name, lines, registry):
    """Wet red paint on a wall, two lines of the chant."""
    im = new(160, 32)
    d = ImageDraw.Draw(im)
    r = random.Random(len(name))
    for i, line in enumerate(lines):
        y = 4 + i * 13
        d.text((5 + r.randint(0, 3), y), line, fill=PAINT + (255,))
        # drips
        for _ in range(4):
            x = r.randint(6, 150)
            d.line((x, y + 9, x, y + 9 + r.randint(3, 9)), fill=PAINT + (190,))
    g = glow(im, (255, 60, 60), radius=1, strength=0.35)
    save_prop(g, name, 0, registry)


def partygoer_bottle(registry):
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.rectangle((13, 10, 18, 28), fill=(40, 90, 60, 220), outline=OUT + (255,))
    d.rectangle((14, 4, 17, 10), fill=(40, 90, 60, 220))
    d.ellipse((6, 22, 26, 31), fill=(60, 100, 70, 90))
    save_prop(im, "bottle", 0, registry)


# ---------------------------------------------------------------------- tiles
def add_tiles():
    atlas = json.load(open(os.path.join(TILES_DIR, "atlas.json")))
    sheet = Image.open(os.path.join(TILES_DIR, "tiles.png")).convert("RGBA")
    cols = sheet.width // T
    used = set(tuple(v) for v in atlas.values())
    free = [(x, y) for y in range(sheet.height // T + 3) for x in range(cols) if (x, y) not in used]

    def sandstone(seed):
        im = Image.new("RGBA", (T, T), SANDSTONE + (255,))
        d = ImageDraw.Draw(im)
        r = random.Random(seed)
        stone_noise(d, (0, 0, 31, 31), SANDSTONE, r, n=260)
        # flagstone joints
        d.line((0, 15, 31, 15), fill=SANDSTONE_D + (255,)); d.line((15, 0, 15, 15), fill=SANDSTONE_D + (255,)); d.line((23, 16, 23, 31), fill=SANDSTONE_D + (255,))
        if seed == 3:
            d.line((4, 20, 12, 27), fill=SANDSTONE_D + (255,))
        if seed == 4:
            for _ in range(12):
                d.point((r.randint(0, 31), r.randint(0, 31)), fill=(230, 200, 150, 255))   # drifted sand
        return im

    def redwall(kind):
        im = Image.new("RGBA", (T, T), RED_ROCK + (255,))
        d = ImageDraw.Draw(im)
        r = random.Random(7 + len(kind))
        for y in range(0, 32, 8):
            off = 0 if (y // 8) % 2 == 0 else 8
            for x in range(-8 + off, 32, 16):
                d.rectangle((x, y, x + 15, y + 7), fill=RED_ROCK + (255,), outline=RED_ROCK_D + (255,))
                stone_noise(d, (max(0, x + 1), y + 1, min(31, x + 14), y + 6), RED_ROCK, r, n=12)
        if kind == "top":
            d.rectangle((0, 0, 31, 3), fill=RED_ROCK_L + (255,)); d.line((0, 4, 31, 4), fill=OUT + (255,))
        if kind == "bot":
            d.rectangle((0, 27, 31, 31), fill=RED_ROCK_D + (255,)); d.line((0, 26, 31, 26), fill=OUT + (255,))
        return im

    names = [("sandstone", sandstone(1)), ("sandstone2", sandstone(2)), ("sandstone3", sandstone(3)), ("sandstone4", sandstone(4)),
             ("brick_sand_top", redwall("top")), ("brick_sand_mid", redwall("mid")), ("brick_sand_bot", redwall("bot"))]
    need_rows = max(y for _, y in free[:len(names)]) + 1
    if sheet.height < need_rows * T:
        bigger = Image.new("RGBA", (sheet.width, need_rows * T), (0, 0, 0, 0))
        bigger.paste(sheet, (0, 0))
        sheet = bigger
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
    red_pillar(registry)
    slot_machine("slot_machine", True, registry)
    slot_machine("slot_machine_dark", False, registry)
    cashier_cage(registry)
    lantern(registry)
    round_table(registry)
    dispenser(registry)
    bar_counter(registry)
    smoothie_stand(registry)
    club_stairs(registry)
    speaker_stack(registry)
    neon_word("neon_lushon", "LUSHON", LANTERN, registry)
    neon_word("neon_casino", "CASINO", AMBER, registry)
    graffiti("graffiti_god", ["THE GOD WHO ANSWERS", "THE GOD WITHIN THE WAVES"], registry)
    graffiti("graffiti_sea", ["SIN DISTRACTS WITHIN", "AN EYELESS SEA"], registry)
    graffiti("graffiti_mimic", ["THE MIMIC WILL COME", "THE DIVINE MIRROR IMPRISONS"], registry)
    graffiti("graffiti_count", ["FROM 0 TO 1, FROM 1 TO 2", "FROM 2 TO 4"], registry)
    partygoer_bottle(registry)
    json.dump(registry, open(os.path.join(PROPS_DIR, "props.json"), "w"), indent=1, sort_keys=True)
    add_tiles()
    print("red rock props written")


if __name__ == "__main__":
    main()
