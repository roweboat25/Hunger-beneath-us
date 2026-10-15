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


# ------------------------------------------------ tiles for scenes 2 to 9
def tile_grass():
    t = new(TILE, TILE)
    fill(t, "#5f7a3a")
    noise(t, ["#4e6630", "#7a9a48", DESERT[2]], 0.25)
    return t


def tile_path():
    t = new(TILE, TILE)
    fill(t, "#9a8f7a")
    noise(t, ["#8a7f6a", "#b0a48d", DESERT[2]], 0.3)
    return t


def tile_bench():
    t = tile_path()
    d = ImageDraw.Draw(t)
    d.rectangle([1, 5, 14, 8], fill="#6b5a3a")
    d.rectangle([2, 9, 3, 13], fill="#4a4a4a")
    d.rectangle([12, 9, 13, 13], fill="#4a4a4a")
    return t


def tile_tent():
    t = tile_path()
    d = ImageDraw.Draw(t)
    d.polygon([(1, 14), (8, 2), (15, 14)], fill="#8a6a4a")
    d.polygon([(5, 14), (8, 7), (11, 14)], fill=VOID[1])
    return t


def tile_graffiti_wall():
    t = tile_wall_face()
    d = ImageDraw.Draw(t)
    d.ellipse([1, 4, 14, 12], outline=BLACK)
    d.ellipse([5, 6, 10, 10], outline=BLACK)
    d.point((7, 8), fill=BLACK)
    return t


def tile_asphalt():
    t = new(TILE, TILE)
    fill(t, "#3a3d42")
    noise(t, ["#2f3236", "#474b52", DESERT[2]], 0.2)
    return t


def tile_concrete():
    t = new(TILE, TILE)
    fill(t, "#8d9196")
    noise(t, ["#7d8186", "#9da1a6"], 0.2)
    return t


def tile_jade_floor():
    t = new(TILE, TILE)
    fill(t, "#1b2a2a")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 0], fill="#223838")
    d.rectangle([0, 0, 0, 15], fill="#223838")
    noise(t, ["#1f3030", JADE[0]], 0.05)
    return t


def tile_table():
    t = new(TILE, TILE)
    fill(t, "#4a2e1a")
    noise(t, ["#5a3a24", "#3a2212"], 0.2)
    return t


def tile_screen_wall():
    t = tile_wall_top()
    d = ImageDraw.Draw(t)
    d.rectangle([1, 2, 14, 12], fill=VOID[0])
    for i in range(3):
        d.rectangle([2 + i * 4, 3 + random.randint(0, 4), 4 + i * 4, 11], fill=random.choice(JADE + [BLOOD[1]]))
    return t


def tile_chair():
    t = tile_jade_floor()
    d = ImageDraw.Draw(t)
    d.rectangle([4, 4, 11, 11], fill=VOID[0])
    d.rectangle([4, 3, 11, 4], fill="#2a2a34")
    return t


def tile_elevator():
    t = new(TILE, TILE)
    fill(t, CLINICAL[1])
    d = ImageDraw.Draw(t)
    d.rectangle([2, 1, 13, 15], fill=CLINICAL[2])
    d.rectangle([7, 1, 8, 15], fill=VOID[0])
    d.rectangle([5, 0, 10, 0], fill=JADE[2])
    return t


def tile_hosp_floor():
    t = new(TILE, TILE)
    fill(t, "#d9dcdf")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 15, 0], fill=CLINICAL[1])
    d.rectangle([0, 0, 0, 15], fill=CLINICAL[1])
    return t


def tile_hosp_bed():
    t = tile_hosp_floor()
    d = ImageDraw.Draw(t)
    d.rectangle([2, 1, 13, 14], fill=CLINICAL[0])
    d.rectangle([2, 1, 13, 4], fill="#c8ccd0")
    d.rectangle([3, 6, 12, 13], fill="#9fb3c8")
    return t


def tile_hosp_wall():
    t = new(TILE, TILE)
    fill(t, "#e3e0d6")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 12, 15, 15], fill="#b9b5a8")
    return t


def tile_platform():
    t = tile_concrete()
    d = ImageDraw.Draw(t)
    d.rectangle([0, 13, 15, 14], fill=DESERT[1])
    return t


def tile_rail():
    t = new(TILE, TILE)
    fill(t, "#2a2622")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 3, 15, 4], fill="#8a8a8a")
    d.rectangle([0, 11, 15, 12], fill="#8a8a8a")
    for x in (2, 8, 14):
        d.rectangle([x, 1, x + 1, 14], fill="#5a4a3a")
    return t


def tile_rock():
    t = new(TILE, TILE)
    fill(t, DESERT[0])
    d = ImageDraw.Draw(t)
    d.rounded_rectangle([1, 2, 14, 14], radius=5, fill="#8a4a24")
    d.rounded_rectangle([3, 4, 10, 9], radius=3, fill="#a85a30")
    return t


def tile_desert():
    t = new(TILE, TILE)
    fill(t, DESERT[1])
    noise(t, [DESERT[0], DESERT[2], "#d88a50"], 0.3)
    return t


def tile_car():
    t = tile_desert()
    d = ImageDraw.Draw(t)
    d.rounded_rectangle([0, 3, 15, 12], radius=3, fill="#1a2a44")
    d.rectangle([3, 5, 12, 8], fill=JADE[2])
    d.rectangle([1, 12, 3, 14], fill=BLACK)
    d.rectangle([12, 12, 14, 14], fill=BLACK)
    return t


def tile_cliff_door():
    t = new(TILE, TILE)
    fill(t, "#6a3a1e")
    d = ImageDraw.Draw(t)
    d.rectangle([2, 0, 13, 15], fill="#4a4a50")
    d.ellipse([4, 5, 11, 10], outline=VOID[0])
    d.point((7, 7), fill=VOID[0])
    return t


def tile_mirror():
    t = new(TILE, TILE)
    fill(t, "#2a2a30")
    d = ImageDraw.Draw(t)
    d.ellipse([1, 1, 14, 14], fill="#c0c8d0", outline=CLINICAL[0])
    d.ellipse([4, 3, 8, 7], fill="#e8ecef")
    return t


def tile_sticky_wall():
    t = tile_wall_face()
    d = ImageDraw.Draw(t)
    for x in range(1, 15, 4):
        for y in range(1, 15, 4):
            d.rectangle([x, y, x + 2, y + 2], fill=random.choice(["#f5e07a", "#f5a0a0", "#a0d8f5"]))
    return t


def tile_frames_broken():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.rectangle([3, 7, 7, 9], outline=JADE[0])
    d.rectangle([9, 6, 13, 9], outline=JADE[0])
    d.line([(5, 6), (6, 10)], fill=CLINICAL[0])
    return t


def tile_stick_circle():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.ellipse([1, 2, 14, 13], outline="#9a7048")
    d.ellipse([4, 5, 11, 10], outline="#9a7048")
    d.rectangle([6, 7, 8, 8], fill=BLOOD[1])
    return t


def tile_tablet():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.rectangle([3, 4, 12, 11], fill=VOID[0])
    d.rectangle([4, 5, 11, 10], fill=JADE[0])
    return t


def tile_pillar():
    t = new(TILE, TILE)
    fill(t, "#5a5e63")
    d = ImageDraw.Draw(t)
    d.rectangle([0, 0, 2, 15], fill="#45494e")
    d.rectangle([13, 0, 15, 15], fill="#45494e")
    return t


def tile_dark_floor():
    t = new(TILE, TILE)
    fill(t, "#101014")
    noise(t, ["#15151c", "#0b0b0e"], 0.2)
    return t


def tile_window():
    t = tile_wall_face()
    d = ImageDraw.Draw(t)
    d.rectangle([2, 1, 13, 10], fill="#e9a060")
    d.rectangle([2, 7, 13, 10], fill="#c8743a")
    for x in (4, 8, 11):
        d.rectangle([x, 8, x, 9], fill=VOID[1])
    return t


def tile_couch():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.rectangle([1, 4, 14, 13], fill="#3a4a5a")
    d.rectangle([1, 4, 14, 6], fill="#2a3a4a")
    return t


def tile_kid_bed():
    t = tile_carpet(dusty=False)
    d = ImageDraw.Draw(t)
    d.rectangle([2, 1, 13, 14], fill=LAVENDER)
    d.rectangle([2, 1, 13, 4], fill=CLINICAL[0])
    return t


def tile_cactus():
    t = tile_desert()
    d = ImageDraw.Draw(t)
    d.rectangle([7, 2, 9, 14], fill="#3f7a3a")
    d.rectangle([3, 6, 5, 10], fill="#3f7a3a")
    d.rectangle([3, 6, 7, 7], fill="#3f7a3a")
    return t


def tile_retaining_wall():
    t = new(TILE, TILE)
    fill(t, "#7a6a5a")
    noise(t, ["#6a5a4a", "#8a7a6a"], 0.2)
    d = ImageDraw.Draw(t)
    d.rectangle([0, 7, 15, 7], fill="#5a4a3a")
    return t


def tile_dirt():
    t = new(TILE, TILE)
    fill(t, "#7a5a3a")
    noise(t, ["#6a4a2a", DESERT[2]], 0.25)
    return t


def tile_nightlight_floor():
    t = tile_carpet(dusty=False)
    noise(t, [LAVENDER], 0.05)
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


def build_psyon_map(path):
    """Monochrome map of Silico with a red eye far out in the desert."""
    img = new(96, 64)
    fill(img, VOID[0])
    d = ImageDraw.Draw(img)
    for x in range(4, 60, 6):
        d.line([(x, 4), (x, 58)], fill="#6f7a84")
    for y in range(4, 60, 6):
        d.line([(4, y), (58, y)], fill="#6f7a84")
    d.ellipse([27, 27, 35, 35], fill=JADE[0], outline=JADE[2])
    for _ in range(40):
        x, y = random.randint(5, 57), random.randint(5, 57)
        d.rectangle([x, y, x + 1, y + 1], fill=CLINICAL[0])
    for x in range(62, 94, 3):
        d.point((x, random.randint(30, 34)), fill=DESERT[0])
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
    """Mira's council: five blurred figures in a hexagonal chamber."""
    img = new(96, 64)
    fill(img, "#1a1430")
    d = ImageDraw.Draw(img)
    d.polygon([(48, 4), (88, 24), (88, 44), (48, 60), (8, 44), (8, 24)], outline=LAVENDER)
    for i, col in enumerate(["#b89ad9", "#c0c8d0", "#f5d6a0", "#7fe0c0", "#e9a060"]):
        x = 20 + i * 14
        d.rectangle([x, 26, x + 6, 44], fill=col)
        d.ellipse([x, 18, x + 6, 25], fill=col)
    noise(img, ["#2a2444", LAVENDER], 0.08)
    img.save(path)


def build_psyon_footage(path):
    """Three seconds of camera footage: Dufredy and the masked figure."""
    img = new(96, 64)
    fill(img, "#1c1f24")
    d = ImageDraw.Draw(img)
    d.rectangle([0, 44, 95, 63], fill="#2a2d33")
    d.rectangle([30, 22, 44, 46], fill="#d8d3bd")
    d.ellipse([31, 12, 43, 24], fill=SKIN)
    d.rectangle([34, 16, 35, 17], fill=BLACK)
    d.rectangle([39, 16, 40, 17], fill=BLACK)
    d.rectangle([54, 14, 68, 50], fill=VOID[0])
    d.ellipse([55, 4, 67, 16], fill="#3a3a44")
    noise(img, [CLINICAL[0], VOID[0]], 0.12)
    d.text((2, 2), "REC 02:14:07", fill=BLOOD[1])
    img.save(path)


def main():
    os.makedirs(os.path.join(ROOT, "tiles"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "sprites"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "portraits"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "ui"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "psyon"), exist_ok=True)

    build_tileset(os.path.join(ROOT, "tiles", "tiles.png"))

    build_character(os.path.join(ROOT, "sprites", "carl.png"), coat=JADE[0])
    build_character(os.path.join(ROOT, "sprites", "officer.png"), coat="#1f2a44", hair="#2a2a2a", glasses=False, pants="#1f2a44")
    build_character(os.path.join(ROOT, "sprites", "lynx.png"), coat="#3a3a4a", hair="#1a1a1a", glasses=True)
    build_character(os.path.join(ROOT, "sprites", "eyeless.png"), coat=VOID[1], hair="#2a2a2a", glasses=False, eyeless=True)

    build_portrait(os.path.join(ROOT, "portraits", "carl.png"), coat=JADE[0])
    build_portrait(os.path.join(ROOT, "portraits", "carl_noglasses.png"), coat=JADE[0], glasses=False)
    build_portrait(os.path.join(ROOT, "portraits", "officer.png"), coat="#1f2a44", hair="#2a2a2a", glasses=False, uniform="#b9c2c9")
    build_portrait(os.path.join(ROOT, "portraits", "ora.png"), coat=JADE[1], hair=JADE[0], skin=JADE[2], glasses=False, bg="#0f2a24")
    build_portrait(os.path.join(ROOT, "portraits", "dufredy.png"), coat="#d8d3bd", hair=CLINICAL[1], glasses=False, eyeless=True)

    people = {
        "seth": dict(coat="#d9ff3a", hair="#6a4a2a", glasses=False, pants="#3a3a3a"),
        "tyson": dict(coat="#6f6a5a", hair="#3a3a3a", glasses=False, pants="#4a4a4a"),
        "monica": dict(coat=LAVENDER, hair="#1a1a1a", glasses=False, pants="#2b2f3a"),
        "mira": dict(coat="#f5d6a0", hair="#1a1a1a", glasses=False, pants=LAVENDER),
        "ezra": dict(coat=JADE[1], hair=HAIR, glasses=False, pants="#2b2f3a"),
        "turan": dict(coat=VOID[1], hair="#6f6f6f", glasses=True, pants=VOID[1]),
        "emmet": dict(coat="#6f7a84", hair="#c62828", glasses=True, pants="#2b2f3a"),
        "forner": dict(coat="#8a6a4a", hair="#b9c2c9", glasses=False, pants="#4a3a2a"),
        "nurse": dict(coat=CLINICAL[0], hair="#4a2e1a", glasses=True, pants=CLINICAL[1]),
        "masked": dict(coat=VOID[0], hair=VOID[0], glasses=False, pants=VOID[0], eyeless=True),
        "bot": dict(coat=CLINICAL[1], hair=CLINICAL[2], skin=CLINICAL[1], glasses=False, pants=CLINICAL[1]),
    }
    for name, kw in people.items():
        build_character(os.path.join(ROOT, "sprites", name + ".png"), **kw)
        pkw = {k: v for k, v in kw.items() if k != "pants"}
        build_portrait(os.path.join(ROOT, "portraits", name + ".png"), **pkw)
    build_portrait(os.path.join(ROOT, "portraits", "lynx.png"), coat="#3a3a4a", hair="#1a1a1a", glasses=True)
    build_portrait(os.path.join(ROOT, "portraits", "psyon.png"), coat=VOID[0], hair=VOID[0], skin=VOID[1], glasses=False, bg=VOID[0])
    build_eye_glyph(os.path.join(ROOT, "ui", "eye_glyph.png"))
    build_eye_glyph(os.path.join(ROOT, "ui", "eye_glyph_red.png"), color=BLOOD[1])
    build_eye_glyph(os.path.join(ROOT, "ui", "icon.png"), size=128, color=JADE[2], bg=VOID[0])
    build_psyon_room(os.path.join(ROOT, "psyon", "room.png"))
    build_psyon_eye(os.path.join(ROOT, "psyon", "eye.png"))
    build_psyon_map(os.path.join(ROOT, "psyon", "map.png"))
    build_psyon_square(os.path.join(ROOT, "psyon", "square.png"))
    build_psyon_tower(os.path.join(ROOT, "psyon", "tower.png"))
    build_psyon_footage(os.path.join(ROOT, "psyon", "footage.png"))
    print("art generated")


if __name__ == "__main__":
    main()
