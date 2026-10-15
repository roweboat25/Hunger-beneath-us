#!/usr/bin/env python3
"""Builds the game's art from Liberated Pixel Cup (LPC Revised) sources.

Sources: https://github.com/ElizaWy/LPC (CC-BY 3.0 / OGA-BY 3.0).
Set LPC_SRC to a checkout of that repo. The files this script uses are
copied into assets/lpc_src/ so the repository stays self-contained, and
CREDITS.md is written from the Credits.txt files next to them.

Outputs:
  assets/tiles/tiles.png + atlas.json   32px tile atlas (floors, walls, terrain)
  assets/props/<name>.png + props.json  furniture and scenery sprites
  assets/sprites/<name>.png             layered character walk sheets (64x64 cells)
  assets/portraits/<name>.png           64x64 dialogue portraits
"""
import json
import os
import shutil
import sys

from PIL import Image, ImageDraw

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
ASSETS = os.path.join(ROOT, "assets")
SRC = os.environ.get("LPC_SRC", "")
LOCAL = os.path.join(ASSETS, "lpc_src")
GEN_PORTRAITS = os.environ.get("GEN_PORTRAITS", "")
T = 32

_used = set()


def src(rel):
    """Path to a source sheet, copying it into assets/lpc_src on first use."""
    _used.add(rel)
    local = os.path.join(LOCAL, rel)
    if os.path.exists(local):
        return local
    if not SRC:
        sys.exit(f"missing {rel}: set LPC_SRC to an ElizaWy/LPC checkout")
    os.makedirs(os.path.dirname(local), exist_ok=True)
    shutil.copy(os.path.join(SRC, rel), local)
    return local


_cache = {}


def sheet(rel):
    if rel not in _cache:
        _cache[rel] = Image.open(src(rel)).convert("RGBA")
    return _cache[rel]


def crop(rel, x, y, w, h):
    return sheet(rel).crop((x, y, x + w, y + h))


def tile(rel, tx, ty):
    return crop(rel, tx * T, ty * T, T, T)


# ------------------------------------------------------------------ tiles
W = "Structure/Walls/"
F = "Structure/Floor/"
PW = W + "Painted Walls.png"


def wall(color, group=0):
    """Painted Walls: 3 columns per colour, 4 rows per group (top, mid, bottom, single)."""
    c = 3 * color
    r = 4 * group
    return {"top": (PW, c, r), "mid": (PW, c, r + 1), "bot": (PW, c, r + 2), "one": (PW, c, r + 3)}


TILES = {
    # floors
    "wood_dark": (F + "Wood Floor A.png", 0, 3),
    "wood_dark2": (F + "Wood Floor A.png", 0, 4),
    "wood_warm": (F + "Wood Floor A.png", 2, 0),
    "wood_warm2": (F + "Wood Floor A.png", 2, 1),
    "wood_grey": (F + "Wood Floor A.png", 1, 3),
    "wood_grey2": (F + "Wood Floor A.png", 1, 4),
    "tile_white": (F + "Tile B.png", 0, 0),
    "tile_blue": (F + "Tile B.png", 1, 0),
    "tile_grey": (F + "Tile C.png", 2, 2),
    "tile_grey2": (F + "Tile C.png", 3, 2),
    "tile_dark": (F + "Tile C.png", 2, 6),
    "tile_dark2": (F + "Tile C.png", 3, 7),
    "tile_cream": (F + "Tile A.png", 0, 0),
    "carpet_navy": (F + "Geometric Carpet C.png", 2, 1),
    "carpet_red": (F + "Geometric Carpet C.png", 8, 1),
    "diamond_dark": (F + "Diamond Tile A.png", 2, 1),
    "diamond_navy": (F + "Diamond Tile A.png", 4, 3),
    "herringbone": (F + "Herringbone A.png", 1, 0),
    "subfloor": (F + "Subfloor.png", 0, 0),
    "asphalt": (F + "Gritty Dirt.png", 1, 1),
    "dirt_red": (F + "Gritty Dirt.png", 0, 1),
    # cement (Cement Platform A: flat, edge face, cracks)
    "cement": ("Structure/Platforms/Cement Platform A.png", 1, 2),
    "cement_b": ("Structure/Platforms/Cement Platform A.png", 1, 3),
    "cement_edge": ("Structure/Platforms/Cement Platform A.png", 1, 4),
    "cement_crack": ("Structure/Platforms/Cement Platform A.png", 1, 5),
    "cement_crack2": ("Structure/Platforms/Cement Platform A.png", 2, 5),
    "cement_dark": ("Structure/Platforms/Cement Platform A.png", 0, 1),
    # terrain
    "grass": ("Terrain/terrain_summer.png", 3, 1),
    "grass2": ("Terrain/terrain_summer.png", 4, 2),
    "grass3": ("Terrain/terrain_summer.png", 5, 1),
    "dirt": ("Terrain/terrain_summer.png", 3, 3),
    "dirt2": ("Terrain/terrain_summer.png", 4, 4),
    "sand": ("Terrain/cliff_summer.png", 1, 1),
    "sand2": ("Terrain/cliff_summer.png", 3, 1),
    "cliff_face": ("Terrain/cliff_summer.png", 5, 3),
    "cliff_face2": ("Terrain/cliff_summer.png", 6, 3),
    "cliff_face_b": ("Terrain/cliff_summer.png", 5, 4),
    "cliff_face_b2": ("Terrain/cliff_summer.png", 6, 4),
    "cliff_top": ("Terrain/cliff_summer.png", 2, 0),
    "cliff_top_l": ("Terrain/cliff_summer.png", 0, 1),
    "cliff_top_r": ("Terrain/cliff_summer.png", 4, 1),
    "cliff_top_bl": ("Terrain/cliff_summer.png", 5, 1),
    "cliff_top_br": ("Terrain/cliff_summer.png", 6, 1),
    "cliff_top_tl": ("Terrain/cliff_summer.png", 1, 0),
    "cliff_top_tr": ("Terrain/cliff_summer.png", 3, 0),
    # brick / stone walls (Brick Wall A: 3x3 blocks; Jagged Stone Walls)
    "brick_grey_top": (W + "Brick Wall A.png", 3, 0),
    "brick_grey_mid": (W + "Brick Wall A.png", 3, 1),
    "brick_grey_bot": (W + "Brick Wall A.png", 3, 2),
    "brick_dark_top": (W + "Brick Wall A.png", 0, 6),
    "brick_dark_mid": (W + "Brick Wall A.png", 0, 7),
    "brick_dark_bot": (W + "Brick Wall A.png", 0, 8),
    "brick_red_top": (W + "Brick Wall A.png", 3, 3),
    "brick_red_bot": (W + "Brick Wall A.png", 3, 5),
    "stone_top": (W + "Jagged Stone Walls.png", 0, 6),
    "stone_mid": (W + "Jagged Stone Walls.png", 0, 7),
    "stone_bot": (W + "Jagged Stone Walls.png", 0, 8),
    "stone_grey_top": (W + "Jagged Stone Walls.png", 3, 0),
    "stone_grey_bot": (W + "Jagged Stone Walls.png", 3, 2),
    # drywall (office)
    "drywall_top": (W + "Drywall.png", 0, 0),
    "drywall_mid": (W + "Drywall.png", 0, 1),
    "drywall_bot": (W + "Drywall.png", 0, 2),
    "drywall_top2": (W + "Drywall.png", 1, 0),
    "drywall_bot2": (W + "Drywall.png", 1, 2),
    # windows (Stone Windows A: columns dark / light / lit; rows 1-2 = 2-tall window)
    "window_dark_top": ("Structure/Windows/Stone Windows A.png", 0, 1),
    "window_dark_bot": ("Structure/Windows/Stone Windows A.png", 0, 2),
    "window_lit_top": ("Structure/Windows/Stone Windows A.png", 2, 1),
    "window_lit_bot": ("Structure/Windows/Stone Windows A.png", 2, 2),
    "window_day_top": ("Structure/Windows/Stone Windows A.png", 1, 1),
    "window_day_bot": ("Structure/Windows/Stone Windows A.png", 1, 2),
    "window_short_dark": ("Structure/Windows/Stone Windows A.png", 0, 3),
    "window_short_day": ("Structure/Windows/Stone Windows A.png", 1, 3),
    # door frames (Doorframe A: 3x2 per frame, cols 0-2 cream, 3-5 grey)
    "frame_l_top": ("Structure/Doors/32x48px Doors/Doorframe A.png", 3, 0),
    "frame_r_top": ("Structure/Doors/32x48px Doors/Doorframe A.png", 5, 0),
    "frame_c_top": ("Structure/Doors/32x48px Doors/Doorframe A.png", 4, 0),
    "frame_l_bot": ("Structure/Doors/32x48px Doors/Doorframe A.png", 3, 1),
    "frame_r_bot": ("Structure/Doors/32x48px Doors/Doorframe A.png", 5, 1),
    "frame_c_bot": ("Structure/Doors/32x48px Doors/Doorframe A.png", 4, 1),
    # misc flat
    "void": None,  # solid black, drawn by the script
    "shadow_floor": None,
}
# painted walls, by colour index (3-column blocks left to right) and row group
WALL_COLOURS = {
    "apt": wall(3, 0),      # grey
    "home": wall(2, 0),     # cream
    "hosp": wall(0, 0),     # pale blue
    "lynx": wall(5, 1),     # darker purple group
    "navy": wall(4, 1),
    "peach": wall(1, 0),
}
for _name, _parts in WALL_COLOURS.items():
    for _part, _loc in _parts.items():
        TILES[f"wall_{_name}_{_part}"] = _loc

ATLAS_COLS = 16


def build_tiles():
    names = list(TILES)
    rows = (len(names) + ATLAS_COLS - 1) // ATLAS_COLS
    atlas = Image.new("RGBA", (ATLAS_COLS * T, rows * T), (0, 0, 0, 0))
    index = {}
    for i, name in enumerate(names):
        ax, ay = i % ATLAS_COLS, i // ATLAS_COLS
        loc = TILES[name]
        if loc is None:
            im = Image.new("RGBA", (T, T), (6, 6, 10, 255) if name == "void" else (0, 0, 0, 90))
        else:
            im = tile(*loc)
        atlas.alpha_composite(im, (ax * T, ay * T))
        index[name] = [ax, ay]
    out = os.path.join(ASSETS, "tiles")
    os.makedirs(out, exist_ok=True)
    atlas.save(os.path.join(out, "tiles.png"))
    with open(os.path.join(out, "atlas.json"), "w") as f:
        json.dump(index, f, indent=1, sort_keys=True)
    print("tiles:", len(names), atlas.size)


# ------------------------------------------------------------------ props
O = "Objects/Furniture/"
S = "Objects/Small Items/"
WI = "Objects/Wall Items/"
# name: (sheet, (x, y, w, h) in pixels, solid rows from the bottom)
PROPS = {
    # office / apartment
    "desk_dark": (O + "Desk, Office.png", (0, 64, 64, 64), 2),
    "desk_light": (O + "Desk, Office.png", (128, 64, 64, 64), 2),
    "desk_wood": (O + "Desk, Office.png", (0, 0, 64, 64), 2),
    "desk_long_wood": (O + "Desk, Office.png", (0, 0, 192, 64), 2),
    "desk_grey": (O + "Desk, Office.png", (0, 128, 64, 64), 2),
    "laptop_open": (S + "Laptop.png", (0, 0, 32, 32), 0),
    "laptop_dark": (S + "Laptop.png", (32, 0, 32, 32), 0),
    "laptop_closed": (S + "Laptop.png", (0, 96, 32, 32), 0),
    "chair_office": (O + "Seating/Chair, Office.png", (0, 0, 32, 32), 1),
    "chair_office_back": (O + "Seating/Chair, Office.png", (0, 32, 32, 32), 1),
    "water_cooler": (O + "Water Cooler.png", (0, 0, 32, 64), 1),
    "copy_machine": (O + "Copy Machine.png", (0, 0, 64, 64), 1),
    "vending": (O + "Vending Machine.png", (0, 0, 64, 64), 1),
    "vending_dark": (O + "Vending Machine.png", (96, 0, 64, 64), 1),
    "paper": (S + "Loose Paper.png", (32, 64, 32, 32), 0),
    "paper2": (S + "Loose Paper.png", (64, 64, 32, 32), 0),
    "paper3": (S + "Loose Paper.png", (0, 32, 32, 32), 0),
    "shelf": (O + "Shelf.png", (0, 0, 96, 32), 1),
    "bookcase": (O + "Cabinet.png", (64, 96, 64, 64), 1),
    "bookcase_empty": (O + "Cabinet.png", (0, 96, 64, 64), 1),
    "cabinet": (O + "Cabinet.png", (0, 0, 64, 64), 1),
    "bin": (O + "Bin.png", (64, 0, 32, 64), 1),
    "bin_white": (O + "Bin.png", (128, 0, 32, 64), 1),
    "box": (S + "Boxes.png", (0, 0, 32, 32), 1),
    "box_open": (S + "Boxes.png", (32, 0, 32, 32), 1),
    "crate": (O + "Crate.png", (0, 0, 32, 64), 1),
    "crate_small": (O + "Crate.png", (64, 32, 32, 32), 1),
    "barrel": (O + "Barrel.png", (0, 0, 32, 64), 1),
    # living room / bedroom
    "sofa_grey": (O + "Seating/Sofa, Casual A.png", (0, 0, 96, 48), 1),
    "sofa_blue": (O + "Seating/Sofa, Casual A.png", (0, 128, 96, 48), 1),
    "sofa_brown": (O + "Seating/Sofa, Casual A.png", (320, 128, 96, 48), 1),
    "sofa_navy": (O + "Seating/Sofa, Casual A.png", (160, 128, 96, 48), 1),
    "sofa_orange": (O + "Seating/Sofa, Casual A.png", (160, 0, 96, 48), 1),
    "armchair_grey": (O + "Seating/Sofa, Casual A.png", (96, 0, 64, 48), 1),
    "tv": (O + "TV, Widescreen.png", (0, 0, 96, 64), 1),
    "tv_small": (O + "TV, Widescreen.png", (240, 0, 64, 64), 1),
    "table": (O + "Table, Card.png", (0, 0, 96, 64), 2),
    "table_wood": (O + "Table, Card.png", (0, 128, 96, 64), 2),
    "chair_front": (O + "Seating/Chair, Dining E.png", (0, 0, 32, 32), 1),
    "chair_back": (O + "Seating/Chair, Dining E.png", (32, 0, 32, 32), 1),
    "lamp_floor": (O + "Lighting, Floor.png", (0, 0, 32, 64), 1),
    "lamp_floor_dark": (O + "Lighting, Floor.png", (96, 64, 32, 64), 1),
    "lamp_table": (S + "Lighting, Table.png", (160, 32, 32, 32), 0),
    "end_table": (O + "End Table.png", (0, 0, 32, 32), 1),
    "planter": (O + "Planter.png", (0, 0, 32, 64), 1),
    "planter_small": (O + "Planter.png", (128, 32, 32, 32), 1),
    "rug_blue": (O + "Rugs/Swirling Vine Rug.png", (0, 0, 96, 64), 0),
    "rug_red": (O + "Rugs/Swirling Vine Rug.png", (0, 64, 96, 64), 0),
    "painting": (WI + "Paintings, Landscape.png", (0, 0, 64, 32), 0),
    "painting2": (WI + "Paintings, Landscape.png", (64, 0, 64, 32), 0),
    "poster": (WI + "Posters.png", (0, 32, 32, 32), 0),
    "poster2": (WI + "Posters.png", (32, 32, 32, 32), 0),
    "poster3": (WI + "Posters.png", (96, 32, 32, 32), 0),
    "poster_blank": (WI + "Posters.png", (0, 0, 32, 32), 0),
    "curtain": (WI + "Curtains.png", (0, 0, 64, 96), 0),
    "curtain_dark": (WI + "Curtains.png", (0, 288, 64, 96), 0),
    "bed_single": (O + "Beds/Beds, Single B.png", (256, 192, 64, 96), 2),
    "bed_single_dark": (O + "Beds/Beds, Single B.png", (128, 192, 64, 96), 2),
    "bed_single_white": (O + "Beds/Beds, Single B.png", (384, 192, 64, 96), 2),
    "bed_wood": (O + "Beds/Beds, Single C.png", (0, 0, 64, 96), 2),
    "bed_child_red": (O + "Beds/Beds, Child.png", (0, 0, 64, 80), 2),
    "bed_child_blue": (O + "Beds/Beds, Child.png", (192, 0, 64, 80), 2),
    "bed_child_yellow": (O + "Beds/Beds, Child.png", (96, 0, 64, 80), 2),
    "dresser": (O + "Dresser.png", (160, 0, 64, 64), 1),
    "dresser_dark": (O + "Dresser.png", (160, 192, 64, 64), 1),
    "mirror_standing": (O + "Mirror, Standing.png", (0, 0, 64, 64), 1),
    "pillow": (S + "Pillows.png", (0, 0, 32, 32), 0),
    "blanket": (S + "Fabric/Blankets, Crumpled.png", (0, 0, 64, 64), 0),
    # kitchen
    "counter": (O + "Countertop.png", (64, 0, 64, 64), 1),
    "counter_l": (O + "Countertop.png", (0, 0, 32, 64), 1),
    "counter_r": (O + "Countertop.png", (160, 0, 32, 64), 1),
    "fridge": (O + "Fridge.png", (0, 0, 32, 64), 1),
    "oven": (O + "Oven, Modern.png", (0, 0, 32, 64), 1),
    "sink": (O + "Sink, Countertop.png", (0, 0, 32, 64), 1),
    "coffee_maker": (S + "Coffee Maker.png", (0, 0, 32, 64), 1),
    "dishes": (S + "Dishes A.png", (0, 0, 32, 32), 0),
    "phone": (S + "Rotary Phones.png", (0, 0, 32, 32), 0),
    # hospital
    "wheelchair": (O.replace("Furniture", "Moveable") + "Wheelchair, Black.png", (0, 96, 64, 64), 1),
    "drain": ("Structure/Misc/Drain A.png", (0, 0, 32, 64), 0),
    # outdoors
    "lamp_post": (O + "Lighting, Outdoors.png", (0, 0, 32, 96), 1),
    "lamp_post_off": (O + "Lighting, Outdoors.png", (32, 0, 32, 96), 1),
    "mailboxes": (WI + "Mailboxes (tiling).png", (32, 32, 32, 32), 1),
    "fence_h": ("Structure/Fences/Plain Fence A.png", (0, 0, 96, 32), 1),
    "fence_iron": ("Structure/Fences/Ornamental Fence B.png", (0, 0, 96, 32), 1),
    "cart": (O.replace("Furniture", "Moveable") + "Shopping Cart.png", (0, 0, 32, 64), 1),
    "graffiti_band": (WI + "Graffiti.png", (0, 0, 64, 64), 0),
    "graffiti_danger": (WI + "Graffiti.png", (64, 0, 96, 64), 0),
    "graffiti_loot": (WI + "Graffiti.png", (160, 0, 96, 64), 0),
    "graffiti_green": (WI + "Graffiti.png", (64, 64, 96, 64), 0),
    "rock_big": ("Terrain/Rocks, Cliffs.png", (0, 0, 64, 64), 1),
    "rock_med": ("Terrain/Rocks, Cliffs.png", (64, 0, 64, 64), 1),
    "rock_small": ("Terrain/Rocks, Cliffs.png", (96, 64, 32, 32), 1),
    "rock_tiny": ("Terrain/Rocks, Cliffs.png", (160, 64, 32, 32), 0),
    "rock_grey": ("Terrain/Rocks, Grasslands.png", (0, 0, 64, 64), 1),
    "rock_grey_small": ("Terrain/Rocks, Grasslands.png", (96, 64, 32, 32), 1),
    "bush": ("Terrain/plants_summer.png", (0, 0, 32, 32), 1),
    "bush2": ("Terrain/plants_summer.png", (64, 0, 32, 32), 1),
    "bush_dark": ("Terrain/plants_summer.png", (0, 64, 32, 64), 1),
    "shrub": ("Terrain/plants_summer.png", (96, 96, 64, 64), 1),
    "grass_tuft": ("Terrain/plants_summer.png", (256, 0, 32, 32), 0),
    "reeds": ("Terrain/plants_summer.png", (352, 0, 32, 64), 0),
    "tree": ("Terrain/trees_summer.png", (128, 0, 96, 128), 1),
    "tree2": ("Terrain/trees_summer.png", (320, 0, 96, 160), 1),
    "tree_small": ("Terrain/trees_summer.png", (320, 160, 96, 128), 1),
    "tree_dead": ("Terrain/trees_summer.png", (0, 256, 96, 160), 1),
    "pine": ("Terrain/trees_summer.png", (128, 384, 96, 128), 1),
    "stump": ("Terrain/trees_summer.png", (32, 416, 32, 64), 1),
    "fire": (S + "Fire, Camp.png", (32, 32, 32, 32), 1),
    "fire_out": (S + "Fire, Camp.png", (0, 0, 32, 32), 0),
    "stone_slab": (O + "Stone Slab.png", (0, 0, 64, 32), 1),
    "cobweb": (S + "Dungeon Elements.png", (32, 0, 32, 32), 0),
    "moss": (S + "Dungeon Elements.png", (0, 0, 32, 64), 0),
    "pillar": ("Structure/Pillars/Stone Pillar A.png", (192, 0, 32, 96), 1),
    "pillar_short": ("Structure/Pillars/Stone Pillar A.png", (192, 96, 32, 96), 1),
    "dias": ("Structure/Platforms/Dias with Steps A.png", (0, 0, 96, 96), 0),
    "cement_stairs": ("Structure/Stairs/Cement Stairs A.png", (0, 0, 32, 64), 0),
    "cave": ("Terrain/cliff_summer.png", (192, 288, 128, 96), 0),
    "cave_door": ("Terrain/cliff_summer.png", (224, 288, 64, 96), 0),
}


def trim(im):
    bbox = im.getbbox()
    if bbox is None:
        return im
    # keep the horizontal size (tiles align by column), trim rows only
    return im.crop((0, bbox[1], im.size[0], bbox[3]))


def build_props():
    out = os.path.join(ASSETS, "props")
    os.makedirs(out, exist_ok=True)
    for f in os.listdir(out):
        if f.endswith(".png"):
            os.remove(os.path.join(out, f))
    index = {}
    for name, (rel, rect, solid) in PROPS.items():
        im = crop(rel, *rect)
        if im.getbbox() is None:
            print("  WARNING empty prop", name)
        im = trim(im)
        im.save(os.path.join(out, name + ".png"))
        index[name] = {"w": im.size[0], "h": im.size[1], "solid": solid}
    for name, (im, solid) in custom_props().items():
        im.save(os.path.join(out, name + ".png"))
        index[name] = {"w": im.size[0], "h": im.size[1], "solid": solid}
    with open(os.path.join(out, "props.json"), "w") as f:
        json.dump(index, f, indent=1, sort_keys=True)
    print("props:", len(index))


def custom_props():
    """Things LPC has no sheet for, drawn here in the same palette family."""
    P = {}

    def new(w, h):
        return Image.new("RGBA", (w, h), (0, 0, 0, 0))

    def outline(im, col=(28, 20, 24, 255)):
        px = im.load()
        w, h = im.size
        src = im.copy().load()
        for y in range(h):
            for x in range(w):
                if src[x, y][3]:
                    continue
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < w and 0 <= ny < h and src[nx, ny][3] and src[nx, ny] != col:
                        px[x, y] = col
                        break
        return im

    # sedan (Psyonic-issued, dark) and Carl's car (blue)
    for name, body, light in (("sedan", (46, 48, 62), (74, 78, 96)), ("car_blue", (52, 86, 140), (90, 130, 190))):
        im = new(64, 40)
        d = ImageDraw.Draw(im)
        d.rounded_rectangle([3, 12, 60, 34], 6, fill=body)
        d.rounded_rectangle([14, 4, 50, 22], 5, fill=light)
        d.rectangle([17, 7, 47, 18], fill=(150, 196, 214))
        d.line([32, 7, 32, 18], fill=light)
        d.rectangle([5, 24, 58, 30], fill=light)
        for x in (10, 48):
            d.ellipse([x, 30, x + 10, 39], fill=(30, 28, 34))
            d.ellipse([x + 3, 33, x + 7, 36], fill=(120, 120, 130))
        d.rectangle([4, 16, 7, 19], fill=(255, 230, 160))
        d.rectangle([56, 16, 59, 19], fill=(255, 230, 160))
        P[name] = (outline(im), 1)

    # tent
    im = new(64, 56)
    d = ImageDraw.Draw(im)
    d.polygon([(2, 50), (32, 6), (62, 50)], fill=(62, 96, 92))
    d.polygon([(32, 6), (62, 50), (32, 50)], fill=(48, 76, 74))
    d.polygon([(22, 50), (32, 22), (42, 50)], fill=(20, 24, 30))
    d.line([(2, 50), (62, 50)], fill=(40, 60, 58), width=3)
    P["tent"] = (outline(im), 1)

    # park bench
    im = new(64, 32)
    d = ImageDraw.Draw(im)
    for y in (6, 11):
        d.rectangle([2, y, 61, y + 3], fill=(140, 92, 54))
    d.rectangle([2, 17, 61, 21], fill=(150, 100, 60))
    for x in (6, 54):
        d.rectangle([x, 4, x + 3, 30], fill=(60, 60, 70))
        d.rectangle([x - 2, 22, x + 5, 24], fill=(60, 60, 70))
    P["bench"] = (outline(im), 1)

    # cactus
    im = new(32, 64)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([12, 8, 20, 60], 4, fill=(70, 130, 70))
    d.rounded_rectangle([3, 20, 9, 40], 3, fill=(70, 130, 70))
    d.rectangle([8, 36, 12, 40], fill=(70, 130, 70))
    d.rounded_rectangle([23, 14, 29, 34], 3, fill=(70, 130, 70))
    d.rectangle([20, 30, 24, 34], fill=(70, 130, 70))
    for y in range(12, 58, 5):
        d.point([(14, y), (18, y + 2)], fill=(150, 200, 130))
    P["cactus"] = (outline(im), 1)

    # elevator doors
    im = new(64, 64)
    d = ImageDraw.Draw(im)
    d.rectangle([0, 0, 63, 63], fill=(96, 100, 112))
    d.rectangle([4, 6, 59, 61], fill=(150, 156, 170))
    d.rectangle([30, 6, 33, 61], fill=(60, 62, 72))
    d.rectangle([8, 10, 27, 57], fill=(170, 176, 190))
    d.rectangle([36, 10, 55, 57], fill=(170, 176, 190))
    d.rectangle([24, 1, 39, 4], fill=(40, 40, 48))
    d.rectangle([26, 2, 37, 3], fill=(120, 220, 170))
    P["elevator"] = (im, 1)

    # the eyes on the floor, blood, the stick and the ritual circle, the tablet, the glyph
    im = new(32, 16)
    d = ImageDraw.Draw(im)
    for x in (6, 18):
        d.ellipse([x, 3, x + 9, 12], fill=(230, 226, 220))
        d.ellipse([x + 3, 6, x + 6, 9], fill=(60, 120, 110))
        d.point([(x + 4, 7)], fill=(10, 10, 10))
    d.ellipse([2, 10, 30, 15], fill=(120, 20, 24))
    P["eyes"] = (outline(im), 0)
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.ellipse([4, 8, 28, 26], fill=(110, 18, 22))
    d.ellipse([10, 4, 20, 12], fill=(110, 18, 22))
    d.ellipse([22, 18, 30, 28], fill=(110, 18, 22))
    d.ellipse([12, 14, 20, 20], fill=(140, 30, 34))
    P["blood"] = (im, 0)
    im = new(32, 16)
    d = ImageDraw.Draw(im)
    d.line([(3, 11), (28, 5)], fill=(110, 80, 50), width=3)
    d.line([(16, 8), (22, 2)], fill=(110, 80, 50), width=2)
    P["stick"] = (outline(im), 0)
    im = new(64, 64)
    d = ImageDraw.Draw(im)
    d.ellipse([4, 4, 59, 59], outline=(110, 80, 50), width=3)
    d.ellipse([20, 20, 43, 43], outline=(110, 80, 50), width=2)
    for a in range(0, 360, 45):
        import math
        x, y = 32 + 24 * math.cos(math.radians(a)), 32 + 24 * math.sin(math.radians(a))
        d.line([(32, 32), (x, y)], fill=(110, 80, 50), width=1)
    P["stick_circle"] = (im, 0)
    im = new(32, 24)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([2, 2, 29, 21], 3, fill=(30, 30, 36))
    d.rectangle([5, 5, 26, 18], fill=(120, 220, 190))
    d.ellipse([12, 8, 19, 15], outline=(30, 30, 36))
    P["tablet"] = (outline(im), 0)
    im = new(32, 24)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([2, 2, 29, 21], 3, fill=(30, 30, 36))
    d.rectangle([5, 5, 26, 18], fill=(60, 60, 70))
    d.line([(8, 8), (23, 16)], fill=(200, 200, 210), width=2)
    d.line([(23, 8), (8, 16)], fill=(200, 200, 210), width=2)
    P["tablet_broken"] = (outline(im), 0)
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.ellipse([2, 8, 29, 23], outline=(120, 220, 190), width=2)
    d.ellipse([11, 11, 20, 20], fill=(120, 220, 190))
    d.ellipse([14, 14, 17, 17], fill=(20, 24, 30))
    P["glyph"] = (im, 0)
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.ellipse([2, 8, 29, 23], outline=(150, 40, 40), width=2)
    d.ellipse([11, 11, 20, 20], fill=(150, 40, 40))
    P["glyph_red"] = (im, 0)
    # big mirror for the chamber: the standing mirror at double size
    m = crop(O + "Mirror, Standing.png", 0, 0, 64, 64)
    m = trim(m)
    P["mirror_big"] = (m.resize((m.size[0] * 2, m.size[1] * 2), Image.NEAREST), 1)
    # nightlight glow and a broken picture frame pile
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.ellipse([2, 2, 29, 29], fill=(255, 220, 150, 70))
    d.ellipse([10, 10, 21, 21], fill=(255, 235, 180, 160))
    P["nightlight"] = (im, 0)
    im = new(32, 32)
    d = ImageDraw.Draw(im)
    d.rectangle([2, 10, 18, 24], outline=(120, 90, 50), width=2)
    d.rectangle([14, 4, 30, 18], outline=(120, 90, 50), width=2)
    d.line([(16, 6), (28, 16)], fill=(200, 200, 210))
    d.line([(4, 12), (16, 22)], fill=(200, 200, 210))
    P["frames_broken"] = (im, 0)
    return P


# ------------------------------------------------------------- characters
C = "Characters/"
MT = C + "Clothing/Masculine, Thin/"
FT = C + "Clothing/Feminine, Thin/"


def layer_paths(kind, item, colour=None):
    """Walk and Idle sheets for one layer."""
    base = f"{kind}/{item}" if item else kind
    if colour:
        base = f"{base}/{colour}"
    return base + "/Walk.png", base + "/Idle.png"


# Output sheet: 4 rows (down, left, right, up) x 9 columns (idle, walk 1-8), 64px cells.
LPC_ROWS = {"up": 0, "left": 1, "down": 2, "right": 3}
OUT_ROWS = ["down", "left", "right", "up"]


def compose(layers, out_path, tint_regions=None, child=False):
    """layers: list of (walk_rel, idle_rel). Later layers draw on top."""
    walk = Image.new("RGBA", (512, 256), (0, 0, 0, 0))
    idle = Image.new("RGBA", (192, 256), (0, 0, 0, 0))
    for wrel, irel in layers:
        w = sheet(wrel)
        if w.size != walk.size:
            w = w.crop((0, 0, 512, 256))
        walk.alpha_composite(w)
        i = sheet(irel)
        idle.alpha_composite(i.crop((0, 0, 192, 256)))
    if tint_regions:
        walk = tint(walk, tint_regions, 8)
        idle = tint(idle, tint_regions, 3)
    out = Image.new("RGBA", (9 * 64, 4 * 64), (0, 0, 0, 0))
    for r, d in enumerate(OUT_ROWS):
        lr = LPC_ROWS[d]
        out.alpha_composite(idle.crop((0, lr * 64, 64, lr * 64 + 64)), (0, r * 64))
        for f in range(8):
            out.alpha_composite(walk.crop((f * 64, lr * 64, f * 64 + 64, lr * 64 + 64)), ((f + 1) * 64, r * 64))
    out.save(out_path)


def tint(im, regions, cols):
    """Recolour skin inside a band of each cell (used to dress the children).
    regions: list of (y0, y1, (r, g, b)) in cell coordinates."""
    px = im.load()
    w, h = im.size
    for cy in range(4):
        for cx in range(cols):
            for (y0, y1, rgb) in regions:
                for y in range(cy * 64 + y0, cy * 64 + y1):
                    for x in range(cx * 64, cx * 64 + 64):
                        r, g, b, a = px[x, y]
                        if a == 0:
                            continue
                        lum = (0.3 * r + 0.59 * g + 0.11 * b) / 255.0
                        lum = 0.45 + lum * 0.7
                        px[x, y] = (min(255, int(rgb[0] * lum)), min(255, int(rgb[1] * lum)), min(255, int(rgb[2] * lum)), a)
    return im


def adult(skin, head="Head 02 - Masculine", hair=None, hair_colour="Black", shirt=("Shirt 01 - Longsleeve Shirt", "Gray"),
          pants=("Pants 03 - Pants", "Charcoal"), shoes=("Shoes 01 - Shoes", "Black"), over=None, glasses=None,
          beard=None, fem=False, hair_behind=False):
    cl = FT if fem else MT
    body = "Body 01 - Feminine, Thin" if fem else "Body 02 - Masculine, Thin"
    layers = []
    if hair_behind and hair:
        layers.append(layer_paths(C + "Hair", hair + "/_Behind", hair_colour))
    layers.append(layer_paths(C + "Body", body, skin))
    if shoes:
        layers.append(layer_paths(cl + "Feet", shoes[0], shoes[1]))
    if pants:
        layers.append(layer_paths(cl + "Legs", pants[0], pants[1]))
    if shirt:
        layers.append(layer_paths(cl + "Torso", shirt[0], shirt[1]))
    if over:
        layers.append(layer_paths(cl + "Torso 2", over[0], over[1]))
    layers.append(layer_paths(C + "Head", head, skin))
    if beard:
        layers.append(layer_paths(C + "Hair", beard[0], beard[1]))
    if hair:
        layers.append(layer_paths(C + "Hair", hair, hair_colour))
    if glasses:
        layers.append(layer_paths(C + "Head Accessories", "Eyewear 01 - Glasses", glasses))
    return layers


def child(skin, hair=None, hair_colour="Black"):
    layers = [
        (C + "Children/Body/" + skin + "/walk.png", C + "Children/Body/" + skin + "/idle.png"),
        (C + "Children/Head/Head 01 - Default/" + skin + "/walk.png", C + "Children/Head/Head 01 - Default/" + skin + "/idle.png"),
    ]
    return layers


CHARACTERS = {
    "carl": dict(layers=adult("Tan", hair="Short 03 - Curly", hair_colour="Raven", shirt=("Shirt 07 - Buttoned Longsleeve Shirt", "Dove"),
                              over=("Sweater 01 - Cardigan", "Forest"), pants=("Pants 03 - Pants", "Charcoal"), glasses="Steel",
                              beard=("Facial Hair 06 - Trimmed Beard", "Raven"))),
    "carl_noglasses": dict(layers=adult("Tan", hair="Short 03 - Curly", hair_colour="Raven", shirt=("Shirt 07 - Buttoned Longsleeve Shirt", "Dove"),
                                        over=("Sweater 01 - Cardigan", "Forest"), pants=("Pants 03 - Pants", "Charcoal"),
                                        beard=("Facial Hair 06 - Trimmed Beard", "Raven"))),
    "officer": dict(layers=adult("Peach", hair="Short 01 - Buzzcut", hair_colour="Black", shirt=("Shirt 07 - Buttoned Longsleeve Shirt", "Navy"),
                                 pants=("Pants 03 - Pants", "Navy"), beard=("Facial Hair 02 - Chevron Mustache", "Black"))),
    "lynx": dict(layers=adult("Porcelain", head="Head 01 - Feminine", fem=True, hair="Medium 01 - Page", hair_colour="Black", hair_behind=True,
                              shirt=("Shirt 01 - Longsleeve Shirt", "Charcoal"), over=None, pants=("Pants 03 - Pants", "Black"), glasses="Iron")),
    "seth": dict(layers=adult("Honey", hair="Medium 01 - Page", hair_colour="Brown", hair_behind=True, shirt=("Shirt 01 - Longsleeve Shirt", "Lemon"),
                              pants=("Pants 04 - Cuffed Pants", "Charcoal"), shoes=("Shoes 02 - Boots", "Brown"))),
    "tyson": dict(layers=adult("Tawny", hair="Short 06 - Balding", hair_colour="Gray", shirt=("Shirt 01 - Longsleeve Shirt", "Olivine"),
                               pants=("Pants 03 - Pants", "Umber"), beard=("Facial Hair 07 - Medium Beard", "Gray"))),
    "monica": dict(layers=adult("Brown", head="Head 01 - Feminine", fem=True, hair="Medium 02 - Curly", hair_colour="Black", hair_behind=True,
                                shirt=("Shirt 03 - Scoop Longsleeve Shirt", "Lavender"), pants=("Pants 03 - Pants", "Midnight"))),
    "turan": dict(layers=adult("Porcelain", head="Head 03 - Elderly", fem=True, hair="Medium 04 - Bangs & Bun", hair_colour="Gray",
                               shirt=("Shirt 07 - Buttoned Longsleeve Shirt", "Black"), over=("Sweater 01 - Cardigan", "Soot"),
                               pants=("Pants 03 - Pants", "Black"), glasses="Silver")),
    "emmet": dict(layers=adult("Ivory", hair="Short 04 - Cowlick", hair_colour="Red", shirt=("Shirt 01 - Longsleeve Shirt", "Denim"),
                               pants=("Pants 03 - Pants", "Charcoal"), glasses="Brass")),
    "forner": dict(layers=adult("Peach", head="Head 03 - Elderly", hair="Short 06 - Balding", hair_colour="White",
                                shirt=("Shirt 07 - Buttoned Longsleeve Shirt", "Ivory"), over=("Sweater 01 - Cardigan", "Leather"),
                                pants=("Pants 03 - Pants", "Umber"), beard=("Facial Hair 06 - Trimmed Beard", "White"))),
    "nurse": dict(layers=adult("Tan", head="Head 01 - Feminine", fem=True, hair="Medium 04 - Bangs & Bun", hair_colour="Chestnut",
                               shirt=("Shirt 04 - T-shirt", "Mint"), pants=("Pants 03 - Pants", "Mint"), glasses="Silver", shoes=("Shoes 01 - Shoes", "White"))),
    "dufredy": dict(layers=adult("Porcelain", head="Head 03 - Elderly", hair=None, shirt=("Shirt 04 - T-shirt", "Linen"),
                                 pants=("Pants 02 - Leggings", "Linen"), shoes=None)),
    "masked": dict(layers=adult("Porcelain", hair="Short 01 - Buzzcut", hair_colour="Black", shirt=("Shirt 01 - Longsleeve Shirt", "Black"),
                                pants=("Pants 03 - Pants", "Black"), shoes=("Shoes 02 - Boots", "Black"))),
    "eyeless": dict(layers=adult("Ivory", hair="Short 05 - Natural", hair_colour="Charcoal", shirt=("Shirt 07 - Buttoned Longsleeve Shirt", "Smoke"),
                                 pants=("Pants 03 - Pants", "Charcoal"))),
    "bot": dict(layers=adult("Porcelain", hair=None, shirt=("Shirt 01 - Longsleeve Shirt", "Silver"),
                             pants=("Pants 02 - Leggings", "Silver"), shoes=("Shoes 02 - Boots", "Silver"))),
    # children have no clothing layers in LPC Revised; dress them by tinting bands of the cell
    "mira": dict(layers=child("Brown"), tint=[(40, 52, (245, 214, 160)), (52, 61, (120, 100, 170))], child=True),
    "ezra": dict(layers=child("Tan"), tint=[(40, 52, (70, 140, 90)), (52, 61, (60, 64, 90))], child=True),
}


def build_characters():
    out = os.path.join(ASSETS, "sprites")
    os.makedirs(out, exist_ok=True)
    for name, spec in CHARACTERS.items():
        compose(spec["layers"], os.path.join(out, name + ".png"), spec.get("tint"), spec.get("child", False))
    # child hair: paste a scaled-down curly hair? Keep simple: draw a hair cap on the children.
    for name, colour in (("mira", (28, 22, 24)), ("ezra", (38, 30, 26))):
        p = os.path.join(out, name + ".png")
        im = Image.open(p)
        add_child_hair(im, colour)
        im.save(p)
    # drop shadow
    sh = Image.new("RGBA", (32, 12), (0, 0, 0, 0))
    ImageDraw.Draw(sh).ellipse([3, 1, 28, 10], fill=(0, 0, 0, 90))
    sh.save(os.path.join(out, "shadow.png"))
    print("characters:", len(CHARACTERS))


def add_child_hair(im, colour):
    """Children's heads are bald in the source; paint a simple curly cap on each frame."""
    px = im.load()
    w, h = im.size
    for cy in range(h // 64):
        for cx in range(w // 64):
            ox, oy = cx * 64, cy * 64
            # find the head top in this cell: first opaque row
            top = None
            for y in range(64):
                if any(px[ox + x, oy + y][3] > 0 for x in range(64)):
                    top = y
                    break
            if top is None:
                continue
            # paint a cap over the top 7 rows of the head, following its silhouette
            for y in range(top, top + 7):
                xs = [x for x in range(64) if px[ox + x, oy + y][3] > 0]
                if not xs:
                    continue
                x0, x1 = min(xs), max(xs)
                for x in range(x0, x1 + 1):
                    shade = 1.0 if (x + y) % 3 else 0.8
                    px[ox + x, oy + y] = (int(colour[0] * shade), int(colour[1] * shade), int(colour[2] * shade), 255)
                # a little volume beyond the silhouette
                if y < top + 5:
                    for x in (x0 - 1, x1 + 1):
                        if 0 <= x < 64:
                            px[ox + x, oy + y] = (colour[0], colour[1], colour[2], 255)


# -------------------------------------------------------------- portraits
PORTRAIT_BG = (16, 18, 36, 255)


def build_portraits():
    out = os.path.join(ASSETS, "portraits")
    os.makedirs(out, exist_ok=True)
    done = set()
    if GEN_PORTRAITS and os.path.isdir(GEN_PORTRAITS):
        for f in sorted(os.listdir(GEN_PORTRAITS)):
            if not f.lower().endswith((".jpg", ".png")):
                continue
            name = os.path.splitext(f)[0]
            im = Image.open(os.path.join(GEN_PORTRAITS, f)).convert("RGB")
            im = im.resize((96, 96), Image.LANCZOS)
            im = im.quantize(48, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGBA")
            im.save(os.path.join(out, name + ".png"))
            done.add(name)
    # the rest: sprite head close-ups, so every speaker has a face
    sprites = os.path.join(ASSETS, "sprites")
    for name in CHARACTERS:
        if name in done:
            continue
        sp = Image.open(os.path.join(sprites, name + ".png"))
        head = sp.crop((16, 8, 48, 40))  # idle, facing down: head and shoulders
        head = head.resize((96, 96), Image.NEAREST)
        bg = Image.new("RGBA", (96, 96), PORTRAIT_BG)
        bg.alpha_composite(head)
        bg.save(os.path.join(out, name + ".png"))
    print("portraits:", len(CHARACTERS), "generated:", len(done))


# ---------------------------------------------------------------- credits
def write_credits():
    lines = ["# Art credits", "",
             "Tiles, furniture and character parts come from the LPC Revised project",
             "(https://github.com/ElizaWy/LPC), licensed CC-BY 3.0 / OGA-BY 3.0.",
             "The source sheets used are kept under assets/lpc_src/. Their authors,",
             "from the Credits.txt files that accompany them:", ""]
    seen = set()
    for rel in sorted(_used):
        d = os.path.dirname(rel)
        while d and d not in seen:
            seen.add(d)
            for cname in ("Credits.txt", "credit.txt", "Credit.txt"):
                p = os.path.join(SRC or LOCAL, d, cname)
                if os.path.exists(p):
                    with open(p, errors="replace") as f:
                        text = f.read().strip()
                    lines += [f"## {d}", "", "```", text[:4000], "```", ""]
                    local = os.path.join(LOCAL, d, cname)
                    if SRC and not os.path.exists(local):
                        os.makedirs(os.path.dirname(local), exist_ok=True)
                        shutil.copy(p, local)
                    break
            d = os.path.dirname(d)
    lines += ["## Files used", ""] + [f"- {r}" for r in sorted(_used)]
    with open(os.path.join(ASSETS, "CREDITS.md"), "w") as f:
        f.write("\n".join(lines) + "\n")


def main():
    build_tiles()
    build_props()
    build_characters()
    build_portraits()
    write_credits()


if __name__ == "__main__":
    main()
