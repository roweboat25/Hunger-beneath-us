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
    "C": (0, 2), "P": (1, 2), "K": (2, 2), "H": (3, 2),
}
SOLID = {"T", "W", "N", "D", "L", "G", "Y", "h", "C", "P", "K"}
# ground-layer stand-in under objects so the floor shows if an object is removed
UNDER = {"D": ".", "L": ".", "h": ".", "C": ",", "P": ".", "K": "."}


def tileset_tres(path):
    lines = [
        '[gd_resource type="TileSet" load_steps=2 format=3]',
        '',
        '[ext_resource type="Texture2D" path="res://assets/tiles/apartment.png" id="1_tiles"]',
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


def tscn(name, script, rows, player_tile, interactables, path):
    ground, objects = layers_from_rows(rows)
    w, h = len(rows[0]) * TILE, len(rows) * TILE
    shapes = {}
    for it in interactables:
        size = it.get("size", (16, 16))
        shapes.setdefault(size, f"RectangleShape2D_{size[0]}x{size[1]}")
    out = [
        f'[gd_scene load_steps={4 + len(shapes)} format=3]',
        '',
        '[ext_resource type="TileSet" path="res://assets/tiles/apartment_tileset.tres" id="1_tileset"]',
        f'[ext_resource type="Script" path="res://scripts/maps/{script}" id="2_script"]',
        '[ext_resource type="PackedScene" path="res://scenes/Player.tscn" id="3_player"]',
        '[ext_resource type="Script" path="res://scripts/Interactable.gd" id="4_interact"]',
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


def main():
    os.makedirs(os.path.join(ROOT, "scenes", "maps"), exist_ok=True)
    tileset_tres(os.path.join(ROOT, "assets", "tiles", "apartment_tileset.tres"))
    tscn("Apartment", "ApartmentScene.gd", APARTMENT, (3, 13), APARTMENT_INTERACTABLES,
         os.path.join(ROOT, "scenes", "maps", "Apartment.tscn"))
    print("maps generated")


if __name__ == "__main__":
    main()
