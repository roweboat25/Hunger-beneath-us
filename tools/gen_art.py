#!/usr/bin/env python3
"""Generates placeholder pixel art for The Hunger Beneath Us.

Every sheet here is a stand-in drawn from the palette in the design doc.
Replace any PNG in assets/ with hand-drawn art of the same size and the
game picks it up without code changes.
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
TRANSPARENT = (0, 0, 0, 0)

random.seed(7)


def new(w, h):
    return Image.new("RGBA", (w, h), TRANSPARENT)


def fill(img, color):
    ImageDraw.Draw(img).rectangle([0, 0, img.width - 1, img.height - 1], fill=color)


def noise(img, colors, density, box=None):
    d = ImageDraw.Draw(img)
    x0, y0, x1, y1 = box or (0, 0, img.width - 1, img.height - 1)
    for _ in range(int((x1 - x0 + 1) * (y1 - y0 + 1) * density)):
        d.point((random.randint(x0, x1), random.randint(y0, y1)), fill=random.choice(colors))


# ---------------------------------------------------------------- tiles
TILE = 16


def tile_carpet(dusty=True):
    t = new(TILE, TILE)
    fill(t, ROT[1])
    noise(t, [ROT[0], "#9a7a58"], 0.25)
    if dusty:
        noise(t, [DESERT[2]], 0.08)
    return t


def tile_debris():
    t = tile_carpet()
    d = ImageDraw.Draw(t)
    for _ in range(3):
        x, y = random.randint(0, 11), random.randint(0, 11)
        d.rectangle([x, y, x + random.randint(2, 4), y + random.randint(1, 3)],
                    fill=random.choice([CLINICAL[0], DESERT[1], "#d9d2a8"]))
    noise(t, [DESERT[2]], 0.2)
    return t


def tile_sand():
    t = new(TILE, TILE)
    fill(t, DESERT[2])
    noise(t, [DESERT[1], "#fff0c8"], 0.3)
    return t


def tile_wall_top():
    t = new(TILE, TILE)
    fill(t, "#6b6f73")
    d = ImageDraw.Draw(t)
    d.line([0, 15, 15, 15], fill="#4c5054")
    return t


def tile_wall_face():
    t = new(TILE, TILE)
    fill(t, "#8d9196")  # off-colored gray wallpaper
    d = ImageDraw.Draw(t)
    for y in range(0, 16, 4):
        d.line([0, y, 15, y], fill="#7f8389")
    noise(t, ["#a0a4a9", "#6f7378"], 0.1)
    return t


def tile_wall_stain():
    t = tile_wall_face()
    d = ImageDraw.Draw(t)
    d.ellipse([3, 4, 12, 13], fill="#6e6a5a")
    noise(t, [ROT[2]], 0.15, (3, 4, 12, 13))
    return t


def tile_desk():
    t = new(TILE, TILE)
    fill(t, "#a07a4a")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 2], fill="#b98f5c")
    d.rectangle([0, 13, 15, 15], fill="#6b4f2d")
    return t


def tile_laptop():
    t = tile_desk()
    d = ImageDraw.Draw(t)
    d.rectangle([3, 3, 12, 10], fill="#1a1b1f")
    d.rectangle([4, 4, 11, 8], fill=VOID[1])
    d.rectangle([3, 11, 12, 12], fill="#3a3b40")
    return t


def tile_blood():
    t = tile_carpet()
    d = ImageDraw.Draw(t)
    d.ellipse([2, 3, 13, 13], fill=BLOOD[0])
    noise(t, [BLOOD[1], "#5a0f0f"], 0.3, (2, 3, 13, 13))
    return t


def tile_eyes():
    t = tile_blood()
    d = ImageDraw.Draw(t)
    for cx in (5, 11):
        d.ellipse([cx - 2, 6, cx + 2, 10], fill=WHITE)
        d.point((cx, 8), fill="#3a6ea5")
    return t


def tile_stick():
    t = tile_carpet()
    d = ImageDraw.Draw(t)
    d.line([2, 12, 13, 5], fill="#6b4a2a", width=1)
    d.line([3, 13, 14, 6], fill="#9a7048", width=1)
    return t


def tile_glass_door():
    t = new(TILE, TILE)
    fill(t, "#9fd3e8")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 15], outline="#50606a")
    d.line([7, 0, 7, 15], fill="#50606a")
    d.line([2, 2, 5, 5], fill="#e0f4ff")
    return t


def tile_balcony():
    t = new(TILE, TILE)
    fill(t, "#5f6b78")
    d = ImageDraw.Draw(t)
    for x in range(0, 16, 4):
        d.line([x, 0, x, 15], fill="#4a5461")
    return t


def tile_city_sky():
    t = new(TILE, TILE)
    fill(t, "#6d8fb0")
    d = ImageDraw.Draw(t)
    for x in range(0, 16, 3):
        h = random.randint(4, 12)
        d.rectangle([x, 16 - h, x + 1, 15], fill="#3b4a5c")
        if random.random() < 0.5:
            d.point((x, 16 - h + 2), fill=JADE[2])
    return t


def tile_door():
    t = new(TILE, TILE)
    fill(t, "#4c5054")
    d = ImageDraw.Draw(t)
    d.rectangle([2, 0, 13, 15], fill="#2e3236")
    d.rectangle([3, 1, 12, 14], fill="#3a3e43")
    d.line([3, 7, 12, 7], fill=JADE[1])
    return t


def tile_bed():
    t = new(TILE, TILE)
    fill(t, "#8d8d7a")
    d = ImageDraw.Draw(t)
    d.rectangle([1, 1, 14, 14], fill="#b5b09a")
    d.rectangle([2, 2, 13, 5], fill="#d8d3bd")
    noise(t, [ROT[0]], 0.08)
    return t


def tile_cardboard():
    t = new(TILE, TILE)
    fill(t, "#b08a5a")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 15], outline="#7d6040")
    d.line([0, 8, 15, 8], fill="#7d6040")
    return t


def tile_plant():
    t = tile_carpet(False)
    d = ImageDraw.Draw(t)
    d.rectangle([5, 10, 10, 15], fill="#7a4a2a")
    d.ellipse([2, 2, 13, 11], fill="#3d6b3a")
    d.point((6, 5), fill="#5f9a58")
    return t


def tile_kitchen():
    t = new(TILE, TILE)
    fill(t, CLINICAL[1])
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 3], fill=CLINICAL[0])
    d.rectangle([2, 6, 6, 9], fill="#2e3236")
    return t


def tile_hall():
    t = new(TILE, TILE)
    fill(t, "#4a5a52")
    noise(t, ["#3f4e47", "#56675e"], 0.2)
    return t


TILES = [
    # row 0
    tile_carpet, tile_debris, tile_sand, tile_wall_top, tile_wall_face, tile_wall_stain, tile_desk, tile_laptop,
    # row 1
    tile_blood, tile_eyes, tile_stick, tile_glass_door, tile_balcony, tile_city_sky, tile_door, tile_bed,
    # row 2
    tile_cardboard, tile_plant, tile_kitchen, tile_hall, tile_carpet, tile_carpet, tile_carpet, tile_carpet,
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


def draw_person(img, ox, oy, facing, frame, coat, hair=HAIR, skin=SKIN, glasses=True, pants="#2b2f3a", eyeless=False):
    d = ImageDraw.Draw(img)
    bob = 1 if frame in (1, 3) else 0
    # legs
    step = [0, 1, 0, -1][frame]
    d.rectangle([ox + 5, oy + 18 + bob, ox + 7, oy + 23], fill=pants)
    d.rectangle([ox + 8, oy + 18 + bob, ox + 10, oy + 23], fill=pants)
    if facing in ("left", "right"):
        d.rectangle([ox + 5 + step, oy + 18 + bob, ox + 7 + step, oy + 23], fill=pants)
        d.rectangle([ox + 8 - step, oy + 18 + bob, ox + 10 - step, oy + 23], fill=pants)
    # coat / body
    d.rectangle([ox + 4, oy + 10 + bob, ox + 11, oy + 18 + bob], fill=coat)
    d.rectangle([ox + 3, oy + 11 + bob, ox + 3, oy + 16 + bob], fill=coat)
    d.rectangle([ox + 12, oy + 11 + bob, ox + 12, oy + 16 + bob], fill=coat)
    # hands
    d.point((ox + 3, oy + 17 + bob), fill=skin)
    d.point((ox + 12, oy + 17 + bob), fill=skin)
    # head
    d.rectangle([ox + 4, oy + 3 + bob, ox + 11, oy + 10 + bob], fill=skin)
    # hair
    d.rectangle([ox + 4, oy + 2 + bob, ox + 11, oy + 4 + bob], fill=hair)
    d.point((ox + 4, oy + 5 + bob), fill=hair)
    d.point((ox + 11, oy + 5 + bob), fill=hair)
    if facing == "up":
        d.rectangle([ox + 4, oy + 2 + bob, ox + 11, oy + 8 + bob], fill=hair)
        return
    # eyes
    eye_col = BLACK if not eyeless else VOID[0]
    if facing == "down":
        if glasses:
            d.rectangle([ox + 5, oy + 6 + bob, ox + 10, oy + 7 + bob], fill=JADE[0])
            d.point((ox + 6, oy + 6 + bob), fill=JADE[2])
            d.point((ox + 9, oy + 6 + bob), fill=JADE[2])
        else:
            d.point((ox + 6, oy + 6 + bob), fill=eye_col)
            d.point((ox + 9, oy + 6 + bob), fill=eye_col)
            if eyeless:
                d.rectangle([ox + 5, oy + 6 + bob, ox + 6, oy + 7 + bob], fill=eye_col)
                d.rectangle([ox + 9, oy + 6 + bob, ox + 10, oy + 7 + bob], fill=eye_col)
    elif facing == "left":
        if glasses:
            d.rectangle([ox + 4, oy + 6 + bob, ox + 7, oy + 7 + bob], fill=JADE[0])
            d.point((ox + 5, oy + 6 + bob), fill=JADE[2])
        else:
            d.point((ox + 5, oy + 6 + bob), fill=eye_col)
    elif facing == "right":
        if glasses:
            d.rectangle([ox + 8, oy + 6 + bob, ox + 11, oy + 7 + bob], fill=JADE[0])
            d.point((ox + 10, oy + 6 + bob), fill=JADE[2])
        else:
            d.point((ox + 10, oy + 6 + bob), fill=eye_col)
    # mouth
    d.point((ox + 7, oy + 9 + bob), fill=SKIN_SHADE)


def build_character(path, coat, hair=HAIR, skin=SKIN, glasses=True, pants="#2b2f3a", eyeless=False):
    sheet = new(CW * 4, CH * 4)
    for r, facing in enumerate(["down", "left", "right", "up"]):
        for f in range(4):
            draw_person(sheet, f * CW, r * CH, facing, f, coat, hair, skin, glasses, pants, eyeless)
    sheet.save(path)


# --------------------------------------------------------------- portraits
def build_portrait(path, coat, hair=HAIR, skin=SKIN, glasses=True, bg=VOID[1], eyeless=False, uniform=None):
    p = new(64, 64)
    fill(p, bg)
    d = ImageDraw.Draw(p)
    # shoulders
    d.rectangle([8, 46, 55, 63], fill=coat)
    if uniform:
        d.rectangle([28, 50, 35, 63], fill=uniform)
    # neck
    d.rectangle([27, 40, 36, 48], fill=SKIN_SHADE)
    # head
    d.rounded_rectangle([18, 10, 45, 44], radius=6, fill=skin)
    # hair
    d.rounded_rectangle([17, 6, 46, 20], radius=6, fill=hair)
    d.rectangle([17, 18, 20, 30], fill=hair)
    d.rectangle([43, 18, 46, 30], fill=hair)
    # brows (uneven left brow for Carl handled by caller via hair tweak)
    d.line([22, 24, 29, 24], fill=hair, width=1)
    d.line([34, 23, 41, 24], fill=hair, width=1)
    # eyes
    if eyeless:
        d.rectangle([22, 26, 29, 31], fill=VOID[0])
        d.rectangle([34, 26, 41, 31], fill=VOID[0])
    elif glasses:
        d.rectangle([21, 25, 30, 31], outline=JADE[1], fill="#243a36")
        d.rectangle([33, 25, 42, 31], outline=JADE[1], fill="#243a36")
        d.line([30, 28, 33, 28], fill=JADE[1])
        d.point((23, 27), fill=JADE[2])
        d.point((35, 27), fill=JADE[2])
    else:
        d.rectangle([23, 27, 28, 30], fill=WHITE)
        d.rectangle([35, 27, 40, 30], fill=WHITE)
        d.rectangle([25, 28, 26, 30], fill="#3a2a1a")
        d.rectangle([37, 28, 38, 30], fill="#3a2a1a")
    # nose, mouth
    d.line([31, 30, 31, 35], fill=SKIN_SHADE)
    d.line([27, 39, 36, 39], fill=SKIN_SHADE)
    # dither shading on the right of the face
    for y in range(12, 44, 2):
        for x in range(41, 45, 2):
            d.point((x, y), fill=SKIN_SHADE)
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


def build_psyon_room(path):
    img = new(96, 64)
    fill(img, VOID[1])
    d = ImageDraw.Draw(img)
    # floor and clutter
    d.rectangle([0, 36, 95, 63], fill=ROT[1])
    noise(img, [ROT[0], DESERT[2], CLINICAL[0]], 0.2, (0, 36, 95, 63))
    # walls
    d.rectangle([0, 0, 95, 35], fill="#7f8389")
    # desk
    d.rectangle([34, 30, 62, 44], fill="#a07a4a")
    # slumped man in a Psyonic jacket
    d.rectangle([40, 22, 56, 34], fill=JADE[0])
    d.ellipse([44, 14, 52, 22], fill=SKIN)
    d.rectangle([44, 13, 52, 16], fill=HAIR)
    img.save(path)


def build_psyon_eye(path):
    img = new(96, 64)
    fill(img, "#8d9196")
    d = ImageDraw.Draw(img)
    # sticks taped in two concentric rings inside an oval
    for r, col in ((28, "#6b4a2a"), (18, "#9a7048")):
        d.ellipse([48 - r * 1.5, 32 - r, 48 + r * 1.5, 32 + r], outline=col, width=2)
    # name in the pupil, written as tiny digital ink
    d.rectangle([37, 29, 59, 35], fill=VOID[0])
    d.text((39, 28), "CARL", fill=JADE[2])
    img.save(path)


def main():
    os.makedirs(os.path.join(ROOT, "tiles"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "sprites"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "portraits"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "ui"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "psyon"), exist_ok=True)

    build_tileset(os.path.join(ROOT, "tiles", "apartment.png"))

    build_character(os.path.join(ROOT, "sprites", "carl.png"), coat=JADE[0])
    build_character(os.path.join(ROOT, "sprites", "officer.png"), coat="#1f2a44", hair="#2a2a2a", glasses=False, pants="#1f2a44")
    build_character(os.path.join(ROOT, "sprites", "lynx.png"), coat="#3a3a4a", hair="#1a1a1a", glasses=True)
    build_character(os.path.join(ROOT, "sprites", "eyeless.png"), coat=VOID[1], hair="#2a2a2a", glasses=False, eyeless=True)

    build_portrait(os.path.join(ROOT, "portraits", "carl.png"), coat=JADE[0])
    build_portrait(os.path.join(ROOT, "portraits", "carl_noglasses.png"), coat=JADE[0], glasses=False)
    build_portrait(os.path.join(ROOT, "portraits", "officer.png"), coat="#1f2a44", hair="#2a2a2a", glasses=False, uniform="#b9c2c9")
    build_portrait(os.path.join(ROOT, "portraits", "ora.png"), coat=JADE[1], hair=JADE[0], skin=JADE[2], glasses=False, bg="#0f2a24")
    build_portrait(os.path.join(ROOT, "portraits", "dufredy.png"), coat="#d8d3bd", hair=CLINICAL[1], glasses=False, eyeless=True)

    build_eye_glyph(os.path.join(ROOT, "ui", "eye_glyph.png"))
    build_eye_glyph(os.path.join(ROOT, "ui", "eye_glyph_red.png"), color=BLOOD[1])
    build_eye_glyph(os.path.join(ROOT, "ui", "icon.png"), size=128, color=JADE[2], bg=VOID[0])
    build_psyon_room(os.path.join(ROOT, "psyon", "room.png"))
    build_psyon_eye(os.path.join(ROOT, "psyon", "eye.png"))
    print("art generated")


if __name__ == "__main__":
    main()
