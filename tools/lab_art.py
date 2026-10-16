#!/usr/bin/env python3
"""The facility behind the mirror (book chapters 10 to 14): the entrance hall
with its obsidian eye and Ionware monitors, Sublevel 1's office floor,
Sublevel Two's housing pens and observation room, and the hangar with the
altar, the mural and the congregation. Writes props into assets/props
(+ props.json), army-green and black brick into the tileset, a robed
congregation sprite sheet and Eren Elontiel's sheet into assets/sprites,
and two portraits. Run after arcade_art.py and before gen_maps.py."""
import json
import os
import random
from PIL import Image, ImageDraw

from redrock_art import (PROPS_DIR, TILES_DIR, ROOT, T, OUT, AMBER, TEAL, PAINT, new, glow, save_prop,
                         stone_noise)

RUST = (150, 58, 34)
STEEL = (120, 126, 140)
STEEL_D = (70, 74, 86)
LEATHER = (22, 20, 24)
GREEN = (74, 86, 52)
GREEN_D = (48, 58, 34)
GREEN_L = (98, 110, 70)
BLACK_BRICK = (24, 22, 26)
BLACK_BRICK_D = (10, 9, 12)
BLACK_BRICK_L = (40, 38, 44)
IONWARE = (90, 200, 255)
SPRITES = os.path.join(ROOT, "assets", "sprites")
PORTRAITS = os.path.join(ROOT, "assets", "portraits")


def screen(d, box, color, lines=3, seed=1):
    """A lit monitor: dark glass with a few rows of text-coloured pixels."""
    x0, y0, x1, y1 = box
    d.rectangle(box, fill=(8, 10, 14, 255), outline=(60, 64, 76, 255))
    r = random.Random(seed)
    for i in range(lines):
        y = y0 + 3 + i * 4
        if y > y1 - 2:
            break
        w = r.randint(4, max(5, (x1 - x0) - 6))
        d.line((x0 + 2, y, x0 + 2 + w, y), fill=color + (255,))


# ------------------------------------------------------------ entrance hall
def monitor_bank(registry):
    """A wall of Ionware monitors, every one on, every one showing the eye."""
    im = new(96, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 40, 95, 47), fill=STEEL_D + (255,), outline=OUT + (255,))
    g = new(96, 48)
    gd = ImageDraw.Draw(g)
    for i in range(3):
        x = 2 + i * 32
        d.rectangle((x, 4, x + 29, 38), fill=(30, 32, 40, 255), outline=OUT + (255,))
        screen(d, (x + 2, 6, x + 27, 30), IONWARE, lines=4, seed=i)
        gd.ellipse((x + 8, 12, x + 21, 24), outline=IONWARE + (255,))
        gd.ellipse((x + 13, 16, x + 16, 20), fill=(255, 255, 255, 255))
        d.text((x + 4, 31), "IONWARE", fill=(120, 124, 140, 255))
    g = glow(g, IONWARE, radius=3, strength=0.7)
    save_prop(Image.alpha_composite(im, g), "monitor_bank", 1, registry)


def flag_us(registry):
    """A faded American flag on a pole, in a facility that stopped being
    American a long time ago."""
    im = new(32, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((14, 2, 16, 62), fill=STEEL + (255,))
    d.ellipse((12, 0, 18, 6), fill=AMBER + (255,))
    for i in range(7):
        y = 6 + i * 4
        d.rectangle((17, y, 31, y + 1), fill=(170, 60, 60, 255) if i % 2 == 0 else (200, 190, 180, 255))
        d.rectangle((17, y + 2, 31, y + 3), fill=(200, 190, 180, 255) if i % 2 == 0 else (170, 60, 60, 255))
    d.rectangle((17, 6, 23, 19), fill=(50, 54, 110, 255))
    r = random.Random(4)
    for _ in range(10):
        d.point((r.randint(18, 22), r.randint(7, 18)), fill=(220, 220, 230, 255))
    d.rectangle((9, 58, 21, 63), fill=STEEL_D + (255,), outline=OUT + (255,))
    save_prop(im, "flag_us", 1, registry)


def obsidian_eye(registry):
    """The eye set into the floor of the entrance hall: black glass, two rings,
    a pupil that is a hole."""
    im = new(128, 64)
    d = ImageDraw.Draw(im)
    d.ellipse((2, 2, 125, 61), fill=(14, 12, 18, 255), outline=(60, 56, 70, 255), width=2)
    d.ellipse((24, 10, 103, 53), outline=(90, 84, 100, 255), width=2)
    d.ellipse((50, 20, 77, 43), fill=(2, 2, 3, 255), outline=(120, 110, 130, 255))
    r = random.Random(11)
    for _ in range(60):
        x, y = r.randint(4, 123), r.randint(4, 59)
        if (x - 64) ** 2 / 3600 + (y - 32) ** 2 / 850 < 1 and not ((x - 64) ** 2 / 190 + (y - 32) ** 2 / 130 < 1):
            d.point((x, y), fill=(70, 66, 84, 255))
    save_prop(im, "obsidian_eye", 0, registry)


def reception_desk(registry):
    im = new(96, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 14, 95, 46), fill=(52, 50, 60, 255), outline=OUT + (255,))
    d.rectangle((0, 10, 95, 16), fill=(78, 76, 90, 255), outline=OUT + (255,))
    d.rectangle((60, 2, 84, 12), fill=(30, 32, 40, 255), outline=OUT + (255,))
    screen(d, (62, 4, 82, 10), IONWARE, lines=2, seed=5)
    d.rectangle((10, 4, 30, 12), fill=(200, 196, 186, 255), outline=(120, 116, 110, 255))  # the visitor book
    d.line((13, 7, 27, 7), fill=(90, 90, 100, 255)); d.line((13, 10, 24, 10), fill=(90, 90, 100, 255))
    save_prop(im, "reception_desk", 1, registry)


def office_chair_old(registry):
    """The old office chair Lynx spins in."""
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((8, 8, 23, 30), fill=(60, 48, 44, 255), outline=OUT + (255,))
    d.rectangle((6, 28, 25, 36), fill=(70, 56, 50, 255), outline=OUT + (255,))
    d.rectangle((15, 36, 16, 42), fill=STEEL_D + (255,))
    for dx in (-8, -3, 3, 8):
        d.line((16, 42, 16 + dx, 46), fill=STEEL_D + (255,))
    save_prop(im, "office_chair_old", 1, registry)


def lift_door(registry):
    """The lift down. Brushed steel, a call button, and a floor indicator
    that only knows how to count down."""
    im = new(64, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 2, 61, 63), fill=STEEL_D + (255,), outline=OUT + (255,))
    d.rectangle((6, 10, 30, 62), fill=STEEL + (255,), outline=OUT + (255,))
    d.rectangle((33, 10, 57, 62), fill=STEEL + (255,), outline=OUT + (255,))
    for y in range(14, 62, 6):
        d.line((8, y, 28, y), fill=(140, 146, 160, 255)); d.line((35, y, 55, y), fill=(140, 146, 160, 255))
    d.rectangle((24, 3, 39, 8), fill=(8, 8, 12, 255))
    g = new(64, 64)
    gd = ImageDraw.Draw(g)
    gd.text((26, 1), "-1", fill=RUST + (255,))
    gd.ellipse((58, 30, 61, 33), fill=AMBER + (255,))
    g = glow(g, RUST, radius=2, strength=0.8)
    save_prop(Image.alpha_composite(im, g), "lift_door", 1, registry)


# ----------------------------------------------------------------- sublevel 1
def whiteboard(registry):
    """The whiteboard with the subject list. 12-34, and under it 12-35."""
    im = new(96, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 0, 95, 44), fill=(226, 228, 226, 255), outline=(110, 112, 118, 255), width=2)
    d.rectangle((0, 44, 95, 47), fill=STEEL + (255,))
    ink = (40, 44, 80, 255)
    d.text((4, 2), "ENCODING  -  SUBJ", fill=ink)
    d.line((4, 12, 90, 12), fill=ink)
    for i, txt in enumerate(("12-31  done", "12-32  done", "12-33  done", "12-34  ...")):
        d.text((4, 13 + i * 8), txt, fill=ink if i < 3 else (170, 40, 40, 255))
    d.text((52, 21), "12-35", fill=(170, 40, 40, 255))
    d.text((52, 29), "C. DRAKE", fill=(170, 40, 40, 255))
    # two rings, drawn in the corner by a hand that never changes
    d.ellipse((76, 2, 90, 11), outline=ink); d.ellipse((80, 4, 86, 9), outline=ink)
    save_prop(im, "whiteboard", 1, registry)


def pc_desk(name, on, registry, seed=1):
    """An Ionware desktop on a grey desk: tower, keyboard, a monitor showing
    the same thing every monitor down here shows."""
    im = new(64, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 22, 63, 46), fill=(62, 64, 72, 255), outline=OUT + (255,))
    d.rectangle((0, 18, 63, 24), fill=(90, 92, 104, 255), outline=OUT + (255,))
    d.rectangle((48, 4, 60, 22), fill=(40, 42, 50, 255), outline=OUT + (255,))      # the tower
    d.rectangle((50, 7, 58, 8), fill=IONWARE + (255,) if on else (60, 60, 70, 255))
    d.rectangle((12, 2, 42, 20), fill=(30, 32, 40, 255), outline=OUT + (255,))      # the monitor
    d.rectangle((24, 20, 30, 23), fill=(40, 42, 50, 255))
    d.rectangle((10, 28, 36, 33), fill=(50, 52, 60, 255), outline=OUT + (255,))      # keyboard
    if on:
        screen(d, (14, 4, 40, 18), IONWARE, lines=3, seed=seed)
        g = new(64, 48)
        gd = ImageDraw.Draw(g)
        gd.ellipse((22, 7, 32, 15), outline=IONWARE + (255,))
        g = glow(g, IONWARE, radius=3, strength=0.6)
        im = Image.alpha_composite(im, g)
    else:
        d.rectangle((14, 4, 40, 18), fill=(10, 10, 14, 255))
    d.text((14, 36), "IONWARE", fill=(120, 124, 140, 255))
    save_prop(im, name, 1, registry)


def report_folder(registry):
    """A fat folder, DARPA on one tab and Psyonic on the other."""
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.rectangle((3, 10, 28, 28), fill=(170, 150, 110, 255), outline=(90, 76, 50, 255))
    d.rectangle((3, 6, 14, 11), fill=(170, 150, 110, 255), outline=(90, 76, 50, 255))
    d.rectangle((16, 6, 28, 11), fill=(120, 150, 200, 255), outline=(60, 76, 110, 255))
    d.text((5, 13), "DARPA", fill=(60, 50, 30, 255))
    d.rectangle((5, 22, 26, 23), fill=(90, 76, 50, 255))
    save_prop(im, "report_folder", 0, registry)


def bunk(registry):
    """A steel bunk with a blanket nobody has slept under for years, and a
    pair of frames on the pillow."""
    im = new(32, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 20, 29, 60), fill=STEEL_D + (255,), outline=OUT + (255,))
    d.rectangle((4, 22, 27, 58), fill=(84, 90, 76, 255))
    d.rectangle((4, 22, 27, 32), fill=(200, 196, 188, 255))
    d.rectangle((9, 26, 22, 28), fill=(30, 30, 36, 255))
    d.line((10, 25, 21, 25), fill=TEAL + (160,))
    d.rectangle((2, 6, 29, 22), fill=STEEL_D + (255,), outline=OUT + (255,))
    d.rectangle((4, 8, 27, 20), fill=(60, 66, 54, 255))
    save_prop(im, "bunk", 1, registry)


def weights_rack(registry):
    im = new(64, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 30, 61, 46), fill=STEEL_D + (255,), outline=OUT + (255,))
    d.rectangle((4, 10, 6, 46), fill=STEEL + (255,)); d.rectangle((57, 10, 59, 46), fill=STEEL + (255,))
    d.rectangle((2, 12, 61, 15), fill=STEEL + (255,))
    for x in (12, 22, 32, 42):
        d.rectangle((x, 6, x + 5, 18), fill=(40, 40, 46, 255), outline=OUT + (255,))
    d.ellipse((16, 36, 24, 44), fill=(40, 40, 46, 255)); d.ellipse((40, 36, 48, 44), fill=(40, 40, 46, 255))
    d.line((20, 40, 44, 40), fill=STEEL + (255,), width=2)
    save_prop(im, "weights_rack", 1, registry)


def treadmill(registry):
    im = new(64, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((6, 30, 61, 44), fill=(40, 40, 46, 255), outline=OUT + (255,))
    d.rectangle((8, 32, 59, 42), fill=(60, 60, 68, 255))
    for x in range(10, 58, 6):
        d.line((x, 32, x, 42), fill=(40, 40, 46, 255))
    d.rectangle((2, 6, 8, 44), fill=STEEL + (255,), outline=OUT + (255,))
    d.rectangle((2, 4, 20, 10), fill=(30, 32, 40, 255), outline=OUT + (255,))
    screen(d, (4, 5, 18, 9), RUST, lines=1, seed=9)
    save_prop(im, "treadmill", 1, registry)


def steel_door(name, registry, locked=True, label=""):
    """A steel door in a lab wall; the locked ones have a red reader light."""
    im = new(32, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 6, 29, 63), fill=STEEL_D + (255,), outline=OUT + (255,))
    d.rectangle((5, 10, 26, 62), fill=STEEL + (255,), outline=OUT + (255,))
    d.rectangle((8, 20, 23, 30), fill=(14, 16, 22, 255), outline=OUT + (255,))      # the little window
    d.rectangle((20, 40, 23, 46), fill=(40, 40, 46, 255))
    if label:
        d.text((6, 11), label, fill=(30, 30, 36, 255))
    g = new(32, 64)
    gd = ImageDraw.Draw(g)
    gd.ellipse((26, 34, 29, 37), fill=(PAINT if locked else TEAL) + (255,))
    g = glow(g, PAINT if locked else TEAL, radius=2, strength=0.8)
    save_prop(Image.alpha_composite(im, g), name, 1, registry)


def stairs_down(registry, name="stairs_down", label="SUB 2", up=False):
    im = new(64, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 2, 61, 63), fill=(12, 12, 16, 255), outline=OUT + (255,))
    for i in range(6):
        y = 8 + i * 9
        c = (20 + i * 8) if up else (60 - i * 8)
        d.rectangle((6, y, 57, y + 7), fill=(c, c, c + 6, 255), outline=(c // 2, c // 2, c // 2 + 4, 255))
    d.text((18, 50), label, fill=RUST + (255,))
    save_prop(im, name, 1, registry)


def server_rack(registry):
    im = new(32, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((3, 2, 28, 62), fill=(30, 32, 40, 255), outline=OUT + (255,))
    r = random.Random(3)
    g = new(32, 64)
    gd = ImageDraw.Draw(g)
    for i in range(9):
        y = 5 + i * 6
        d.rectangle((5, y, 26, y + 4), fill=(44, 46, 56, 255), outline=(20, 20, 26, 255))
        for k in range(3):
            col = TEAL if r.random() < 0.6 else (RUST if r.random() < 0.5 else AMBER)
            gd.point((7 + k * 3, y + 2), fill=col + (255,))
    g = glow(g, TEAL, radius=2, strength=0.6)
    save_prop(Image.alpha_composite(im, g), "server_rack", 1, registry)


# ----------------------------------------------------------------- sublevel 2
def pen_bars(registry):
    """The barred front of a housing pen."""
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 44, 31, 47), fill=STEEL_D + (255,))
    d.rectangle((0, 2, 31, 5), fill=STEEL_D + (255,))
    for x in range(2, 32, 6):
        d.rectangle((x, 2, x + 1, 46), fill=STEEL + (255,))
        d.point((x, 10), fill=(180, 184, 196, 255))
    save_prop(im, "pen_bars", 1, registry)


def pen_door(name, registry, open_=False):
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 44, 31, 47), fill=STEEL_D + (255,))
    if open_:
        d.rectangle((0, 2, 4, 46), fill=STEEL + (255,))
        d.rectangle((26, 2, 31, 46), fill=STEEL + (255,))
    else:
        d.rectangle((0, 2, 31, 5), fill=STEEL_D + (255,))
        for x in range(2, 32, 6):
            d.rectangle((x, 2, x + 1, 46), fill=STEEL + (255,))
        d.rectangle((12, 20, 20, 28), fill=(40, 40, 46, 255), outline=OUT + (255,))
        d.ellipse((14, 22, 18, 26), fill=RUST + (255,))
    save_prop(im, name, 0 if open_ else 1, registry)


def pen_number(n, registry):
    """A stencil on the brick above each pen: HOUSING PEN n."""
    im = new(96, 16)
    d = ImageDraw.Draw(im)
    d.text((3, 2), "HOUSING PEN %d" % n, fill=(200, 196, 180, 255))
    save_prop(im, "pen_%d" % n, 0, registry)


def scratches(registry):
    """What a subject scratched into the pen wall: rings inside rings, and a
    count."""
    im = new(64, 32)
    d = ImageDraw.Draw(im)
    c = (160, 150, 130, 255)
    for i in range(14):
        x = 3 + i * 4
        d.line((x, 4, x, 14), fill=c)
        if i % 5 == 4:
            d.line((x - 16, 3, x + 1, 15), fill=c)
    d.ellipse((30, 16, 58, 30), outline=c); d.ellipse((38, 20, 50, 26), outline=c)
    d.text((2, 18), "day", fill=c)
    save_prop(im, "scratches", 0, registry)


def cot(registry):
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 14, 29, 44), fill=STEEL_D + (255,), outline=OUT + (255,))
    d.rectangle((4, 16, 27, 42), fill=(70, 70, 64, 255))
    d.rectangle((4, 16, 27, 24), fill=(150, 146, 136, 255))
    save_prop(im, "cot", 1, registry)


def observation_console(registry):
    """The observation room's console: one big Ionware monitor and the deck
    that plays the perturbation sessions."""
    im = new(96, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 36, 95, 62), fill=(50, 52, 62, 255), outline=OUT + (255,))
    d.rectangle((0, 32, 95, 38), fill=(80, 82, 96, 255), outline=OUT + (255,))
    d.rectangle((16, 2, 80, 36), fill=(28, 30, 38, 255), outline=OUT + (255,))
    d.rectangle((18, 4, 78, 30), fill=(6, 8, 12, 255))
    r = random.Random(41)
    for _ in range(140):   # static
        x, y = r.randint(19, 77), r.randint(5, 29)
        v = r.randint(20, 90)
        d.point((x, y), fill=(v, v, v + 10, 255))
    d.text((20, 6), "OBS_LOG_S41", fill=IONWARE + (255,))
    d.rectangle((10, 42, 40, 56), fill=(36, 36, 44, 255), outline=OUT + (255,))
    for i in range(5):
        d.rectangle((13 + i * 5, 46, 15 + i * 5, 52), fill=(60, 62, 72, 255))
    d.rectangle((50, 42, 86, 56), fill=(36, 36, 44, 255), outline=OUT + (255,))
    g = new(96, 64)
    gd = ImageDraw.Draw(g)
    gd.ellipse((58, 45, 63, 50), fill=PAINT + (255,))
    gd.text((66, 42), "REC", fill=PAINT + (255,))
    g = glow(g, PAINT, radius=2, strength=0.8)
    save_prop(Image.alpha_composite(im, g), "observation_console", 1, registry)


def hangar_door(registry):
    """The door from the pens to the hangar: a rolling steel shutter with the
    eye sprayed across it."""
    im = new(96, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 0, 95, 63), fill=STEEL_D + (255,), outline=OUT + (255,))
    for y in range(4, 62, 6):
        d.line((3, y, 92, y), fill=(90, 94, 106, 255))
    d.ellipse((28, 14, 68, 48), outline=PAINT + (255,), width=2)
    d.ellipse((40, 24, 56, 38), outline=PAINT + (255,), width=2)
    d.ellipse((45, 29, 51, 33), fill=PAINT + (255,))
    save_prop(im, "hangar_door", 1, registry)


# --------------------------------------------------------------------- hangar
def mural_eye(registry):
    """The stick-eye mural, ten feet across, on black brick."""
    im = new(192, 96)
    d = ImageDraw.Draw(im)
    bone = (196, 184, 160, 255)
    r = random.Random(7)
    # sticks laid in two rings
    for i in range(44):
        a = i / 44 * 6.2832
        import math
        for rad, ln in ((82, 14), (46, 10)):
            cx, cy = 96 + math.cos(a) * rad, 48 + math.sin(a) * rad * 0.5
            dx, dy = math.cos(a + 1.5708) * ln, math.sin(a + 1.5708) * ln * 0.5
            d.line((cx - dx, cy - dy, cx + dx, cy + dy), fill=bone, width=2)
    # the pupil: sticks laid in a star
    for i in range(10):
        a = i / 10 * 6.2832
        import math
        d.line((96, 48, 96 + math.cos(a) * 18, 48 + math.sin(a) * 10), fill=bone, width=2)
    for _ in range(80):
        x, y = r.randint(2, 189), r.randint(2, 93)
        d.point((x, y), fill=(120, 40, 36, 200))   # dried spatter
    save_prop(im, "mural_eye", 0, registry)


def altar_recliner(registry):
    """The altar: a black leather recliner with two rust-red probes on their
    arms, and the cables that run from it into the floor."""
    im = new(64, 64)
    d = ImageDraw.Draw(im)
    for i, (x0, x1) in enumerate(((2, 10), (54, 62))):
        d.line((x0 + 4, 60, x0 + 4 + (6 if i == 0 else -6), 63), fill=(30, 30, 36, 255), width=2)
    d.rectangle((10, 44, 54, 62), fill=LEATHER + (255,), outline=(70, 68, 76, 255))           # footrest
    d.rectangle((12, 14, 52, 46), fill=(30, 28, 34, 255), outline=(80, 78, 88, 255))            # seat
    d.rectangle((14, 4, 50, 18), fill=LEATHER + (255,), outline=(80, 78, 88, 255))              # headrest
    d.rectangle((6, 26, 13, 46), fill=(36, 34, 40, 255), outline=(80, 78, 88, 255))             # arms
    d.rectangle((51, 26, 58, 46), fill=(36, 34, 40, 255), outline=(80, 78, 88, 255))
    for x in (9, 55):
        d.line((x, 26, x, 12), fill=STEEL + (255,), width=2)                                      # probe stalks
        d.line((x, 12, 32 + (-10 if x < 32 else 10), 8), fill=STEEL + (255,), width=2)
    g = new(64, 64)
    gd = ImageDraw.Draw(g)
    for x in (22, 42):
        gd.polygon([(x - 3, 10), (x + 3, 10), (x, 4)], fill=RUST + (255,))                         # the probe tips
    gd.ellipse((24, 7, 28, 11), fill=RUST + (255,)); gd.ellipse((36, 7, 40, 11), fill=RUST + (255,))
    g = glow(g, RUST, radius=3, strength=0.8)
    save_prop(Image.alpha_composite(im, g), "altar_recliner", 1, registry)


def hangar_lamp(registry):
    """The single lamp over the altar, on a chain."""
    im = new(32, 96)
    d = ImageDraw.Draw(im)
    for y in range(0, 60, 4):
        d.rectangle((15, y, 16, y + 2), fill=STEEL_D + (255,))
    d.polygon([(4, 74), (27, 74), (20, 60), (11, 60)], fill=(40, 40, 46, 255), outline=OUT + (255,))
    g = new(32, 96)
    gd = ImageDraw.Draw(g)
    gd.ellipse((10, 72, 21, 78), fill=AMBER + (255,))
    g = glow(g, AMBER, radius=6, strength=0.9)
    save_prop(Image.alpha_composite(im, g), "hangar_lamp", 0, registry)


def cube_stand(registry):
    """The black cube on its stand: it opens, later."""
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((10, 30, 21, 46), fill=STEEL_D + (255,), outline=OUT + (255,))
    d.rectangle((8, 44, 23, 47), fill=STEEL_D + (255,))
    d.polygon([(8, 18), (18, 14), (24, 18), (14, 22)], fill=(26, 24, 30, 255), outline=(70, 66, 80, 255))
    d.polygon([(8, 18), (14, 22), (14, 32), (8, 28)], fill=(10, 9, 12, 255), outline=(70, 66, 80, 255))
    d.polygon([(14, 22), (24, 18), (24, 28), (14, 32)], fill=(16, 15, 18, 255), outline=(70, 66, 80, 255))
    save_prop(im, "cube_stand", 1, registry)


def bowl_stand(registry):
    """The bowl of dark liquid on its stand."""
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((13, 30, 18, 46), fill=STEEL_D + (255,), outline=OUT + (255,))
    d.ellipse((4, 18, 27, 32), fill=(60, 58, 66, 255), outline=OUT + (255,))
    d.ellipse((7, 19, 24, 27), fill=(8, 6, 10, 255))
    d.ellipse((12, 21, 15, 23), fill=(40, 30, 50, 255))
    save_prop(im, "bowl_stand", 1, registry)


def office_window(registry):
    """The factory office's window onto the hangar floor: wired glass, half a
    blind, the place Lynx drags Carl to watch from."""
    im = new(96, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((0, 0, 95, 47), fill=(40, 40, 46, 255), outline=OUT + (255,))
    d.rectangle((4, 4, 91, 43), fill=(14, 16, 24, 255))
    for x in range(8, 92, 8):
        d.line((x, 4, x, 43), fill=(30, 34, 46, 255))
    for y in range(8, 44, 8):
        d.line((4, y, 91, y), fill=(30, 34, 46, 255))
    for y in range(4, 22, 3):
        d.line((4, y, 91, y), fill=(120, 118, 110, 255))
    save_prop(im, "office_window", 1, registry)


def candle_ring(registry):
    """A ring of candles on the hangar floor, for the congregation to stand in."""
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    g = new(32, 32)
    gd = ImageDraw.Draw(g)
    for x, y in ((6, 20), (16, 24), (26, 20), (16, 12)):
        d.rectangle((x - 1, y, x + 1, y + 6), fill=(220, 210, 180, 255))
        gd.ellipse((x - 1, y - 3, x + 1, y - 1), fill=AMBER + (255,))
    g = glow(g, AMBER, radius=3, strength=0.9)
    save_prop(Image.alpha_composite(im, g), "candle_ring", 0, registry)


def blood_pool(registry):
    im = new(64, 32)
    d = ImageDraw.Draw(im)
    d.ellipse((4, 8, 60, 30), fill=(90, 12, 14, 230))
    d.ellipse((20, 4, 44, 18), fill=(110, 16, 18, 230))
    d.ellipse((30, 14, 40, 20), fill=(140, 24, 24, 200))
    save_prop(im, "blood_pool", 0, registry)


# -------------------------------------------------------------------- sprites
def recolour_sheet(src, dst, fn):
    im = Image.open(os.path.join(SPRITES, src + ".png")).convert("RGBA")
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            if a:
                px[x, y] = fn(r, g, b) + (a,)
    im.save(os.path.join(SPRITES, dst + ".png"))
    print("sprite", dst)


def robed(r, g, b):
    """Everything on the masked figure goes to a dark robe; the mask stays pale."""
    lum = (r * 299 + g * 587 + b * 114) // 1000
    if lum > 150 and abs(r - g) < 30 and abs(g - b) < 30:
        return (min(255, lum), min(255, lum - 6), min(255, lum - 10))   # the mask / pale cloth
    k = lum // 5 + 8
    return (k + 6, k, k + 10)


def eren(r, g, b):
    """Eren Elontiel: a tall woman in a charcoal suit with silver hair."""
    lum = (r * 299 + g * 587 + b * 114) // 1000
    if r > g + 20 and r > b + 20:                 # skin tones stay warm but cold
        return (min(255, r - 10), min(255, g), min(255, b + 10))
    if lum > 160:
        return (min(255, lum + 20), min(255, lum + 20), min(255, lum + 30))   # silver hair / shirt
    return (lum // 3 + 20, lum // 3 + 20, lum // 3 + 28)


def portrait_from(src, dst, fn):
    im = Image.open(os.path.join(PORTRAITS, src + ".png")).convert("RGBA")
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            if a:
                px[x, y] = fn(r, g, b) + (a,)
    im.save(os.path.join(PORTRAITS, dst + ".png"))
    print("portrait", dst)


def priest_portrait(r, g, b):
    """Subject 41 as the priest: the masked portrait, the mask gone the colour
    of old bone, the sockets under it rust-red."""
    lum = (r * 299 + g * 587 + b * 114) // 1000
    if lum > 150 and abs(r - g) < 30 and abs(g - b) < 30:
        return (min(255, lum), min(255, lum - 14), min(255, lum - 40))
    if r > 120 and g < 90 and b < 90:
        return (150, 58, 34)
    return (lum // 4 + 10, lum // 4 + 8, lum // 4 + 14)


# ---------------------------------------------------------------------- tiles
def add_tiles():
    atlas = json.load(open(os.path.join(TILES_DIR, "atlas.json")))
    sheet = Image.open(os.path.join(TILES_DIR, "tiles.png")).convert("RGBA")
    cols = sheet.width // T
    used = set(tuple(v) for v in atlas.values())
    free = [(x, y) for y in range(sheet.height // T + 4) for x in range(cols) if (x, y) not in used]

    def brick(base, dark, light, kind, seed):
        im = Image.new("RGBA", (T, T), base + (255,))
        d = ImageDraw.Draw(im)
        r = random.Random(seed)
        for y in range(0, 32, 8):
            off = 0 if (y // 8) % 2 == 0 else 8
            for x in range(-8 + off, 32, 16):
                d.rectangle((x, y, x + 15, y + 7), fill=base + (255,), outline=dark + (255,))
                stone_noise(d, (max(0, x + 1), y + 1, min(31, x + 14), y + 6), base, r, n=10)
        if kind == "top":
            d.rectangle((0, 0, 31, 3), fill=light + (255,)); d.line((0, 4, 31, 4), fill=OUT + (255,))
        if kind == "bot":
            d.rectangle((0, 27, 31, 31), fill=dark + (255,)); d.line((0, 26, 31, 26), fill=OUT + (255,))
        return im

    def lab_floor(seed, base=(96, 100, 104)):
        im = Image.new("RGBA", (T, T), base + (255,))
        d = ImageDraw.Draw(im)
        r = random.Random(seed)
        stone_noise(d, (0, 0, 31, 31), base, r, n=90)
        d.line((0, 0, 31, 0), fill=tuple(c - 18 for c in base) + (255,)); d.line((0, 0, 0, 31), fill=tuple(c - 18 for c in base) + (255,))
        if seed == 2:
            d.line((6, 20, 18, 30), fill=tuple(c - 30 for c in base) + (255,))
        if seed == 3:
            d.rectangle((10, 10, 21, 21), outline=tuple(c - 12 for c in base) + (255,))   # a drain
            d.line((12, 16, 19, 16), fill=tuple(c - 30 for c in base) + (255,))
        return im

    def hangar_floor(seed):
        base = (34, 32, 36)
        im = Image.new("RGBA", (T, T), base + (255,))
        d = ImageDraw.Draw(im)
        r = random.Random(seed)
        stone_noise(d, (0, 0, 31, 31), base, r, n=60)
        if seed == 2:
            for _ in range(5):
                d.point((r.randint(0, 31), r.randint(0, 31)), fill=(90, 20, 20, 255))
        return im

    names = [("brick_green_top", brick(GREEN, GREEN_D, GREEN_L, "top", 1)), ("brick_green_mid", brick(GREEN, GREEN_D, GREEN_L, "mid", 2)),
             ("brick_green_bot", brick(GREEN, GREEN_D, GREEN_L, "bot", 3)),
             ("brick_black_top", brick(BLACK_BRICK, BLACK_BRICK_D, BLACK_BRICK_L, "top", 4)), ("brick_black_mid", brick(BLACK_BRICK, BLACK_BRICK_D, BLACK_BRICK_L, "mid", 5)),
             ("brick_black_bot", brick(BLACK_BRICK, BLACK_BRICK_D, BLACK_BRICK_L, "bot", 6)),
             ("lab_floor", lab_floor(1)), ("lab_floor2", lab_floor(2)), ("lab_floor3", lab_floor(3)),
             ("lab_floor_green", lab_floor(4, (72, 80, 64))), ("lab_floor_green2", lab_floor(5, (72, 80, 64))),
             ("hangar_floor", hangar_floor(1)), ("hangar_floor2", hangar_floor(2))]
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
    monitor_bank(registry); flag_us(registry); obsidian_eye(registry); reception_desk(registry)
    office_chair_old(registry); lift_door(registry)
    whiteboard(registry); pc_desk("pc_desk", True, registry, 1); pc_desk("pc_desk2", True, registry, 2); pc_desk("pc_desk_off", False, registry)
    report_folder(registry); bunk(registry); weights_rack(registry); treadmill(registry)
    steel_door("steel_door_locked", registry, True); steel_door("steel_door", registry, False); steel_door("steel_door_lab", registry, True, "LAB")
    stairs_down(registry); stairs_down(registry, "stairs_up", "SUB 1", up=True); stairs_down(registry, "stairs_hangar", "SUB 3"); server_rack(registry)
    pen_bars(registry); pen_door("pen_door", registry); pen_door("pen_door_open", registry, True)
    for n in range(1, 7):
        pen_number(n, registry)
    scratches(registry); cot(registry); observation_console(registry); hangar_door(registry)
    mural_eye(registry); altar_recliner(registry); hangar_lamp(registry); cube_stand(registry); bowl_stand(registry)
    office_window(registry); candle_ring(registry); blood_pool(registry)
    json.dump(registry, open(os.path.join(PROPS_DIR, "props.json"), "w"), indent=1, sort_keys=True)
    recolour_sheet("masked", "robed", robed)
    recolour_sheet("nurse", "eren", eren)
    portrait_from("masked", "priest", priest_portrait)
    portrait_from("nurse", "eren", eren)
    add_tiles()
    print("lab art written")


if __name__ == "__main__":
    main()
