#!/usr/bin/env python3
"""The arcade under Red Rock Plaza: cabinets, the Psymatchbot booth, the
prize counter ("50 tickets for a new phone, 200 for a companion"), the
ticket machine, the claw machine, a dance pad, and the Password Game's
chant on the wall. Writes into assets/props (+ props.json). Run after
redrock_art.py and before gen_maps.py."""
import json
import os
import random
from PIL import Image, ImageDraw

from redrock_art import (PROPS_DIR, OUT, AMBER, TEAL, MAGENTA, PAINT, new, glow, save_prop,
                         neon_word, graffiti)

PINK = (255, 110, 150)
BLUE = (90, 140, 255)
GREEN = (120, 240, 140)
RED = (224, 69, 58)


def cabinet(name, color, on, registry, screen_eye=False):
    """An upright arcade cabinet, one tile wide, a tile and a half tall."""
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((3, 10, 28, 46), fill=(30, 28, 40, 255), outline=OUT + (255,))
    d.rectangle((3, 2, 28, 11), fill=(44, 40, 58, 255), outline=OUT + (255,))      # marquee
    d.rectangle((6, 14, 25, 27), fill=(8, 8, 14, 255), outline=(70, 66, 84, 255))  # screen
    d.rectangle((5, 31, 26, 36), fill=(50, 46, 62, 255), outline=OUT + (255,))      # control panel
    d.ellipse((8, 32, 11, 35), fill=RED + (255,)); d.ellipse((13, 32, 16, 35), fill=AMBER + (255,))
    d.rectangle((21, 29, 23, 34), fill=(160, 160, 170, 255)); d.ellipse((19, 27, 25, 31), fill=RED + (255,))
    d.rectangle((5, 40, 26, 43), fill=(20, 18, 26, 255))  # coin door
    if on:
        g = new(32, 48)
        gd = ImageDraw.Draw(g)
        gd.rectangle((5, 4, 26, 9), fill=color + (255,))
        if screen_eye:
            gd.ellipse((9, 17, 22, 25), outline=color + (255,))
            gd.ellipse((14, 19, 17, 23), fill=RED + (255,))
        else:
            r = random.Random(name)
            for _ in range(14):
                x, y = r.randint(7, 23), r.randint(15, 25)
                gd.rectangle((x, y, x + 1, y + 1), fill=color + (255,))
        g = glow(g, color, radius=3, strength=0.8)
        im = Image.alpha_composite(im, g)
    else:
        d.rectangle((5, 4, 26, 9), fill=(40, 36, 44, 255))
        d.line((8, 16, 23, 25), fill=(60, 56, 70, 255)); d.line((23, 16, 8, 25), fill=(60, 56, 70, 255))
    save_prop(im, name, 1, registry)


def psymatch_booth(registry):
    """The Psymatchbot booth: a two-seat pod with a curtain and a heart-shaped
    light, Psyonic's corporate dating program in a coin-op shell."""
    im = new(64, 64)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle((4, 10, 59, 62), radius=8, fill=(40, 30, 52, 255), outline=OUT + (255,))
    d.rectangle((8, 20, 55, 56), fill=(18, 12, 26, 255), outline=(80, 60, 96, 255))
    # the curtain
    for x in range(10, 54, 6):
        d.rectangle((x, 22, x + 3, 54), fill=(96, 28, 60, 255))
        d.line((x + 1, 22, x + 1, 54), fill=(130, 40, 84, 255))
    d.rectangle((24, 30, 39, 42), fill=(10, 8, 14, 255), outline=(90, 70, 100, 255))  # the little screen
    d.text((25, 31), "97%", fill=PINK + (255,))
    d.rectangle((44, 46, 54, 54), fill=(60, 56, 70, 255), outline=OUT + (255,))  # coin slot
    g = new(64, 64)
    gd = ImageDraw.Draw(g)
    # the heart on the top panel
    gd.polygon([(32, 17), (24, 9), (20, 11), (20, 15), (32, 24), (44, 15), (44, 11), (40, 9)], fill=PINK + (255,))
    gd.ellipse((20, 6, 28, 14), fill=PINK + (255,)); gd.ellipse((36, 6, 44, 14), fill=PINK + (255,))
    g = glow(g, PINK, radius=4, strength=0.9)
    im = Image.alpha_composite(im, g)
    save_prop(im, "psymatch_booth", 1, registry)


def prize_counter(registry):
    """The prize counter: a glass case and shelves behind it. 50 tickets for a
    new phone, 200 for a companion. The plush eyes are 10."""
    im = new(96, 48)
    d = ImageDraw.Draw(im)
    # shelves behind
    d.rectangle((0, 0, 95, 26), fill=(36, 30, 40, 255), outline=OUT + (255,))
    for y in (8, 18):
        d.line((2, y, 93, y), fill=(70, 60, 76, 255))
    # the goods
    d.rectangle((6, 2, 12, 7), fill=(20, 20, 30, 255), outline=(120, 130, 150, 255))   # a phone
    d.rectangle((16, 1, 24, 7), fill=(200, 200, 210, 255)); d.rectangle((17, 2, 23, 6), fill=TEAL + (255,))  # frames box
    for x in (30, 40, 50):  # plush eyes
        d.ellipse((x, 1, x + 8, 7), fill=(240, 236, 220, 255)); d.ellipse((x + 3, 3, x + 5, 5), fill=RED + (255,))
    d.rectangle((62, 0, 90, 7), fill=(60, 40, 60, 255), outline=(140, 100, 140, 255))  # the long box
    d.text((64, -1), "SLEEP", fill=PINK + (255,))
    d.rectangle((6, 11, 20, 17), fill=(220, 180, 120, 255))  # tickets
    d.rectangle((28, 10, 36, 17), fill=(40, 40, 60, 255), outline=(120, 130, 150, 255))
    d.ellipse((44, 10, 52, 18), fill=(240, 236, 220, 255)); d.ellipse((47, 13, 49, 15), fill=RED + (255,))
    d.rectangle((60, 10, 90, 17), fill=(44, 36, 56, 255), outline=(120, 100, 140, 255))
    d.text((62, 9), "50 / 200", fill=AMBER + (255,))
    # the glass counter
    d.rectangle((0, 28, 95, 46), fill=(60, 70, 90, 180), outline=OUT + (255,))
    d.rectangle((0, 26, 95, 29), fill=(150, 150, 170, 255))
    d.line((4, 32, 30, 32), fill=(200, 210, 230, 120))
    d.rectangle((70, 32, 90, 42), fill=(30, 30, 40, 255), outline=(90, 90, 110, 255))  # the till
    d.text((72, 31), "T", fill=TEAL + (255,))
    save_prop(im, "prize_counter", 1, registry)


def ticket_machine(registry):
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((5, 6, 26, 46), fill=(50, 40, 44, 255), outline=OUT + (255,))
    d.rectangle((8, 10, 23, 20), fill=(10, 8, 12, 255), outline=(90, 80, 90, 255))
    d.text((9, 9), "TIX", fill=AMBER + (255,))
    d.rectangle((9, 26, 22, 29), fill=(14, 12, 16, 255))
    # tickets spilling out
    for i in range(6):
        d.rectangle((10 + i * 2, 29 + i * 2, 14 + i * 2, 31 + i * 2), fill=(230, 190, 120, 255), outline=(150, 110, 60, 255))
    g = new(32, 48)
    gd = ImageDraw.Draw(g)
    gd.rectangle((9, 10, 22, 12), fill=AMBER + (255,))
    g = glow(g, AMBER, radius=3, strength=0.7)
    im = Image.alpha_composite(im, g)
    save_prop(im, "ticket_machine", 1, registry)


def claw_machine(registry):
    im = new(32, 48)
    d = ImageDraw.Draw(im)
    d.rectangle((3, 2, 28, 46), fill=(30, 26, 36, 255), outline=OUT + (255,))
    d.rectangle((6, 6, 25, 30), fill=(40, 60, 80, 200), outline=(120, 140, 160, 255))
    r = random.Random(7)
    for _ in range(7):
        x, y = r.randint(7, 20), r.randint(20, 26)
        d.ellipse((x, y, x + 5, y + 4), fill=(240, 236, 220, 255)); d.ellipse((x + 2, y + 1, x + 3, y + 2), fill=RED + (255,))
    d.rectangle((14, 7, 16, 14), fill=(160, 160, 170, 255)); d.polygon([(12, 14), (18, 14), (15, 18)], fill=(160, 160, 170, 255))
    d.rectangle((6, 34, 25, 42), fill=(44, 40, 52, 255), outline=OUT + (255,))
    d.ellipse((13, 36, 18, 41), fill=RED + (255,))
    g = new(32, 48)
    gd = ImageDraw.Draw(g)
    gd.rectangle((6, 3, 25, 5), fill=BLUE + (255,))
    g = glow(g, BLUE, radius=3, strength=0.7)
    im = Image.alpha_composite(im, g)
    save_prop(im, "claw_machine", 1, registry)


def dance_pad(registry):
    """A floor pad, two tiles square: nine panels, the four arrows lit."""
    im = new(64, 64)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 2, 61, 61), fill=(36, 34, 44, 255), outline=OUT + (255,))
    for i in range(3):
        for j in range(3):
            x, y = 4 + i * 19, 4 + j * 19
            d.rectangle((x, y, x + 17, y + 17), fill=(28, 26, 34, 255), outline=(60, 58, 70, 255))
    g = new(64, 64)
    gd = ImageDraw.Draw(g)
    c = 32
    gd.polygon([(c, 8), (c - 6, 16), (c + 6, 16)], fill=TEAL + (255,))       # up
    gd.polygon([(c, 56), (c - 6, 48), (c + 6, 48)], fill=TEAL + (255,))      # down
    gd.polygon([(8, c), (16, c - 6), (16, c + 6)], fill=TEAL + (255,))       # left
    gd.polygon([(56, c), (48, c - 6), (48, c + 6)], fill=TEAL + (255,))      # right
    gd.ellipse((c - 5, c - 5, c + 5, c + 5), outline=RED + (255,))
    g = glow(g, TEAL, radius=3, strength=0.7)
    im = Image.alpha_composite(im, g)
    save_prop(im, "dance_pad", 0, registry)


def kids_table(registry):
    """A low table with two school tablets on it, one of them cracked."""
    im = new(64, 32)
    d = ImageDraw.Draw(im)
    d.rectangle((2, 6, 61, 28), fill=(96, 70, 50, 255), outline=OUT + (255,))
    d.rectangle((2, 24, 61, 28), fill=(70, 50, 36, 255))
    d.rectangle((10, 10, 26, 22), fill=(20, 20, 28, 255), outline=(120, 120, 130, 255))
    d.rectangle((12, 12, 24, 20), fill=TEAL + (255,))
    d.rectangle((36, 10, 52, 22), fill=(20, 20, 28, 255), outline=(120, 120, 130, 255))
    d.rectangle((38, 12, 50, 20), fill=(60, 70, 80, 255))
    d.line((38, 12, 50, 20), fill=(200, 200, 210, 255)); d.line((44, 12, 40, 20), fill=(200, 200, 210, 255))
    save_prop(im, "kids_table", 1, registry)


def main():
    registry = json.load(open(os.path.join(PROPS_DIR, "props.json")))
    cabinet("cab_serpent", GREEN, True, registry)
    cabinet("cab_hush", BLUE, True, registry)
    cabinet("cab_blastula", MAGENTA, True, registry)
    cabinet("cab_tower", AMBER, True, registry, screen_eye=True)
    cabinet("cab_dark", (0, 0, 0), False, registry)
    psymatch_booth(registry)
    prize_counter(registry)
    ticket_machine(registry)
    claw_machine(registry)
    dance_pad(registry)
    kids_table(registry)
    neon_word("neon_arcade", "ARCADE", MAGENTA, registry)
    neon_word("neon_psymatch", "MATCH", PINK, registry)
    graffiti("graffiti_gift", ["I GIVE MY GIFT", "I CLOSE THE DOOR"], registry)
    json.dump(registry, open(os.path.join(PROPS_DIR, "props.json"), "w"), indent=1, sort_keys=True)
    print("arcade props written")


if __name__ == "__main__":
    main()
