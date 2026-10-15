#!/usr/bin/env python3
"""Generates the pixel art for The Hunger Beneath Us.

Everything is drawn procedurally from the palette in the art bible, with
1px outlines and dithered shading so it reads as 16-bit JRPG art. Replace
any PNG in assets/ with hand-drawn art of the same size and the game picks
it up without code changes.
"""
import os
import random
from PIL import Image, ImageDraw

ROOT = os.path.join(os.path.dirname(__file__), "..", "assets")

# Palette from the art bible
JADE = ["#1f6f5c", "#2fa184", "#7fe0c0"]
DESERT = ["#c8743a", "#e9a060", "#f5d6a0"]
ROT = ["#5a4a3a", "#8a6a4a", "#3b2e26"]
CLINICAL = ["#e8ecef", "#b9c2c9", "#6f7a84"]
BLOOD = ["#8f1d1d", "#c62828"]
VOID = ["#050608", "#141622"]
LAVENDER = "#b89ad9"
SKIN = "#e6b89c"
SKIN_SHADE = "#c48f6e"
HAIR = "#4a2e1a"
WHITE = "#ffffff"
BLACK = "#000000"
OUTLINE = "#14121a"
TRANSPARENT = (0, 0, 0, 0)

random.seed(7)


# ------------------------------------------------------------------ helpers
def new(w, h):
    return Image.new("RGBA", (w, h), TRANSPARENT)


def hexrgb(c):
    c = c.lstrip("#")
    return tuple(int(c[i:i + 2], 16) for i in (0, 2, 4))


def shade(c, f):
    """Darken (f<1) or lighten (f>1) a hex colour."""
    r, g, b = hexrgb(c)
    return "#%02x%02x%02x" % tuple(max(0, min(255, int(v * f))) for v in (r, g, b))


def mix(a, b, t):
    ra, ga, ba = hexrgb(a)
    rb, gb, bb = hexrgb(b)
    return "#%02x%02x%02x" % (int(ra + (rb - ra) * t), int(ga + (gb - ga) * t), int(ba + (bb - ba) * t))


def fill(img, color):
    ImageDraw.Draw(img).rectangle([0, 0, img.width - 1, img.height - 1], fill=color)


def noise(img, colors, density, box=None):
    d = ImageDraw.Draw(img)
    x0, y0, x1, y1 = box or (0, 0, img.width - 1, img.height - 1)
    for _ in range(int((x1 - x0 + 1) * (y1 - y0 + 1) * density)):
        d.point((random.randint(x0, x1), random.randint(y0, y1)), fill=random.choice(colors))


def dither(img, color, box, step=2, phase=0):
    """Checkerboard dither of `color` inside box."""
    d = ImageDraw.Draw(img)
    x0, y0, x1, y1 = box
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            if (x + y + phase) % step == 0:
                d.point((x, y), fill=color)


def outline(img, color=OUTLINE, box=None):
    """Draw a 1px outline around every opaque region (4-neighbour)."""
    px = img.load()
    w, h = img.size
    x0, y0, x1, y1 = box or (0, 0, w - 1, h - 1)
    todo = []
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            if px[x, y][3] != 0:
                continue
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if x0 <= nx <= x1 and y0 <= ny <= y1 and px[nx, ny][3] != 0:
                    todo.append((x, y))
                    break
    c = hexrgb(color) + (255,)
    for x, y in todo:
        px[x, y] = c


def rim(img, box, light, dark):
    """Top-left highlight and bottom-right shadow on a rectangle."""
    d = ImageDraw.Draw(img)
    x0, y0, x1, y1 = box
    d.line([x0, y0, x1, y0], fill=light)
    d.line([x0, y0, x0, y1], fill=light)
    d.line([x0, y1, x1, y1], fill=dark)
    d.line([x1, y0, x1, y1], fill=dark)


# ------------------------------------------------------------------- tiles
TILE = 16


def base(color, n1, n2, density=0.2):
    t = new(TILE, TILE)
    fill(t, color)
    noise(t, [n1, n2], density)
    return t


def tile_carpet(dusty=True):
    t = new(TILE, TILE)
    fill(t, "#7d5f42")
    d = ImageDraw.Draw(t)
    for y in range(0, 16, 2):
        for x in range(0, 16, 2):
            d.point((x + (y // 2) % 2, y), fill="#8a6a4a")
    noise(t, ["#6c5038", "#937050"], 0.12)
    if dusty:
        noise(t, [DESERT[2], "#d9c9a8"], 0.08)
    return t


def tile_debris():
    t = tile_carpet()
    d = ImageDraw.Draw(t)
    for _ in range(3):
        x, y = random.randint(0, 10), random.randint(0, 11)
        w, h = random.randint(2, 4), random.randint(1, 3)
        c = random.choice([CLINICAL[0], DESERT[1], "#d9d2a8", "#c9b58a"])
        d.rectangle([x, y, x + w, y + h], fill=c)
        d.line([x, y + h, x + w, y + h], fill=shade(c, 0.6))
    noise(t, [DESERT[2]], 0.15)
    return t


def tile_sand():
    t = base(DESERT[2], DESERT[1], "#fff0c8", 0.25)
    d = ImageDraw.Draw(t)
    for y in (4, 11):
        d.line([0, y, 6, y + 1], fill=shade(DESERT[2], 0.88))
        d.line([9, y + 1, 15, y], fill=shade(DESERT[2], 0.88))
    return t


def tile_wall_top():
    t = new(TILE, TILE)
    fill(t, "#4c5054")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 2], fill="#5b6065")
    d.line([0, 15, 15, 15], fill="#2c2f33")
    noise(t, ["#454a4e", "#53585d"], 0.15)
    return t


def tile_wall_face():
    t = new(TILE, TILE)
    fill(t, "#8f9398")
    d = ImageDraw.Draw(t)
    for x in range(1, 16, 5):
        d.line([x, 0, x, 11], fill="#9ba0a5")
        d.line([x + 2, 0, x + 2, 11], fill="#858a90")
    d.rectangle([0, 12, 15, 15], fill="#6f7378")
    d.line([0, 12, 15, 12], fill="#a0a4a9")
    d.line([0, 15, 15, 15], fill="#55595e")
    noise(t, ["#848990", "#9a9fa5"], 0.06, (0, 0, 15, 11))
    return t


def tile_wall_stain():
    t = tile_wall_face()
    d = ImageDraw.Draw(t)
    d.ellipse([2, 3, 13, 12], fill="#6e6655")
    d.ellipse([4, 5, 11, 10], fill="#5a5244")
    noise(t, [ROT[2], "#7a6e58"], 0.2, (2, 3, 13, 12))
    return t


def _on_carpet(dusty=False):
    return tile_carpet(dusty)


def tile_desk():
    t = _on_carpet()
    d = ImageDraw.Draw(t)
    d.rectangle([0, 3, 15, 12], fill="#a07a4a")
    d.rectangle([0, 3, 15, 5], fill="#b58a56")
    d.line([0, 12, 15, 12], fill="#6a4a2a")
    d.rectangle([1, 13, 2, 15], fill="#6a4a2a")
    d.rectangle([13, 13, 14, 15], fill="#6a4a2a")
    d.line([0, 3, 15, 3], fill=OUTLINE)
    return t


def tile_laptop():
    t = tile_desk()
    d = ImageDraw.Draw(t)
    d.rectangle([4, 1, 11, 8], fill="#2a2d33")
    d.rectangle([5, 2, 10, 7], fill=VOID[1])
    d.rectangle([6, 3, 9, 4], fill=JADE[1])
    d.point((7, 6), fill=JADE[2])
    d.rectangle([3, 9, 12, 11], fill="#3a3d44")
    d.line([3, 11, 12, 11], fill=OUTLINE)
    return t


def tile_blood():
    t = tile_carpet()
    d = ImageDraw.Draw(t)
    d.ellipse([3, 4, 12, 12], fill=BLOOD[0])
    d.ellipse([5, 6, 10, 10], fill="#6e1414")
    for x, y in ((2, 3), (13, 5), (12, 13), (4, 13)):
        d.point((x, y), fill=BLOOD[0])
    return t


def tile_eyes():
    t = tile_blood()
    d = ImageDraw.Draw(t)
    for x in (4, 9):
        d.ellipse([x, 6, x + 3, 9], fill="#f2f0e8")
        d.point((x + 1, 7), fill="#3a6a8a")
        d.point((x + 2, 7), fill=OUTLINE)
        d.line([x + 3, 9, x + 4, 11], fill="#d88a8a")
    return t


def tile_stick():
    t = tile_carpet()
    d = ImageDraw.Draw(t)
    d.line([2, 11, 12, 4], fill="#6b4a2a", width=1)
    d.line([3, 12, 13, 5], fill="#9a7048", width=1)
    d.line([9, 13, 13, 11], fill="#6b4a2a")
    return t


def tile_glass_door():
    t = new(TILE, TILE)
    fill(t, "#6d8ea8")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 15], outline="#3f4a55")
    d.line([7, 0, 7, 15], fill="#3f4a55")
    d.line([2, 12, 6, 2], fill="#9fc0d8")
    d.line([10, 13, 13, 5], fill="#9fc0d8")
    d.rectangle([0, 0, 15, 2], fill="#2c3540")
    return t


def tile_balcony():
    t = base("#555a60", "#4a4f55", "#60656b")
    d = ImageDraw.Draw(t)
    for x in range(1, 16, 3):
        d.line([x, 0, x, 12], fill="#2c3036")
    d.rectangle([0, 0, 15, 1], fill="#2c3036")
    d.rectangle([0, 13, 15, 15], fill="#3c4046")
    return t


def tile_city_sky():
    t = new(TILE, TILE)
    d = ImageDraw.Draw(t)
    for y in range(16):
        d.line([0, y, 15, y], fill=mix("#2a3550", "#c8743a", y / 15))
    for x in range(0, 16, 3):
        h = random.randint(5, 11)
        d.rectangle([x, 16 - h, x + 1, 15], fill="#1c2233")
        if random.random() < 0.6:
            d.point((x, 16 - h + random.randint(1, h - 1)), fill=DESERT[2])
    return t


def tile_door():
    t = new(TILE, TILE)
    fill(t, "#6a4a2a")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 15], outline="#3a2a1a")
    d.rectangle([2, 2, 13, 13], outline="#8a6a4a")
    d.rectangle([4, 4, 11, 7], fill="#7a5a3a")
    d.point((12, 9), fill=DESERT[2])
    return t


def tile_bed():
    t = _on_carpet()
    d = ImageDraw.Draw(t)
    d.rectangle([1, 0, 14, 15], fill="#b7b2a6")
    d.rectangle([1, 0, 14, 4], fill="#d8d3c8")
    d.rectangle([3, 1, 12, 3], fill="#eceae2")
    d.rectangle([1, 5, 14, 15], fill="#6b7a8a")
    d.line([1, 5, 14, 5], fill="#8a9aaa")
    d.rectangle([0, 0, 0, 15], fill="#5a4a3a")
    d.rectangle([15, 0, 15, 15], fill="#5a4a3a")
    noise(t, ["#5f6e7e"], 0.1, (1, 6, 14, 15))
    return t


def tile_cardboard():
    t = tile_carpet()
    d = ImageDraw.Draw(t)
    d.rectangle([1, 3, 10, 12], fill="#b58a56")
    d.rectangle([1, 3, 10, 5], fill="#c9a06a")
    d.rectangle([8, 7, 15, 15], fill="#a07a4a")
    d.line([1, 12, 10, 12], fill="#6a4a2a")
    d.line([8, 15, 15, 15], fill="#6a4a2a")
    d.line([5, 3, 5, 12], fill="#8a6a3a")
    return t


def tile_plant():
    t = _on_carpet()
    d = ImageDraw.Draw(t)
    d.rectangle([5, 10, 10, 15], fill="#8a4a2a")
    d.rectangle([5, 10, 10, 11], fill="#a85a30")
    d.rectangle([7, 3, 8, 10], fill="#4a5a3a")
    for x, y in ((3, 4), (10, 2), (4, 8), (11, 6)):
        d.rectangle([x, y, x + 2, y + 1], fill="#5a6a3a")
    d.point((4, 4), fill="#8a7a4a")
    d.point((11, 2), fill="#8a7a4a")
    return t


def tile_kitchen():
    t = new(TILE, TILE)
    fill(t, "#c7cacf")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 3], fill="#e0e3e6")
    d.rectangle([0, 4, 15, 4], fill="#8a8f95")
    d.rectangle([1, 6, 6, 13], fill="#a9adb2")
    d.rectangle([9, 6, 14, 13], fill="#a9adb2")
    d.rectangle([1, 6, 6, 6], fill="#7a7f85")
    d.rectangle([9, 6, 14, 6], fill="#7a7f85")
    d.point((3, 9), fill="#4a4f55")
    d.point((11, 9), fill="#4a4f55")
    d.line([0, 15, 15, 15], fill="#6f7378")
    return t


def tile_hall():
    return base("#4a5a52", "#3f4e47", "#56675e")


def tile_grass():
    t = base("#5f7a3a", "#536b30", "#6d8a44", 0.3)
    d = ImageDraw.Draw(t)
    for _ in range(4):
        x, y = random.randint(1, 13), random.randint(2, 14)
        d.line([x, y, x, y - 2], fill="#7a9a48")
        d.point((x + 1, y - 1), fill="#7a9a48")
    noise(t, [DESERT[2]], 0.03)
    return t


def tile_path():
    t = base("#9a8f7a", "#8d8370", "#aaa08a", 0.25)
    d = ImageDraw.Draw(t)
    for _ in range(3):
        x, y = random.randint(0, 12), random.randint(0, 12)
        d.rectangle([x, y, x + 2, y + 1], fill="#b0a48d")
        d.point((x, y + 2), fill="#7f7560")
    return t


def tile_bench():
    t = tile_path()
    d = ImageDraw.Draw(t)
    d.rectangle([0, 2, 15, 4], fill="#8a6a4a")
    d.rectangle([0, 6, 15, 8], fill="#7a5a3a")
    d.line([0, 4, 15, 4], fill="#5a3a1a")
    d.line([0, 8, 15, 8], fill="#5a3a1a")
    d.rectangle([2, 9, 3, 13], fill="#3a3a3a")
    d.rectangle([12, 9, 13, 13], fill="#3a3a3a")
    return t


def tile_tent():
    t = tile_path()
    d = ImageDraw.Draw(t)
    d.polygon([(0, 14), (8, 1), (15, 14)], fill="#8a6a4a")
    d.polygon([(8, 1), (15, 14), (8, 14)], fill="#6f5238")
    d.polygon([(5, 14), (8, 7), (11, 14)], fill=VOID[1])
    d.line([0, 14, 15, 14], fill="#3a2a1a")
    d.line([8, 1, 8, 7], fill="#a98a66")
    return t


def tile_graffiti_wall():
    t = tile_wall_face()
    d = ImageDraw.Draw(t)
    d.ellipse([1, 3, 14, 11], outline=OUTLINE)
    d.ellipse([4, 5, 11, 9], outline=OUTLINE)
    d.rectangle([7, 7, 8, 7], fill=OUTLINE)
    return t


def tile_asphalt():
    t = base("#3a3d42", "#2f3236", "#474b52", 0.2)
    d = ImageDraw.Draw(t)
    d.line([2, 14, 6, 9], fill="#2a2c30")
    d.line([6, 9, 9, 8], fill="#2a2c30")
    noise(t, [DESERT[2]], 0.03)
    return t


def tile_concrete():
    t = base("#8d9196", "#7d8186", "#9da1a6", 0.15)
    d = ImageDraw.Draw(t)
    d.line([0, 15, 15, 15], fill="#6f7378")
    d.line([15, 0, 15, 15], fill="#6f7378")
    d.line([0, 0, 15, 0], fill="#a3a7ac")
    return t


def tile_jade_floor():
    t = new(TILE, TILE)
    fill(t, "#1b2a2a")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 0], fill="#2a4040")
    d.rectangle([0, 0, 0, 15], fill="#2a4040")
    d.rectangle([1, 1, 14, 14], outline="#182424")
    dither(t, "#1f3131", (2, 2, 13, 13), 4)
    d.point((14, 14), fill=JADE[1])
    return t


def tile_table():
    t = new(TILE, TILE)
    fill(t, "#5a3a22")
    d = ImageDraw.Draw(t)
    for y in range(0, 16, 3):
        d.line([0, y, 15, y], fill="#4a2e1a")
    noise(t, ["#6a4a2e", "#3e2714"], 0.12)
    d.line([0, 0, 15, 0], fill="#7a5a3a")
    return t


def tile_screen_wall():
    t = tile_wall_top()
    d = ImageDraw.Draw(t)
    d.rectangle([1, 2, 14, 12], fill=VOID[0])
    d.rectangle([1, 2, 14, 12], outline="#2c2f33")
    for i in range(4):
        h = random.randint(2, 7)
        d.rectangle([2 + i * 3, 11 - h, 3 + i * 3, 11], fill=random.choice(JADE + [BLOOD[1]]))
    d.line([2, 3, 13, 3], fill=JADE[0])
    return t


def tile_chair():
    t = tile_jade_floor()
    d = ImageDraw.Draw(t)
    d.rectangle([4, 5, 11, 12], fill="#23232e")
    d.rectangle([4, 3, 11, 5], fill="#33334a")
    d.rectangle([5, 6, 10, 11], fill="#2c2c3a")
    d.line([4, 12, 11, 12], fill=OUTLINE)
    return t


def tile_elevator():
    t = new(TILE, TILE)
    fill(t, "#4c5054")
    d = ImageDraw.Draw(t)
    d.rectangle([1, 1, 14, 15], fill="#9ea3a8")
    d.rectangle([2, 2, 7, 15], fill="#b9c2c9")
    d.rectangle([8, 2, 13, 15], fill="#b9c2c9")
    d.line([7, 1, 8, 15], fill="#2c2f33")
    d.line([2, 2, 2, 15], fill="#d8dde2")
    d.rectangle([5, 0, 10, 0], fill=JADE[2])
    return t


def tile_hosp_floor():
    t = new(TILE, TILE)
    fill(t, "#d9dcdf")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 7, 7], fill="#e4e7ea")
    d.rectangle([8, 8, 15, 15], fill="#e4e7ea")
    d.line([0, 0, 15, 0], fill="#c4c8cc")
    d.line([0, 0, 0, 15], fill="#c4c8cc")
    return t


def tile_hosp_bed():
    t = tile_hosp_floor()
    d = ImageDraw.Draw(t)
    d.rectangle([1, 0, 14, 15], fill="#c8ccd0")
    d.rectangle([2, 1, 13, 14], fill=CLINICAL[0])
    d.rectangle([3, 2, 12, 4], fill="#f6f7f8")
    d.rectangle([2, 6, 13, 14], fill="#9fb3c8")
    d.line([2, 6, 13, 6], fill="#b8c8d8")
    d.rectangle([1, 7, 1, 9], fill="#6a4a4a")
    d.rectangle([14, 7, 14, 9], fill="#6a4a4a")
    return t


def tile_hosp_wall():
    t = new(TILE, TILE)
    fill(t, "#e3e0d6")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 2], fill="#efede6")
    d.rectangle([0, 11, 15, 15], fill="#b9b5a8")
    d.line([0, 11, 15, 11], fill="#d4d0c4")
    d.line([0, 15, 15, 15], fill="#8a867a")
    return t


def tile_platform():
    t = tile_concrete()
    d = ImageDraw.Draw(t)
    d.rectangle([0, 12, 15, 13], fill=DESERT[1])
    d.rectangle([0, 14, 15, 15], fill="#5a5e63")
    return t


def tile_rail():
    t = base("#2a2622", "#241f1b", "#332d27")
    d = ImageDraw.Draw(t)
    for x in (1, 7, 13):
        d.rectangle([x, 0, x + 1, 15], fill="#5a4a3a")
    d.rectangle([0, 3, 15, 4], fill="#8a8a8a")
    d.rectangle([0, 11, 15, 12], fill="#8a8a8a")
    d.line([0, 5, 15, 5], fill="#5a5a5a")
    d.line([0, 13, 15, 13], fill="#5a5a5a")
    return t


def tile_desert():
    t = base(DESERT[1], DESERT[0], "#f0b070", 0.2)
    d = ImageDraw.Draw(t)
    for y in (3, 9, 14):
        d.line([0, y, 5, y + 1], fill="#d88a50")
        d.line([8, y + 1, 15, y], fill="#d88a50")
    noise(t, [DESERT[2]], 0.08)
    return t


def tile_rock():
    t = tile_desert()
    d = ImageDraw.Draw(t)
    d.ellipse([1, 4, 14, 15], fill="#8a4a24")
    d.ellipse([2, 3, 12, 11], fill="#a85a30")
    d.ellipse([4, 4, 8, 7], fill="#c06a3a")
    d.line([3, 14, 12, 14], fill="#5a2e14")
    return t


def tile_car():
    t = tile_desert()
    d = ImageDraw.Draw(t)
    d.rounded_rectangle([0, 3, 15, 12], radius=3, fill="#1a2a44")
    d.rounded_rectangle([0, 3, 15, 6], radius=2, fill="#243a5a")
    d.rectangle([3, 5, 12, 8], fill="#6fb0c0")
    d.rectangle([3, 5, 12, 5], fill="#a0d8e0")
    d.rectangle([1, 12, 3, 14], fill=OUTLINE)
    d.rectangle([12, 12, 14, 14], fill=OUTLINE)
    d.point((14, 8), fill=DESERT[2])
    return t


def tile_cliff_door():
    t = new(TILE, TILE)
    fill(t, "#6a3a1e")
    d = ImageDraw.Draw(t)
    d.rectangle([2, 0, 13, 15], fill="#4a4a50")
    d.rectangle([3, 1, 12, 14], fill="#5a5a62")
    d.line([3, 1, 12, 1], fill="#7a7a84")
    d.ellipse([4, 5, 11, 10], outline=VOID[0])
    d.ellipse([6, 6, 9, 9], outline=VOID[0])
    d.point((7, 7), fill=BLOOD[1])
    return t


def tile_mirror():
    t = new(TILE, TILE)
    fill(t, "#2a2a30")
    d = ImageDraw.Draw(t)
    d.ellipse([0, 0, 15, 15], fill="#8a9098")
    d.ellipse([1, 1, 14, 14], fill="#c0c8d0")
    d.ellipse([4, 3, 8, 7], fill="#e8ecef")
    d.line([3, 11, 11, 4], fill="#d8e0e8")
    return t


def tile_sticky_wall():
    t = tile_wall_face()
    d = ImageDraw.Draw(t)
    for x in range(1, 14, 4):
        for y in range(1, 11, 4):
            c = random.choice(["#f5e07a", "#f5a0a0", "#a0d8f5", "#c8f5a0"])
            d.rectangle([x, y, x + 2, y + 2], fill=c)
            d.line([x, y + 1, x + 2, y + 1], fill=shade(c, 0.7))
    return t


def tile_frames_broken():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.rectangle([2, 6, 6, 9], outline=JADE[0])
    d.rectangle([9, 5, 13, 9], outline=JADE[0])
    d.line([7, 7, 8, 7], fill=JADE[0])
    d.line([4, 5, 5, 10], fill=CLINICAL[0])
    d.line([10, 10, 14, 12], fill=JADE[1])
    d.point((11, 7), fill=CLINICAL[0])
    return t


def tile_stick_circle():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.ellipse([0, 1, 15, 14], outline="#9a7048")
    d.ellipse([3, 4, 12, 11], outline="#7a5a38")
    d.rectangle([6, 6, 9, 9], fill="#e8e0d0")
    d.ellipse([6, 6, 9, 9], outline=BLOOD[1])
    return t


def tile_tablet():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.rectangle([2, 3, 13, 12], fill="#2a2d33")
    d.rectangle([3, 4, 12, 11], fill=JADE[0])
    d.rectangle([5, 6, 10, 7], fill=JADE[2])
    d.line([2, 12, 13, 12], fill=OUTLINE)
    return t


def tile_pillar():
    t = new(TILE, TILE)
    fill(t, "#5a5e63")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 2, 15], fill="#40444a")
    d.rectangle([13, 0, 15, 15], fill="#40444a")
    d.rectangle([3, 0, 4, 15], fill="#6b7076")
    noise(t, ["#4f5358", "#666b70"], 0.1, (3, 0, 12, 15))
    return t


def tile_dark_floor():
    t = base("#101014", "#15151c", "#0b0b0e")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 15], outline="#0b0b0e")
    return t


def tile_window():
    t = tile_wall_face()
    d = ImageDraw.Draw(t)
    d.rectangle([1, 0, 14, 10], fill="#2c3540")
    for y in range(1, 10):
        d.line([2, y, 13, y], fill=mix("#4a5a80", "#e9a060", y / 9))
    d.rectangle([4, 7, 5, 9], fill="#2a3040")
    d.rectangle([8, 5, 9, 9], fill="#2a3040")
    d.line([1, 10, 14, 10], fill="#d8dde2")
    d.line([7, 0, 7, 10], fill="#3a4450")
    return t


def tile_couch():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.rectangle([0, 3, 15, 13], fill="#3a4a5a")
    d.rectangle([0, 3, 15, 5], fill="#2a3a4a")
    d.rectangle([2, 7, 13, 12], fill="#44566a")
    d.line([7, 7, 7, 12], fill="#2a3a4a")
    d.line([0, 13, 15, 13], fill=OUTLINE)
    return t


def tile_kid_bed():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.rectangle([1, 0, 14, 15], fill="#8a6aa9")
    d.rectangle([2, 1, 13, 4], fill=CLINICAL[0])
    d.rectangle([2, 5, 13, 14], fill=LAVENDER)
    for y in range(6, 14, 3):
        d.line([2, y, 13, y], fill="#a888c8")
    d.rectangle([0, 0, 0, 15], fill="#4a3a5a")
    d.rectangle([15, 0, 15, 15], fill="#4a3a5a")
    return t


def tile_cactus():
    t = tile_desert()
    d = ImageDraw.Draw(t)
    d.rectangle([7, 1, 9, 14], fill="#3f7a3a")
    d.rectangle([3, 5, 4, 9], fill="#3f7a3a")
    d.rectangle([3, 5, 7, 6], fill="#3f7a3a")
    d.rectangle([11, 3, 12, 8], fill="#3f7a3a")
    d.rectangle([9, 3, 12, 4], fill="#3f7a3a")
    d.line([8, 1, 8, 14], fill="#5a9a4a")
    d.rectangle([6, 14, 10, 15], fill="#a05020")
    return t


def tile_retaining_wall():
    t = new(TILE, TILE)
    fill(t, "#7a6a5a")
    d = ImageDraw.Draw(t)
    for y in range(0, 16, 4):
        d.line([0, y, 15, y], fill="#5a4a3a")
        off = 0 if (y // 4) % 2 == 0 else 4
        for x in range(off, 16, 8):
            d.line([x, y, x, y + 3], fill="#5a4a3a")
    noise(t, ["#8a7a6a", "#6a5a4a"], 0.12)
    return t


def tile_dirt():
    return base("#7a5a3a", "#6a4a2a", DESERT[2], 0.25)


def tile_nightlight_floor():
    t = tile_carpet(dusty=False)
    noise(t, [LAVENDER, "#9a84b8"], 0.05)
    return t


TILES = [
    # row 0
    tile_carpet, tile_debris, tile_sand, tile_wall_top, tile_wall_face, tile_wall_stain, tile_desk, tile_laptop,
    # row 1
    tile_blood, tile_eyes, tile_stick, tile_glass_door, tile_balcony, tile_city_sky, tile_door, tile_bed,
    # row 2
    tile_cardboard, tile_plant, tile_kitchen, tile_hall, tile_grass, tile_path, tile_bench, tile_tent,
    # row 3
    tile_graffiti_wall, tile_asphalt, tile_concrete, tile_jade_floor, tile_table, tile_screen_wall, tile_chair, tile_elevator,
    # row 4
    tile_hosp_floor, tile_hosp_bed, tile_hosp_wall, tile_platform, tile_rail, tile_rock, tile_desert, tile_car,
    # row 5
    tile_cliff_door, tile_mirror, tile_sticky_wall, tile_frames_broken, tile_stick_circle, tile_tablet, tile_pillar, tile_dark_floor,
    # row 6
    tile_window, tile_couch, tile_kid_bed, tile_cactus, tile_retaining_wall, tile_dirt, tile_nightlight_floor, tile_carpet,
]
TILE_COLS = 8


def build_tileset(path):
    rows = (len(TILES) + TILE_COLS - 1) // TILE_COLS
    sheet = new(TILE_COLS * TILE, rows * TILE)
    for i, fn in enumerate(TILES):
        sheet.paste(fn(), ((i % TILE_COLS) * TILE, (i // TILE_COLS) * TILE))
    sheet.save(path)


# ------------------------------------------------------------- characters
CW, CH = 16, 24


def draw_person(img, ox, oy, facing, frame, coat, hair=HAIR, skin=SKIN, glasses=True, pants="#2b2f3a",
                eyeless=False, style="short", hat=None, mask=False, shoes=OUTLINE):
    """One 16x24 frame. Drawn into a scratch image so the outline is clean."""
    f = new(CW, CH)
    d = ImageDraw.Draw(f)
    bob = 1 if frame in (1, 3) else 0
    step = [0, 1, 0, -1][frame]
    coat_d = shade(coat, 0.72)
    coat_l = shade(coat, 1.18)
    hair_l = shade(hair, 1.3)
    hair_d = shade(hair, 0.7)
    skin_d = shade(skin, 0.85)


    # legs
    if facing in ("left", "right"):
        d.rectangle([5 + step, 18 + bob, 7 + step, 22], fill=pants)
        d.rectangle([8 - step, 18 + bob, 10 - step, 22], fill=shade(pants, 0.8))
        d.rectangle([5 + step, 22, 7 + step, 22], fill=shoes)
        d.rectangle([8 - step, 22, 10 - step, 22], fill=shoes)
    else:
        la = abs(step)
        d.rectangle([5, 18 + bob, 7, 22 - la], fill=pants)
        d.rectangle([8, 18 + bob, 10, 22 - (1 - la if step else 0)], fill=shade(pants, 0.85))
        d.rectangle([5, 22 - la, 7, 22 - la], fill=shoes)
        d.rectangle([8, 22, 10, 22], fill=shoes)

    # body
    if facing in ("left", "right"):
        d.rectangle([5, 10 + bob, 10, 17 + bob], fill=coat)
        d.rectangle([10, 10 + bob, 10, 17 + bob], fill=coat_d)
        ax = 7 if facing == "left" else 8
        d.rectangle([ax, 11 + bob + step, ax, 16 + bob + step], fill=coat_d)
        d.point((ax, 17 + bob + step), fill=skin)
    else:
        d.rectangle([4, 10 + bob, 11, 17 + bob], fill=coat)
        d.rectangle([10, 10 + bob, 11, 17 + bob], fill=coat_d)
        d.rectangle([4, 10 + bob, 5, 17 + bob], fill=coat_l)
        if facing == "down":
            d.rectangle([7, 10 + bob, 8, 12 + bob], fill=coat_l)  # collar
            d.line([7, 13 + bob, 7, 17 + bob], fill=coat_d)
        # arms swing
        d.rectangle([3, 11 + bob + step, 3, 16 + bob + step], fill=coat_d)
        d.rectangle([12, 11 + bob - step, 12, 16 + bob - step], fill=coat_d)
        d.point((3, 17 + bob + step), fill=skin)
        d.point((12, 17 + bob - step), fill=skin)

    # head
    hx0, hx1 = (5, 10) if facing in ("left", "right") else (4, 11)
    d.rectangle([hx0, 3 + bob, hx1, 9 + bob], fill=skin)
    d.rectangle([hx1, 4 + bob, hx1, 9 + bob], fill=skin_d)
    # hair
    d.rectangle([hx0, 2 + bob, hx1, 4 + bob], fill=hair)
    d.rectangle([hx0 + 1, 2 + bob, hx1 - 1, 2 + bob], fill=hair_l)
    if style in ("curly", "long", "bun"):
        d.point((hx0, 5 + bob), fill=hair)
        d.point((hx1, 5 + bob), fill=hair)
    if style == "curly":
        d.point((hx0, 2 + bob), fill=hair_d)
        d.point((hx1, 2 + bob), fill=hair_d)
        d.point((hx0 + 2, 1 + bob), fill=hair)
        d.point((hx1 - 2, 1 + bob), fill=hair)
    if style == "long":
        d.rectangle([hx0, 5 + bob, hx0, 9 + bob], fill=hair)
        d.rectangle([hx1, 5 + bob, hx1, 9 + bob], fill=hair_d)
    if style == "bun":
        d.rectangle([hx0 + 2, 0 + bob, hx1 - 2, 1 + bob], fill=hair)
    if style == "bald":
        d.rectangle([hx0, 2 + bob, hx1, 4 + bob], fill=skin)
        d.rectangle([hx0, 2 + bob, hx1, 2 + bob], fill=hair)
    if facing == "up":
        d.rectangle([hx0, 2 + bob, hx1, 8 + bob], fill=hair)
        d.rectangle([hx0 + 1, 2 + bob, hx1 - 1, 3 + bob], fill=hair_l)
        if style == "bun":
            d.rectangle([hx0 + 2, 0 + bob, hx1 - 2, 1 + bob], fill=hair)
    if hat:
        d.rectangle([hx0, 1 + bob, hx1, 3 + bob], fill=hat)
        d.rectangle([hx0 - 1 if facing != "right" else hx0, 4 + bob, hx1 if facing != "left" else hx1 + 1, 4 + bob], fill=shade(hat, 0.7))
    if mask:
        d.rectangle([hx0, 3 + bob, hx1, 9 + bob], fill=VOID[0])
        d.rectangle([hx0, 2 + bob, hx1, 2 + bob], fill=VOID[1])
        d.point((hx0 + 1, 5 + bob), fill="#3a3a48")
    # face
    if facing != "up" and not mask:
        eye_y = 6 + bob
        eyes = []
        if facing == "down":
            eyes = [(5, 6), (9, 10)]
        elif facing == "left":
            eyes = [(5, 6)]
        else:
            eyes = [(9, 10)]
        if glasses:
            gx0 = hx0 + 1 if facing != "right" else 8
            gx1 = hx1 - 1 if facing != "left" else 7
            d.rectangle([gx0, eye_y, gx1, eye_y + 1], fill=JADE[0])
            for wx, px in eyes:
                d.point((wx, eye_y), fill=JADE[2])
                d.point((px, eye_y + 1), fill=JADE[1])
        else:
            for wx, px in eyes:
                if eyeless:
                    d.rectangle([wx, eye_y, px, eye_y + 1], fill=VOID[0])
                    d.point((px, eye_y + 2), fill=BLOOD[1])
                else:
                    d.point((wx, eye_y), fill=WHITE)
                    d.point((px, eye_y), fill=OUTLINE)
        mx = 7 if facing != "right" else 8
        d.point((mx, 9 + bob), fill=SKIN_SHADE)
        if eyeless:
            d.line([mx - 1, 9 + bob, mx + 1, 9 + bob], fill=BLOOD[0])

    outline(f)
    img.paste(f, (ox, oy), f)


def build_character(path, coat, hair=HAIR, skin=SKIN, glasses=True, pants="#2b2f3a", eyeless=False,
                    style="short", hat=None, mask=False):
    sheet = new(CW * 4, CH * 4)
    for r, facing in enumerate(["down", "left", "right", "up"]):
        for fr in range(4):
            draw_person(sheet, fr * CW, r * CH, facing, fr, coat, hair, skin, glasses, pants, eyeless, style, hat, mask)
    sheet.save(path)


def build_shadow(path):
    img = new(16, 8)
    d = ImageDraw.Draw(img)
    d.ellipse([2, 1, 13, 6], fill=(0, 0, 0, 90))
    img.save(path)


# --------------------------------------------------------------- portraits
def build_portrait(path, coat, hair=HAIR, skin=SKIN, glasses=True, bg=None, eyeless=False, uniform=None,
                   style="short", hat=None, mask=False, smile=False, gauze=False, iris="#3a2a1a", brow_tilt=0):
    p = new(64, 64)
    d = ImageDraw.Draw(p)
    # background: colour wash with diagonal dither
    base_bg = bg or shade(coat, 0.45)
    for y in range(64):
        d.line([0, y, 63, y], fill=mix(base_bg, VOID[0], y / 63))
    for y in range(0, 64):
        for x in range(0, 64):
            if (x + y) % 6 == 0:
                d.point((x, y), fill=mix(base_bg, VOID[1], 0.5))

    fig = new(64, 64)
    f = ImageDraw.Draw(fig)
    coat_d = shade(coat, 0.7)
    coat_l = shade(coat, 1.2)
    skin_d = shade(skin, 0.82)
    hair_d = shade(hair, 0.65)
    hair_l = shade(hair, 1.35)
    # shoulders / coat
    f.rounded_rectangle([6, 46, 57, 70], radius=8, fill=coat)
    f.rectangle([6, 46, 18, 63], fill=coat_l)
    f.rectangle([46, 46, 57, 63], fill=coat_d)
    f.polygon([(24, 46), (32, 56), (40, 46)], fill=coat_d)  # lapels
    if uniform:
        f.rectangle([28, 48, 35, 63], fill=uniform)
    # neck
    f.rectangle([27, 38, 36, 49], fill=skin_d)
    # head with jaw
    f.rounded_rectangle([18, 8, 45, 38], radius=7, fill=skin)
    f.polygon([(19, 30), (45, 30), (40, 43), (24, 43)], fill=skin)
    f.rounded_rectangle([18, 8, 45, 38], radius=7, outline=None)
    # ears
    f.rectangle([16, 24, 18, 30], fill=skin_d)
    f.rectangle([45, 24, 47, 30], fill=skin_d)
    # shading on the right side of the face
    for y in range(10, 43):
        for x in range(39, 46):
            if (x + y) % 2 == 0:
                f.point((x, y), fill=skin_d)
    # hair
    if style != "bald":
        f.rounded_rectangle([16, 4, 47, 19], radius=7, fill=hair)
        f.rectangle([16, 14, 20, 26], fill=hair)
        f.rectangle([43, 14, 47, 26], fill=hair_d)
        f.rectangle([20, 6, 40, 8], fill=hair_l)
    if style == "curly":
        for x in range(15, 48, 4):
            f.ellipse([x, 2, x + 4, 7], fill=hair)
            f.point((x + 1, 3), fill=hair_l)
        f.ellipse([13, 10, 19, 18], fill=hair)
        f.ellipse([44, 10, 50, 18], fill=hair_d)
    if style == "long":
        f.rectangle([14, 14, 20, 46], fill=hair)
        f.rectangle([43, 14, 49, 46], fill=hair_d)
    if style == "bun":
        f.ellipse([24, 0, 40, 10], fill=hair)
        f.ellipse([27, 1, 33, 5], fill=hair_l)
        f.rectangle([16, 14, 18, 22], fill=hair)
        f.rectangle([45, 14, 47, 22], fill=hair_d)
    if style == "bald":
        f.rectangle([16, 10, 19, 24], fill=hair)
        f.rectangle([44, 10, 47, 24], fill=hair_d)
    if hat:
        f.rounded_rectangle([14, 2, 49, 16], radius=5, fill=hat)
        f.rectangle([12, 15, 51, 18], fill=shade(hat, 0.7))
        f.rectangle([20, 4, 44, 6], fill=shade(hat, 1.2))
    # brows
    f.line([22, 23 + brow_tilt, 29, 23], fill=hair_d, width=2)
    f.line([34, 23, 41, 23 + brow_tilt], fill=hair_d, width=2)
    # eyes
    if mask:
        f.rounded_rectangle([18, 8, 45, 43], radius=9, fill=VOID[0])
        f.line([22, 14, 30, 10], fill="#2a2a38", width=2)
        f.ellipse([24, 20, 39, 30], outline="#1c1c28")
    elif eyeless or gauze:
        if gauze:
            f.rectangle([17, 22, 46, 32], fill=CLINICAL[0])
            f.line([17, 26, 46, 26], fill=CLINICAL[1])
            f.line([17, 30, 46, 30], fill=CLINICAL[1])
            f.ellipse([22, 24, 29, 30], fill=mix(CLINICAL[0], BLOOD[1], 0.5))
            f.ellipse([34, 24, 41, 30], fill=mix(CLINICAL[0], BLOOD[1], 0.5))
        else:
            for x in (21, 33):
                f.ellipse([x, 24, x + 9, 31], fill=VOID[0])
                f.ellipse([x, 24, x + 9, 31], outline=BLOOD[0])
                f.line([x + 4, 31, x + 4, 37], fill=BLOOD[1])
                f.point((x + 5, 38), fill=BLOOD[1])
    else:
        for x in (22, 34):
            f.rectangle([x, 25, x + 7, 30], fill=WHITE)
            f.rectangle([x + 2, 26, x + 4, 30], fill=iris)
            f.point((x + 3, 27), fill=OUTLINE)
            f.point((x + 2, 26), fill=WHITE)
            f.line([x, 25, x + 7, 25], fill=skin_d)
        if glasses:
            for x in (20, 33):
                f.rectangle([x, 23, x + 10, 32], fill=(47, 161, 132, 70))
                f.rounded_rectangle([x, 23, x + 10, 32], radius=2, outline=JADE[1])
                f.line([x + 2, 31, x + 8, 25], fill=(127, 224, 192, 120))
            f.line([30, 27, 33, 27], fill=JADE[1])
            f.line([15, 25, 20, 26], fill=JADE[0])
            f.line([43, 26, 48, 25], fill=JADE[0])
    # nose and mouth
    f.line([31, 28, 31, 34], fill=skin_d)
    f.line([31, 34, 33, 34], fill=skin_d)
    if smile:
        f.arc([25, 32, 38, 41], 0, 180, fill=BLOOD[0], width=2)
        f.line([27, 37, 36, 37], fill=WHITE)
    elif not mask:
        f.line([27, 38, 36, 38], fill=skin_d, width=1)
        f.line([28, 39, 35, 39], fill=shade(skin, 0.7))
    outline(fig)
    p.paste(fig, (0, 0), fig)
    p.save(path)


def build_portrait_ora(path):
    p = new(64, 64)
    d = ImageDraw.Draw(p)
    for y in range(64):
        d.line([0, y, 63, y], fill=mix("#0f2a24", VOID[0], y / 63))
    fig = new(64, 64)
    f = ImageDraw.Draw(fig)
    f.rounded_rectangle([14, 8, 49, 48], radius=12, fill=JADE[0])
    f.rounded_rectangle([18, 12, 45, 44], radius=10, fill="#163f36")
    f.rectangle([22, 22, 41, 30], fill=JADE[1])
    f.rectangle([24, 24, 39, 28], fill=JADE[2])
    for x in range(26, 38, 3):
        f.line([x, 24, x, 28], fill=JADE[1])
    f.line([20, 36, 43, 36], fill=JADE[2])
    f.line([24, 39, 39, 39], fill=JADE[1])
    f.rectangle([26, 48, 37, 63], fill=JADE[0])
    f.rounded_rectangle([8, 54, 55, 70], radius=8, fill="#163f36")
    outline(fig, "#0a1f1a")
    p.paste(fig, (0, 0), fig)
    p.save(path)


def build_portrait_bot(path):
    p = new(64, 64)
    d = ImageDraw.Draw(p)
    for y in range(64):
        d.line([0, y, 63, y], fill=mix("#3a4048", VOID[0], y / 63))
    fig = new(64, 64)
    f = ImageDraw.Draw(fig)
    f.rounded_rectangle([12, 10, 51, 44], radius=6, fill=CLINICAL[1])
    f.rounded_rectangle([16, 14, 47, 40], radius=4, fill=VOID[1])
    f.rectangle([22, 22, 27, 26], fill=JADE[2])
    f.rectangle([36, 22, 41, 26], fill=JADE[2])
    f.arc([24, 26, 39, 36], 0, 180, fill=JADE[2], width=2)
    f.rectangle([28, 44, 35, 52], fill=CLINICAL[2])
    f.rounded_rectangle([10, 52, 53, 70], radius=6, fill=CLINICAL[1])
    f.rectangle([30, 2, 33, 10], fill=CLINICAL[2])
    f.ellipse([29, 0, 34, 4], fill=BLOOD[1])
    outline(fig)
    p.paste(fig, (0, 0), fig)
    p.save(path)


def build_portrait_psyon(path):
    p = new(64, 64)
    d = ImageDraw.Draw(p)
    fill(p, VOID[0])
    for _ in range(60):
        d.point((random.randint(0, 63), random.randint(0, 63)), fill=VOID[1])
    d.ellipse([6, 20, 57, 44], outline=JADE[2], width=2)
    d.ellipse([20, 22, 43, 42], outline=JADE[1], width=2)
    d.ellipse([27, 27, 36, 37], fill=BLOOD[1])
    d.point((30, 29), fill=WHITE)
    p.save(path)


# ---------------------------------------------------------------- symbols
def build_eye_glyph(path, size=32, color=WHITE, bg=TRANSPARENT):
    g = Image.new("RGBA", (size, size), bg)
    d = ImageDraw.Draw(g)
    m = size // 2
    d.ellipse([1, m - size // 4, size - 2, m + size // 4], outline=color)
    d.ellipse([m - size // 5, m - size // 5, m + size // 5, m + size // 5], outline=color)
    d.ellipse([m - size // 9, m - size // 9, m + size // 9, m + size // 9], outline=color)
    g.save(path)


def build_panel(path):
    """9-slice frame for dialogue boxes: 24x24, 6px borders."""
    img = new(24, 24)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, 23, 23], fill=(5, 6, 8, 240))
    d.rectangle([1, 1, 22, 22], outline=JADE[0])
    d.rectangle([2, 2, 21, 21], outline=JADE[1])
    d.rectangle([3, 3, 20, 20], outline="#0d1f1b")
    for x, y in ((1, 1), (22, 1), (1, 22), (22, 22)):
        d.rectangle([x - 1 if x > 1 else x, y - 1 if y > 1 else y, x + 1 if x == 1 else x, y + 1 if y == 1 else y], fill=JADE[2])
    img.save(path)


def build_panel_dark(path):
    img = new(24, 24)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, 23, 23], fill=(11, 18, 16, 250))
    d.rectangle([0, 0, 23, 23], outline="#1f6f5c")
    d.rectangle([1, 1, 22, 22], outline="#0f2a24")
    d.rectangle([2, 2, 21, 2], fill=JADE[1])
    img.save(path)


def build_cursor(path):
    img = new(8, 8)
    d = ImageDraw.Draw(img)
    d.polygon([(1, 1), (6, 4), (1, 7)], fill=JADE[2])
    img.save(path)


def build_title_bg(path):
    """480x270 title card: the tower against a bruised sky, the eye above."""
    img = new(480, 270)
    d = ImageDraw.Draw(img)
    for y in range(270):
        d.line([0, y, 479, y], fill=mix("#0b0e1a", "#4a2a3a", y / 269))
    for _ in range(140):
        d.point((random.randint(0, 479), random.randint(0, 160)), fill=random.choice([CLINICAL[1], "#8a8aa0"]))
    # desert floor
    d.rectangle([0, 215, 479, 269], fill="#3a2418")
    noise(img, ["#4a3020", "#2a1a10"], 0.2, (0, 215, 479, 269))
    # city blocks
    for x in range(0, 480, 14):
        h = random.randint(20, 70)
        d.rectangle([x, 215 - h, x + 11, 215], fill="#1a1c28")
        for wy in range(215 - h + 3, 213, 5):
            for wx in range(x + 2, x + 10, 4):
                if random.random() < 0.3:
                    d.point((wx, wy), fill=DESERT[2])
    # the tower: a donut on a stick
    d.rectangle([232, 95, 247, 215], fill="#1f3a36")
    d.rectangle([236, 95, 239, 215], fill="#2fa184")
    d.ellipse([200, 60, 279, 110], fill="#1f6f5c")
    d.ellipse([214, 70, 265, 100], fill="#0b0e1a")
    d.ellipse([204, 62, 275, 80], outline=JADE[2])
    for y in range(100, 215, 6):
        d.line([233, y, 246, y], fill="#112622")
    # the eye, faint, over the sky
    d.ellipse([140, 10, 340, 100], outline=(198, 40, 40, 90), width=2)
    d.ellipse([205, 25, 275, 85], outline=(198, 40, 40, 70), width=2)
    img.save(path)


def build_psyon_room(path):
    img = new(96, 64)
    fill(img, VOID[1])
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, 95, 35], fill="#7f8389")
    for x in range(0, 96, 6):
        d.line([x, 0, x, 35], fill="#858a90")
    d.rectangle([0, 36, 95, 63], fill="#7d5f42")
    noise(img, [ROT[0], DESERT[2], CLINICAL[0]], 0.2, (0, 36, 95, 63))
    d.rectangle([30, 28, 66, 46], fill="#a07a4a")
    d.rectangle([30, 28, 66, 30], fill="#b58a56")
    d.rectangle([40, 18, 56, 34], fill=JADE[0])
    d.rectangle([54, 18, 56, 34], fill="#174f42")
    d.ellipse([43, 9, 53, 19], fill=SKIN)
    d.rectangle([43, 8, 53, 12], fill=HAIR)
    d.rectangle([28, 14, 38, 26], fill="#2a2d33")
    d.rectangle([29, 15, 37, 23], fill=JADE[1])
    noise(img, [VOID[0]], 0.05)
    img.save(path)


def build_psyon_eye(path):
    img = new(96, 64)
    fill(img, "#8d9196")
    d = ImageDraw.Draw(img)
    noise(img, ["#848990", "#9a9fa5"], 0.1)
    for r, col in ((28, "#6b4a2a"), (18, "#9a7048")):
        d.ellipse([48 - r * 1.5, 32 - r, 48 + r * 1.5, 32 + r], outline=col, width=2)
    for a in range(0, 360, 20):
        import math
        x = 48 + math.cos(math.radians(a)) * 42
        y = 32 + math.sin(math.radians(a)) * 28
        d.line([x - 2, y, x + 2, y], fill="#5a3a1a")
    d.rectangle([37, 29, 59, 35], fill=VOID[0])
    d.text((39, 28), "CARL", fill=JADE[2])
    img.save(path)


def build_psyon_map(path):
    img = new(96, 64)
    fill(img, VOID[0])
    d = ImageDraw.Draw(img)
    for x in range(4, 60, 6):
        d.line([(x, 4), (x, 58)], fill="#4a5560")
    for y in range(4, 60, 6):
        d.line([(4, y), (58, y)], fill="#4a5560")
    d.ellipse([27, 27, 35, 35], fill=JADE[0], outline=JADE[2])
    for _ in range(40):
        x, y = random.randint(5, 57), random.randint(5, 57)
        d.rectangle([x, y, x + 1, y + 1], fill=CLINICAL[0])
    for x in range(62, 94, 3):
        d.point((x, random.randint(30, 34)), fill=DESERT[0])
    for i in range(6):
        d.text((62, 4 + i * 9), "ᛟᛇᚦ"[i % 3], fill="#6f7a84")
    d.ellipse([80, 24, 92, 32], outline=BLOOD[1])
    d.ellipse([84, 26, 88, 30], fill=BLOOD[1])
    img.save(path)


def build_psyon_square(path):
    img = new(96, 64)
    fill(img, VOID[0])
    d = ImageDraw.Draw(img)
    d.rectangle([24, 8, 72, 56], fill=BLACK, outline="#1a1a22")
    img.save(path)


def build_psyon_tower(path):
    img = new(96, 64)
    fill(img, "#1a1430")
    d = ImageDraw.Draw(img)
    d.polygon([(48, 4), (88, 24), (88, 44), (48, 60), (8, 44), (8, 24)], fill="#241c44", outline=LAVENDER)
    for i, col in enumerate(["#b89ad9", "#c0c8d0", "#f5d6a0", "#7fe0c0", "#e9a060"]):
        x = 20 + i * 14
        d.rectangle([x, 26, x + 6, 44], fill=col)
        d.ellipse([x, 18, x + 6, 25], fill=col)
        d.rectangle([x, 28, x + 6, 44], fill=(255, 255, 255, 40))
    noise(img, ["#2a2444", LAVENDER], 0.08)
    img.save(path)


def build_psyon_footage(path):
    img = new(96, 64)
    fill(img, "#1c1f24")
    d = ImageDraw.Draw(img)
    d.rectangle([0, 44, 95, 63], fill="#2a2d33")
    d.rectangle([30, 22, 44, 46], fill="#d8d3bd")
    d.ellipse([31, 12, 43, 24], fill=SKIN)
    d.rectangle([33, 16, 35, 18], fill=VOID[0])
    d.rectangle([39, 16, 41, 18], fill=VOID[0])
    d.rectangle([54, 14, 68, 50], fill=VOID[0])
    d.ellipse([55, 4, 67, 16], fill="#3a3a44")
    d.line([57, 9, 65, 9], fill="#5a5a68")
    for y in range(0, 64, 2):
        d.line([0, y, 95, y], fill=(0, 0, 0, 50))
    noise(img, [CLINICAL[0], VOID[0]], 0.1)
    d.text((2, 2), "REC 02:14:07", fill=BLOOD[1])
    img.save(path)


def main():
    for sub in ("tiles", "sprites", "portraits", "ui", "psyon"):
        os.makedirs(os.path.join(ROOT, sub), exist_ok=True)

    build_tileset(os.path.join(ROOT, "tiles", "tiles.png"))

    people = {
        "carl": dict(coat=JADE[0], hair=HAIR, style="curly"),
        "officer": dict(coat="#1f2a44", hair="#2a2a2a", glasses=False, pants="#1f2a44", hat="#1f2a44"),
        "lynx": dict(coat="#3a3a4a", hair="#1a1a1a", glasses=True, style="long"),
        "eyeless": dict(coat=VOID[1], hair="#2a2a2a", glasses=False, eyeless=True),
        "seth": dict(coat="#d9ff3a", hair="#6a4a2a", glasses=False, pants="#3a3a3a", style="long", hat="#c8743a"),
        "tyson": dict(coat="#6f6a5a", hair="#3a3a3a", glasses=False, pants="#4a4a4a", style="bald"),
        "monica": dict(coat=LAVENDER, hair="#1a1a1a", glasses=False, pants="#2b2f3a", style="curly"),
        "mira": dict(coat="#f5d6a0", hair="#1a1a1a", glasses=False, pants=LAVENDER, style="curly"),
        "ezra": dict(coat=JADE[1], hair=HAIR, glasses=False, pants="#2b2f3a", style="curly"),
        "turan": dict(coat=VOID[1], hair="#6f6f6f", glasses=True, pants=VOID[1], style="bun"),
        "emmet": dict(coat="#6f7a84", hair="#c62828", glasses=True, pants="#2b2f3a"),
        "forner": dict(coat="#8a6a4a", hair="#b9c2c9", glasses=False, pants="#4a3a2a", style="bald"),
        "nurse": dict(coat=CLINICAL[0], hair="#4a2e1a", glasses=True, pants=CLINICAL[1], style="bun"),
        "masked": dict(coat=VOID[0], hair=VOID[0], glasses=False, pants=VOID[0], mask=True),
        "bot": dict(coat=CLINICAL[1], hair=CLINICAL[2], skin=CLINICAL[1], glasses=False, pants=CLINICAL[1], style="bald"),
    }
    for name, kw in people.items():
        build_character(os.path.join(ROOT, "sprites", name + ".png"), **kw)
    build_shadow(os.path.join(ROOT, "sprites", "shadow.png"))

    portrait_extra = {
        "carl": dict(iris="#3a5a7a", brow_tilt=1),
        "officer": dict(uniform="#b9c2c9"),
        "mira": dict(iris="#4a2a1a"),
        "monica": dict(iris="#4a2a1a"),
        "turan": dict(iris="#2a2a2a"),
        "eyeless": dict(),
        "masked": dict(),
    }
    for name, kw in people.items():
        pkw = {k: v for k, v in kw.items() if k != "pants"}
        pkw.update(portrait_extra.get(name, {}))
        if name == "bot":
            build_portrait_bot(os.path.join(ROOT, "portraits", "bot.png"))
            continue
        build_portrait(os.path.join(ROOT, "portraits", name + ".png"), **pkw)
    build_portrait(os.path.join(ROOT, "portraits", "carl_noglasses.png"), coat=JADE[0], style="curly", glasses=False, iris="#3a5a7a", brow_tilt=1)
    build_portrait(os.path.join(ROOT, "portraits", "dufredy.png"), coat="#d8d3bd", hair=CLINICAL[1], glasses=False, gauze=True, smile=True, style="bald", bg="#2a2420")
    build_portrait_ora(os.path.join(ROOT, "portraits", "ora.png"))
    build_portrait_psyon(os.path.join(ROOT, "portraits", "psyon.png"))

    build_eye_glyph(os.path.join(ROOT, "ui", "eye_glyph.png"))
    build_eye_glyph(os.path.join(ROOT, "ui", "eye_glyph_red.png"), color=BLOOD[1])
    build_eye_glyph(os.path.join(ROOT, "ui", "icon.png"), size=128, color=JADE[2], bg=VOID[0])
    build_panel(os.path.join(ROOT, "ui", "panel.png"))
    build_panel_dark(os.path.join(ROOT, "ui", "panel_dark.png"))
    build_cursor(os.path.join(ROOT, "ui", "cursor.png"))
    build_title_bg(os.path.join(ROOT, "ui", "title.png"))
    build_psyon_room(os.path.join(ROOT, "psyon", "room.png"))
    build_psyon_eye(os.path.join(ROOT, "psyon", "eye.png"))
    build_psyon_map(os.path.join(ROOT, "psyon", "map.png"))
    build_psyon_square(os.path.join(ROOT, "psyon", "square.png"))
    build_psyon_tower(os.path.join(ROOT, "psyon", "tower.png"))
    build_psyon_footage(os.path.join(ROOT, "psyon", "footage.png"))
    print("art generated")


if __name__ == "__main__":
    main()
