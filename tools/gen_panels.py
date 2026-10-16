#!/usr/bin/env python3
"""Paints the cut-scene and dream panels that have no generated still yet
(assets/closeups/cs_*.png, dream_*.png). Everything is drawn at 320x180 and
then put through the same pixel pass as the generated close-ups (48 colours,
nearest-neighbour to 640x360), so a painted panel and a generated one sit
together. Replace any of them by dropping a 16:9 image through closeups.py."""
import os
import random
from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
OUT = os.path.join(ROOT, "assets", "closeups")
W, H = 320, 180
TEAL = (127, 224, 192)
AMBER = (245, 214, 160)
RED = (224, 69, 58)
NAVY = (11, 14, 26)
PLUM = (90, 74, 106)
CEMENT = (143, 160, 168)
BLACK = (5, 6, 8)
SAND = (192, 138, 74)


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def sky(d, top, bottom):
    for y in range(H):
        d.line([(0, y), (W, y)], fill=lerp(top, bottom, y / H))


def noise(im, amount=6, seed=1):
    r = random.Random(seed)
    px = im.load()
    for y in range(H):
        for x in range(W):
            n = r.randint(-amount, amount)
            c = px[x, y]
            px[x, y] = tuple(max(0, min(255, v + n)) for v in c[:3])


def vignette(im, strength=0.55):
    px = im.load()
    cx, cy = W / 2, H / 2
    for y in range(H):
        for x in range(W):
            dx, dy = (x - cx) / cx, (y - cy) / cy
            f = 1.0 - strength * min(1.0, (dx * dx + dy * dy) ** 0.8)
            c = px[x, y]
            px[x, y] = tuple(int(v * f) for v in c[:3])


def glow(im, pts, color, radius=10, alpha=0.5):
    layer = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(layer)
    for (x, y, r) in pts:
        d.ellipse([x - r, y - r, x + r, y + r], fill=color)
    layer = layer.filter(ImageFilter.GaussianBlur(radius))
    return Image.blend(im, Image.eval(layer, lambda v: v), 0.0) if False else Image.composite(
        Image.blend(im, layer, alpha), im, layer.convert("L").point(lambda v: min(255, v * 3)))


def windows(d, x0, y0, x1, y1, step=(6, 7), lit=0.8, color=AMBER, dark=(30, 32, 44), seed=1, off=None):
    r = random.Random(seed)
    k = 0
    for y in range(y0 + 2, y1 - 2, step[1]):
        for x in range(x0 + 2, x1 - 2, step[0]):
            on = r.random() < lit
            if off is not None and k == off:
                on = False
            c = color if on else dark
            if on and r.random() < 0.3:
                c = lerp(color, dark, 0.45)
            d.rectangle([x, y, x + step[0] - 3, y + step[1] - 3], fill=c)
            k += 1


def lift(im, n):
    """Moves the picture up n rows so the subject sits above the caption band,
    and extends the bottom row (ground, floor, dashboard) to fill the gap."""
    out = Image.new("RGB", (W, H))
    out.paste(im.crop((0, n, W, H)), (0, 0))
    last = im.crop((0, H - 1, W, H))
    r = random.Random(99)
    for y in range(H - n, H):
        out.paste(last, (0, y))
    px = out.load()
    for y in range(H - n, H):
        for x in range(W):
            c = px[x, y]
            k = r.randint(-5, 5)
            px[x, y] = tuple(max(0, min(255, v + k)) for v in c[:3])
    return out


def finish(im, name, n=30):
    im = lift(im, n)
    im = im.convert("RGB")
    im = im.quantize(colors=48, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    im = im.resize((640, 360), Image.NEAREST)
    im.save(os.path.join(OUT, name + ".png"))
    print("panel", name)


# ------------------------------------------------------------ opening 2
def opening_car():
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    # night city beyond the windscreen, blurred
    sky(d, (14, 16, 34), (40, 34, 60))
    r = random.Random(3)
    for _ in range(70):
        x, y = r.randint(0, W), r.randint(20, 95)
        c = r.choice([AMBER, TEAL, (200, 90, 120), (120, 140, 200)])
        rr = r.randint(1, 3)
        d.ellipse([x - rr, y - rr, x + rr, y + rr], fill=lerp(c, (40, 34, 60), 0.4))
    im = im.filter(ImageFilter.GaussianBlur(2.2))
    d = ImageDraw.Draw(im)
    # pillars and roof lining
    d.polygon([(0, 0), (28, 0), (14, 110), (0, 118)], fill=(16, 14, 18))
    d.polygon([(W, 0), (W - 28, 0), (W - 14, 110), (W, 118)], fill=(16, 14, 18))
    d.rectangle([0, 0, W, 10], fill=(12, 10, 14))
    # dashboard
    d.polygon([(0, 112), (W, 112), (W, H), (0, H)], fill=(46, 40, 50))
    d.polygon([(10, 112), (W - 10, 112), (W - 40, 128), (50, 128)], fill=(62, 54, 66))
    d.line([(0, 112), (W, 112)], fill=(60, 52, 64), width=2)
    # steering wheel, left
    d.ellipse([52, 118, 158, 226], outline=(88, 78, 92), width=9)
    d.ellipse([52, 118, 158, 226], outline=(28, 24, 30), width=2)
    d.rectangle([90, 150, 120, 172], fill=(70, 62, 74))
    # centre screen rebooting: teal glitch bars
    d.rectangle([150, 128, 212, 164], fill=(8, 12, 16))
    d.rectangle([150, 128, 212, 164], outline=(50, 56, 70))
    g = random.Random(7)
    for i in range(14):
        y = 131 + i * 2.4
        x0 = 152 + g.randint(0, 20)
        x1 = x0 + g.randint(4, 40)
        c = TEAL if g.random() < 0.5 else lerp(TEAL, BLACK, 0.6)
        d.line([(x0, y), (min(x1, 210), y)], fill=c)
    d.rectangle([162, 150, 200, 156], fill=lerp(TEAL, BLACK, 0.3))
    # passenger seat, right, with the frames on it glowing
    d.polygon([(214, 132), (320, 126), (320, 180), (206, 180)], fill=(74, 56, 62))
    d.polygon([(222, 140), (312, 134), (316, 176), (214, 176)], fill=(92, 70, 76))
    d.line([(222, 140), (214, 176)], fill=(30, 22, 26))
    # the frames: two rings and a bridge
    im = glow(im, [(262, 158, 14)], TEAL, radius=9, alpha=0.55)
    d = ImageDraw.Draw(im)
    d.ellipse([244, 150, 260, 166], outline=(30, 34, 38), width=2)
    d.ellipse([266, 148, 282, 164], outline=(30, 34, 38), width=2)
    d.line([(260, 157), (266, 156)], fill=(30, 34, 38), width=2)
    d.ellipse([246, 152, 258, 164], outline=TEAL, width=1)
    d.ellipse([268, 150, 280, 162], outline=TEAL, width=1)
    d.line([(282, 155), (300, 150)], fill=(30, 34, 38), width=2)
    d.line([(244, 157), (228, 152)], fill=(30, 34, 38), width=2)
    # windscreen dust
    r = random.Random(5)
    for _ in range(150):
        x, y = r.randint(28, W - 28), r.randint(12, 110)
        im.putpixel((x, y), lerp(im.getpixel((x, y)), (110, 100, 80), 0.35))
    vignette(im, 0.35)
    noise(im, 4, 2)
    finish(im, "cs_opening_2")


# ------------------------------------------------------------ opening 3
def opening_tower():
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (6, 8, 18), (34, 28, 48))
    # neighbouring towers, dim
    d.polygon([(0, 40), (70, 30), (80, 140), (0, 150)], fill=(18, 16, 28))
    windows(d, 4, 36, 76, 140, step=(8, 9), lit=0.5, color=lerp(AMBER, (18, 16, 28), 0.5), dark=(14, 12, 20), seed=11)
    d.polygon([(250, 36), (320, 28), (320, 148), (240, 148)], fill=(18, 16, 28))
    windows(d, 252, 34, 318, 146, step=(8, 9), lit=0.45, color=lerp(AMBER, (18, 16, 28), 0.5), dark=(14, 12, 20), seed=12)
    # the Lamplight tower, looming, one dark window
    d.polygon([(118, 0), (202, 0), (226, 150), (94, 150)], fill=(30, 26, 40))
    d.polygon([(118, 0), (202, 0), (226, 150), (94, 150)], outline=(50, 44, 62))
    windows(d, 112, 4, 208, 146, step=(9, 10), lit=0.92, color=AMBER, dark=(22, 18, 30), seed=13, off=34)
    # the dark window: a hint of red in the glass
    d.rectangle([148, 44, 153, 50], fill=(16, 8, 10))
    d.point((150, 47), fill=(80, 20, 20))
    # pavement and kerb
    d.rectangle([0, 150, W, H], fill=(44, 48, 56))
    d.rectangle([0, 150, W, 156], fill=(70, 74, 82))
    d.rectangle([0, 170, W, H], fill=(28, 30, 36))
    # a thin line of sand along the kerb
    r = random.Random(21)
    for x in range(0, W, 2):
        y = 156 + r.randint(0, 3)
        d.line([(x, y), (x + 1, y)], fill=SAND if r.random() < 0.7 else lerp(SAND, (44, 48, 56), 0.5))
    # police cruiser at the kerb, lights off
    d.rectangle([20, 136, 110, 166], fill=(20, 22, 30))
    d.polygon([(34, 136), (96, 136), (88, 124), (44, 124)], fill=(26, 28, 38))
    d.rectangle([46, 126, 86, 135], fill=(40, 46, 60))
    d.rectangle([52, 120, 78, 124], fill=(30, 20, 24))
    d.rectangle([52, 120, 64, 124], fill=(60, 24, 30))
    d.rectangle([66, 120, 78, 124], fill=(24, 30, 60))
    d.ellipse([24, 160, 40, 176], fill=(10, 10, 12))
    d.ellipse([90, 160, 106, 176], fill=(10, 10, 12))
    d.rectangle([22, 150, 108, 153], fill=(60, 64, 72))
    # lamp post, buzzing
    d.rectangle([236, 60, 240, 152], fill=(40, 42, 50))
    d.rectangle([228, 56, 248, 62], fill=(60, 62, 70))
    im = glow(im, [(238, 64, 16)], lerp(AMBER, (255, 255, 255), 0.2), radius=10, alpha=0.5)
    vignette(im, 0.35)
    noise(im, 5, 3)
    finish(im, "cs_opening_3")


# ------------------------------------------------------------- outage 1
def outage_boulevard():
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (26, 20, 44), (70, 48, 70))
    # the tower, far, the only light
    d.polygon([(150, 40), (170, 40), (176, 120), (144, 120)], fill=(24, 30, 40))
    windows(d, 146, 42, 174, 118, step=(4, 5), lit=0.9, color=TEAL, dark=(20, 26, 34), seed=31)
    im = glow(im, [(160, 80, 22)], TEAL, radius=14, alpha=0.4)
    d = ImageDraw.Draw(im)
    # road in perspective
    d.polygon([(0, 180), (320, 180), (176, 120), (144, 120)], fill=(36, 34, 44))
    d.polygon([(130, 180), (190, 180), (161, 122), (159, 122)], fill=(44, 42, 52))
    # buildings either side, stepping back
    r = random.Random(41)
    for i, (x0, x1, top) in enumerate([(0, 60, 10), (60, 100, 30), (100, 130, 60), (130, 146, 90)]):
        d.polygon([(x0, top), (x1, top + (90 - top) * 0.3), (x1, 180 - (i * 18)), (x0, 180)], fill=(22, 18, 30))
        # a screen on each, dead to static
        sx0, sy0 = x0 + 6, top + 14
        sx1, sy1 = x1 - 6, top + 14 + (x1 - x0) * 0.6
        for y in range(int(sy0), int(sy1)):
            for x in range(int(sx0), int(sx1)):
                v = r.randint(40, 150)
                im.putpixel((x, y), (v, v, v + 6))
    for i, (x0, x1, top) in enumerate([(260, 320, 10), (220, 260, 30), (190, 220, 60), (174, 190, 90)]):
        d.polygon([(x0, top + (90 - top) * 0.3), (x1, top), (x1, 180), (x0, 180 - (i * 18))], fill=(22, 18, 30))
        sx0, sy0 = x0 + 6, top + 14
        sx1, sy1 = x1 - 6, top + 14 + (x1 - x0) * 0.6
        for y in range(int(sy0), int(sy1)):
            for x in range(int(sx0), int(sx1)):
                v = r.randint(40, 150)
                im.putpixel((x, y), (v, v, v + 6))
    # lamps down the street, dying toward the tower: lit near, dead far
    lamps = []
    for i, (lx, ly, s) in enumerate([(40, 100, 1.0), (88, 112, 0.8), (118, 118, 0.6), (136, 121, 0.4), (280, 100, 1.0), (232, 112, 0.8), (202, 118, 0.6), (184, 121, 0.4)]):
        d.line([(lx, ly), (lx, 180 - (i % 4) * 18)], fill=(50, 50, 60), width=max(1, int(3 * s)))
        if (i % 4) < 2:
            lamps.append((lx, ly, int(9 * s)))
        else:
            d.rectangle([lx - 2, ly - 2, lx + 2, ly], fill=(60, 50, 44))
    im = glow(im, lamps, AMBER, radius=8, alpha=0.45)
    d = ImageDraw.Draw(im)
    # parked cars nearest
    d.rectangle([6, 150, 70, 178], fill=(16, 16, 22))
    d.polygon([(16, 150), (60, 150), (54, 140), (24, 140)], fill=(22, 22, 30))
    d.rectangle([250, 150, 314, 178], fill=(16, 16, 22))
    d.polygon([(260, 150), (304, 150), (298, 140), (268, 140)], fill=(22, 22, 30))
    vignette(im, 0.35)
    noise(im, 5, 4)
    finish(im, "cs_outage_1", 20)


# ------------------------------------------------------------- outage 2
def outage_crowd():
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (6, 6, 12), (18, 16, 26))
    # a dead screen behind them
    d.rectangle([60, 10, 260, 90], fill=(14, 14, 20))
    d.rectangle([60, 10, 260, 90], outline=(30, 30, 40))
    r = random.Random(51)
    for _ in range(400):
        x, y = r.randint(62, 258), r.randint(12, 88)
        v = r.randint(16, 40)
        im.putpixel((x, y), (v, v, v + 4))
    d.rectangle([0, 120, W, H], fill=(10, 10, 14))
    # rows of people, back to front, all faces up, lit by their frames
    glows = []
    for row, (ybase, scale, n, seed) in enumerate([(104, 0.55, 18, 1), (124, 0.75, 13, 2), (150, 1.0, 9, 3), (182, 1.3, 7, 4)]):
        rr = random.Random(seed)
        xs = sorted(rr.randint(-10, W + 10) for _ in range(n))
        for x in xs:
            hw, hh = int(10 * scale), int(26 * scale)
            headr = int(6 * scale)
            body = lerp((20, 18, 26), (34, 30, 42), rr.random())
            d.rectangle([x - hw, ybase - hh, x + hw, ybase + 40], fill=body)
            # head tilted back: slightly up and behind the shoulders
            hx, hy = x + int(2 * scale), ybase - hh - headr + int(2 * scale)
            d.ellipse([hx - headr, hy - headr, hx + headr, hy + headr], fill=lerp(body, (60, 50, 60), 0.3))
            # the frames: two teal points where the eyes are, angled up
            ex = hx - int(2 * scale)
            ey = hy - int(2 * scale)
            d.rectangle([ex - 1, ey, ex, ey + max(1, int(scale))], fill=TEAL)
            d.rectangle([ex + int(4 * scale), ey - 1, ex + int(4 * scale) + 1, ey + max(1, int(scale))], fill=TEAL)
            # faint lit face
            d.ellipse([hx - headr + 1, hy - headr + 1, hx + headr - 1, hy + 1], outline=lerp(TEAL, body, 0.7))
            glows.append((hx, hy, int(5 * scale)))
    im = glow(im, glows, TEAL, radius=6, alpha=0.3)
    vignette(im, 0.35)
    noise(im, 4, 5)
    finish(im, "cs_outage_2", 36)


# ---------------------------------------------------------------- dreams
def dream_desk():
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (8, 12, 16), (20, 30, 28))
    r = random.Random(61)
    # pines, back to front
    for depth, (n, col, wmin, wmax) in enumerate([(26, (14, 22, 22), 3, 6), (14, (10, 16, 16), 6, 10), (7, (6, 10, 10), 10, 16)]):
        for _ in range(n):
            x = r.randint(0, W)
            w = r.randint(wmin, wmax)
            top = r.randint(-20, 30) + depth * 10
            d.rectangle([x - w // 2, top, x + w // 2, H], fill=col)
            for i in range(5):
                y = top + i * (24 + depth * 6)
                d.polygon([(x - w * 2, y + 20 + depth * 4), (x + w * 2, y + 20 + depth * 4), (x, y)], fill=col)
    # damp earth
    d.rectangle([0, 140, W, H], fill=(18, 16, 14))
    for _ in range(300):
        x, y = r.randint(0, W - 1), r.randint(140, H - 1)
        im.putpixel((x, y), lerp((18, 16, 14), (40, 34, 24), r.random()))
    # the desk, pristine, in a clearing
    d.rectangle([118, 112, 206, 118], fill=(70, 46, 30))
    d.rectangle([118, 118, 206, 150], fill=(52, 34, 22))
    d.rectangle([122, 122, 160, 146], fill=(44, 28, 18))
    d.rectangle([164, 122, 202, 146], fill=(44, 28, 18))
    d.rectangle([126, 132, 156, 134], fill=(80, 60, 40))
    d.rectangle([168, 132, 198, 134], fill=(80, 60, 40))
    d.rectangle([118, 150, 124, 170], fill=(40, 26, 16))
    d.rectangle([200, 150, 206, 170], fill=(40, 26, 16))
    # the eye carved into its surface, pulsing
    d.ellipse([148, 108, 176, 120], outline=RED, width=1)
    d.ellipse([157, 110, 167, 118], outline=RED, width=1)
    d.ellipse([160, 112, 164, 116], fill=RED)
    im = glow(im, [(162, 114, 12)], RED, radius=8, alpha=0.5)
    vignette(im, 0.35)
    noise(im, 5, 6)
    finish(im, "dream_desk")


def dream_chamber():
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    # hexagonal chamber, warm
    sky(d, (60, 36, 30), (120, 74, 48))
    cx, cy = 160, 100
    for i, rad in enumerate([150, 120, 92, 66]):
        pts = []
        for k in range(6):
            import math
            a = math.pi / 6 + k * math.pi / 3
            pts.append((cx + rad * math.cos(a), cy + rad * 0.78 * math.sin(a)))
        d.polygon(pts, outline=lerp((200, 140, 90), (60, 36, 30), i * 0.2))
    # five floating figures, slightly blurred
    layer = Image.new("RGB", (W, H), BLACK)
    ld = ImageDraw.Draw(layer)
    for (x, y, col) in [(70, 96, (120, 100, 150)), (115, 80, (200, 200, 210)), (160, 72, (240, 230, 190)), (205, 80, (90, 140, 180)), (250, 96, (160, 120, 90))]:
        ld.polygon([(x - 10, y + 46), (x + 10, y + 46), (x + 7, y), (x - 7, y)], fill=col)
        ld.ellipse([x - 7, y - 16, x + 7, y - 2], fill=col)
    layer = layer.filter(ImageFilter.GaussianBlur(1.6))
    im = Image.composite(Image.blend(im, layer, 0.85), im, layer.convert("L").point(lambda v: min(255, v * 2)))
    d = ImageDraw.Draw(im)
    # the librarian's star eyes
    d.point((157, 62), fill=(255, 255, 255))
    d.point((163, 62), fill=(255, 255, 255))
    # the floor, a glowing eye in the centre
    d.polygon([(0, 150), (W, 150), (W, H), (0, H)], fill=(50, 30, 24))
    d.ellipse([130, 152, 190, 170], outline=AMBER)
    d.ellipse([150, 156, 170, 166], outline=AMBER)
    d.ellipse([157, 159, 163, 163], fill=AMBER)
    im = glow(im, [(160, 161, 12)], AMBER, radius=8, alpha=0.4)
    vignette(im, 0.35)
    noise(im, 4, 7)
    finish(im, "dream_chamber", 24)


def dream_door():
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (30, 20, 40), (120, 80, 70))
    # cliff face
    r = random.Random(71)
    d.polygon([(0, 20), (W, 10), (W, 150), (0, 150)], fill=(70, 52, 40))
    for _ in range(900):
        x, y = r.randint(0, W - 1), r.randint(12, 150)
        im.putpixel((x, y), lerp((70, 52, 40), (110, 80, 56), r.random()))
    for _ in range(40):
        x, y = r.randint(0, W), r.randint(16, 140)
        d.line([(x, y), (x + r.randint(-20, 20), y + r.randint(4, 30))], fill=(44, 32, 26))
    # the door, no handle, the eye scorched in
    d.rectangle([128, 44, 192, 150], fill=(48, 44, 46))
    d.rectangle([128, 44, 192, 150], outline=(30, 26, 28), width=2)
    d.rectangle([132, 48, 188, 146], outline=(60, 56, 58))
    d.ellipse([142, 80, 178, 100], outline=(20, 12, 10), width=2)
    d.ellipse([153, 83, 167, 97], outline=(20, 12, 10), width=2)
    d.ellipse([157, 87, 163, 93], fill=(20, 12, 10))
    im = glow(im, [(160, 90, 10)], RED, radius=7, alpha=0.3)
    d = ImageDraw.Draw(im)
    # sand
    d.rectangle([0, 150, W, H], fill=(150, 108, 60))
    for _ in range(600):
        x, y = r.randint(0, W - 1), r.randint(150, H - 1)
        im.putpixel((x, y), lerp((150, 108, 60), (200, 150, 90), r.random()))
    # a small figure at the door, back to us, in a pale yellow top
    d.rectangle([154, 118, 166, 150], fill=(220, 200, 120))
    d.ellipse([152, 104, 168, 120], fill=(30, 22, 20))
    d.rectangle([156, 134, 164, 150], fill=(200, 170, 140))
    vignette(im, 0.35)
    noise(im, 5, 8)
    finish(im, "dream_door")



# ------------------------------------------------------------ Drop 3 panels
def figure(d, x, ybase, scale=1.0, body=(30, 28, 40), head=(70, 56, 60), tilt=0, frames=None, bow=False):
    """A silhouette seen from behind. tilt > 0 leans the head back; bow drops it."""
    hw, hh = int(10 * scale), int(28 * scale)
    headr = int(6 * scale)
    d.rectangle([x - hw, ybase - hh, x + hw, ybase], fill=body)
    hy = ybase - hh - headr + (int(6 * scale) if bow else -tilt)
    hx = x + (int(3 * scale) if tilt else 0)
    d.ellipse([hx - headr, hy - headr, hx + headr, hy + headr], fill=head)
    if frames:
        d.rectangle([hx - headr + 1, hy - 1, hx + headr - 1, hy + 1], fill=frames)


def tower_shape(d, cx, top, base_w, height, col, outline):
    d.polygon([(cx - base_w // 2, top + height), (cx + base_w // 2, top + height), (cx + base_w // 3, top), (cx - base_w // 3, top)], fill=col, outline=outline)


def tower_1():
    """The tower from the Spine at seven in the morning, every window teal."""
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (40, 36, 60), (150, 120, 120))
    # the boulevard's blocks either side
    d.polygon([(0, 60), (60, 50), (70, 150), (0, 150)], fill=(24, 22, 34))
    windows(d, 4, 56, 64, 146, step=(8, 9), lit=0.4, color=lerp(AMBER, (24, 22, 34), 0.5), dark=(16, 14, 22), seed=31)
    d.polygon([(260, 56), (320, 48), (320, 150), (250, 150)], fill=(24, 22, 34))
    windows(d, 262, 54, 318, 146, step=(8, 9), lit=0.4, color=lerp(AMBER, (24, 22, 34), 0.5), dark=(16, 14, 22), seed=32)
    # the tower: glass and metal musculature, every window teal
    tower_shape(d, 160, -10, 120, 162, (22, 30, 40), (60, 80, 90))
    windows(d, 112, 0, 208, 148, step=(6, 7), lit=0.97, color=TEAL, dark=(16, 24, 30), seed=33)
    for y in range(6, 150, 22):
        d.line([(104 + (150 - y) // 6, y), (216 - (150 - y) // 6, y)], fill=(70, 90, 100))
    # the plaza, the car, the door
    d.rectangle([0, 150, W, H], fill=(60, 64, 72))
    d.rectangle([0, 150, W, 154], fill=(90, 94, 102))
    d.rectangle([120, 134, 200, 152], fill=(14, 16, 24))
    d.rectangle([150, 128, 170, 152], fill=(10, 12, 18))
    d.rectangle([40, 158, 110, 178], fill=(18, 20, 28))
    d.polygon([(50, 158), (100, 158), (92, 148), (58, 148)], fill=(26, 28, 38))
    d.ellipse([44, 172, 58, 184], fill=(8, 8, 10)); d.ellipse([92, 172, 106, 184], fill=(8, 8, 10))
    im = glow(im, [(160, 70, 60)], TEAL, radius=18, alpha=0.25)
    vignette(im, 0.3)
    noise(im, 4, 41)
    finish(im, "cs_tower_1", 26)


def tower_2():
    """Floor 86: a wall of screens running the same three seconds, Turan's silhouette."""
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (16, 22, 30), (30, 40, 50))
    r = random.Random(43)
    for row in range(3):
        for col in range(6):
            x0, y0 = 8 + col * 52, 8 + row * 44
            d.rectangle([x0, y0, x0 + 46, y0 + 38], fill=(12, 16, 22), outline=(40, 56, 66))
            # the footage: two figures, a street
            d.rectangle([x0 + 2, y0 + 2, x0 + 44, y0 + 36], fill=(26, 30, 38))
            d.rectangle([x0 + 4, y0 + 26, x0 + 42, y0 + 36], fill=(38, 42, 52))
            for fx in (x0 + 18, x0 + 28):
                d.rectangle([fx - 3, y0 + 14, fx + 3, y0 + 30], fill=(8, 8, 12))
                d.ellipse([fx - 3, y0 + 8, fx + 3, y0 + 14], fill=(8, 8, 12))
            if r.random() < 0.3:
                d.line([(x0 + 2, y0 + r.randint(4, 34)), (x0 + 44, y0 + r.randint(4, 34))], fill=TEAL)
            # the stock ticker under each
            d.rectangle([x0 + 2, y0 + 32, x0 + 44, y0 + 36], fill=(60, 14, 14))
            d.line([(x0 + 4, y0 + 33), (x0 + 42, y0 + 35)], fill=RED)
    # the table and the team's backs, Turan turned toward us
    d.polygon([(0, 140), (W, 140), (W, H), (0, H)], fill=(24, 26, 34))
    d.polygon([(30, 150), (290, 150), (320, 180), (0, 180)], fill=(40, 42, 54))
    figure(d, 70, 176, 1.1, (28, 26, 36), (60, 50, 56))
    figure(d, 250, 176, 1.1, (30, 26, 32), (70, 56, 60))
    figure(d, 160, 170, 1.3, (44, 30, 36), (120, 90, 80))
    d.ellipse([154, 118, 166, 130], fill=(120, 90, 80))
    d.point((158, 124), fill=(10, 10, 10)); d.point((162, 124), fill=(10, 10, 10))
    im = glow(im, [(160, 60, 40)], (90, 120, 140), radius=20, alpha=0.2)
    vignette(im, 0.35)
    noise(im, 4, 44)
    finish(im, "cs_tower_2", 20)


def drive_1():
    """The Restricted Road at night through the windscreen: the checkpoint, sand across the lane."""
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (8, 8, 18), (40, 30, 40))
    r = random.Random(51)
    for _ in range(60):
        im.putpixel((r.randint(0, W - 1), r.randint(0, 60)), (200, 200, 220))
    # the flats and the road, converging
    d.polygon([(0, 100), (W, 100), (W, H), (0, H)], fill=(70, 54, 40))
    d.polygon([(100, 100), (220, 100), (320, H), (0, H)], fill=(30, 30, 36))
    for i in range(6):
        y = 104 + i * 14
        w = 2 + i * 4
        d.rectangle([160 - w // 2, y, 160 + w // 2, y + 5], fill=(120, 110, 90))
    for _ in range(400):
        x, y = r.randint(0, W - 1), r.randint(100, H - 1)
        if r.random() < 0.5:
            im.putpixel((x, y), lerp((70, 54, 40), SAND, r.random()))
    # sand drifting across the lane
    for _ in range(14):
        x0 = r.randint(40, 280); y = r.randint(110, 178)
        d.line([(x0, y), (x0 + r.randint(10, 60), y + r.randint(-2, 2))], fill=lerp(SAND, (30, 30, 36), 0.3))
    # the checkpoint: a booth, a barrier up, a sleeping guard's lit frames
    d.rectangle([200, 70, 236, 104], fill=(26, 28, 36), outline=(50, 52, 60))
    d.rectangle([206, 78, 230, 92], fill=(14, 16, 24))
    d.rectangle([214, 84, 218, 85], fill=TEAL)
    d.line([(196, 104), (196, 60)], fill=(80, 80, 90), width=3)
    d.line([(196, 62), (120, 50)], fill=(160, 40, 40), width=3)
    # headlight cone
    layer = Image.new("RGB", (W, H), BLACK)
    ld = ImageDraw.Draw(layer)
    ld.polygon([(120, 100), (200, 100), (300, H), (20, H)], fill=(60, 56, 40))
    layer = layer.filter(ImageFilter.GaussianBlur(10))
    im = Image.blend(im, Image.composite(layer, im, layer.convert("L")), 0.5)
    d = ImageDraw.Draw(im)
    # dashboard and wheel
    d.polygon([(0, 140), (W, 140), (W, H), (0, H)], fill=(46, 40, 50))
    d.ellipse([52, 146, 158, 250], outline=(88, 78, 92), width=9)
    d.rectangle([180, 150, 240, 176], fill=(8, 12, 16), outline=(50, 56, 70))
    d.rectangle([186, 156, 234, 160], fill=lerp(TEAL, BLACK, 0.3))
    d.rectangle([186, 164, 220, 168], fill=lerp(RED, BLACK, 0.3))
    vignette(im, 0.35)
    noise(im, 4, 52)
    finish(im, "cs_drive_1", 34)


def drive_2():
    """Lynx's sedan on the flats, doors open, under the cliff with the door in it."""
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (20, 14, 36), (110, 70, 70))
    r = random.Random(61)
    d.polygon([(0, 30), (W, 20), (W, 110), (0, 118)], fill=(70, 52, 40))
    for _ in range(700):
        x, y = r.randint(0, W - 1), r.randint(22, 116)
        im.putpixel((x, y), lerp((70, 52, 40), (110, 80, 56), r.random()))
    d.rectangle([150, 60, 182, 118], fill=(40, 36, 40), outline=(24, 20, 22))
    d.ellipse([158, 80, 174, 92], outline=(16, 10, 8), width=2)
    d.rectangle([0, 112, W, H], fill=(150, 108, 60))
    for _ in range(600):
        x, y = r.randint(0, W - 1), r.randint(112, H - 1)
        im.putpixel((x, y), lerp((150, 108, 60), (200, 150, 90), r.random()))
    # the sedan, doors open, a little sand on the roof
    d.rectangle([60, 120, 190, 158], fill=(26, 28, 36), outline=(10, 10, 14))
    d.polygon([(78, 120), (172, 120), (160, 104), (92, 104)], fill=(34, 36, 46), outline=(10, 10, 14))
    d.rectangle([96, 106, 156, 118], fill=(40, 46, 60))
    d.polygon([(60, 124), (36, 118), (36, 150), (60, 150)], fill=(30, 32, 42), outline=(10, 10, 14))
    d.polygon([(190, 124), (214, 118), (214, 150), (190, 150)], fill=(30, 32, 42), outline=(10, 10, 14))
    d.ellipse([70, 150, 92, 170], fill=(8, 8, 10)); d.ellipse([158, 150, 180, 170], fill=(8, 8, 10))
    d.rectangle([180, 128, 188, 134], fill=(120, 30, 30))
    d.line([(96, 104), (150, 102)], fill=SAND)
    # headlights still on, into the sand
    im = glow(im, [(190, 140, 10)], AMBER, radius=12, alpha=0.5)
    vignette(im, 0.35)
    noise(im, 5, 62)
    finish(im, "cs_drive_2", 30)


def vigil_1():
    """Leaving Fargona: from the top of the steps, a street of lit faces tilted back."""
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (10, 8, 20), (40, 30, 60))
    # the fractal above, faint, with the frames
    r = random.Random(71)
    for i in range(5):
        rad = 20 + i * 18
        d.ellipse([160 - rad, 40 - rad // 2, 160 + rad, 40 + rad // 2], outline=lerp((200, 120, 200), (40, 30, 60), 0.3 + i * 0.12))
    # the street receding, lamps out, candles along the kerbs
    d.polygon([(0, 90), (W, 90), (W, 160), (0, 160)], fill=(22, 20, 30))
    d.polygon([(110, 90), (210, 90), (300, 160), (20, 160)], fill=(30, 28, 40))
    glows = []
    for row, (ybase, scale, n, seed) in enumerate([(104, 0.4, 24, 1), (118, 0.55, 18, 2), (136, 0.75, 13, 3), (160, 1.0, 9, 4)]):
        rr = random.Random(seed + 70)
        xs = sorted(rr.randint(30, W - 30) for _ in range(n))
        for x in xs:
            figure(d, x, ybase, scale, lerp((20, 18, 26), (36, 30, 44), rr.random()), (60, 50, 60), tilt=int(4 * scale), frames=TEAL)
            glows.append((x + int(3 * scale), ybase - int(34 * scale), int(5 * scale)))
    for x in range(20, 300, 24):
        glows.append((x, 158, 3))
        d.rectangle([x - 1, 154, x + 1, 160], fill=(240, 220, 160))
    im = glow(im, glows, TEAL, radius=6, alpha=0.3)
    d = ImageDraw.Draw(im)
    # the steps, foreground
    for i in range(4):
        d.rectangle([0, 160 + i * 6, W, 166 + i * 6], fill=lerp((80, 84, 92), (40, 42, 48), i / 4))
    vignette(im, 0.35)
    noise(im, 4, 72)
    finish(im, "cs_vigil_1", 22)


def big_text(im, text, y, color):
    """Draws text at twice the bitmap font's size, centred, a clear gap between words."""
    words = text.split()
    gap = 6
    tmp = Image.new("RGB", (W, 12), BLACK)
    td = ImageDraw.Draw(tmp)
    widths = [int(td.textlength(w)) + 1 for w in words]
    tw = sum(widths) + gap * (len(words) - 1)
    x = (W - tw) / 2
    for w, ww in zip(words, widths):
        td.text((x, 0), w, fill=color)
        x += ww + gap
    tmp = tmp.resize((W * 2, 24), Image.NEAREST)
    mask = tmp.convert("L").point(lambda v: 255 if v > 110 else 0)
    layer = Image.new("RGB", (W * 2, 24), color)
    big = Image.composite(layer, Image.new("RGB", (W * 2, 24), BLACK), mask)
    big = big.crop((W // 2, 0, W // 2 + W, 24))
    mask = mask.crop((W // 2, 0, W // 2 + W, 24))
    im.paste(big, (0, y), mask)


def ending(kind):
    """The mirror, cleared, with Carl in it and the company he keeps behind him."""
    im = Image.new("RGB", (W, H), BLACK)
    d = ImageDraw.Draw(im)
    sky(d, (22, 22, 30), (56, 52, 62))
    # the stone mural eye and the mirror as its pupil
    d.ellipse([10, 14, 310, 176], outline=(96, 90, 100), width=3)
    d.ellipse([50, 34, 270, 156], outline=(96, 90, 100), width=2)
    d.ellipse([96, 36, 224, 154], fill=(70, 76, 92), outline=(170, 170, 180), width=3)
    r = random.Random(81)
    for _ in range(600):
        x, y = r.randint(98, 222), r.randint(38, 152)
        if (x - 160) ** 2 / 4000 + (y - 95) ** 2 / 3400 < 1:
            im.putpixel((x, y), lerp((70, 76, 92), (110, 118, 140), r.random()))
    d = ImageDraw.Draw(im)
    # behind Carl, in the glass
    if kind == "company":
        figure(d, 130, 128, 0.95, (60, 66, 90), (120, 96, 96))
        figure(d, 192, 128, 0.95, (90, 66, 76), (130, 104, 104))
        d.rectangle([130, 112, 136, 116], fill=(200, 60, 60))
        d.rectangle([136, 132, 186, 142], fill=(20, 22, 32)); d.rectangle([182, 128, 188, 142], fill=(14, 16, 24))
    elif kind == "investigator":
        figure(d, 190, 130, 1.0, (60, 54, 66), (150, 110, 80))
        d.rectangle([196, 116, 206, 120], fill=(40, 44, 50)); d.line([(196, 117), (204, 113)], fill=TEAL, width=2)
    elif kind == "sleeper":
        for i, x in enumerate(range(108, 216, 9)):
            figure(d, x, 126 + (i % 2) * 5, 0.6, (46, 42, 56), (90, 76, 86), tilt=4, frames=TEAL)
    # Carl, from behind, in the glass
    if kind == "sleeper":
        figure(d, 160, 150, 1.5, (44, 42, 54), (84, 66, 60), bow=True)
    else:
        figure(d, 160, 150, 1.5, (44, 42, 54), (84, 66, 60))
        if kind == "company":
            d.rectangle([150, 122, 158, 128], fill=TEAL)
    words = {"company": "PROTECT THE BRAND", "investigator": "FIND OUT WHAT HAPPENED", "sleeper": "BOW", "none": ""}[kind]
    if words:
        big_text(im, words, 44, TEAL)
    d = ImageDraw.Draw(im)
    d.polygon([(0, 152), (W, 152), (W, H), (0, H)], fill=(44, 42, 50))
    d.polygon([(80, 152), (240, 152), (262, 168), (58, 168)], fill=(68, 64, 72))
    im = glow(im, [(160, 95, 48)], (150, 160, 190), radius=18, alpha=0.25)
    vignette(im, 0.25)
    noise(im, 4, 82 + len(kind))
    finish(im, "ending_" + kind, 14)


if __name__ == "__main__" and "--drop3" in __import__("sys").argv:
    os.makedirs(OUT, exist_ok=True)
    tower_1(); tower_2(); drive_1(); drive_2(); vigil_1()
    for k in ("company", "investigator", "sleeper", "none"):
        ending(k)
    raise SystemExit

if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    opening_car()
    opening_tower()
    outage_boulevard()
    outage_crowd()
    dream_desk()
    dream_chamber()
    dream_door()
