#!/usr/bin/env python3
"""Paint Silico's building facades: albedo, lit-window emission, normal and
roughness maps, 512 px for a 10.5 m square of wall (three 3.5 m floors, four
2.625 m bays). Writes assets/facades/f<N>_{albedo,emit,normal,rough}.png.

Styles: 0 concrete flats (balconies, AC units, drip stains), 1 glass curtain
wall (mullions, spandrels, office strip lights), 2 precast megablock (panel
seams, small windows, rust and vents). Two seeds of each.

    python3 silico3d/tools/gen_facades.py
"""
import os
import numpy as np
from PIL import Image, ImageFilter

N = 512
PPM = N / 10.5          # pixels per metre
FLOOR = int(3.5 * PPM)  # 170 px
BAY = N // 4            # 128 px
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "facades")


def noise(rng, scale, amp):
    """Smooth value noise, tiling."""
    small = rng.random((max(2, N // scale), max(2, N // scale)))
    img = Image.fromarray((small * 255).astype(np.uint8)).resize((N, N), Image.BICUBIC)
    return (np.asarray(img, np.float32) / 255.0 - 0.5) * 2.0 * amp


def drips(rng, h, x0, x1, y0, length, amount):
    """Grime streaks running down from a ledge."""
    for _ in range(int((x1 - x0) * 0.25)):
        x = rng.integers(x0, x1)
        ln = int(length * rng.uniform(0.3, 1.0))
        w = rng.integers(1, 4)
        fall = np.linspace(amount, 0, ln)[:, None]
        h[y0:y0 + ln, x:x + w] -= fall[: max(0, min(ln, N - y0))]


def window(alb, emi, rough, height, rng, x0, y0, w, hgt, frame_c, lit_p, style):
    x1, y1 = x0 + w, y0 + hgt
    f = 5 if style != 1 else 3
    alb[y0:y1, x0:x1] = frame_c
    height[y0:y1, x0:x1] = 0.75
    gx0, gy0, gx1, gy1 = x0 + f, y0 + f, x1 - f, y1 - f
    # glass: sky reflection gradient, darker at the bottom
    g = np.linspace(1.0, 0.45, gy1 - gy0)[:, None, None]
    tint = np.array(rng.choice([[0.16, 0.2, 0.26], [0.12, 0.15, 0.18], [0.2, 0.22, 0.25], [0.1, 0.12, 0.16]]))
    alb[gy0:gy1, gx0:gx1] = tint * g
    rough[gy0:gy1, gx0:gx1] = 0.06
    height[gy0:gy1, gx0:gx1] = 0.15
    # a diagonal sheen
    for k in range(gy1 - gy0):
        s = gx0 + int((gx1 - gx0) * 0.2) + k // 2
        if s + 6 < gx1:
            alb[gy0 + k, s:s + 6] = np.minimum(alb[gy0 + k, s:s + 6] + 0.06, 1)
    # mullion
    if w > 70:
        mx = (gx0 + gx1) // 2
        alb[gy0:gy1, mx - 2:mx + 2] = frame_c
        height[gy0:gy1, mx - 2:mx + 2] = 0.75
    # interior: blinds, curtains, a lamp
    kind = rng.random()
    lit = rng.random() < lit_p
    col = np.array(rng.choice([[1.0, 0.72, 0.42], [1.0, 0.86, 0.62], [0.55, 0.85, 1.0], [1.0, 0.35, 0.7], [0.45, 1.0, 0.7]],
                              p=[0.38, 0.3, 0.18, 0.07, 0.07])) * rng.uniform(0.45, 0.95)
    if lit:
        e = np.linspace(0.75, 1.0, gy1 - gy0)[:, None, None] * col
        emi[gy0:gy1, gx0:gx1] = e
    if kind < 0.35:  # blinds
        drop = rng.integers(int((gy1 - gy0) * 0.2), gy1 - gy0)
        for y in range(gy0, gy0 + drop, 4):
            alb[y:y + 2, gx0:gx1] = alb[y:y + 2, gx0:gx1] * 0.5 + 0.25
            if lit:
                emi[y:y + 2, gx0:gx1] *= 0.35
    elif kind < 0.6:  # curtains at the sides
        cc = np.array(rng.choice([[0.5, 0.15, 0.12], [0.3, 0.32, 0.4], [0.55, 0.5, 0.35], [0.2, 0.3, 0.22]]))
        cw = (gx1 - gx0) // 4
        for xs in (slice(gx0, gx0 + cw), slice(gx1 - cw, gx1)):
            alb[gy0:gy1, xs] = cc * 0.6
            if lit:
                emi[gy0:gy1, xs] *= 0.25
    elif kind < 0.7 and lit:  # somebody standing at the glass
        cx = rng.integers(gx0 + 10, gx1 - 10)
        top = gy0 + (gy1 - gy0) // 4
        emi[top:gy1, cx - 7:cx + 7] *= 0.08
        yy, xx = np.ogrid[-9:10, -9:10]
        m = (xx ** 2 + yy ** 2) <= 72
        sub = emi[top - 10:top + 9, cx - 9:cx + 10]
        sub[m[: sub.shape[0], : sub.shape[1]]] *= 0.08
    # sill
    alb[y1:y1 + 6, x0 - 4:x1 + 4] = np.array(frame_c) * 0.9
    height[y1:y1 + 6, x0 - 4:x1 + 4] = 1.0
    return lit


def facade(style, seed):
    rng = np.random.default_rng(seed)
    alb = np.zeros((N, N, 3), np.float32)
    emi = np.zeros((N, N, 3), np.float32)
    rough = np.full((N, N), 0.88, np.float32)
    height = np.full((N, N), 0.5, np.float32)
    if style == 1:
        base = np.array([0.1, 0.13, 0.16]) + rng.uniform(0, 0.05)
        alb[:] = base
        for fy in range(3):
            y0 = fy * FLOOR
            # spandrel: the opaque band at the slab
            alb[y0:y0 + 34] = np.array([0.2, 0.21, 0.23]) + rng.uniform(-0.03, 0.03)
            rough[y0:y0 + 34] = 0.35
            height[y0:y0 + 34] = 0.6
            for bx in range(8):
                x0 = bx * 64
                window(alb, emi, rough, height, rng, x0, y0 + 34, 64, FLOOR - 34, [0.55, 0.57, 0.6], 0.38, 1)
            # office strip lights behind the glass, row by row
            for bx in range(8):
                if emi[y0 + 50, bx * 64 + 30].sum() > 0:
                    for ly in (y0 + 44, y0 + 46):
                        emi[ly, bx * 64 + 4:bx * 64 + 60] = [1.0, 1.0, 0.95]
        alb[:, ::64] = [0.6, 0.62, 0.66]
        height[:, ::64] = 0.85
    else:
        if style == 0:
            base = np.array([0.42, 0.4, 0.37]) * rng.uniform(0.85, 1.1)
        else:
            base = np.array([0.46, 0.46, 0.45]) * rng.uniform(0.8, 1.05)
        alb[:] = base
        n = noise(rng, 16, 0.06) + noise(rng, 4, 0.03)
        alb += n[..., None]
        height += n * 0.6
        frame = [0.78, 0.78, 0.76] if style == 0 else [0.28, 0.3, 0.32]
        for fy in range(3):
            y0 = fy * FLOOR
            if style == 0:
                # floor slab, a projecting band with stains below
                alb[y0 + FLOOR - 14:y0 + FLOOR] = base * 1.18
                height[y0 + FLOOR - 14:y0 + FLOOR] = 0.95
                drips(rng, alb[..., 0:1].squeeze(-1) if False else height, 0, N, min(N - 1, y0 + FLOOR), 60, 0.25)
            for bx in range(4):
                x0 = bx * BAY
                if style == 0:
                    window(alb, emi, rough, height, rng, x0 + 22, y0 + 34, 84, 92, frame, 0.33, 0)
                    if rng.random() < 0.45:  # balcony railing across the bay
                        ry = y0 + FLOOR - 50
                        alb[ry:ry + 4, x0 + 4:x0 + BAY - 4] = [0.15, 0.15, 0.16]
                        for rx in range(x0 + 6, x0 + BAY - 4, 9):
                            alb[ry:ry + 36, rx:rx + 2] = [0.15, 0.15, 0.16]
                        height[ry:ry + 36, x0 + 4:x0 + BAY - 4] = 0.9
                    if rng.random() < 0.4:  # AC unit under the sill
                        ax = x0 + rng.integers(24, 70)
                        ay = y0 + 134
                        alb[ay:ay + 22, ax:ax + 34] = [0.62, 0.62, 0.6]
                        alb[ay + 4:ay + 18, ax + 4:ax + 22:3] = [0.25, 0.25, 0.25]
                        height[ay:ay + 22, ax:ax + 34] = 1.0
                        drips(rng, height, ax, ax + 34, ay + 22, 50, 0.2)
                else:
                    for k in (0, 1):
                        window(alb, emi, rough, height, rng, x0 + 14 + k * 58, y0 + 50, 44, 58, frame, 0.3, 2)
                    if rng.random() < 0.3:  # vent grille
                        vx = x0 + rng.integers(20, 90)
                        for vy in range(y0 + 130, y0 + 150, 4):
                            alb[vy:vy + 2, vx:vx + 24] = base * 0.4
                    if rng.random() < 0.5:  # rust running from a bolt
                        rx = x0 + rng.integers(5, 120)
                        ln = rng.integers(30, 120)
                        alb[y0 + 8:y0 + 8 + ln, rx:rx + 3] = alb[y0 + 8:y0 + 8 + ln, rx:rx + 3] * 0.6 + np.array([0.36, 0.18, 0.08]) * 0.4
        if style == 2:
            # panel seams
            for y in range(0, N, FLOOR):
                alb[y:y + 3] *= 0.45
                height[y:y + 3] = 0.1
            for x in range(0, N, BAY):
                alb[:, x:x + 3] *= 0.5
                height[:, x:x + 3] = 0.1
        # weathering: darker towards the bottom of each tile, streaks
        alb *= np.linspace(1.05, 0.88, N)[:, None, None]
        for _ in range(40):
            x = rng.integers(0, N - 4)
            y = rng.integers(0, N - 40)
            ln = rng.integers(20, 160)
            alb[y:y + ln, x:x + rng.integers(1, 5)] *= 0.82
    alb = np.clip(alb, 0, 1)
    emi = np.clip(emi, 0, 1)
    # normal from height
    hm = Image.fromarray((np.clip(height, 0, 1) * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(1.2))
    h = np.asarray(hm, np.float32) / 255.0
    dx = (np.roll(h, -1, 1) - np.roll(h, 1, 1)) * 3.0
    dy = (np.roll(h, -1, 0) - np.roll(h, 1, 0)) * 3.0
    nz = np.ones_like(h)
    nrm = np.stack([-dx, dy, nz], -1)
    nrm /= np.linalg.norm(nrm, axis=-1, keepdims=True)
    return alb, emi, (nrm * 0.5 + 0.5), rough


def save(a, path):
    Image.fromarray((np.clip(a, 0, 1) * 255).astype(np.uint8)).save(path)


if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    for i in range(6):
        alb, emi, nrm, rough = facade(i % 3, 900 + i)
        save(alb, os.path.join(OUT, f"f{i}_albedo.png"))
        save(emi, os.path.join(OUT, f"f{i}_emit.png"))
        save(nrm, os.path.join(OUT, f"f{i}_normal.png"))
        save(rough, os.path.join(OUT, f"f{i}_rough.png"))
    print("wrote", OUT)


def shop(seed):
    """A shop interior seen through the glass: 8 m by 3 m, lit shelves, a
    counter, a screen, a figure behind it. Returns (albedo, emission)."""
    rng = np.random.default_rng(seed)
    W, H = 512, 192
    alb = np.zeros((H, W, 3), np.float32)
    emi = np.zeros((H, W, 3), np.float32)
    wall = np.array(rng.choice([[0.5, 0.42, 0.3], [0.32, 0.36, 0.4], [0.55, 0.5, 0.45], [0.25, 0.22, 0.28]]))
    alb[:] = wall * np.linspace(1.0, 0.45, H)[:, None, None]
    floor_y = int(H * 0.86)
    alb[floor_y:] = [0.2, 0.19, 0.18]
    light = np.array(rng.choice([[1.0, 0.85, 0.6], [0.8, 0.95, 1.0], [1.0, 0.6, 0.75], [0.7, 1.0, 0.8]]))
    # ceiling strip lights
    for x in range(20, W, 90):
        emi[6:10, x:x + 60] = light
        alb[10:floor_y, x:x + 60] += (light * 0.08)[None, None]
    # shelves with goods
    for sx in range(0, W, 128):
        if rng.random() < 0.7:
            for sy in range(44, floor_y - 10, 34):
                alb[sy:sy + 4, sx + 8:sx + 112] = [0.12, 0.1, 0.09]
                for gx in range(sx + 12, sx + 108, 12):
                    gc = rng.random(3) * 0.8 + 0.15
                    alb[sy - 20:sy, gx:gx + 9] = gc
                    if rng.random() < 0.4:
                        emi[sy - 20:sy, gx:gx + 9] = gc * 0.35
    # counter and a screen
    cx = rng.integers(60, W - 160)
    alb[floor_y - 40:floor_y, cx:cx + 120] = [0.28, 0.24, 0.2]
    alb[floor_y - 42:floor_y - 38, cx - 4:cx + 124] = [0.5, 0.48, 0.45]
    emi[40:72, cx + 20:cx + 80] = light * 0.6
    alb[40:72, cx + 20:cx + 80] = light * 0.6
    # someone behind the counter, dark against the light
    px = cx + rng.integers(10, 100)
    alb[floor_y - 95:floor_y - 40, px - 9:px + 9] = [0.05, 0.05, 0.06]
    yy, xx = np.ogrid[-9:10, -9:10]
    m = (xx ** 2 + yy ** 2) <= 70
    alb[floor_y - 108:floor_y - 89, px - 9:px + 10][m] = [0.07, 0.06, 0.06]
    emi *= 1.0
    emi += alb * 0.22  # the whole room reads lit from the street
    return alb, emi


def leaves(seed):
    """A cluster of leaves on alpha for canopy cards, 256 px."""
    rng = np.random.default_rng(seed)
    S = 256
    img = np.zeros((S, S, 4), np.float32)
    for _ in range(900):
        cx, cy = rng.integers(20, S - 20, 2)
        if (cx - S / 2) ** 2 + (cy - S / 2) ** 2 > (S * 0.44) ** 2:
            continue
        r = rng.integers(5, 11)
        shade = rng.uniform(0.55, 1.15)
        c = np.array([0.22, 0.38, 0.12]) * shade + np.array([0.08, 0.04, 0]) * rng.random()
        yy, xx = np.ogrid[-r:r + 1, -r:r + 1]
        ang = rng.random() * np.pi
        ex = xx * np.cos(ang) + yy * np.sin(ang)
        ey = -xx * np.sin(ang) + yy * np.cos(ang)
        m = (ex / r) ** 2 + (ey / (r * 0.5)) ** 2 <= 1
        sub = img[cy - r:cy + r + 1, cx - r:cx + r + 1]
        sub[m[: sub.shape[0], : sub.shape[1]]] = [*c, 1.0]
    return img


if __name__ == "__main__":
    for i in range(4):
        a, e = shop(500 + i)
        save(a, os.path.join(OUT, f"shop{i}_albedo.png"))
        save(e, os.path.join(OUT, f"shop{i}_emit.png"))
    Image.fromarray((np.clip(leaves(7), 0, 1) * 255).astype(np.uint8), "RGBA").save(os.path.join(OUT, "leaves.png"))
    print("wrote shops and leaves")
