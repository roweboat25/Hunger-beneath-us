#!/usr/bin/env python3
"""Turns generated 16:9 concept images into 640x360 pixel-art backdrops for the
first-person close-up views (assets/closeups/*.png). Source jpgs live outside the
repo; set CLOSEUP_SRC to their folder."""
import os
import sys
from PIL import Image

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
SRC = os.environ.get("CLOSEUP_SRC", "")
OUT = os.path.join(ROOT, "assets", "closeups")


def convert(path, out):
    im = Image.open(path).convert("RGB")
    im = im.resize((320, 180), Image.LANCZOS)
    im = im.quantize(colors=48, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    im = im.resize((640, 360), Image.NEAREST)
    im.save(out)


def main():
    if not SRC or not os.path.isdir(SRC):
        sys.exit("set CLOSEUP_SRC to the folder of source jpgs")
    os.makedirs(OUT, exist_ok=True)
    n = 0
    for f in sorted(os.listdir(SRC)):
        if f.lower().endswith((".jpg", ".png")):
            convert(os.path.join(SRC, f), os.path.join(OUT, os.path.splitext(f)[0] + ".png"))
            n += 1
    print("closeups:", n)


if __name__ == "__main__":
    main()
