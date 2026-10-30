extends RefCounted
## Carl's Tower, Memory (bible-3 "The open city": "Carl's Tower ... Each is a
## buff on the street; each is a room in Act 3's climb"; Terminal.gd: "What
## you gave stays hung up here, where you can visit it."). Once the room is
## built, 86D's free visit has it where the bedroom door was, at the end of
## the hall: a room higher than the flat, frames on every wall. The four
## memories the fork takes for words (drawing, photo, lion, trophy) hang in
## theirs once traded; the frames of the ones not given yet wait, empty, the
## hooks still there. The NICU glass and the leaves are hung whatever he does.
## On the lectern, the ledger lines the trades blacked out, written in full
## (Terminal.trade keeps them as "was"). Mira's council floats under the
## ceiling, as it does over the room in the climb (Chair.gd _room "memory").
##
## Built from Home._hall (free visit, main.tower_rooms has "memory"); its
## interactions come through City.home_interact -> Standing.memory_interact.
## Every line is (game); ian rewrites them.

const X0 := 13.0        # the hall's end wall, where the bedroom door was
const X1 := 18.0
const Z0 := -9.0
const Z1 := -4.0
const RH := 3.4         # higher than the flat's ceiling
const ITEMS := ["drawing", "photo", "lion", "trophy"]

const LINES := {
	"prompt_door": "The door at the end of the hall",
	"prompt": "Look at the frame",
	"prompt_lectern": "Read the book on the lectern",
	"prompt_council": "Look up",
	"scan": "CARL'S TOWER  -  MEMORY\nfloor: %d\nframes: 6  -  hung: %d",
	"plaques": {"drawing": "MIRA'S DRAWING", "photo": "RED ROCK, THE SUMMER", "lion": "THE LION", "trophy": "RECESS CHAMPION",
		"nicu": "NICU, WEEK ONE", "leaves": "THE LEAVES"},
	"door": ["Our bedroom door. Behind it there should have been the bed Monica made every morning, her side and mine.",   # (game)
		"It opened onto a room I had built with devotion instead. The ceiling was higher than the flat's. Frames on every wall."],   # (game)
	"filled": {
		"drawing": "Mira's drawing, the one from the fridge, under glass. The Tower, her council round the brown table, her in the middle with her curls. Gone from the fridge. Here. It would always be here.",   # (game)
		"photo": "Red Rock Plaza, the summer the kids were small. Four of us against the orange rock. I couldn't remember the day any more. Only that I'd had it.",   # (game)
		"lion": "The toy lion from Red Rock Plaza on a little shelf in its frame, the mane flattened where she used to hold it under her chin.",   # (game)
		"trophy": "Ezra's recess trophy, the gold rubbed off the cup where his thumb went.",   # (game)
	},
	"empty": "An empty frame and a brass hook. The plaque already said %s. It was still out there in the flat. The frame could wait. It was good at waiting.",   # (game)
	"nicu": "A pane of the NICU glass, the handprints still on it. Mira on the other side, so small, the wires on her. I hadn't traded that. Nobody had asked. It was hung up anyway.",   # (game)
	"leaves": "Leaves, red and gold, pressed flat under glass. The woods near my parents' house in autumn. Somebody laughing just outside the frame.",   # (game)
	"lectern": "A lectern, a book open on it. My handwriting. The ledger, the lines the fork had blacked out, written out again in full:",   # (game)
	"lectern_none": "A lectern, a book open on it, ruled and empty. Waiting for what I'd give.",   # (game)
	"council": "Five of them, floating under the high ceiling the way they floated over Mira's table: the knight, the bear, the girl with pigtails, two I didn't know. Waiting for a question.",   # (game)
	"book_none": "(ruled, empty)",
	"was_log": "Visited the Memory room. %d of 4 hung.",
	# 86D, the first look at each: the ledger lines a trade blacks out
	# (Terminal.LINES memory_keys finds them by these words)
	"noted": {
		"drawing": "Mira's drawing on the fridge: her Tower, her council round the table, her in the middle.",   # (game)
		"photo": "The Red Rock photo on the side table. The only one we ever printed.",   # (game)
		"lion": "The toy lion from Red Rock Plaza, on Mira's bed.",   # (game)
		"trophy": "Ezra's recess trophy on his shelf. Conflict Leadership, grade 5.",   # (game)
	},
}


## The end wall with a doorway, and the room behind it.
static func build(h: Node) -> void:
	var main: Node = h.main
	var traded: Array = main.traded
	var H: float = h.H
	# the end wall of the hall, a doorway where the bedroom door was
	h._wb(Vector3(0.14, H, 0.35), Vector3(X0, H / 2.0, -7.125))
	h._wb(Vector3(0.14, H, 0.35), Vector3(X0, H / 2.0, -5.875))
	h._wb(Vector3(0.14, H - 2.1, 0.9), Vector3(X0, 2.1 + (H - 2.1) / 2.0, -6.5))
	var trim: Material = h._trim
	for z: float in [-6.98, -6.02]:
		h.box(Vector3(0.2, 2.1, 0.06), Vector3(X0, 1.05, z), trim)
	h.box(Vector3(0.2, 0.08, 1.0), Vector3(X0, 2.12, -6.5), trim)
	h.interactable("mem_door", LINES["prompt_door"], Vector3(X0 - 0.2, 1.1, -6.5), Vector3(0.2, 2.0, 0.9), "", false)
	# the room: darker plaster, dark boards, a high ceiling
	var wall: Material = h.pbr("plaster", Vector3(1, 1, 1) / 2.2, true, Color(0.42, 0.38, 0.42))
	var cx := (X0 + X1) / 2.0
	var cz := (Z0 + Z1) / 2.0
	h.box(Vector3(X1 - X0 + 0.14, RH, 0.14), Vector3(cx, RH / 2.0, Z0), wall, true)
	h.box(Vector3(X1 - X0 + 0.14, RH, 0.14), Vector3(cx, RH / 2.0, Z1), wall, true)
	h.box(Vector3(0.14, RH, Z1 - Z0), Vector3(X1, RH / 2.0, cz), wall, true)
	h.box(Vector3(0.14, RH, -7.3 - Z0), Vector3(X0, RH / 2.0, (Z0 - 7.3) / 2.0), wall, true)
	h.box(Vector3(0.14, RH, Z1 + 5.7), Vector3(X0, RH / 2.0, (Z1 - 5.7) / 2.0), wall, true)
	h.box(Vector3(0.14, RH - H, 1.6), Vector3(X0 + 0.01, H + (RH - H) / 2.0, -6.5), wall)
	h.floor_quad(Vector2(X1 - X0, Z1 - Z0), Vector3(cx, 0.003, cz), 0.0, h.pbr("woodfloor", Vector3(1, 1, 1) / 2.0, true, Color(0.45, 0.36, 0.3)))
	h.box(Vector3(X1 - X0 + 0.2, 0.2, Z1 - Z0 + 0.2), Vector3(cx, RH + 0.1, cz), h.mat(Color(0.2, 0.19, 0.2), 0.95))
	# the eye on the ceiling, small, where the light fitting should be
	var eye := Sprite3D.new()
	eye.texture = h._glyph_tex
	eye.pixel_size = 0.006
	eye.modulate = Color(0.75, 0.08, 0.06, 0.8)
	eye.rotation.x = PI / 2.0
	eye.position = Vector3(cx, RH - 0.01, cz)
	h.add_child(eye)
	# the frames: two on each wall
	var hung := 0
	var spots := {
		"drawing": [Vector3(14.4, 1.75, Z0 + 0.08), 0.0], "photo": [Vector3(16.6, 1.75, Z0 + 0.08), 0.0],
		"lion": [Vector3(14.4, 1.75, Z1 - 0.08), PI], "trophy": [Vector3(16.6, 1.75, Z1 - 0.08), PI],
		"nicu": [Vector3(X1 - 0.08, 1.75, -7.6), -PI / 2.0], "leaves": [Vector3(X1 - 0.08, 1.75, -5.4), -PI / 2.0],
	}
	for k: String in spots:
		var pos: Vector3 = spots[k][0]
		var rot: float = spots[k][1]
		var filled: bool = traded.has(k) or k in ["nicu", "leaves"]
		if filled and k in ITEMS:
			hung += 1
		var fr := Node3D.new()
		fr.position = pos
		fr.rotation.y = rot
		h.add_child(fr)
		_frame(h, fr, k, filled)
		var normal := Vector3(sin(rot), 0, cos(rot))
		var it: CollisionObject3D = h.interactable("mem_" + k, LINES["prompt"], pos + normal * 0.18, Vector3(1.1, 1.3, 0.3), "", false)
		it.rotation.y = rot
		it.set_meta("filled", filled)
		h.label(str(LINES["plaques"][k]), pos + normal * 0.03 + Vector3(0, -0.82, 0), rot, 0.0016, Color(0.85, 0.72, 0.4), h, false)
	# the lectern in the middle, the book open on it
	var wood: Material = h.pbr("woodfloor", Vector3.ONE, true, Color(0.4, 0.28, 0.2))
	var lp := Vector3(cx, 0.0, cz)
	h.cyl(0.08, 0.14, 1.0, lp + Vector3(0, 0.5, 0), wood, 8)
	h.box(Vector3(0.6, 0.05, 0.45), lp + Vector3(0, 1.08, 0), wood).rotation.x = 0.35
	h.solid_box(Vector3(0.6, 1.1, 0.5), lp + Vector3(0, 0.55, 0))
	var paper: Material = h.mat(Color(0.9, 0.87, 0.78), 0.9)
	for s: float in [-0.13, 0.13]:
		h.box(Vector3(0.25, 0.01, 0.34), lp + Vector3(s, 1.115, 0.0), paper).rotation.x = 0.35
	var page: Label3D = h.label(_book_text(main), lp + Vector3(0, 1.125, 0.02), 0.0, 0.0006, Color(0.12, 0.1, 0.1), h, false)
	page.rotation.x = -PI / 2.0 + 0.35
	page.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	page.width = 760.0
	page.font_size = 64
	h.interactable("mem_lectern", LINES["prompt_lectern"], lp + Vector3(0, 1.0, 0), Vector3(0.8, 0.6, 0.7),
		LINES["scan"] % [main.tower_rooms.find("memory") + 1, hung], false)
	# Mira's council floating under the ceiling, turned to the lectern
	var coats := [Color(0.5, 0.55, 0.65), Color(0.45, 0.3, 0.15), Color(0.95, 0.8, 0.2), Color(0.3, 0.5, 0.35), Color(0.6, 0.35, 0.55)]
	for i in 5:
		var a := TAU * i / 5.0 + 0.3
		var f: Node3D = h.figure(coats[i], Color(0.86, 0.76, 0.66), {"scale": 0.55, "arms": true, "knees": true})
		f.position = lp + Vector3(cos(a) * 1.4, 2.35 + 0.1 * sin(i * 1.7), sin(a) * 1.4)
		h.add_child(f)
		h.turn_to(f, lp + Vector3(0, 2.35, 0))
		f.rotation.x = 0.15
	h.interactable("mem_council", LINES["prompt_council"], lp + Vector3(0, 2.85, 0), Vector3(2.4, 0.5, 2.4), "", false)
	h.light(Vector3(cx, RH - 0.5, cz), Color(1.0, 0.82, 0.62), 0.9, 6.0, false)
	h.light(Vector3(X1 - 0.7, 1.9, -7.6), Color(0.6, 0.85, 1.0), 0.5, 3.5, false)


## One frame, local to `fr` (its face looks along +Z): the border, the backing,
## and what hangs in it, or the hook.
static func _frame(h: Node, fr: Node3D, k: String, filled: bool) -> void:
	var gilt: Material = h.mat(Color(0.55, 0.42, 0.2), 0.4, 0.7)
	var w := 1.0
	var ht := 1.2
	for y: float in [-ht / 2.0, ht / 2.0]:
		h.box(Vector3(w + 0.14, 0.07, 0.06), Vector3(0, y, 0.03), gilt, false, fr)
	for x: float in [-w / 2.0, w / 2.0]:
		h.box(Vector3(0.07, ht, 0.06), Vector3(x, 0, 0.03), gilt, false, fr)
	h.quad(Vector2(w, ht), Vector3(0, 0, 0.005), 0.0, h.mat(Color(0.08, 0.07, 0.08), 0.95), fr)
	if not filled:
		# the hook still there; a paler shape where something will hang
		h.quad(Vector2(0.6, 0.75), Vector3(0, -0.05, 0.008), 0.0, h.mat(Color(0.16, 0.15, 0.16), 0.95), fr)
		h.box(Vector3(0.05, 0.03, 0.06), Vector3(0, 0.42, 0.03), gilt, false, fr)
		h.cyl(0.012, 0.012, 0.06, Vector3(0, 0.38, 0.06), gilt, 6, fr)
		return
	match k:
		"drawing":
			var q: MeshInstance3D = h.quad(Vector2(0.62, 0.82), Vector3(0, 0, 0.012), 0.0, h.tex_mat(h._sketch_page(0), Vector3.ONE, 0.9), fr)
			(q.material_override as StandardMaterial3D).cull_mode = BaseMaterial3D.CULL_DISABLED
		"photo":
			h.quad(Vector2(0.84, 0.63), Vector3(0, 0, 0.012), 0.0, h.tex_mat(h._photo_tex(), Vector3.ONE, 0.7), fr)
		"lion":
			h.box(Vector3(0.5, 0.03, 0.16), Vector3(0, -0.28, 0.08), gilt, false, fr)
			var lion: Material = h.mat(Color(0.85, 0.62, 0.25), 0.9)
			var mane: Material = h.mat(Color(0.5, 0.3, 0.12), 0.9)
			var lp := Vector3(0, -0.12, 0.09)
			h.sphere(0.13, lp, lion, 10, fr).scale = Vector3(1.3, 0.8, 1.0)
			h.sphere(0.13, lp + Vector3(0.15, 0.1, 0.0), mane, 10, fr).scale = Vector3(0.5, 1.0, 1.0)
			h.sphere(0.09, lp + Vector3(0.18, 0.1, 0.02), lion, 10, fr)
		"trophy":
			h.box(Vector3(0.5, 0.03, 0.16), Vector3(0, -0.3, 0.08), gilt, false, fr)
			var gold: Material = h.mat(Color(0.85, 0.7, 0.3), 0.35, 0.8)
			h.box(Vector3(0.18, 0.05, 0.14), Vector3(0, -0.26, 0.08), h.mat(Color(0.1, 0.1, 0.1), 0.5), false, fr)
			h.cyl(0.02, 0.02, 0.14, Vector3(0, -0.16, 0.08), gold, 8, fr)
			h.cyl(0.09, 0.04, 0.16, Vector3(0, -0.01, 0.08), gold, 10, fr)
		"nicu":
			var gl: StandardMaterial3D = h.newmat(Color(0.75, 0.9, 0.95, 0.35), 0.05, 0.2)
			gl.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			h.quad(Vector2(0.86, 1.06), Vector3(0, 0, 0.02), 0.0, gl, fr)
			for i in 3:
				h.quad(Vector2(0.09, 0.11), Vector3(-0.2 + i * 0.17, 0.1 - i * 0.07, 0.025), 0.0, h.mat(Color(0.6, 0.65, 0.68), 0.6), fr)
			h.quad(Vector2(0.3, 0.2), Vector3(0.05, -0.25, 0.012), 0.0, h.glow(Color(0.5, 0.75, 0.9), 0.5), fr)
		"leaves":
			var cols := [Color(0.85, 0.45, 0.12), Color(0.75, 0.2, 0.1), Color(0.9, 0.7, 0.2)]
			for i in 9:
				var lf: MeshInstance3D = h.quad(Vector2(0.14, 0.09), Vector3(-0.3 + (i % 3) * 0.3, -0.35 + int(i / 3) * 0.33, 0.012 + i * 0.0005), 0.0, h.mat(cols[i % 3], 0.9), fr)
				lf.rotation.z = i * 0.7


static func _book_text(main: Node) -> String:
	var rows := []
	for e in main.ledger:
		if e.has("was"):
			rows.append("- " + str(e["was"]))
	if rows.is_empty():
		return LINES["book_none"]
	return "\n".join(rows.slice(maxi(0, rows.size() - 6)))


## 86D, any visit: the first look at a memory goes in the ledger, so a
## trade has something to black out (and the lectern something to restore).
static func note(main: Node, k: String) -> void:
	if main.traded.has(k) or main.flags.has("noted_" + k):
		return
	main.flags["noted_" + k] = true
	main.log_line("memory", LINES["noted"][k])


## E on the room's frames, lectern, council, door.
static func interact(main: Node, id: String) -> bool:
	var ui = main.ui
	var k := id.substr(4)
	match k:
		"door":
			for l: String in LINES["door"]:
				await ui.think(l)
			if not main.flags.has("memory_room_seen"):
				main.flags["memory_room_seen"] = true
				var hung := 0
				for m: String in ITEMS:
					if main.traded.has(m):
						hung += 1
				main.log_line("tower", LINES["was_log"] % hung)
		"drawing", "photo", "lion", "trophy":
			if main.traded.has(k):
				await ui.think(LINES["filled"][k])
			else:
				await ui.think(LINES["empty"] % LINES["plaques"][k])
		"nicu", "leaves":
			await ui.think(LINES[k])
		"lectern":
			var rows := []
			for e in main.ledger:
				if e.has("was"):
					rows.append(str(e["was"]))
			if rows.is_empty():
				await ui.think(LINES["lectern_none"])
			else:
				await ui.think(LINES["lectern"])
				for r: String in rows.slice(maxi(0, rows.size() - 4)):
					await ui.say("", "[color=#c8a0ff]%s[/color]" % r)
		"council":
			await ui.think(LINES["council"])
		_:
			return false
	return true
