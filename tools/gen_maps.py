#!/usr/bin/env python3
"""Writes the tileset resource and the map scenes from text layouts.

Maps are plain Godot .tscn files afterwards: open them in the editor and
paint on them like any other TileMapLayer. Re-running this script
overwrites them, so once a map is hand-edited, stop regenerating it.
"""
import os
import struct

ROOT = os.path.join(os.path.dirname(__file__), "..")
TILE = 16

# atlas coords for each legend character (see gen_art.py TILES order)
LEGEND = {
    ".": (0, 0), ",": (1, 0), "s": (2, 0), "T": (3, 0), "W": (4, 0), "N": (5, 0), "D": (6, 0), "L": (7, 0),
    "B": (0, 1), "E": (1, 1), "|": (2, 1), "G": (3, 1), "b": (4, 1), "Y": (5, 1), "d": (6, 1), "h": (7, 1),
    "C": (0, 2), "P": (1, 2), "K": (2, 2), "H": (3, 2), "g": (4, 2), "p": (5, 2), "n": (6, 2), "t": (7, 2),
    "Q": (0, 3), "a": (1, 3), "c": (2, 3), "j": (3, 3), "A": (4, 3), "S": (5, 3), "i": (6, 3), "V": (7, 3),
    "f": (0, 4), "m": (1, 4), "M": (2, 4), "l": (3, 4), "r": (4, 4), "R": (5, 4), "x": (6, 4), "v": (7, 4),
    "O": (0, 5), "I": (1, 5), "k": (2, 5), "z": (3, 5), "o": (4, 5), "u": (5, 5), "U": (6, 5), "F": (7, 5),
    "w": (0, 6), "q": (1, 6), "e": (2, 6), "X": (3, 6), "J": (4, 6), "-": (5, 6), "~": (6, 6),
}
SOLID = {"T", "W", "N", "D", "L", "G", "Y", "h", "C", "P", "K",
         "n", "t", "Q", "A", "S", "V", "m", "M", "r", "R", "v", "O", "I", "k", "U", "w", "q", "e", "X", "J"}
# ground-layer stand-in under objects so the floor shows if an object is removed
UNDER = {"D": ".", "L": ".", "h": ".", "C": ",", "P": ".", "K": ".",
         "n": "p", "t": "p", "A": "j", "i": "j", "m": "f", "R": "x", "v": "x", "X": "x",
         "z": ".", "o": ".", "u": ".", "q": ".", "e": ".", "L": "."}


def tileset_tres(path):
    lines = [
        '[gd_resource type="TileSet" load_steps=2 format=3]',
        '',
        '[ext_resource type="Texture2D" path="res://assets/tiles/tiles.png" id="1_tiles"]',
        '',
        '[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_apt"]',
        'texture = ExtResource("1_tiles")',
        'texture_region_size = Vector2i(16, 16)',
    ]
    for ch, (x, y) in LEGEND.items():
        lines.append(f"{x}:{y}/0 = 0")
        if ch in SOLID:
            lines.append(f"{x}:{y}/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)")
    lines += [
        '',
        '[resource]',
        'physics_layer_0/collision_layer = 1',
        'physics_layer_0/collision_mask = 1',
        'sources/0 = SubResource("TileSetAtlasSource_apt")',
        '',
    ]
    with open(path, "w") as f:
        f.write("\n".join(lines))


def encode_cells(cells):
    """TileMapLayer.tile_map_data: uint16 version 0, then 12 bytes per cell."""
    data = struct.pack("<H", 0)
    for (x, y), (ax, ay) in cells:
        data += struct.pack("<hhhhhh", x, y, 0, ax, ay, 0)
    return "PackedByteArray(" + ", ".join(str(b) for b in data) + ")"


def layers_from_rows(rows):
    ground, objects = [], []
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch == " " or ch not in LEGEND:
                continue
            if ch in UNDER:
                ground.append(((x, y), LEGEND[UNDER[ch]]))
                objects.append(((x, y), LEGEND[ch]))
            else:
                ground.append(((x, y), LEGEND[ch]))
    return ground, objects


def tscn(name, script, rows, player_tile, interactables, path, npcs=()):
    for r in rows:
        assert len(r) == len(rows[0]), (name, r)
    ground, objects = layers_from_rows(rows)
    w, h = len(rows[0]) * TILE, len(rows) * TILE
    shapes = {(16, 16): "RectangleShape2D_16x16"}
    for it in interactables:
        size = it.get("size", (16, 16))
        shapes.setdefault(size, f"RectangleShape2D_{size[0]}x{size[1]}")
    out = [
        f'[gd_scene load_steps={5 + len(shapes)} format=3]',
        '',
        '[ext_resource type="TileSet" path="res://assets/tiles/tileset.tres" id="1_tileset"]',
        f'[ext_resource type="Script" path="res://scripts/maps/{script}" id="2_script"]',
        '[ext_resource type="PackedScene" path="res://scenes/Player.tscn" id="3_player"]',
        '[ext_resource type="Script" path="res://scripts/Interactable.gd" id="4_interact"]',
        '[ext_resource type="Script" path="res://scripts/NPC.gd" id="5_npc"]',
        '',
    ]
    for size, sid in shapes.items():
        out += [f'[sub_resource type="RectangleShape2D" id="{sid}"]', f'size = Vector2({size[0]}, {size[1]})', '']
    out += [
        f'[node name="{name}" type="Node2D"]',
        'script = ExtResource("2_script")',
        f'map_size = Vector2i({w}, {h})',
        '',
        '[node name="Ground" type="TileMapLayer" parent="."]',
        f'tile_map_data = {encode_cells(ground)}',
        'tile_set = ExtResource("1_tileset")',
        '',
        '[node name="Objects" type="TileMapLayer" parent="."]',
        f'tile_map_data = {encode_cells(objects)}',
        'tile_set = ExtResource("1_tileset")',
        '',
        '[node name="Interactables" type="Node2D" parent="."]',
        '',
    ]
    seen = {}
    for it in interactables:
        size = it.get("size", (16, 16))
        sid = shapes[size]
        tx, ty = it["tile"]
        px = tx * TILE + size[0] / 2
        py = ty * TILE + size[1] / 2
        node = it["id"].title().replace("_", "")
        seen[node] = seen.get(node, 0) + 1
        if seen[node] > 1:
            node += str(seen[node])
        out += [
            f'[node name="{node}" type="Area2D" parent="Interactables"]',
            f'position = Vector2({px:g}, {py:g})',
            'script = ExtResource("4_interact")',
            f'id = "{it["id"]}"',
        ]
        if it.get("on_enter"):
            out.append("on_enter = true")
        if it.get("once") is False:
            out.append("once = false")
        out += ['', f'[node name="Shape" type="CollisionShape2D" parent="Interactables/{node}"]', f'shape = SubResource("{sid}")', '']
    for n in npcs:
        tx, ty = n["tile"]
        node = "Npc" + n["id"].title().replace("_", "")
        out += [
            f'[node name="{node}" type="Area2D" parent="Interactables"]',
            f'position = Vector2({tx * TILE + 8}, {ty * TILE + 8})',
            'script = ExtResource("5_npc")',
            f'id = "{n["id"]}"',
            f'sprite_sheet = "res://assets/sprites/{n.get("sprite", n["id"])}.png"',
            f'facing = "{n.get("facing", "down")}"',
            '', f'[node name="Shape" type="CollisionShape2D" parent="Interactables/{node}"]',
            'shape = SubResource("RectangleShape2D_16x16")', '',
        ]
    px, py = player_tile[0] * TILE + 8, player_tile[1] * TILE + 8
    out += [
        '[node name="Player" parent="." instance=ExtResource("3_player")]',
        f'position = Vector2({px}, {py})',
        '',
    ]
    with open(path, "w") as f:
        f.write("\n".join(out))


APARTMENT = [
    "TTTTTTTYYYYTTTTTTTTTTTTTTTTTTT",
    "TWWWWWWGGGGWWWWWWWWTWWWWNWWWWT",
    "T.,..........,.KKKKTC.,,,,,,CT",
    "T......,.......,...TChh.,,,,CT",
    "T..,.....P.........TChh,,..DLT",
    "T.........,.,......TC.,,,...,T",
    "T,....,............T.,,,,,.,,T",
    "T......s...,.......T,,,.,,,,,T",
    "T...s.....,......,..,,...,,,.T",
    "T.,.........,,.....T,,,.EB,,,T",
    "T.......,.........,T,,,,....,T",
    "T...,,......,.....,T,,.|,,,,,T",
    "T.........s........T,..,,,,,CT",
    "T,.....,..........,TC,,,,,,,CT",
    "T..........,...,...TCC,,,,,CCT",
    "T.........,........T,,,,,,,,,T",
    "TTTdTTTTTTTTTTTTTTTTTTTTTTTTTT",
]

APARTMENT_INTERACTABLES = [
    {"id": "balcony", "tile": (7, 1), "size": (64, 16)},
    {"id": "kitchen", "tile": (15, 2), "size": (64, 16)},
    {"id": "plant", "tile": (9, 4)},
    {"id": "debris", "tile": (12, 9), "size": (32, 16)},
    {"id": "debris", "tile": (4, 8)},
    {"id": "stain", "tile": (24, 1)},
    {"id": "cardboard", "tile": (20, 2), "size": (16, 32)},
    {"id": "cardboard", "tile": (28, 12), "size": (16, 32)},
    {"id": "bed", "tile": (21, 3), "size": (32, 32)},
    {"id": "desk", "tile": (27, 4)},
    {"id": "laptop", "tile": (28, 4)},
    {"id": "eyes", "tile": (24, 9), "size": (32, 16)},
    {"id": "stick", "tile": (23, 11), "on_enter": True},
    {"id": "under_eye", "tile": (25, 6), "size": (48, 48), "on_enter": True, "once": False},
    {"id": "exit", "tile": (3, 15), "on_enter": True, "once": False},
]


# ----------------------------------------------------------------- layouts
def grid(w, h, ch):
    return [[ch] * w for _ in range(h)]


def rect(g, x0, y0, x1, y1, ch):
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            g[y][x] = ch


def put(g, x, y, ch):
    g[y][x] = ch


def rows(g):
    return ["".join(r) for r in g]


def border(g, ch="T"):
    h, w = len(g), len(g[0])
    rect(g, 0, 0, w - 1, 0, ch)
    rect(g, 0, h - 1, w - 1, h - 1, ch)
    rect(g, 0, 0, 0, h - 1, ch)
    rect(g, w - 1, 0, w - 1, h - 1, ch)


def park():
    g = grid(40, 17, "g")
    border(g)
    rect(g, 1, 1, 38, 1, "W")
    rect(g, 28, 1, 29, 15, "J")
    rect(g, 28, 9, 29, 10, "p")
    rect(g, 30, 2, 38, 15, "s")
    put(g, 31, 1, "Q"); put(g, 36, 1, "Q")
    rect(g, 2, 2, 6, 15, "p")
    rect(g, 12, 5, 20, 9, "p")
    rect(g, 6, 7, 12, 8, "p")
    rect(g, 20, 9, 28, 10, "p")
    put(g, 8, 3, "n"); put(g, 9, 3, "n")
    for x, y in ((24, 3), (5, 12), (16, 13), (22, 14)):
        put(g, x, y, "X")
    put(g, 34, 5, "t"); put(g, 35, 5, "t")
    for x, y in ((26, 9), (23, 10), (19, 8), (16, 7)):
        put(g, x, y, "B")
    return rows(g)


PARK_INTERACTABLES = [
    {"id": "bench", "tile": (8, 3), "size": (32, 16)},
    {"id": "blood", "tile": (23, 10)},
    {"id": "plaza", "tile": (15, 6), "size": (32, 32)},
    {"id": "wall_gap", "tile": (28, 9), "size": (32, 32), "on_enter": True},
    {"id": "alley_graffiti", "tile": (36, 1)},
    {"id": "glyph_wall", "tile": (31, 1)},
    {"id": "tent", "tile": (34, 5), "size": (32, 16)},
    {"id": "exit", "tile": (3, 15), "on_enter": True, "once": False},
]
PARK_NPCS = [
    {"id": "seth", "tile": (9, 4), "facing": "down"},
    {"id": "tyson", "tile": (33, 7), "facing": "left"},
]


def home():
    g = grid(30, 17, ".")
    border(g)
    rect(g, 1, 1, 28, 1, "W")
    for x in (3, 4, 5, 6, 20, 21, 22, 23):
        put(g, x, 1, "w")
    rect(g, 1, 2, 6, 2, "K")
    rect(g, 9, 5, 11, 6, "A")
    rect(g, 2, 9, 4, 9, "q")
    rect(g, 16, 1, 16, 15, "T")
    put(g, 16, 8, ".")
    rect(g, 18, 1, 18, 15, "T")
    put(g, 18, 4, "."); put(g, 18, 12, ".")
    rect(g, 19, 8, 28, 8, "T")
    rect(g, 19, 2, 28, 7, "~")
    put(g, 26, 3, "e"); put(g, 26, 4, "e")
    put(g, 26, 13, "e"); put(g, 26, 14, "e")
    put(g, 3, 16, "d")
    return rows(g)


HOME_INTERACTABLES = [
    {"id": "window", "tile": (3, 1), "size": (64, 16)},
    {"id": "kitchen", "tile": (1, 2), "size": (96, 16)},
    {"id": "table", "tile": (9, 5), "size": (48, 32)},
    {"id": "couch", "tile": (2, 9), "size": (48, 16)},
    {"id": "mira_door", "tile": (18, 4), "on_enter": True, "once": False},
    {"id": "mira_bed", "tile": (26, 3), "size": (16, 32)},
    {"id": "ritual", "tile": (23, 5)},
    {"id": "ezra_bed", "tile": (26, 13), "size": (16, 32)},
    {"id": "exit", "tile": (3, 15), "on_enter": True, "once": False},
]
HOME_NPCS = [
    {"id": "monica", "tile": (3, 3), "facing": "down"},
    {"id": "mira", "tile": (9, 4), "facing": "down"},
    {"id": "ezra", "tile": (11, 7), "facing": "up"},
]


def warroom():
    g = grid(30, 17, "j")
    border(g)
    rect(g, 1, 1, 14, 1, "S")
    rect(g, 15, 1, 28, 1, "W")
    put(g, 26, 1, "V"); put(g, 27, 1, "V")
    rect(g, 8, 6, 17, 8, "A")
    for x in (9, 11, 13, 15):
        put(g, x, 5, "i"); put(g, x, 9, "i")
    put(g, 3, 12, "D"); put(g, 4, 12, "L")
    put(g, 3, 16, "d")
    return rows(g)


WARROOM_INTERACTABLES = [
    {"id": "screens", "tile": (1, 1), "size": (224, 16)},
    {"id": "table", "tile": (8, 6), "size": (160, 48)},
    {"id": "forner_desk", "tile": (3, 12), "size": (32, 16)},
    {"id": "elevator", "tile": (26, 1), "size": (32, 16)},
    {"id": "exit", "tile": (3, 15), "on_enter": True, "once": False},
]
WARROOM_NPCS = [
    {"id": "turan", "tile": (12, 4), "facing": "down"},
    {"id": "lynx", "tile": (18, 7), "facing": "left"},
    {"id": "emmet", "tile": (7, 10), "facing": "up"},
    {"id": "forner", "tile": (4, 13), "facing": "up"},
]


def hospital():
    g = grid(30, 17, "f")
    border(g)
    rect(g, 1, 1, 28, 1, "M")
    rect(g, 13, 1, 13, 15, "T"); put(g, 13, 8, "f")
    rect(g, 18, 1, 18, 15, "T"); put(g, 18, 6, "f")
    rect(g, 3, 3, 6, 3, "S")
    rect(g, 19, 2, 28, 15, "F")
    put(g, 25, 4, "m"); put(g, 25, 5, "m")
    put(g, 2, 16, "d")
    return rows(g)


HOSPITAL_INTERACTABLES = [
    {"id": "screens", "tile": (3, 3), "size": (64, 16)},
    {"id": "room_door", "tile": (18, 6), "on_enter": True, "once": False},
    {"id": "blinds", "tile": (24, 1), "size": (48, 16)},
    {"id": "dufredy", "tile": (25, 4), "size": (16, 32)},
    {"id": "exit", "tile": (2, 15), "on_enter": True, "once": False},
]
HOSPITAL_NPCS = [
    {"id": "bot", "tile": (8, 5), "facing": "down"},
    {"id": "nurse", "tile": (16, 6), "facing": "down"},
]


def southtown():
    g = grid(50, 20, "a")
    border(g)
    rect(g, 1, 1, 48, 1, "W")
    put(g, 12, 1, "Q"); put(g, 38, 1, "Q")
    rect(g, 1, 2, 14, 2, "r")
    rect(g, 1, 3, 14, 3, "l")
    rect(g, 1, 4, 48, 4, "c")
    rect(g, 1, 10, 48, 10, "c")
    rect(g, 16, 11, 26, 14, "W")
    rect(g, 16, 11, 26, 11, "T")
    put(g, 20, 12, "Q")
    rect(g, 28, 12, 36, 15, "-")
    for x, y in ((30, 13), (32, 14), (34, 13)):
        put(g, x, y, "t")
    rect(g, 40, 6, 48, 13, "c")
    for x, y in ((42, 6), (42, 12), (46, 6), (46, 12)):
        put(g, x, y, "U")
    rect(g, 1, 18, 48, 18, "c")
    for x, y in ((6, 7), (24, 7), (10, 15), (44, 16)):
        put(g, x, y, "s")
    return rows(g)


SOUTHTOWN_INTERACTABLES = [
    {"id": "glyph_station", "tile": (12, 1)},
    {"id": "glyph_factory", "tile": (20, 12)},
    {"id": "glyph_far", "tile": (38, 1)},
    {"id": "factory", "tile": (16, 11), "size": (176, 16)},
    {"id": "shanty", "tile": (30, 13), "size": (80, 32)},
    {"id": "station", "tile": (1, 3), "size": (224, 16)},
    {"id": "overpass", "tile": (42, 8), "size": (64, 48), "on_enter": True},
    {"id": "exit", "tile": (3, 17), "on_enter": True, "once": False},
]
SOUTHTOWN_NPCS = [
    {"id": "lynx", "tile": (7, 5), "facing": "down"},
]


def lynx_apartment():
    g = grid(30, 17, ".")
    border(g)
    rect(g, 1, 1, 28, 1, "W")
    rect(g, 1, 1, 15, 1, "k")
    rect(g, 1, 2, 6, 2, "K")
    rect(g, 9, 5, 11, 6, "A")
    rect(g, 2, 9, 4, 9, "q")
    put(g, 6, 8, "z")
    rect(g, 16, 1, 16, 15, "T")
    put(g, 16, 8, ".")
    rect(g, 18, 1, 18, 15, "T")
    put(g, 18, 8, ".")
    rect(g, 19, 2, 28, 15, "~")
    put(g, 25, 1, "Q")
    put(g, 24, 3, "h"); put(g, 25, 3, "h"); put(g, 24, 4, "h"); put(g, 25, 4, "h")
    put(g, 25, 3, "L")
    put(g, 3, 16, "d")
    return rows(g)


LYNX_INTERACTABLES = [
    {"id": "door", "tile": (3, 14), "on_enter": True},
    {"id": "notes", "tile": (1, 1), "size": (240, 16)},
    {"id": "frames", "tile": (6, 8)},
    {"id": "photos", "tile": (19, 1), "size": (96, 16)},
    {"id": "sigil", "tile": (25, 1)},
    {"id": "laptop", "tile": (24, 3), "size": (32, 32)},
    {"id": "exit", "tile": (3, 15), "on_enter": True, "once": False},
]


def desert():
    g = grid(40, 17, "x")
    border(g, "R")
    rect(g, 33, 0, 39, 16, "R")
    put(g, 33, 8, "O")
    put(g, 20, 7, "v"); put(g, 21, 7, "v")
    put(g, 4, 13, "v"); put(g, 5, 13, "v")
    for x, y in ((10, 4), (26, 12), (15, 10), (30, 3)):
        put(g, x, y, "X")
    for x, y in ((12, 14), (27, 5), (8, 8)):
        put(g, x, y, "R")
    return rows(g)


DESERT_INTERACTABLES = [
    {"id": "sedan", "tile": (20, 7), "size": (32, 16)},
    {"id": "my_car", "tile": (4, 13), "size": (32, 16)},
    {"id": "door_approach", "tile": (30, 7), "size": (32, 48), "on_enter": True},
    {"id": "door", "tile": (33, 8)},
]


def mirror():
    g = grid(20, 12, "F")
    border(g)
    rect(g, 1, 1, 18, 1, "Q")
    put(g, 9, 1, "I"); put(g, 10, 1, "I")
    return rows(g)


MIRROR_INTERACTABLES = [
    {"id": "center", "tile": (9, 6), "size": (32, 16), "on_enter": True},
    {"id": "mirror", "tile": (9, 1), "size": (32, 16)},
]


def main():
    os.makedirs(os.path.join(ROOT, "scenes", "maps"), exist_ok=True)
    tileset_tres(os.path.join(ROOT, "assets", "tiles", "tileset.tres"))
    maps = os.path.join(ROOT, "scenes", "maps")
    tscn("Apartment", "ApartmentScene.gd", APARTMENT, (3, 13), APARTMENT_INTERACTABLES, os.path.join(maps, "Apartment.tscn"))
    tscn("Park", "ParkScene.gd", park(), (3, 14), PARK_INTERACTABLES, os.path.join(maps, "Park.tscn"), PARK_NPCS)
    tscn("Home", "HomeScene.gd", home(), (3, 14), HOME_INTERACTABLES, os.path.join(maps, "Home.tscn"), HOME_NPCS)
    tscn("WarRoom", "WarRoomScene.gd", warroom(), (14, 14), WARROOM_INTERACTABLES, os.path.join(maps, "WarRoom.tscn"), WARROOM_NPCS)
    tscn("Hospital", "HospitalScene.gd", hospital(), (3, 13), HOSPITAL_INTERACTABLES, os.path.join(maps, "Hospital.tscn"), HOSPITAL_NPCS)
    tscn("Southtown", "SouthtownScene.gd", southtown(), (3, 6), SOUTHTOWN_INTERACTABLES, os.path.join(maps, "Southtown.tscn"), SOUTHTOWN_NPCS)
    tscn("LynxApartment", "LynxApartmentScene.gd", lynx_apartment(), (3, 13), LYNX_INTERACTABLES, os.path.join(maps, "LynxApartment.tscn"))
    tscn("Desert", "DesertScene.gd", desert(), (6, 11), DESERT_INTERACTABLES, os.path.join(maps, "Desert.tscn"))
    tscn("Mirror", "MirrorScene.gd", mirror(), (9, 9), MIRROR_INTERACTABLES, os.path.join(maps, "Mirror.tscn"))
    print("maps generated")


if __name__ == "__main__":
    main()
