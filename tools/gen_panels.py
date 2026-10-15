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


if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    opening_car()
    opening_tower()
    outage_boulevard()
    outage_crowd()
    dream_desk()
    dream_chamber()
    dream_door()
