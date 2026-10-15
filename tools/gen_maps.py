#!/usr/bin/env python3
"""Writes the tileset resource and the map scenes from Python layouts.

Maps are plain Godot .tscn files afterwards: open them in the editor and
move things around like any other scene. Re-running this script overwrites
them, so once a map is hand-edited, stop regenerating it.

Each map has three drawing layers and one logic layer:
  Ground / Walls   TileMapLayers from assets/tiles/tiles.png (atlas.json names)
  Decals           flat Sprite2Ds drawn under everyone (rugs, paper, glyphs)
  Actors           y-sorted: furniture props, NPCs and the Player
  Interactables    Area2D triggers (see scripts/Interactable.gd)
Props with an `id` can be hidden/shown/removed from the scene scripts
(MapScene.show_prop / remove_prop).

Run with --preview to also write PNG renders of every map to PREVIEW_DIR.
"""
import json
import os
import random
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import density  # noqa: E402  (the people and machines of the city)

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
TILE = 32
ATLAS = json.load(open(os.path.join(ROOT, "assets", "tiles", "atlas.json")))
PROPS = json.load(open(os.path.join(ROOT, "assets", "props", "props.json")))
PREVIEW_DIR = os.environ.get("PREVIEW_DIR", os.path.join(ROOT, "build", "previews"))

SOLID_PREFIXES = ("wall_", "brick_", "stone_", "drywall_", "window_", "frame_",
                  "cliff_", "void", "cement_edge")


def meta_literal(v):
    """A metadata value as a .tscn literal: numbers and true/false raw, text quoted."""
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return str(v)
    if v in ("true", "false"):
        return v
    return json.dumps(v, ensure_ascii=False)


def is_solid(tile):
    return tile.startswith(SOLID_PREFIXES)


# ----------------------------------------------------------------- resources
def tileset_tres(path):
    lines = [
        '[gd_resource type="TileSet" load_steps=2 format=3]',
        '',
        '[ext_resource type="Texture2D" path="res://assets/tiles/tiles.png" id="1_tiles"]',
        '',
        '[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_main"]',
        'texture = ExtResource("1_tiles")',
        f'texture_region_size = Vector2i({TILE}, {TILE})',
    ]
    h = TILE // 2
    for name, (x, y) in sorted(ATLAS.items(), key=lambda kv: (kv[1][1], kv[1][0])):
        lines.append(f"{x}:{y}/0 = 0")
        if is_solid(name):
            lines.append(f"{x}:{y}/0/physics_layer_0/polygon_0/points = "
                         f"PackedVector2Array({-h}, {-h}, {h}, {-h}, {h}, {h}, {-h}, {h})")
    lines += [
        '',
        '[resource]',
        f'tile_size = Vector2i({TILE}, {TILE})',
        'physics_layer_0/collision_layer = 1',
        'physics_layer_0/collision_mask = 1',
        'sources/0 = SubResource("TileSetAtlasSource_main")',
        '',
    ]
    with open(path, "w") as f:
        f.write("\n".join(lines))


def encode_cells(cells):
    """TileMapLayer.tile_map_data: uint16 version 0, then 12 bytes per cell."""
    data = struct.pack("<H", 0)
    for (x, y), name in cells:
        ax, ay = ATLAS[name]
        data += struct.pack("<hhhhhh", x, y, 0, ax, ay, 0)
    return "PackedByteArray(" + ", ".join(str(b) for b in data) + ")"


def node_name(prefix, text):
    # ":" is not allowed in Godot node names; ids keep it, nodes don't
    return prefix + "".join(p.title() for p in text.replace(":", "_").split("_"))


# ----------------------------------------------------------------- map model
class Map:
    def __init__(self, name, script, w, h, floor, seed=1):
        self.name, self.script, self.w, self.h = name, script, w, h
        self.rng = random.Random(seed)
        self.ground = [[None] * w for _ in range(h)]
        self.walls = [[None] * w for _ in range(h)]
        self.decals = []      # (name, tx, ty, lift)
        self.props = []       # dict(name, tx, ty, lift, id, visible)
        self.triggers = []    # dict(id, tx, ty, tw, th, on_enter, once)
        self.npcs = []        # dict(id, tx, ty, facing, sprite)
        self.player = (1, 1)
        self.fill(0, 0, w - 1, h - 1, floor)

    # --- tiles
    def _pick(self, names):
        if isinstance(names, str):
            return names
        return self.rng.choice(names)

    def fill(self, x0, y0, x1, y1, names, layer="ground"):
        grid = self.ground if layer == "ground" else self.walls
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                grid[y][x] = self._pick(names)

    def wall(self, x0, y0, x1, y1, names):
        self.fill(x0, y0, x1, y1, names, "walls")

    def clear_wall(self, x, y):
        self.walls[y][x] = None

    def top_wall(self, group, x0, x1, windows=(), y=0):
        """Two-tall painted wall along the top with optional window columns."""
        self.wall(x0, y, x1, y, f"wall_{group}_top")
        self.wall(x0, y + 1, x1, y + 1, f"wall_{group}_bot")
        for wx, kind in windows:
            self.walls[y][wx] = f"window_{kind}_top"
            self.walls[y + 1][wx] = f"window_{kind}_bot"

    def void_border(self, left=True, right=True, bottom=True):
        if left:
            self.wall(0, 0, 0, self.h - 1, "void")
        if right:
            self.wall(self.w - 1, 0, self.w - 1, self.h - 1, "void")
        if bottom:
            self.wall(0, self.h - 1, self.w - 1, self.h - 1, "void")

    def partition(self, group, x, y0, y1, gaps=()):
        """Vertical interior wall from y0..y1 with doorway gaps."""
        for y in range(y0, y1 + 1):
            if y in gaps:
                continue
            end = y == y1 or (y + 1) in gaps
            self.walls[y][x] = f"wall_{group}_bot" if end else f"wall_{group}_mid"

    def hwall(self, group, x0, x1, y, gaps=()):
        for x in range(x0, x1 + 1):
            if x not in gaps:
                self.walls[y][x] = f"wall_{group}_one"

    # --- sprites. (tx, ty) is the tile under the sprite's bottom-left corner.
    def decal(self, name, tx, ty, lift=0):
        assert name in PROPS, name
        self.decals.append((name, tx, ty, lift))

    def prop(self, name, tx, ty, lift=0, id=None, visible=True, solid=None, meta=None):
        assert name in PROPS, name
        self.props.append(dict(name=name, tx=tx, ty=ty, lift=lift, id=id, visible=visible,
                               solid=PROPS[name]["solid"] if solid is None else solid, meta=meta or {}))

    def glyph(self, id, tx, ty, deep=False, lift=0):
        """A hidden eye glyph: only drawn with the frames on (deep ones only once
        connection is high). Examining it decodes a line of the chant."""
        self.prop("glyph_red" if deep else "glyph", tx, ty, lift=lift, id="glyph:" + id, visible=False, solid=0,
                  meta={"glyph_deep": "true" if deep else "false"})
        self.trigger("glyph:" + id, tx, ty)

    def trigger(self, id, tx, ty, tw=1, th=1, on_enter=False, once=True, meta=None):
        self.triggers.append(dict(id=id, tx=tx, ty=ty, tw=tw, th=th, on_enter=on_enter, once=once, meta=meta or {}))

    def blocked_grid(self):
        """Cells Carl can't stand on: solid tiles, solid props, people."""
        blocked = [[False] * self.w for _ in range(self.h)]
        for y in range(self.h):
            for x in range(self.w):
                for grid in (self.ground, self.walls):
                    if grid[y][x] and is_solid(grid[y][x]):
                        blocked[y][x] = True
        for p in self.props:
            if p["solid"] and p["visible"]:
                pw, ph = PROPS[p["name"]]["w"], PROPS[p["name"]]["h"]
                rows = max(1, round(min(ph, p["solid"] * TILE) / TILE))
                for dy in range(rows):
                    for dx in range(pw // TILE):
                        x, y = p["tx"] + dx, p["ty"] - dy
                        if 0 <= x < self.w and 0 <= y < self.h:
                            blocked[y][x] = True
        for n in self.npcs:
            blocked[n["ty"]][n["tx"]] = True
        for t in self.triggers:
            if t["on_enter"]:
                for dx in range(t["tw"]):
                    for dy in range(t["th"]):
                        x, y = t["tx"] + dx, t["ty"] + dy
                        if 0 <= x < self.w and 0 <= y < self.h:
                            blocked[y][x] = True
        return blocked

    def free_near(self, tx, ty, blocked=None):
        """The nearest cell to (tx, ty) that is free and connected to the player's start."""
        blocked = blocked or self.blocked_grid()
        seen = {self.player}
        stack = [self.player]
        while stack:
            x, y = stack.pop()
            for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if 0 <= nx < self.w and 0 <= ny < self.h and not blocked[ny][nx] and (nx, ny) not in seen:
                    seen.add((nx, ny))
                    stack.append((nx, ny))
        best = min(seen, key=lambda c: abs(c[0] - tx) + abs(c[1] - ty) + (0 if c[1] == ty else 0.5))
        return best

    def npc(self, id, tx, ty, facing="down", sprite=None, meta=None):
        self.npcs.append(dict(id=id, tx=tx, ty=ty, facing=facing, sprite=sprite or id, meta=meta or {}))

    def exit(self, id, tx, ty, tw=1, th=1):
        """An edge of the map that leads to another map (see scripts/World.gd)."""
        self.trigger(id, tx, ty, tw, th, on_enter=True, once=False)

    def scatter(self, names, cells, layer="ground"):
        for (x, y) in cells:
            (self.ground if layer == "ground" else self.walls)[y][x] = self._pick(names)

    # --- checks
    def check(self):
        """Flood-fill from the player over walkable tiles and warn about triggers Carl can't reach."""
        blocked = [[False] * self.w for _ in range(self.h)]
        for y in range(self.h):
            for x in range(self.w):
                for grid in (self.ground, self.walls):
                    if grid[y][x] and is_solid(grid[y][x]):
                        blocked[y][x] = True
        for p in self.props:
            if p["solid"] and p["visible"] and not (p.get("meta") or {}).get("gate"):
                pw, ph = PROPS[p["name"]]["w"], PROPS[p["name"]]["h"]
                rows = max(1, round(min(ph, p["solid"] * TILE) / TILE))
                for dy in range(rows):
                    for dx in range(pw // TILE):
                        x, y = p["tx"] + dx, p["ty"] - dy
                        if 0 <= x < self.w and 0 <= y < self.h:
                            blocked[y][x] = True
        for n in self.npcs:
            blocked[n["ty"]][n["tx"]] = True
        seen = {self.player}
        stack = [self.player]
        if blocked[self.player[1]][self.player[0]]:
            print(f"  {self.name}: player start is blocked")
        while stack:
            x, y = stack.pop()
            for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if 0 <= nx < self.w and 0 <= ny < self.h and not blocked[ny][nx] and (nx, ny) not in seen:
                    seen.add((nx, ny))
                    stack.append((nx, ny))
        for t in self.triggers:
            cells = [(t["tx"] + dx, t["ty"] + dy) for dx in range(t["tw"]) for dy in range(t["th"])]
            ok = any(c in seen for c in cells)
            if not ok and not t["on_enter"]:
                ok = any((x + ox, y + oy) in seen for (x, y) in cells for ox, oy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
            if not ok:
                print(f"  {self.name}: trigger '{t['id']}' at {t['tx']},{t['ty']} is unreachable")
        for n in self.npcs:
            x, y = n["tx"], n["ty"]
            if not any((x + ox, y + oy) in seen for ox, oy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                print(f"  {self.name}: npc '{n['id']}' at {x},{y} is unreachable")
        return seen

    # --- output
    def write(self, path):
        W, H = self.w * TILE, self.h * TILE
        ground = [((x, y), self.ground[y][x]) for y in range(self.h) for x in range(self.w) if self.ground[y][x]]
        walls = [((x, y), self.walls[y][x]) for y in range(self.h) for x in range(self.w) if self.walls[y][x]]
        textures = {}
        for d in self.decals:
            textures.setdefault(d[0], f"tex_{d[0]}")
        for p in self.props:
            textures.setdefault(p["name"], f"tex_{p['name']}")
        shapes = {}

        def shape(w, h):
            key = (int(w), int(h))
            return shapes.setdefault(key, f"Rect_{key[0]}x{key[1]}")

        for t in self.triggers:
            shape(t["tw"] * TILE, t["th"] * TILE)
        shape(TILE, TILE)
        shape(W, TILE)
        shape(TILE, H)
        for p in self.props:
            if p["solid"]:
                pw, ph = PROPS[p["name"]]["w"], PROPS[p["name"]]["h"]
                shape(pw - 4, min(ph, p["solid"] * TILE) - 4)
        n_ext = 5 + len(textures)
        out = [
            f'[gd_scene load_steps={n_ext + len(shapes) + 1} format=3]',
            '',
            '[ext_resource type="TileSet" path="res://assets/tiles/tileset.tres" id="1_tileset"]',
            f'[ext_resource type="Script" path="res://scripts/maps/{self.script}" id="2_script"]',
            '[ext_resource type="PackedScene" path="res://scenes/Player.tscn" id="3_player"]',
            '[ext_resource type="Script" path="res://scripts/Interactable.gd" id="4_interact"]',
            '[ext_resource type="Script" path="res://scripts/NPC.gd" id="5_npc"]',
        ]
        for name, tid in sorted(textures.items()):
            out.append(f'[ext_resource type="Texture2D" path="res://assets/props/{name}.png" id="{tid}"]')
        out.append('')
        for (w, h), sid in shapes.items():
            out += [f'[sub_resource type="RectangleShape2D" id="{sid}"]', f'size = Vector2({w}, {h})', '']
        out += [
            f'[node name="{self.name}" type="Node2D"]',
            'script = ExtResource("2_script")',
            f'map_size = Vector2i({W}, {H})',
            '',
            '[node name="Ground" type="TileMapLayer" parent="."]',
            f'tile_map_data = {encode_cells(ground)}',
            'tile_set = ExtResource("1_tileset")',
            '',
            '[node name="Walls" type="TileMapLayer" parent="."]',
            f'tile_map_data = {encode_cells(walls)}',
            'tile_set = ExtResource("1_tileset")',
            '',
            '[node name="Bounds" type="StaticBody2D" parent="."]',
            'collision_layer = 1',
            'collision_mask = 0',
            '',
        ]
        for i, (px, py, sw, sh) in enumerate([
                (W / 2, -TILE / 2, W, TILE), (W / 2, H + TILE / 2, W, TILE),
                (-TILE / 2, H / 2, TILE, H), (W + TILE / 2, H / 2, TILE, H)]):
            out += [f'[node name="Edge{i}" type="CollisionShape2D" parent="Bounds"]',
                    f'position = Vector2({px:g}, {py:g})', f'shape = SubResource("{shape(sw, sh)}")', '']
        out.append('[node name="Decals" type="Node2D" parent="."]')
        out.append('')
        for i, (name, tx, ty, lift) in enumerate(self.decals):
            pw, ph = PROPS[name]["w"], PROPS[name]["h"]
            out += [f'[node name="D{i}_{name}" type="Sprite2D" parent="Decals"]',
                    f'position = Vector2({tx * TILE + pw / 2:g}, {(ty + 1) * TILE - lift:g})',
                    f'offset = Vector2(0, {-ph / 2:g})',
                    f'texture = ExtResource("{textures[name]}")', '']
        out += ['[node name="Actors" type="Node2D" parent="."]', 'y_sort_enabled = true', '']
        for i, p in enumerate(self.props):
            name = p["name"]
            pw, ph = PROPS[name]["w"], PROPS[name]["h"]
            node = f'P{i}_{name}'
            out += [f'[node name="{node}" type="Sprite2D" parent="Actors"]',
                    f'position = Vector2({p["tx"] * TILE + pw / 2:g}, {(p["ty"] + 1) * TILE + 1:g})',
                    f'offset = Vector2(0, {-ph / 2 - 1 - p["lift"]:g})',
                    f'texture = ExtResource("{textures[name]}")']
            if p["id"]:
                out.append(f'metadata/prop_id = "{p["id"]}"')
            for k, v in p.get("meta", {}).items():
                out.append(f'metadata/{k} = {meta_literal(v)}')
            if not p["visible"]:
                out.append('visible = false')
            out.append('')
            if p["solid"]:
                sh = min(ph, p["solid"] * TILE) - 4
                out += [f'[node name="Body" type="StaticBody2D" parent="Actors/{node}"]',
                        'collision_layer = 1', 'collision_mask = 0', '',
                        f'[node name="Shape" type="CollisionShape2D" parent="Actors/{node}/Body"]',
                        f'position = Vector2(0, {-sh / 2 - 3:g})',
                        f'shape = SubResource("{shape(pw - 4, sh)}")', '']
        for n in self.npcs:
            node = node_name("Npc", n["id"])
            out += [f'[node name="{node}" type="Area2D" parent="Actors"]',
                    f'position = Vector2({n["tx"] * TILE + 16}, {n["ty"] * TILE + 28})',
                    'script = ExtResource("5_npc")', f'id = "{n["id"]}"',
                    f'sprite_sheet = "res://assets/sprites/{n["sprite"]}.png"',
                    f'facing = "{n["facing"]}"']
            for k, v in n.get("meta", {}).items():
                out.append(f'metadata/{k} = {meta_literal(v)}')
            out += ['',
                    f'[node name="Shape" type="CollisionShape2D" parent="Actors/{node}"]',
                    'position = Vector2(0, -16)',
                    f'shape = SubResource("{shape(TILE, TILE)}")', '']
        px, py = self.player
        out += ['[node name="Player" parent="Actors" instance=ExtResource("3_player")]',
                f'position = Vector2({px * TILE + 16}, {py * TILE + 28})', '',
                '[node name="Interactables" type="Node2D" parent="."]', '']
        seen = {}
        for t in self.triggers:
            node = node_name("", t["id"])
            seen[node] = seen.get(node, 0) + 1
            if seen[node] > 1:
                node += str(seen[node])
            sw, sh = t["tw"] * TILE, t["th"] * TILE
            out += [f'[node name="{node}" type="Area2D" parent="Interactables"]',
                    f'position = Vector2({t["tx"] * TILE + sw / 2:g}, {t["ty"] * TILE + sh / 2:g})',
                    'script = ExtResource("4_interact")', f'id = "{t["id"]}"']
            if t["on_enter"]:
                out.append("on_enter = true")
            if not t["once"]:
                out.append("once = false")
            for k, v in t.get("meta", {}).items():
                out.append(f'metadata/{k} = {meta_literal(v)}')
            out += ['', f'[node name="Shape" type="CollisionShape2D" parent="Interactables/{node}"]',
                    f'shape = SubResource("{shape(sw, sh)}")', '']
        with open(path, "w") as f:
            f.write("\n".join(out))

    def preview(self, path, show_triggers=True):
        from PIL import Image, ImageDraw
        tiles = Image.open(os.path.join(ROOT, "assets", "tiles", "tiles.png")).convert("RGBA")
        im = Image.new("RGBA", (self.w * TILE, self.h * TILE), (0, 0, 0, 255))
        cache = {}

        def tile(name):
            if name not in cache:
                ax, ay = ATLAS[name]
                cache[name] = tiles.crop((ax * TILE, ay * TILE, ax * TILE + TILE, ay * TILE + TILE))
            return cache[name]

        def sprite(name):
            key = "p:" + name
            if key not in cache:
                cache[key] = Image.open(os.path.join(ROOT, "assets", "props", name + ".png")).convert("RGBA")
            return cache[key]

        for grid in (self.ground, self.walls):
            for y in range(self.h):
                for x in range(self.w):
                    if grid[y][x]:
                        im.alpha_composite(tile(grid[y][x]), (x * TILE, y * TILE))
        for name, tx, ty, lift in self.decals:
            s = sprite(name)
            im.alpha_composite(s, (tx * TILE, (ty + 1) * TILE - lift - s.size[1]))
        actors = []
        for p in self.props:
            if p["visible"]:
                actors.append(((p["ty"] + 1) * TILE + 1, "prop", p))
        for n in self.npcs:
            actors.append((n["ty"] * TILE + 28, "npc", n))
        actors.append((self.player[1] * TILE + 28, "npc", dict(tx=self.player[0], ty=self.player[1], sprite="carl")))
        for _, kind, a in sorted(actors, key=lambda t: t[0]):
            if kind == "prop":
                s = sprite(a["name"])
                im.alpha_composite(s, (a["tx"] * TILE, (a["ty"] + 1) * TILE - a["lift"] - s.size[1]))
            else:
                sheet = Image.open(os.path.join(ROOT, "assets", "sprites", a["sprite"] + ".png")).convert("RGBA")
                cell = sheet.crop((0, 0, 64, 64))
                im.alpha_composite(cell, (a["tx"] * TILE + 16 - 32, a["ty"] * TILE + 28 - 61))
        if show_triggers:
            d = ImageDraw.Draw(im)
            for t in self.triggers:
                x0, y0 = t["tx"] * TILE, t["ty"] * TILE
                x1, y1 = x0 + t["tw"] * TILE - 1, y0 + t["th"] * TILE - 1
                d.rectangle((x0, y0, x1, y1), outline=(255, 80, 80, 200) if t["on_enter"] else (255, 230, 80, 200))
                d.text((x0 + 2, y0 + 1), t["id"], fill=(255, 255, 255, 255))
        im.save(path)


# ----------------------------------------------------------------- layouts
WOOD_DARK = ["wood_dark"] * 4 + ["wood_dark2"]
WOOD_WARM = ["wood_warm"] * 4 + ["wood_warm2"]
WOOD_GREY = ["wood_grey"] * 4 + ["wood_grey2"]
GRASS = ["grass"] * 3 + ["grass2", "grass3"]
DIRT = ["dirt"] * 3 + ["dirt2"]
SAND = ["sand"] * 3 + ["sand2"]
CEMENT = ["cement"] * 12 + ["cement_b", "cement_crack", "cement_crack2"]
TILE_DARK = ["tile_dark"] * 3 + ["tile_dark2"]
TILE_GREY = ["tile_grey"] * 3 + ["tile_grey2"]


def apartment():
    m = Map("Apartment", "ApartmentScene.gd", 30, 17, WOOD_DARK, seed=3)
    m.fill(20, 2, 28, 15, WOOD_GREY)
    m.void_border()
    m.top_wall("apt", 1, 28, windows=[(7, "dark"), (8, "dark"), (9, "dark"), (10, "dark"), (24, "dark"), (25, "dark")])
    m.partition("apt", 19, 0, 15, gaps=(8,))
    m.ground[16][3] = "shadow_floor"; m.clear_wall(3, 16)
    # kitchen along the top wall
    m.prop("oven", 13, 2); m.prop("counter_l", 14, 2); m.prop("counter", 15, 2)
    m.prop("sink", 17, 2); m.prop("fridge", 18, 2)
    m.prop("dishes", 15, 2, lift=38); m.prop("coffee_maker", 16, 2, lift=0)
    # living room
    m.prop("bookcase_empty", 11, 3)
    m.prop("planter", 9, 4)
    m.decal("painting2", 3, 1, lift=0)
    m.decal("rug_blue", 3, 10)
    m.prop("lamp_floor_dark", 2, 7); m.prop("sofa_grey", 3, 7); m.prop("end_table", 6, 7)
    m.prop("phone", 6, 7, lift=20)
    m.prop("tv_small", 6, 13)
    m.prop("crate", 16, 7); m.prop("crate_small", 17, 7); m.prop("box_open", 16, 8)
    m.decal("paper", 12, 9); m.decal("paper2", 13, 9); m.decal("paper3", 4, 8); m.prop("box", 4, 8)
    m.decal("paper3", 10, 12); m.decal("paper", 14, 5)
    # bedroom
    m.decal("moss", 24, 1)
    m.prop("crate", 20, 3); m.prop("box", 21, 2)
    m.prop("bed_single_dark", 21, 5); m.prop("pillow", 21, 3, lift=30)
    m.prop("dresser_dark", 24, 4); m.prop("lamp_table", 24, 4, lift=36)
    m.prop("desk_dark", 27, 5); m.prop("laptop_open", 28, 5, lift=18, id="laptop"); m.prop("chair_office_back", 26, 6)
    m.decal("eyes", 24, 9)
    m.decal("stick", 23, 11)
    m.prop("crate", 28, 13); m.prop("box_open", 27, 13); m.decal("paper2", 26, 14)
    m.decal("cobweb", 28, 2)
    m.trigger("balcony", 7, 1, 4)
    m.trigger("kitchen", 14, 2, 5)
    m.trigger("plant", 9, 4)
    m.trigger("debris", 12, 9, 2)
    m.trigger("debris", 4, 8)
    m.trigger("stain", 24, 1)
    m.trigger("cardboard", 20, 2, 1, 2)
    m.trigger("cardboard", 28, 12, 1, 2)
    m.trigger("bed", 21, 3, 2, 3)
    m.trigger("desk", 27, 5)
    m.trigger("laptop", 28, 5)
    m.trigger("eyes", 24, 9)
    m.trigger("stick", 23, 11, on_enter=True)
    m.trigger("under_eye", 25, 6, 3, 3, on_enter=True, once=False)
    m.glyph("apt_kitchen", 12, 1); m.glyph("apt_bedroom", 27, 1, deep=True)
    m.trigger("exit", 3, 15, on_enter=True, once=False)
    m.player = (3, 13)
    return m


def park():
    m = Map("Park", "ParkScene.gd", 40, 17, GRASS, seed=5)
    m.wall(0, 0, 39, 0, "brick_grey_top"); m.wall(0, 1, 39, 1, "brick_grey_bot")
    m.fill(30, 2, 38, 16, CEMENT)
    m.fill(39, 2, 39, 16, "cement_edge")
    # brick wall between park and alley, with a gap
    for y in range(2, 17):
        m.walls[y][28] = "brick_grey_mid"; m.walls[y][29] = "brick_grey_mid"
    for y in (9, 10):
        m.clear_wall(28, y); m.clear_wall(29, y)
    m.walls[8][28] = "brick_grey_bot"; m.walls[8][29] = "brick_grey_bot"
    m.walls[11][28] = "brick_grey_top"; m.walls[11][29] = "brick_grey_top"
    m.walls[16][28] = "brick_grey_bot"; m.walls[16][29] = "brick_grey_bot"
    m.fill(28, 9, 29, 10, CEMENT)
    # paths
    m.fill(2, 2, 6, 16, DIRT); m.fill(12, 5, 20, 9, CEMENT); m.fill(6, 7, 12, 8, DIRT); m.fill(20, 9, 27, 10, DIRT)
    m.fill(2, 2, 27, 2, DIRT)
    # park furniture
    m.prop("bench", 8, 3); m.prop("lamp_post", 11, 4); m.prop("lamp_post_off", 21, 11); m.prop("bin", 7, 4)
    m.prop("tree", 24, 4); m.prop("tree2", 5, 13); m.prop("pine", 16, 14); m.prop("tree_small", 22, 15)
    m.prop("tree2", 14, 3); m.prop("pine", 2, 10)
    m.prop("bush", 26, 9); m.prop("bush2", 19, 8); m.prop("shrub", 16, 7); m.prop("bush", 9, 11); m.prop("bush2", 25, 13)
    m.decal("grass_tuft", 10, 10); m.decal("grass_tuft", 23, 6); m.decal("grass_tuft", 4, 5)
    m.prop("fence_iron", 8, 16); m.prop("fence_iron", 11, 16); m.prop("fence_iron", 20, 16); m.prop("fence_iron", 23, 16)
    m.decal("blood", 23, 10)
    m.decal("paper", 13, 7); m.decal("paper3", 18, 6)
    # alley
    m.decal("graffiti_danger", 31, 1); m.decal("graffiti_loot", 35, 1)
    m.prop("bin", 31, 3); m.prop("bin", 37, 4); m.prop("barrel", 36, 3)
    m.prop("tent", 34, 6); m.decal("fire_out", 32, 8); m.prop("cart", 36, 10); m.prop("crate", 37, 13); m.prop("crate_small", 36, 14)
    m.decal("blanket", 32, 12); m.decal("paper2", 33, 10); m.decal("paper", 31, 14)
    m.prop("lamp_post_off", 33, 15)
    m.npc("seth", 9, 4, "down"); m.npc("tyson", 33, 7, "left")
    m.trigger("bench", 8, 3, 2)
    m.trigger("blood", 23, 10)
    m.trigger("plaza", 15, 6, 2, 2)
    m.trigger("wall_gap", 28, 9, 2, 2, on_enter=True)
    m.trigger("alley_graffiti", 36, 1)
    m.trigger("glyph_wall", 31, 1)
    m.trigger("tent", 34, 5, 2, 2)
    m.glyph("park_wall", 20, 1); m.glyph("park_alley", 38, 1); m.glyph("park_gap", 29, 11, deep=True)
    m.trigger("exit", 3, 15, on_enter=True, once=False)
    m.player = (3, 14)
    return m


def home():
    m = Map("Home", "HomeScene.gd", 30, 17, WOOD_WARM, seed=7)
    m.fill(19, 2, 28, 7, "carpet_red"); m.fill(19, 9, 28, 15, "carpet_navy")
    m.void_border()
    m.top_wall("home", 1, 28, windows=[(8, "day"), (9, "day"), (10, "day"), (11, "day"), (21, "day"), (22, "day")])
    m.partition("home", 16, 0, 15, gaps=(8,)); m.partition("home", 18, 0, 15, gaps=(4, 12))
    m.hwall("home", 19, 28, 8)
    m.ground[16][3] = "shadow_floor"; m.clear_wall(3, 16)
    # kitchen
    m.prop("counter_l", 1, 2); m.prop("counter", 2, 2); m.prop("sink", 4, 2); m.prop("oven", 5, 2); m.prop("fridge", 6, 2)
    m.prop("dishes", 2, 2, lift=38); m.prop("coffee_maker", 3, 2)
    m.decal("painting2", 13, 1)
    m.prop("bookcase", 13, 3); m.prop("cabinet", 8, 3)
    m.prop("chair_back", 11, 4); m.prop("table_wood", 9, 6); m.prop("chair_front", 9, 8); m.prop("dishes", 10, 6, lift=20)
    m.prop("tablet", 11, 6, lift=18)
    m.prop("sofa_brown", 2, 9); m.prop("lamp_floor", 5, 9); m.decal("rug_red", 2, 11); m.prop("tv_small", 2, 13); m.prop("planter", 14, 13)
    # Mira's room
    m.prop("dresser", 19, 3); m.prop("lamp_table", 19, 3, lift=36)
    m.prop("bed_child_yellow", 26, 3); m.prop("nightlight", 25, 3, lift=0, solid=0)
    m.prop("stick_circle", 22, 6, id="ritual_circle", visible=False); m.prop("tablet", 23, 5, id="ritual_tablet", visible=False)
    m.decal("rug_blue", 21, 7)
    m.prop("box_open", 28, 6); m.decal("paper3", 24, 4)
    # Ezra's room
    m.decal("poster", 22, 8); m.decal("poster2", 24, 8); m.decal("poster3", 26, 8)
    m.prop("desk_light", 20, 11); m.prop("laptop_closed", 21, 11, lift=18); m.prop("chair_office", 20, 12)
    m.prop("bed_child_blue", 26, 13); m.prop("bookcase", 27, 10); m.prop("crate_small", 19, 14)
    m.npc("monica", 3, 4, "down"); m.npc("mira", 12, 5, "left"); m.npc("ezra", 7, 7, "right")
    m.trigger("window", 8, 1, 4)
    m.trigger("kitchen", 1, 2, 6)
    m.trigger("table", 9, 5, 3, 2)
    m.trigger("couch", 2, 9, 3)
    m.trigger("mira_door", 18, 4, on_enter=True, once=False)
    m.trigger("mira_bed", 26, 3, 2)
    m.trigger("ritual", 23, 5)
    m.trigger("ezra_bed", 26, 13, 2)
    m.glyph("home_kitchen", 7, 1); m.glyph("home_mira", 24, 1, deep=True)
    m.trigger("exit", 3, 15, on_enter=True, once=False)
    m.player = (3, 14)
    return m


def warroom():
    m = Map("WarRoom", "WarRoomScene.gd", 30, 17, TILE_DARK, seed=11)
    m.fill(1, 10, 28, 15, ["carpet_navy"])
    m.void_border()
    m.top_wall("navy", 1, 28)
    m.ground[16][3] = "shadow_floor"; m.clear_wall(3, 16)
    for x in (1, 4, 7, 10):
        m.prop("tv", x, 2)
    m.prop("tv_small", 13, 2)
    m.prop("elevator", 26, 1, solid=0)
    m.prop("cabinet", 16, 3); m.prop("bookcase", 18, 3); m.prop("water_cooler", 22, 3); m.prop("vending_dark", 23, 3)
    m.prop("desk_long_wood", 8, 7); m.prop("desk_long_wood", 14, 7)
    for x in (9, 11, 13, 15, 17):
        m.prop("chair_office_back", x, 5); m.prop("chair_office", x, 9)
    m.prop("laptop_open", 10, 7, lift=12); m.prop("laptop_open", 16, 7, lift=12); m.prop("phone", 13, 7, lift=12)
    m.prop("paper", 12, 7, lift=12, solid=0); m.prop("tablet", 18, 7, lift=12)
    m.prop("desk_grey", 3, 12); m.prop("laptop_dark", 4, 12, lift=10); m.prop("chair_office_back", 3, 11); m.prop("paper2", 3, 12, lift=10, solid=0)
    m.prop("copy_machine", 26, 13); m.prop("bin", 28, 13); m.prop("planter", 1, 14); m.prop("planter_small", 28, 5)
    m.decal("rug_blue", 8, 13)
    m.npc("turan", 12, 4, "down"); m.npc("lynx", 21, 7, "left"); m.npc("emmet", 7, 10, "up"); m.npc("forner", 4, 13, "up")
    m.trigger("screens", 1, 2, 14)
    m.trigger("table", 8, 6, 12, 2)
    m.trigger("forner_desk", 3, 12, 2)
    m.trigger("elevator", 26, 1, 2)
    m.glyph("hq_wall", 20, 1); m.glyph("hq_lift", 28, 1, deep=True)
    m.trigger("exit", 3, 15, on_enter=True, once=False)
    m.player = (14, 14)
    return m


def hospital():
    m = Map("Hospital", "HospitalScene.gd", 30, 17, ["tile_white"], seed=13)
    m.fill(14, 2, 17, 15, ["tile_blue"]); m.fill(19, 2, 28, 15, TILE_DARK)
    m.void_border()
    m.top_wall("hosp", 1, 28, windows=[(24, "dark"), (25, "dark"), (9, "day"), (10, "day")])
    m.partition("hosp", 13, 0, 15, gaps=(8,)); m.partition("hosp", 18, 0, 15, gaps=(6,))
    m.ground[16][2] = "shadow_floor"; m.clear_wall(2, 16)
    m.prop("counter_l", 3, 3); m.prop("counter", 4, 3); m.prop("counter_r", 6, 3)
    m.prop("laptop_dark", 4, 3, lift=36); m.prop("phone", 5, 3, lift=36)
    m.prop("planter", 1, 3); m.prop("planter", 12, 3); m.prop("bin_white", 7, 3)
    m.prop("bench", 1, 11); m.prop("bench", 8, 11); m.prop("bench", 8, 7); m.prop("water_cooler", 12, 13)
    m.decal("poster_blank", 2, 1); m.decal("poster3", 11, 1)
    m.prop("vending", 14, 3); m.prop("cart", 17, 12); m.prop("wheelchair", 14, 14)
    # Dufredy's room
    m.prop("bed_single_white", 25, 5); m.prop("blanket", 25, 5, lift=20, solid=0)
    m.prop("end_table", 27, 5); m.prop("lamp_table", 27, 5, lift=20)
    m.decal("curtain_dark", 23, 2)
    m.prop("wheelchair", 22, 8); m.decal("drain", 27, 12); m.prop("cabinet", 19, 3); m.decal("cobweb", 28, 2)
    m.npc("bot", 8, 5, "down"); m.npc("nurse", 16, 6, "down")
    m.trigger("screens", 3, 3, 4)
    m.trigger("room_door", 18, 6, on_enter=True, once=False)
    m.trigger("blinds", 24, 1, 2)
    m.trigger("dufredy", 25, 3, 2, 3)
    m.glyph("hosp_lobby", 5, 1); m.glyph("hosp_ward", 20, 1, deep=True)
    m.trigger("exit", 2, 15, on_enter=True, once=False)
    m.player = (3, 13)
    return m


def southtown():
    m = Map("Southtown", "SouthtownScene.gd", 50, 20, ["asphalt"], seed=17)
    m.wall(0, 0, 49, 0, "brick_dark_top"); m.wall(0, 1, 49, 1, "brick_dark_bot")
    # station front
    m.wall(1, 0, 14, 0, "brick_grey_top"); m.wall(1, 1, 14, 2, "brick_grey_mid"); m.wall(1, 3, 14, 3, "brick_grey_bot")
    for x in (3, 4, 9, 10):
        m.walls[2][x] = "window_dark_top"; m.walls[3][x] = "window_dark_bot"
    m.walls[2][6] = "frame_l_top"; m.walls[3][6] = "frame_l_bot"; m.walls[2][7] = "frame_r_top"; m.walls[3][7] = "frame_r_bot"
    m.walls[1][6] = "frame_c_top"; m.walls[1][7] = "frame_c_top"
    m.decal("poster", 1, 3); m.decal("poster2", 12, 2); m.decal("glyph", 12, 3)
    m.prop("mailboxes", 13, 4, solid=0)
    m.fill(1, 4, 48, 4, CEMENT); m.fill(1, 10, 48, 10, CEMENT); m.fill(1, 18, 48, 18, CEMENT)
    m.fill(0, 19, 49, 19, "cement_edge"); m.fill(0, 2, 0, 18, "cement_edge"); m.fill(49, 2, 49, 18, "cement_edge")
    # factory
    m.wall(16, 11, 26, 11, "brick_dark_top"); m.wall(16, 12, 26, 13, "brick_red_top"); m.wall(16, 14, 26, 14, "brick_red_bot")
    m.decal("graffiti_green", 17, 14); m.decal("glyph", 20, 14); m.decal("graffiti_band", 24, 14)
    for x in (18, 23):
        m.walls[12][x] = "window_dark_top"; m.walls[13][x] = "window_dark_bot"
    m.prop("fence_h", 13, 13); m.prop("fence_h", 27, 13); m.prop("barrel", 15, 15); m.prop("crate", 26, 15)
    # shanty
    m.fill(28, 12, 36, 15, DIRT)
    m.prop("tent", 30, 14); m.prop("tent", 33, 13); m.prop("fire", 32, 15); m.prop("cart", 35, 12); m.prop("barrel", 29, 12)
    m.decal("blanket", 28, 15); m.decal("paper2", 34, 15); m.prop("crate_small", 36, 14)
    # overpass
    m.fill(40, 6, 48, 13, ["cement_dark"]); m.fill(40, 5, 48, 5, "cement_edge")
    for x, y in ((42, 8), (46, 8), (42, 13), (46, 13)):
        m.prop("pillar", x, y)
    m.decal("cement_stairs", 41, 12); m.decal("blood", 44, 11)
    # street dressing
    m.decal("graffiti_band", 28, 1); m.decal("glyph", 38, 1); m.decal("poster_blank", 33, 1); m.decal("graffiti_danger", 42, 1)
    m.prop("lamp_post", 6, 7); m.prop("lamp_post", 24, 7); m.prop("lamp_post_off", 10, 16); m.prop("lamp_post_off", 44, 17)
    m.prop("sedan", 8, 9); m.prop("car_blue", 36, 17); m.prop("bin", 15, 5); m.prop("bin", 37, 5)
    m.decal("paper", 20, 6); m.decal("paper3", 30, 8); m.decal("rock_tiny", 5, 15); m.prop("barrel", 2, 12)
    m.scatter(["cement_crack", "cement_crack2"], [(5, 4), (20, 4), (33, 10), (9, 18)])
    m.npc("lynx", 7, 5, "down")
    m.trigger("glyph_station", 12, 3)
    m.trigger("glyph_factory", 20, 14)
    m.trigger("glyph_far", 38, 1)
    m.trigger("factory", 16, 14, 4); m.trigger("factory", 21, 14, 6)
    m.trigger("shanty", 30, 13, 5, 2)
    m.trigger("station", 1, 3, 11); m.trigger("station", 13, 3, 2)
    m.trigger("overpass", 43, 8, 2, 3, on_enter=True)
    m.glyph("st_station", 2, 3); m.glyph("st_overpass", 47, 5, deep=True); m.glyph("st_shanty", 36, 11)
    m.trigger("exit", 3, 17, on_enter=True, once=False)
    m.exit("exit:east", 49, 5, 1, 5)
    m.fill(49, 5, 49, 9, CEMENT)
    m.exit("exit:south", 46, 19, 3, 1)
    m.fill(46, 19, 48, 19, CEMENT)
    m.trigger("door:Factory", 21, 15, 2, 1, on_enter=True, once=False)
    m.player = (3, 6)
    return m


def lynx_apartment():
    m = Map("LynxApartment", "LynxApartmentScene.gd", 30, 17, WOOD_GREY, seed=19)
    m.fill(19, 2, 28, 15, ["carpet_navy"])
    m.void_border()
    m.top_wall("lynx", 1, 28, windows=[(8, "dark"), (9, "dark"), (22, "dark"), (23, "dark")])
    m.partition("lynx", 16, 0, 15, gaps=(8,)); m.partition("lynx", 18, 0, 15, gaps=(8,))
    m.ground[16][3] = "shadow_floor"; m.clear_wall(3, 16)
    # notes everywhere
    for i, x in enumerate(range(1, 16)):
        m.decal(["paper", "paper2", "poster_blank", "paper3"][i % 4], x, 1, lift=6 + (i % 3) * 5)
    m.decal("curtain_dark", 8, 1)
    m.prop("counter_l", 1, 2); m.prop("counter", 2, 2); m.prop("sink", 4, 2); m.prop("fridge", 6, 2); m.prop("dishes", 2, 2, lift=38)
    m.prop("chair_back", 10, 4); m.prop("table", 9, 6); m.prop("chair_front", 11, 8); m.prop("paper", 10, 6, lift=20, solid=0); m.prop("laptop_closed", 9, 6, lift=20)
    m.prop("sofa_navy", 2, 9); m.decal("rug_red", 2, 11); m.prop("lamp_floor_dark", 5, 9)
    m.decal("frames_broken", 6, 8)
    m.prop("box_open", 13, 11); m.prop("crate", 14, 13); m.decal("paper2", 12, 13); m.decal("cobweb", 1, 2)
    # back room
    m.decal("poster", 19, 1); m.decal("poster2", 20, 1); m.decal("poster3", 21, 1); m.decal("glyph_red", 25, 1)
    m.prop("desk_dark", 24, 4); m.prop("laptop_open", 25, 4, lift=14); m.prop("chair_office", 24, 5)
    m.prop("bookcase", 27, 3); m.prop("bed_wood", 20, 9); m.prop("mirror_standing", 27, 9)
    m.decal("paper", 22, 12); m.decal("paper3", 25, 10); m.prop("box", 19, 14); m.decal("cobweb", 28, 2)
    m.trigger("door", 3, 14, on_enter=True)
    m.trigger("notes", 1, 1, 15)
    m.trigger("frames", 6, 8)
    m.trigger("photos", 19, 1, 3)
    m.trigger("sigil", 25, 1)
    m.trigger("laptop", 24, 4, 2)
    m.glyph("lynx_kitchen", 12, 1, lift=4); m.glyph("lynx_back", 22, 1, deep=True)
    m.trigger("exit", 3, 15, on_enter=True, once=False)
    m.player = (3, 13)
    return m


def desert():
    m = Map("Desert", "DesertScene.gd", 40, 17, SAND, seed=23)
    m.scatter(["dirt_red", "dirt"], [(m.rng.randrange(1, 32), m.rng.randrange(1, 17)) for _ in range(26)])
    m.wall(33, 0, 33, 16, ["cliff_face", "cliff_face2"]); m.wall(34, 0, 34, 16, "cliff_top_l"); m.wall(35, 0, 39, 16, DIRT)
    m.wall(0, 0, 32, 0, ["cliff_face_b", "cliff_face_b2"])
    m.decal("cave", 32, 9)
    m.prop("cave_door", 33, 9, id="cave_door", solid=0)
    m.prop("sedan", 20, 7); m.prop("car_blue", 4, 13)
    m.prop("rock_big", 10, 4); m.prop("rock_big", 26, 12); m.prop("rock_med", 15, 10); m.prop("rock_grey", 30, 3); m.prop("rock_med", 8, 8)
    m.prop("rock_small", 12, 14); m.prop("rock_grey_small", 27, 5); m.prop("rock_small", 22, 2); m.prop("rock_grey_small", 2, 3)
    m.prop("cactus", 13, 13); m.prop("cactus", 28, 6); m.prop("cactus", 6, 7); m.prop("tree_dead", 18, 3); m.prop("bush_dark", 24, 15); m.prop("bush_dark", 3, 9)
    for x, y in ((5, 5), (14, 7), (22, 12), (29, 9), (9, 15), (17, 15), (31, 14), (25, 4)):
        m.decal("rock_tiny", x, y)
    for x, y in ((7, 11), (19, 9), (27, 8), (11, 2), (30, 12)):
        m.decal("grass_tuft", x, y)
    m.decal("reeds", 31, 6)
    m.trigger("sedan", 20, 7, 2)
    m.trigger("my_car", 4, 13, 2)
    m.trigger("door_approach", 30, 8, 2, 3, on_enter=True)
    m.trigger("door", 33, 9, 2)
    m.glyph("desert_cliff", 33, 3); m.glyph("desert_cliff2", 33, 14, deep=True)
    m.exit("exit:west", 0, 9, 1, 4)
    m.player = (6, 11)
    return m


def mirror():
    m = Map("Mirror", "MirrorScene.gd", 20, 12, ["diamond_dark"], seed=29)
    m.scatter(["diamond_navy"], [(x, y) for x in range(20) for y in range(12) if (x + y) % 2 == 0])
    m.void_border()
    m.wall(1, 0, 18, 0, "stone_top"); m.wall(1, 1, 18, 1, "stone_bot")
    m.decal("dias", 8, 4)
    m.prop("mirror_big", 8, 3)
    for x, y in ((3, 4), (16, 4), (3, 9), (16, 9)):
        m.prop("pillar", x, y)
    m.decal("cobweb", 1, 2); m.decal("cobweb", 18, 2); m.prop("stone_slab", 5, 10); m.prop("stone_slab", 13, 10)
    m.decal("blood", 10, 7); m.decal("moss", 18, 1)
    m.trigger("center", 9, 6, 2, on_enter=True)
    m.trigger("mirror", 9, 3, 2)
    m.glyph("mirror_wall", 3, 1); m.glyph("mirror_wall2", 15, 1, deep=True)
    m.player = (9, 9)
    return m


def storefront(m, x0, x1, door, style, windows, y_top=0, height=6, sign=None):
    """A building face spanning x0..x1 with the bottom wall row at y_top+height, a door at `door`."""
    top, bot = f"brick_{style}_top", f"brick_{style}_bot"
    mid = f"brick_{style}_mid" if f"brick_{style}_mid" in ATLAS else top
    yb = y_top + height
    m.wall(x0, y_top, x1, y_top, top)
    m.wall(x0, y_top + 1, x1, yb - 1, mid)
    m.wall(x0, yb, x1, yb, bot)
    for wx in windows:
        for wy in range(y_top + 1, yb - 1, 2):
            if wy + 1 <= yb - 1:
                m.walls[wy][wx] = "window_dark_top"; m.walls[wy + 1][wx] = "window_dark_bot"
    m.walls[yb - 1][door - 2] = "window_lit_top"; m.walls[yb][door - 2] = "window_lit_bot"
    m.walls[yb - 1][door + 2] = "window_lit_top"; m.walls[yb][door + 2] = "window_lit_bot"
    m.walls[yb - 2][door] = "frame_c_top"; m.walls[yb - 1][door] = "frame_l_top"; m.walls[yb][door] = "frame_l_bot"
    m.walls[yb - 1][door + 1] = "frame_r_top"; m.walls[yb][door + 1] = "frame_r_bot"
    m.walls[yb - 2][door + 1] = "frame_c_top"
    if sign:
        m.decal(sign, door - 1, yb - 2)


def street_base(name, script, w, h, seed, top_wall=True):
    """A boulevard: building fronts along the top (rows 0-6), sidewalks, street, sidewalk, a bottom band."""
    m = Map(name, script, w, h, ["asphalt"], seed=seed)
    m.fill(0, 7, w - 1, 9, CEMENT); m.fill(0, 15, w - 1, 17, CEMENT)
    if top_wall:
        m.wall(0, 0, w - 1, 6, "brick_dark_mid"); m.wall(0, 0, w - 1, 0, "brick_dark_top"); m.wall(0, 6, w - 1, 6, "brick_dark_bot")
    m.fill(0, 18, w - 1, h - 1, CEMENT)
    return m


def lamplight():
    m = street_base("Lamplight", "LamplightScene.gd", 48, 20, 31)
    storefront(m, 1, 13, 7, "grey", windows=(3, 11), sign="poster")            # the Lamplight, Dufredy's building
    storefront(m, 16, 30, 23, "red", windows=(17, 20, 26, 29), sign="poster2")  # the neighbour's block
    storefront(m, 33, 46, 40, "grey", windows=(35, 45), sign="poster_blank")
    m.decal("graffiti_green", 0, 4); m.decal("glyph", 15, 5); m.decal("graffiti_band", 31, 4)
    m.prop("mailboxes", 13, 6, solid=0)
    # bottom band: the backs of the next block, with the canal steps at x 19-21
    m.wall(0, 18, 18, 19, "brick_dark_mid"); m.wall(22, 18, 47, 19, "brick_dark_mid")
    m.wall(0, 18, 18, 18, "brick_dark_top"); m.wall(22, 18, 47, 18, "brick_dark_top")
    m.decal("cement_stairs", 19, 19); m.decal("cement_stairs", 20, 19); m.decal("cement_stairs", 21, 19)
    m.decal("graffiti_loot", 8, 18); m.decal("poster3", 30, 18)
    for x in (4, 20, 36):
        m.prop("lamp_post", x, 9)
    for x in (12, 28, 44):
        m.prop("lamp_post_off", x, 16)
    m.prop("sedan", 34, 12, id="cruiser"); m.prop("car_blue", 10, 13)
    m.prop("bin", 2, 8); m.prop("bin", 31, 8); m.prop("planter", 15, 8); m.prop("planter_small", 32, 8)
    m.decal("paper", 23, 9); m.decal("paper3", 40, 16); m.decal("blood", 6, 15); m.decal("paper2", 14, 16)
    m.scatter(["cement_crack", "cement_crack2"], [(5, 9), (18, 8), (31, 16), (44, 15)])
    m.npc("officer", 37, 15, "up")
    m.glyph("ll_front", 2, 6); m.glyph("ll_neighbour", 30, 6, deep=True); m.glyph("ll_back", 40, 18)
    m.trigger("door:Apartment", 7, 8, 2, 1, on_enter=True, once=False)
    m.trigger("neighbour", 23, 7, 2)
    m.trigger("mailboxes", 13, 7)
    m.trigger("cruiser", 34, 12, 2)
    m.trigger("stairs_sign", 18, 17)
    m.exit("exit:east", 47, 7, 1, 11)
    m.exit("exit:south", 19, 19, 3, 1)
    m.player = (8, 10)
    return m


def spine():
    m = street_base("Spine", "SpineScene.gd", 64, 22, 33)
    storefront(m, 1, 12, 6, "grey", windows=(3, 10), sign="poster")
    storefront(m, 15, 25, 20, "red", windows=(16, 24), sign="poster2")           # the flyover ramp
    storefront(m, 28, 41, 34, "dark", windows=(29, 31, 37, 39), sign="poster3")  # Psyonic Integrations
    storefront(m, 44, 54, 49, "grey", windows=(45, 53), sign="poster_blank")     # SalTech shuttle stop
    storefront(m, 56, 62, 59, "red", windows=(57,), sign="paper")
    m.decal("graffiti_loot", 26, 4); m.decal("graffiti_band", 55, 4); m.decal("graffiti_green", 0, 4)
    # bottom band: a vacant lot with the camp, the underpass stairs at x 33-36, walls either side
    m.fill(0, 18, 63, 21, CEMENT)
    m.fill(2, 19, 30, 21, DIRT)
    m.prop("fence_h", 2, 18); m.prop("fence_h", 6, 18); m.prop("fence_h", 22, 18); m.prop("fence_h", 26, 18)
    m.prop("crate", 5, 21); m.prop("barrel", 9, 21); m.prop("cart", 24, 20); m.prop("tent", 15, 20); m.prop("fire", 18, 21)
    m.decal("blanket", 12, 21); m.decal("paper2", 21, 19); m.decal("graffiti_green", 3, 19)
    m.wall(38, 18, 63, 21, "brick_dark_mid"); m.wall(38, 18, 63, 18, "brick_dark_top"); m.wall(0, 18, 1, 21, "brick_dark_mid")
    m.wall(31, 18, 32, 21, "brick_dark_mid")
    m.fill(33, 18, 37, 21, ["cement_dark"])
    m.decal("cement_stairs", 33, 21); m.decal("cement_stairs", 34, 21); m.decal("cement_stairs", 35, 21); m.decal("cement_stairs", 36, 21)
    m.decal("graffiti_danger", 40, 18); m.decal("glyph", 47, 18); m.decal("graffiti_band", 58, 18)
    for x in (4, 18, 32, 46, 60):
        m.prop("lamp_post", x, 9)
    for x in (11, 25, 39, 53):
        m.prop("lamp_post_off", x, 16)
    m.prop("sedan", 13, 13, id="my_car"); m.prop("car_blue", 36, 11); m.prop("sedan", 51, 13)
    m.prop("bin", 2, 8); m.prop("bin", 26, 8); m.prop("bin", 55, 8); m.prop("bin", 20, 15); m.prop("bin", 47, 15)
    m.prop("vending", 41, 8, solid=1); m.prop("planter", 27, 8); m.prop("planter", 44, 8); m.prop("planter_small", 15, 8); m.prop("planter_small", 55, 8)
    m.decal("paper", 23, 9); m.decal("paper3", 40, 16); m.decal("blood", 9, 15)
    m.npc("preacher", 30, 15, "down", sprite="eyeless")
    m.glyph("sp_tower", 40, 6, deep=True); m.glyph("sp_west", 14, 6); m.glyph("sp_lot", 45, 18)
    m.trigger("door:WarRoom", 34, 8, 2, 1, on_enter=True, once=False)
    m.exit("exit:north", 20, 8, 2, 1)          # the flyover ramp, up to the Heights
    m.trigger("shuttle_stop", 49, 8, 2, 1)
    m.trigger("my_car", 13, 13, 2)
    m.trigger("vending", 41, 8, 2)
    m.trigger("tower_sign", 32, 6, 5)
    m.trigger("camp", 12, 20, 10, 2)
    m.trigger("south_glyph", 47, 18)
    m.exit("exit:west", 0, 7, 1, 11)
    m.exit("exit:east", 63, 7, 1, 11)
    m.exit("exit:south", 33, 21, 4, 1)
    m.player = (34, 10)
    return m


def zetapark():
    m = street_base("ZetaPark", "ZetaParkScene.gd", 48, 20, 35)
    storefront(m, 3, 17, 10, "red", windows=(4, 7, 13, 16), sign="paper")        # Lynx's building
    storefront(m, 20, 34, 27, "grey", windows=(21, 24, 30, 33), sign="poster3")  # the glass block
    storefront(m, 37, 46, 42, "dark", windows=(38, 45), sign="poster_blank")
    m.decal("glyph_red", 18, 5); m.decal("graffiti_band", 0, 4); m.decal("graffiti_danger", 35, 4)
    # bottom band: Park Avenue crossing, a wall with the one working camera on it
    m.wall(0, 18, 47, 19, "brick_dark_mid"); m.wall(0, 18, 47, 18, "brick_dark_top")
    m.decal("poster", 5, 18); m.decal("graffiti_loot", 30, 18); m.decal("poster2", 40, 18)
    m.fill(20, 15, 23, 19, CEMENT)  # the crossing
    m.fill(20, 10, 23, 14, ["cement_dark"])
    for x in (2, 16, 30, 44):
        m.prop("lamp_post", x, 9)
    for x in (9, 36):
        m.prop("lamp_post_off", x, 16)
    m.prop("lamp_post", 25, 16, id="camera_post")
    m.prop("car_blue", 6, 12); m.prop("sedan", 38, 13)
    m.prop("bin", 1, 8); m.prop("bin", 19, 8); m.prop("bin", 35, 8); m.prop("planter", 18, 8); m.prop("planter_small", 47, 8)
    m.decal("paper", 12, 9); m.decal("paper3", 28, 16); m.decal("blood", 21, 16); m.decal("paper2", 42, 15)
    m.npc("masked", 22, 17, "up", meta={"min_connection": 50})
    m.glyph("zp_lynx", 2, 6); m.glyph("zp_glass", 33, 6, deep=True); m.glyph("zp_corner", 26, 18)
    m.trigger("door:LynxApartment", 10, 8, 2, 1, on_enter=True, once=False)
    m.trigger("camera", 25, 16)
    m.trigger("corner", 20, 15, 4, 2)
    m.trigger("glass_lobby", 27, 7, 2)
    m.exit("exit:west", 0, 7, 1, 11)
    m.exit("exit:east", 47, 7, 1, 11)
    m.player = (11, 10)
    return m


def canalwalk():
    m = Map("CanalWalk", "CanalWalkScene.gd", 40, 16, CEMENT, seed=37)
    # the dry canal runs north-south down the middle; ramps at rows 6-7
    m.fill(14, 0, 25, 15, ["cement_dark"]); m.scatter(SAND, [(14 + (i * 7) % 12, (i * 5) % 16) for i in range(30)])
    for y in range(16):
        if y not in (6, 7):
            m.ground[y][13] = "cement_edge"; m.ground[y][26] = "cement_edge"
    m.fill(27, 0, 39, 15, DIRT); m.scatter(GRASS, [(28 + (i * 3) % 12, (i * 7) % 16) for i in range(24)])
    m.decal("stick_circle", 17, 3); m.decal("stick_circle", 21, 10); m.decal("stick_circle", 15, 13)
    m.decal("stick", 19, 8); m.decal("stick", 23, 5); m.decal("rock_tiny", 16, 11); m.decal("reeds", 24, 14); m.decal("reeds", 14, 1)
    m.prop("sedan", 3, 4, id="radio_car"); m.prop("lamp_post_off", 9, 2); m.prop("lamp_post", 9, 12); m.prop("bin", 1, 9)
    m.prop("tree_dead", 31, 3); m.prop("tree_small", 36, 10); m.prop("bush_dark", 29, 13); m.prop("rock_med", 34, 6)
    m.decal("paper", 5, 8); m.decal("blood", 20, 12)
    m.npc("kid1", 6, 10, "right", sprite="ezra"); m.npc("kid2", 8, 10, "left", sprite="mira")
    m.npc("bank_figure", 33, 8, "left", sprite="eyeless", meta={"min_connection": 25})
    m.glyph("cw_wall", 13, 3); m.glyph("cw_far", 26, 12, deep=True)
    m.trigger("radio", 3, 4, 2)
    m.trigger("chalk", 6, 11, 3)
    m.trigger("circles", 17, 3)
    m.trigger("circles", 21, 10)
    m.trigger("silt", 15, 6, 10, 2, on_enter=True)
    m.exit("exit:north", 18, 0, 4, 1)
    m.exit("exit:south", 18, 15, 4, 1)
    m.player = (20, 2)
    return m


def underpass():
    m = Map("Underpass", "UnderpassScene.gd", 40, 16, ["cement_dark"], seed=41)
    m.wall(0, 0, 39, 1, "brick_dark_mid"); m.wall(0, 0, 39, 0, "brick_dark_top"); m.wall(0, 1, 39, 1, "brick_dark_bot")
    m.wall(0, 14, 39, 15, "brick_dark_mid"); m.wall(0, 14, 39, 14, "brick_dark_top")
    for x in (18, 19, 20, 21):
        m.clear_wall(x, 0); m.clear_wall(x, 1); m.clear_wall(x, 14); m.clear_wall(x, 15)
    m.fill(18, 0, 21, 1, ["cement_dark"]); m.fill(18, 14, 21, 15, ["cement_dark"])
    for x in (6, 14, 25, 33):
        m.prop("pillar", x, 6); m.prop("pillar", x, 11)
    m.decal("graffiti_band", 2, 1); m.decal("graffiti_green", 5, 1); m.decal("glyph", 9, 1); m.decal("graffiti_danger", 12, 1)
    m.decal("graffiti_loot", 27, 1); m.decal("glyph_red", 30, 1); m.decal("graffiti_band", 34, 1); m.decal("poster_blank", 37, 1)
    m.decal("graffiti_green", 3, 14); m.decal("glyph", 23, 14); m.decal("graffiti_danger", 31, 14)
    m.decal("blanket", 9, 4); m.decal("blanket", 12, 4); m.decal("blanket", 15, 4); m.decal("fire_out", 11, 6)
    m.prop("barrel", 2, 5); m.prop("crate", 36, 4); m.prop("crate_small", 37, 12); m.prop("cart", 3, 11); m.prop("lamp_post_off", 22, 8)
    m.decal("paper", 17, 9); m.decal("paper2", 29, 12); m.decal("blood", 31, 8); m.decal("drain", 20, 7)
    m.npc("sleeper1", 10, 4, "left", sprite="eyeless"); m.npc("sleeper2", 13, 4, "left", sprite="eyeless"); m.npc("sleeper3", 16, 4, "left", sprite="eyeless")
    m.glyph("up_east", 24, 1); m.glyph("up_deep", 36, 14, deep=True)
    m.trigger("chant_wall", 2, 1, 12)
    m.trigger("sleepers", 9, 4, 8, 1)
    m.trigger("drain", 20, 7)
    m.trigger("old_layers", 27, 1, 8)
    m.exit("exit:north", 18, 0, 4, 1)
    m.exit("exit:south", 18, 15, 4, 1)
    m.player = (20, 2)
    return m


def heights():
    m = street_base("Heights", "HeightsScene.gd", 48, 20, 43)
    # houses: low fronts with lit windows and a nightlight in each
    storefront(m, 1, 9, 5, "grey", windows=(), sign=None)
    storefront(m, 12, 20, 16, "red", windows=(), sign=None)            # Carl's house: door at 16
    storefront(m, 23, 31, 27, "grey", windows=(), sign=None)
    storefront(m, 34, 46, 40, "dark", windows=(36, 44), sign="poster_blank")  # the school
    for x in (3, 14, 25):
        m.prop("nightlight", x, 4, lift=10, solid=0)
    m.decal("glyph", 32, 5)
    for x in (10, 21, 32):
        m.prop("tree_small", x, 8)
    m.prop("planter", 11, 8); m.prop("planter", 22, 8); m.prop("planter_small", 33, 8)
    # bottom band: garden walls, the ramp down at x 22-25, Carl's car in the drive
    m.wall(0, 18, 21, 19, "brick_dark_mid"); m.wall(26, 18, 47, 19, "brick_dark_mid")
    m.wall(0, 18, 21, 18, "brick_dark_top"); m.wall(26, 18, 47, 18, "brick_dark_top")
    m.fill(22, 18, 25, 19, ["cement_dark"]); m.decal("cement_stairs", 22, 19); m.decal("cement_stairs", 24, 19)
    for x in (2, 5, 8, 36, 39, 42):
        m.prop("fence_iron", x, 17)
    m.fill(2, 15, 10, 16, GRASS); m.fill(36, 15, 46, 16, GRASS)
    m.prop("tree", 4, 17); m.prop("bush", 40, 16); m.prop("bush2", 44, 15)
    for x in (6, 30):
        m.prop("lamp_post", x, 9)
    for x in (18, 42):
        m.prop("lamp_post_off", x, 16)
    m.prop("sedan", 14, 12, id="my_car"); m.prop("car_blue", 28, 13)
    m.decal("paper", 20, 9); m.decal("paper3", 12, 16)
    m.decal("rug_blue", 36, 9)  # chalk on the pavement, blue
    m.npc("jogger", 44, 10, "left", sprite="seth")
    m.glyph("ht_school", 46, 6); m.glyph("ht_wall", 12, 18, deep=True); m.glyph("ht_garden", 46, 18)
    m.trigger("door:Home", 16, 8, 2, 1, on_enter=True, once=False)
    m.trigger("school", 40, 8, 2)
    m.trigger("nightlight", 3, 6); m.trigger("nightlight", 14, 6); m.trigger("nightlight", 25, 6)
    m.trigger("chalk", 36, 9)
    m.trigger("my_car", 14, 12, 2)
    m.exit("exit:south", 22, 19, 4, 1)
    m.exit("exit:west", 0, 7, 1, 11)
    m.player = (17, 10)
    return m


def flyover():
    m = Map("Flyover", "FlyoverScene.gd", 24, 28, ["asphalt"], seed=47)
    m.fill(0, 0, 4, 27, CEMENT); m.fill(19, 0, 23, 27, CEMENT)
    m.fill(5, 0, 5, 27, "cement_edge"); m.fill(18, 0, 18, 27, "cement_edge")
    for y in (6, 7, 14, 15, 22, 23):
        m.ground[y][5] = m._pick(CEMENT); m.ground[y][18] = m._pick(CEMENT)
    # the billboard wall on the east walkway: twenty years of ads, oldest at the top
    m.wall(21, 0, 23, 27, "brick_dark_mid")
    for i, y in enumerate((2, 6, 10, 14, 18, 22)):
        m.decal(["poster_blank", "poster3", "poster2", "poster", "graffiti_band", "graffiti_loot"][i], 21, y)
        m.trigger("billboard", 21, y, 1, 2)
    m.decal("glyph", 22, 25)
    for y in (3, 11, 19, 26):
        m.prop("lamp_post", 2, y)
    m.prop("sedan", 10, 12, id="stalled"); m.decal("stick", 9, 15); m.decal("stick", 13, 14)
    m.decal("blood", 8, 20); m.decal("paper", 15, 5); m.decal("paper2", 11, 24)
    m.scatter(["cement_crack", "cement_crack2"], [(1, 9), (3, 17), (20, 4), (19, 21)])
    m.npc("jogger", 2, 22, "up", sprite="tyson")
    m.glyph("fo_top", 21, 26, deep=True); m.glyph("fo_edge", 5, 10)
    m.trigger("stalled", 10, 12, 2)
    m.trigger("ramp_top", 6, 2, 12, 1, on_enter=True)
    m.exit("exit:north", 10, 0, 4, 1)
    m.exit("exit:south", 10, 27, 4, 1)
    m.player = (12, 25)
    return m


def hillroad():
    m = Map("HillRoad", "HillRoadScene.gd", 40, 16, ["asphalt"], seed=53)
    m.fill(0, 0, 39, 4, DIRT); m.fill(0, 11, 39, 15, DIRT)
    m.fill(0, 5, 39, 5, CEMENT); m.fill(0, 10, 39, 10, CEMENT)
    m.scatter(GRASS, [((i * 7) % 40, (i * 3) % 4) for i in range(30)] + [((i * 11) % 40, 11 + (i * 3) % 5) for i in range(30)])
    # SalTech gate at the west end
    m.wall(0, 0, 7, 4, "brick_grey_mid"); m.wall(0, 0, 7, 0, "brick_grey_top"); m.wall(0, 4, 7, 4, "brick_grey_bot")
    m.walls[3][3] = "frame_l_top"; m.walls[4][3] = "frame_l_bot"; m.walls[3][4] = "frame_r_top"; m.walls[4][4] = "frame_r_bot"
    m.walls[2][3] = "frame_c_top"; m.walls[2][4] = "frame_c_top"
    m.decal("poster_blank", 1, 2); m.decal("poster3", 6, 2)
    m.prop("car_blue", 9, 2, id="ambulance")
    for x in (12, 20, 28, 36):
        m.prop("lamp_post", x, 4, id="lamp_on_%d" % x)
        m.prop("lamp_post_off", x, 4, id="lamp_off_%d" % x, visible=False)
    for x, y in ((14, 1), (24, 0), (33, 1), (5, 13), (17, 12), (30, 13)):
        m.prop("tree", x, y + 3) if y < 3 else m.prop("tree2", x, y + 2)
    m.prop("bush", 10, 14); m.prop("bush_dark", 38, 12); m.prop("rock_med", 22, 14); m.prop("bench", 26, 11)
    m.decal("grass_tuft", 8, 12); m.decal("grass_tuft", 35, 2); m.decal("paper", 18, 10)
    m.npc("nurse", 11, 5, "down")
    m.npc("follower", 30, 10, "left", sprite="eyeless", meta={"min_connection": 0})
    m.glyph("hr_gate", 7, 4); m.glyph("hr_bench", 26, 15, deep=True)
    m.trigger("door:Hospital", 3, 5, 2, 1, on_enter=True, once=False)
    m.trigger("ambulance", 9, 2, 2)
    m.trigger("bench", 26, 11)
    m.trigger("lights", 16, 5, 2, 6, on_enter=True)
    m.trigger("follow", 24, 5, 2, 6, on_enter=True)
    m.exit("exit:east", 39, 5, 1, 6)
    m.player = (37, 7)
    return m


def cognizo():
    m = street_base("Cognizo", "CognizoScene.gd", 48, 20, 59)
    # glass fronts: the rival's district is all windows
    storefront(m, 1, 14, 7, "grey", windows=(2, 4, 10, 12), sign="poster_blank")
    storefront(m, 17, 30, 23, "dark", windows=(18, 20, 27, 29), sign="poster3")   # the subway entrance
    storefront(m, 33, 46, 40, "grey", windows=(34, 36, 43, 45), sign="poster2")
    for x in (3, 11, 19, 28, 35, 44):
        m.walls[1][x] = "window_lit_top"; m.walls[2][x] = "window_lit_bot"
    m.decal("glyph_red", 16, 5); m.decal("graffiti_band", 31, 4)
    m.wall(0, 18, 47, 19, "brick_grey_mid"); m.wall(0, 18, 47, 18, "brick_grey_top")
    m.decal("poster_blank", 6, 18); m.decal("glyph", 24, 18); m.decal("poster3", 40, 18)
    for x in (5, 21, 37):
        m.prop("lamp_post", x, 9)
    for x in (13, 29, 45):
        m.prop("lamp_post", x, 16)
    m.prop("sedan", 9, 12); m.prop("sedan", 26, 13); m.prop("car_blue", 40, 12)
    m.prop("vending", 31, 8, solid=1); m.prop("planter", 15, 8); m.prop("planter", 32, 15); m.prop("bin", 1, 8); m.prop("bin", 46, 15)
    m.prop("bench", 8, 15); m.prop("bench", 40, 15)
    m.decal("paper", 20, 9); m.decal("paper2", 36, 16); m.decal("drain", 24, 10)
    m.npc("suit", 11, 15, "up", sprite="forner")
    m.npc("suit2", 38, 10, "down", sprite="turan")
    m.glyph("cq_lobby", 2, 6); m.glyph("cq_subway", 30, 6, deep=True); m.glyph("cq_wall", 24, 18)
    m.trigger("door:CognizoStation", 23, 8, 2, 1, on_enter=True, once=False)
    m.trigger("lobby", 7, 7, 2); m.trigger("lobby", 40, 7, 2)
    m.trigger("vending", 31, 8, 2)
    m.trigger("drain", 24, 10)
    m.exit("exit:west", 0, 7, 1, 11)
    m.exit("exit:south", 44, 19, 3, 1)
    m.fill(44, 18, 46, 19, ["cement_dark"]); m.decal("cement_stairs", 44, 19); m.decal("cement_stairs", 46, 19)
    for x in (44, 45, 46):
        m.clear_wall(x, 18); m.clear_wall(x, 19)
    m.player = (24, 10)
    return m


def cognizo_station():
    m = Map("CognizoStation", "CognizoStationScene.gd", 30, 17, TILE_GREY, seed=61)
    m.void_border()
    m.top_wall("navy", 1, 28)
    m.fill(1, 12, 28, 15, ["asphalt"])           # the track bed
    m.fill(1, 11, 28, 11, "cement_edge")         # the platform edge
    m.ground[9][0] = "shadow_floor"; m.clear_wall(0, 9)   # the stairs up, left wall
    for x in (6, 14, 22):
        m.prop("pillar", x, 5)
    m.prop("bench", 9, 6); m.prop("bench", 18, 6); m.prop("vending_dark", 25, 3); m.prop("bin", 2, 3); m.prop("bin", 27, 6)
    m.decal("poster3", 4, 1); m.decal("poster_blank", 12, 1); m.decal("glyph", 20, 1); m.decal("poster2", 26, 1)
    m.decal("paper", 7, 8); m.decal("paper3", 16, 7); m.decal("blood", 11, 8); m.decal("tablet_broken", 23, 7)
    for x in range(2, 28, 2):
        m.decal("drain", x, 13)
    m.npc("guard", 4, 7, "right", sprite="officer")
    m.glyph("cs_wall", 20, 1); m.glyph("cs_far", 27, 1, deep=True)
    m.trigger("board", 12, 1, 2)
    m.trigger("tablet", 23, 7)
    m.trigger("edge", 1, 10, 28, 1, on_enter=True)
    m.trigger("exit", 0, 9, on_enter=True, once=False)
    m.player = (2, 8)
    return m


def railcut():
    m = Map("RailCut", "RailCutScene.gd", 40, 16, DIRT, seed=67)
    m.fill(0, 6, 39, 9, ["asphalt"])             # the cutting: two tracks
    m.fill(0, 5, 39, 5, "cement_edge"); m.fill(0, 10, 39, 10, "cement_edge")
    for x in (8, 9, 30, 31):
        m.ground[5][x] = m._pick(DIRT); m.ground[10][x] = m._pick(DIRT)   # crossings
    m.fill(0, 0, 39, 1, GRASS); m.fill(0, 14, 39, 15, GRASS)
    for x, y in ((3, 3), (17, 12), (26, 2), (35, 13)):
        m.decal("rock_tiny", x, y)
    for x, y in ((2, 2), (14, 1), (27, 2), (36, 1)):
        m.prop("fence_h", x, y)
    for x, y in ((5, 13), (20, 12), (33, 13)):
        m.prop("fence_h", x, y)
    m.prop("tree_dead", 11, 3); m.prop("tree_dead", 24, 14); m.prop("bush_dark", 37, 3); m.prop("barrel", 1, 12)
    m.prop("crate", 16, 12); m.prop("lamp_post_off", 10, 4); m.prop("lamp_post_off", 29, 4); m.prop("lamp_post", 20, 11)
    m.decal("paper", 6, 11); m.decal("paper2", 22, 3); m.decal("blood", 31, 11); m.decal("graffiti_band", 0, 4)
    m.npc("watcher", 21, 12, "up", sprite="eyeless", meta={"min_connection": 25})
    m.glyph("rc_post", 10, 4); m.glyph("rc_crate", 16, 12, deep=True)
    m.trigger("train", 8, 5, 2, 6, on_enter=True)
    m.trigger("tracks", 12, 6, 16, 4)
    m.trigger("sign", 0, 4)
    m.exit("exit:west", 0, 11, 1, 3)
    m.exit("exit:east", 39, 2, 1, 3)
    m.player = (2, 12)
    return m


def parkave():
    m = Map("ParkAve", "ParkAveScene.gd", 40, 16, ["asphalt"], seed=71)
    m.fill(0, 0, 39, 2, CEMENT); m.fill(0, 13, 39, 15, CEMENT)
    m.wall(0, 0, 39, 0, "brick_grey_top"); m.wall(0, 1, 39, 1, "brick_grey_bot")
    for x in (4, 12, 20, 28, 36):
        m.walls[0][x] = "window_lit_top"; m.walls[1][x] = "window_lit_bot"
    m.decal("poster2", 8, 1); m.decal("glyph", 16, 1); m.decal("poster_blank", 24, 1); m.decal("graffiti_loot", 32, 1)
    for x in (2, 18, 34):
        m.prop("lamp_post", x, 2)
    for x in (10, 26):
        m.prop("lamp_post_off", x, 14)
    m.prop("lamp_post", 30, 14, id="camera2")
    m.prop("sedan", 6, 6); m.prop("car_blue", 22, 9); m.prop("sedan", 33, 7)
    m.prop("bin", 1, 13); m.prop("planter", 15, 13); m.prop("planter_small", 38, 13); m.prop("bench", 20, 13)
    m.decal("paper", 12, 3); m.decal("paper3", 29, 13); m.decal("blood", 17, 10)
    m.scatter(["cement_crack", "cement_crack2"], [(7, 2), (25, 14), (36, 2)])
    for i, (x, y) in enumerate(((14, 8), (16, 11), (19, 5), (22, 12), (25, 7))):
        m.npc("crowd%d" % i, x, y, "down", sprite="eyeless", meta={"min_connection": 50})
    m.glyph("pa_window", 12, 1); m.glyph("pa_end", 39, 14, deep=True)
    m.trigger("crowd", 12, 3, 16, 10, on_enter=True)
    m.trigger("camera2", 30, 14)
    m.trigger("bench", 20, 13)
    m.exit("exit:west", 0, 3, 1, 10)
    m.exit("exit:east", 39, 3, 1, 10)
    m.player = (2, 8)
    return m


def restricted_road():
    m = Map("RestrictedRoad", "RestrictedRoadScene.gd", 40, 16, ["asphalt"], seed=73)
    m.fill(0, 0, 39, 4, SAND); m.fill(0, 11, 39, 15, SAND)
    m.fill(0, 5, 39, 5, "cement_edge"); m.fill(0, 10, 39, 10, "cement_edge")
    for x in (3, 4, 20, 21, 36, 37):
        m.ground[5][x] = m._pick(SAND); m.ground[10][x] = m._pick(SAND)
    # sand creeps over the road the further east it goes
    m.scatter(SAND, [(x, y) for x in range(14, 40) for y in range(6, 10) if (x * 7 + y * 3) % max(2, 40 - x) == 0])
    m.fill(30, 6, 39, 9, SAND)
    m.scatter(["dirt_red", "dirt"], [((i * 13) % 40, (i * 5) % 5) for i in range(20)] + [((i * 11) % 40, 11 + (i * 3) % 5) for i in range(20)])
    # the checkpoint at x 16-19: a booth and a barrier
    m.prop("fence_h", 13, 5, solid=1); m.prop("fence_h", 20, 5, solid=1); m.prop("fence_h", 13, 11); m.prop("fence_h", 20, 11)
    m.prop("counter", 17, 3, id="booth"); m.prop("lamp_post", 16, 4); m.prop("lamp_post_off", 19, 12)
    m.decal("poster_blank", 14, 4)
    m.prop("sedan", 33, 12, id="wreck"); m.decal("stick_circle", 33, 11); m.decal("rock_tiny", 36, 13)
    m.prop("cactus", 6, 2); m.prop("rock_big", 26, 1); m.prop("rock_med", 9, 13); m.prop("tree_dead", 24, 13); m.prop("bush_dark", 2, 12)
    m.decal("grass_tuft", 11, 3); m.decal("reeds", 38, 2); m.decal("rock_tiny", 29, 3); m.decal("blood", 22, 8)
    m.npc("guard", 17, 4, "down", sprite="officer")
    m.glyph("rr_booth", 14, 4); m.glyph("rr_wreck", 33, 12, deep=True)
    m.trigger("sign", 14, 4)
    m.trigger("gate", 17, 6, 2, 4, on_enter=True, once=False)
    m.trigger("deep_sand", 30, 6, 2, 4, on_enter=True)
    m.trigger("wreck", 33, 12, 2)
    m.exit("exit:west", 0, 6, 1, 4)
    m.exit("exit:east", 39, 6, 1, 4)
    m.player = (2, 8)
    return m


def factory():
    m = Map("Factory", "FactoryScene.gd", 30, 17, TILE_DARK, seed=79)
    m.fill(1, 2, 9, 15, ["cement_dark"])          # the locked floor, west
    m.fill(19, 2, 28, 15, WOOD_GREY)              # the office, east
    m.void_border()
    m.top_wall("navy", 1, 28, windows=[(23, "dark"), (24, "dark")])
    m.partition("navy", 10, 0, 15, gaps=(8,)); m.partition("navy", 18, 0, 15, gaps=(5,))
    m.ground[16][12] = "shadow_floor"; m.clear_wall(12, 16)
    # the card-reader door: a cabinet stands in the gap until the card opens it
    m.prop("cabinet", 10, 8, id="locked_door", solid=1, meta={"gate": 1})  # opens with the keycard
    # main floor
    m.prop("copy_machine", 12, 3); m.prop("copy_machine", 15, 3); m.prop("vending_dark", 12, 7)
    m.prop("crate", 16, 9); m.prop("crate", 17, 10); m.prop("crate_small", 15, 12); m.prop("barrel", 12, 13); m.prop("barrel", 13, 13)
    m.decal("paper", 14, 6); m.decal("paper3", 16, 14); m.decal("drain", 13, 10); m.decal("glyph", 16, 1)
    m.npc("worker", 14, 9, "left", sprite="seth")
    # office
    m.prop("desk_grey", 22, 4); m.prop("laptop_dark", 23, 4, lift=10, id="office_laptop_prop"); m.prop("chair_office", 22, 5)
    m.prop("bookcase", 26, 3); m.prop("cabinet", 20, 3); m.prop("water_cooler", 27, 7); m.prop("bin", 20, 13)
    m.decal("poster", 21, 1); m.decal("rug_blue", 21, 9); m.decal("paper2", 25, 11); m.decal("paper", 24, 13)
    # the locked floor: the eye is drawn by the scene; frames laid around it
    for x, y in ((2, 6), (8, 6), (2, 12), (8, 12)):
        m.decal("stick", x, y)
    m.decal("stick_circle", 5, 5); m.decal("stick_circle", 5, 13); m.decal("frames_broken", 3, 9); m.decal("frames_broken", 7, 9)
    m.decal("blood", 5, 11); m.decal("cobweb", 1, 2); m.decal("glyph_red", 4, 1)
    m.glyph("fa_office", 27, 1); m.glyph("fa_floor", 4, 1, deep=True)
    m.trigger("machines", 12, 3, 5)
    m.trigger("keycard", 22, 4)
    m.trigger("office_laptop", 23, 4)
    m.trigger("ledger", 26, 3)
    m.trigger("locked_door", 11, 8)
    m.trigger("floor_eye", 3, 7, 5, 5, on_enter=True)
    m.trigger("exit", 12, 16, on_enter=True, once=False)
    m.player = (12, 14)
    return m


MAPS = [apartment, park, home, warroom, hospital, southtown, lynx_apartment, desert, mirror,
        lamplight, spine, zetapark, canalwalk, underpass, heights, flyover, hillroad, cognizo, cognizo_station, railcut, parkave, restricted_road, factory]


def main():
    maps_dir = os.path.join(ROOT, "scenes", "maps")
    os.makedirs(maps_dir, exist_ok=True)
    tileset_tres(os.path.join(ROOT, "assets", "tiles", "tileset.tres"))
    preview = "--preview" in sys.argv
    if preview:
        os.makedirs(PREVIEW_DIR, exist_ok=True)
    for build in MAPS:
        m = build()
        density.densify(m)
        m.check()
        m.write(os.path.join(maps_dir, m.name + ".tscn"))
        if preview:
            m.preview(os.path.join(PREVIEW_DIR, m.name + ".png"))
    print("maps generated")


if __name__ == "__main__":
    main()
