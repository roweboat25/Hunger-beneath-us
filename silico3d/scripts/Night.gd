extends Node3D
## The night layer of the open city (bible-3 "The open city (Days 4-6)":
## "Night. From 20:00 streets at Faith >= 2 hold eyeless; the follower roams
## one district per night (announced by a feed line: 'a figure on Hill
## Road'); the alley double in Red Rock at >= 50"; bible-1 "Danger tiers":
## tier 2 is any street after 20:00 or at Faith 2, "the eyeless at night
## from Faith 2; the follower"; "The city": Hill Road is the follower's
## first street, Park Avenue holds the crowd of 30 from Connection 50 (it
## sings at Faith 2 and has Carl's face at Faith 3), Fargona Avenue the
## preacher's vigil at night, Red Rock "the alley double").
##
## Street.gd adds one of these to every district street it builds. It
## spawns, from Faith, the clock, Connection and the flags:
##
## - the eyeless (night, Faith 2+): statues with the frames off; with them on
##   they orient to the frames' signal in 45-degree steps, faster the closer
##   Carl is, and close at walking speed. A touch is +5 Connection and Carl
##   is put back at the end of the street. Never a game over. They cannot be
##   hacked (meta "eyeless": Hack.gd refuses them) and Melee never works on
##   them (no "addict" meta).
## - the follower (from Day 4, one district a night: FOLLOWER_NIGHTS): black
##   coat to the ground, a flat pale oval for a face, no legs; it does not
##   walk, it glides in steps; it is never seen except at confrontation range
##   (bible-5). Halfway up its street it is simply there, and the
##   confrontation starts (Confront.gd). Held, it stays where the word left it.
## - the Park Avenue crowd (Connection 50+): thirty in the road looking up at
##   the tower; they turn as one when Carl comes near. Faith 2: they sing.
##   Faith 3: every face is Carl's.
## - the Fargona preacher (night, from Day 4): the digital vigil across the
##   road, smart glasses lit, staring at the sky where the frames draw the
##   fractal; the preacher with his tablet held like a bible.
## - the Red Rock alley double (night, Connection 50+): a man with Carl's face
##   in an alley mouth, only there with the frames on.
## - from Connection 75: one person in twenty has Carl's face for one frame.
##
## Also the 50 and 75 HUD effects Main asks for (objective_text, scan_text),
## the nightfall feed line (City.advance), and the --night=1 test.
##
## Lines are in LINES; (game) marks lines written for the game.

const ConfrontS := preload("res://scripts/Confront.gd")

const LINES := {
	"feed": {
		"follower": "a figure on %s",
		"eyeless": "(game) ORA advisory: %s - stay on lit streets after 20:00. Do not remove your frames.",
	},
	"gather": "gather, sleeper",
	"corrupt": "CARL DRAKE\nPSYONIC INTEGRATIONS - INVESTIGATIONS\nstatus: ON THE PATH",
	"prompts": {"eyeless": "Look at it", "follower": "Look at it", "crowd": "Look at them", "preacher": "The preacher",
		"vigil": "Look at them", "double": "The man in the alley", "alley": "The alley"},
	"scan": {
		"eyeless": "NO RECORD\neyes: NONE\nsync 100%",
		"follower": "NO SIGNAL",
		"crowd": "CITIZEN\nPsyon: sync 100%%\nfacing: THE TOWER\nin chorus: %d",
		"preacher": "UNREGISTERED\nframes: ORA (UNISSUED)\nstatus: PREACHING",
		"vigil": "CITIZEN\nframes: LIT\nlooking: UP",
		"double": "DRAKE, CARL (38)\nPSYONIC INTEGRATIONS - INVESTIGATIONS\nMATCH: 100%",
	},
	"examine": {
		"eyeless": "No eyes. The sockets had healed over the way skin heals over a burn. The head turned to follow me and the neck made no sound.",
		"eyeless_dark": "(game) A shape on the pavement that didn't move. With the frames off it could have been a coat on a hook. I didn't look long.",
		"follower_held": "(game) It stood where the word had left it, the coat touching the ground and no feet under it. The mask was turned to where I'd been standing, not to where I was.",
		"crowd": "(game) They stood in the road with their faces up to the tower, every one of them, not swaying, not talking. The frames gave me thirty sync bars at a hundred percent.",
		"crowd_faces": "(game) Every one of them had my face. My jaw, my scar, my uneven left brow, thirty times, turned up to the tower.",
		"preacher": "(game) He held the tablet up like a bible and read from it without looking down. The scripture scrolled on the screen faster than he read it.",
		"vigil": "They each wore a pair of smart glasses and were staring at the sky.",
		"double": "(game) He was still there, in the mouth of the alley, my face, waiting for me to make the first move so he could make it too.",
		"alley": "(game) An alley, a dead end, a smell of hot bins. Someone had been sleeping in it. The frames flagged nothing.",
	},
	"touch": {
		"eyeless": "(game) Its hand found my face in the dark of the frames, flat and patient, and covered my eyes. When it let go I was at the end of the street, and my eyes were still mine.",
		"why": "touched by the eyeless",
	},
	"back": "(game) I was a street back. I didn't remember walking it. My face was warm where it had been touched.",
	"log_eyeless": "The eyeless on %s at night. One of them touched me. They only move when the frames are on.",
}

## The follower's nights: Hill Road first (bible-1 "the follower's first
## street"); then Lamplight, where Dufredy was led away from his building
## (ch.4, the footage); then Harmony Green, where Tyson saw it lead "Eyeless
## Joe" out from behind the wall (ch.2). Later nights roam ROAM.
const FOLLOWER_NIGHTS := {4: "hill_road", 5: "lamplight", 6: "harmony_green"}
const ROAM := ["hill_road", "lamplight", "canal_walk", "heights", "zeta_park", "park_ave", "harmony_green", "rail_cut", "southtown", "fargona"]
const BLACK := Color(0.015, 0.015, 0.02)
## Street.gd's road: north along -Z from S to N.
const STREET_N := -110.0
const STREET_S := 70.0

static var _faces := {}

var main: Node
var lv  # the Street level (untyped: its own members)
var did := ""
var eyeless: Array = []      # [{fig, it, home, yaw, hold}]
var follower: Node3D
var crowd: Array = []        # Node3D figures
var crowd_turned := false
var preacher: Node3D
var vigil: Array = []
var fractal: MeshInstance3D
var double: Node3D
var alley_at := Vector3(-12.2, 0.12, -23.0)
var face_flashes := 0
## Scripted picks for the next confrontation (the --night test).
var script_picks: Array = []
var last_result := ""
var busy := false
var _touch_cd := 0.0
var _t := 0.0
var _face_t := 0.0
var _flashed: Array = []     # [[mesh, material]]
var _yaw_hist: Array = []
var _mask_sheen: MeshInstance3D
var _show_once := false


# ------------------------------------------------------------------ static: the city's night, the HUD at 50 and 75

## Where the follower walks on night `day` ("" before Day 4).
static func follower_district(day: int) -> String:
	if day < 4:
		return ""
	if FOLLOWER_NIGHTS.has(day):
		return str(FOLLOWER_NIGHTS[day])
	return str(ROAM[(day * 7 + 3) % ROAM.size()])


## 20:00: the feed names where the figure is tonight, and warns the streets
## that hold the eyeless. Once a night (City.advance and set_time call it).
static func nightfall(m: Node) -> void:
	if not m.city.is_night() or int(m.day) < 4:
		return
	var key := "nightfall_d%d" % int(m.day)
	if m.flags.has(key):
		return
	m.flags[key] = true
	var fd := follower_district(int(m.day))
	if fd != "":
		m.city.feed(LINES["feed"]["follower"] % m.city.district_name(fd))
	for id: String in m.city.DISTRICT_IDS:
		if id != "restricted_road" and int(m.faith.get(id, 0)) >= 2:
			m.city.feed(LINES["feed"]["eyeless"] % m.city.district_name(id))
			break


## The objective line: past 50 it sometimes reads "gather, sleeper" (bible-1 HUD: 10% of the time).
static func objective_text(m: Node, text: String) -> String:
	if m.connection >= 50.0 and text != "" and randf() < 0.1:
		return LINES["gather"]
	return text


## An ORA card: past 50, 30% of people's cards are Carl's (bible-1 "ORA card").
static func scan_text(m: Node, text: String, person := true) -> String:
	if person and m.connection >= 50.0 and randf() < 0.3:
		return LINES["corrupt"]
	return text


## The confrontation screen, made once and kept on the UI layer (under the
## dialogue box, so the lines and the verbs draw over the letterbox).
static func confront_ui(m: Node) -> Control:
	var c: Control = m.ui.root.get_node_or_null("Confront")
	if c == null:
		c = ConfrontS.new()
		m.ui.root.add_child(c)
		c.setup(m)
		m.ui.root.move_child(c, m.ui.dlg.get_index())
	return c


## Run a confrontation anywhere (a level's scripted one, e.g. Dufredy at Lushon's).
static func confront(m: Node, kind: String, fig: Node3D = null, picks: Array = []) -> String:
	return await confront_ui(m).run(m, kind, fig, picks)


## Run and touched: Carl ends up one street back (+1 hour, the street he
## came from, or the next one over). Outside the open city, the level's spawn.
static func street_back(m: Node) -> void:
	var c: Node = m.city
	if m.level_name != "Street":
		m.player.global_position = m.level.spawn
		m.player.velocity = Vector3.ZERO
		return
	var here := str(c.district)
	var back := str(c.get("came_from")) if c.get("came_from") != null else ""
	if back == "" or back == here or back == "home" or not c.DISTRICT_IDS.has(back) or back == "restricted_road":
		back = ""
		for r: Array in c.ROADS:
			var o := ""
			if r[0] == here:
				o = r[1]
			elif r[1] == here:
				o = r[0]
			if o != "" and o != "home" and o != "restricted_road":
				back = o
				break
	if back == "":
		back = "spine"
	c.advance(1)
	m.flags["street_back_line"] = true
	c.came_from = here
	c.go(back)


# ------------------------------------------------------------------ faces

static func _face_img(base: StandardMaterial3D) -> Image:
	var img: Image = (base.albedo_texture as Texture2D).get_image()
	if img.is_compressed():
		img.decompress()
	img.clear_mipmaps()
	img.convert(Image.FORMAT_RGBA8)
	return img


static func _face_from(base: StandardMaterial3D, img: Image) -> StandardMaterial3D:
	img.generate_mipmaps()
	var mt := base.duplicate() as StandardMaterial3D
	mt.albedo_texture = ImageTexture.create_from_image(img)
	return mt


## Carl's face: "my jaw. My scar. My uneven left brow." (as Hangar.gd and RedRock.gd draw it)
static func carl_face() -> StandardMaterial3D:
	if not _faces.has("carl"):
		var base: StandardMaterial3D = Body.face_mat(Color(0.84, 0.66, 0.54), Color(0.12, 0.09, 0.07), false, 1)
		var img := _face_img(base)
		for j in 14:
			Body._rect(img, 108 + j * 0.6, 112 + j, 1.5, 1, Color(0.72, 0.5, 0.42))
		Body._rect(img, 104, 82, 14, 2, Color(0.1, 0.07, 0.05))
		_faces["carl"] = _face_from(base, img)
	return _faces["carl"]


## The double: Carl's face with the eyes wide and full of glee (ch.19).
static func double_face() -> StandardMaterial3D:
	if not _faces.has("double"):
		var img := _face_img(carl_face())
		for sd: float in [-1.0, 1.0]:
			Body._ell(img, 128 + sd * 16.2, 95.9, 7.5, 5.5, Color(0.98, 0.97, 0.93))
			Body._ell(img, 128 + sd * 16.2, 95.9, 1.6, 1.6, Color(0.05, 0.04, 0.04))
		Body._rect(img, 110, 154, 36, 3, Color(0.35, 0.05, 0.05))
		Body._rect(img, 113, 151, 30, 3, Color(0.95, 0.93, 0.88))
		_faces["double"] = _face_from(carl_face(), img)
	return _faces["double"]


## Healed-over sockets.
static func eyeless_face(skin: Color, hair: Color, seed: int) -> StandardMaterial3D:
	var key := "eyeless%d" % seed
	if not _faces.has(key):
		var base: StandardMaterial3D = Body.face_mat(skin, hair, false, seed)
		var img := _face_img(base)
		for sd: float in [-1.0, 1.0]:
			var ex := 128.0 + sd * 16.2
			Body._ell(img, ex, 95.9, 9.0, 6.5, skin.darkened(0.2), 0.5)
			Body._ell(img, ex, 95.9, 6.5, 2.0, skin.darkened(0.45))
			for k in 7:
				var a := TAU * k / 7.0
				Body._rect(img, ex + cos(a) * 6.0, 95.9 + sin(a) * 4.0, 2, 1, Color(skin.darkened(0.4), 0.8))
		_faces[key] = _face_from(base, img)
	return _faces[key]


static func head_mesh(fig: Node3D) -> MeshInstance3D:
	var hd = fig.get_meta("head") if fig.has_meta("head") else null
	if hd is Node3D:
		for c in (hd as Node3D).get_children():
			if c is MeshInstance3D:
				return c
	return null


# ------------------------------------------------------------------ building the night into a street

func setup(l) -> void:
	lv = l
	main = l.main
	name = "Night"
	did = str(lv.did)
	nightfall(main)
	var night: bool = lv.night
	var f := int(lv.faith)
	var day := int(main.day)
	var fl: Dictionary = main.flags
	if night and f >= 2:
		_eyeless(4 if f == 2 else 6)
	if night and did == follower_district(day) and not fl.has("follower_d%d" % day):
		_follower()
	if did == "park_ave" and main.connection >= 50.0:
		_crowd(f)
	if did == "fargona" and night and day >= 4:
		_preacher()
	if did == "red_rock" and night:
		_alley()
		if main.connection >= 50.0 and not fl.has("double_d%d" % day):
			_double()
	if fl.has("street_back_line"):
		fl.erase("street_back_line")
		_say_back.call_deferred()


func _say_back() -> void:
	while main.loading:
		await get_tree().process_frame
	main.ui.show_toast(LINES["back"], 4.0)


func _collider(id: String, fig: Node3D, kind: String, scan := "") -> CollisionObject3D:
	var b: CollisionObject3D = lv.person(id, LINES["prompts"][kind], fig, scan)
	b.set_meta("encounter", "night")
	b.set_meta("night_kind", kind)
	b.set_meta("night_node", self)
	return b


## The eyeless: on the pavements and one in the road, facing the tower.
func _eyeless(n: int) -> void:
	var spots := [Vector3(-10.4, 0.12, 24.0), Vector3(10.0, 0.12, 6.0), Vector3(-11.0, 0.12, -10.0),
		Vector3(9.6, 0.12, -38.0), Vector3(-3.2, 0.0, -27.0), Vector3(-10.2, 0.12, -54.0)]
	var skins := [Color(0.8, 0.62, 0.5), Color(0.62, 0.46, 0.34), Color(0.9, 0.76, 0.66), Color(0.5, 0.36, 0.26)]
	var tp: Vector3 = lv.cfg["tower"]
	for i in mini(n, spots.size()):
		var sk: Color = skins[i % skins.size()]
		var hair := Color(0.2, 0.18, 0.16) if i % 2 == 0 else sk.darkened(0.3)
		var coat := Color(0.3, 0.29, 0.27).darkened(0.25 * (i % 3))
		var fg: Node3D = lv.figure(coat, sk, {"hair": hair, "long_coat": true, "arms": true, "knees": true, "legs": Color(0.16, 0.15, 0.15)})
		fg.position = spots[i]
		add_child(fg)
		var d: Vector3 = tp - fg.position
		fg.rotation.y = atan2(-d.x, -d.z)
		var hm := head_mesh(fg)
		if hm:
			hm.material_override = eyeless_face(sk, hair, 1500 + i)
		for a in fg.get_meta("arms"):
			(a as Node3D).rotation.x = -0.12
		fg.set_meta("eyeless", true)
		var it := _collider("night_eyeless%d" % i, fg, "eyeless", LINES["scan"]["eyeless"])
		it.set_meta("eyeless", true)
		eyeless.append({"fig": fg, "it": it, "home": fg.position, "yaw": fg.rotation.y, "hold": 0.0})


## The follower: built hidden; it is only ever seen at confrontation range.
func _follower() -> void:
	var f: Node3D = lv.figure(BLACK, Color(0.1, 0.1, 0.1), {"long_coat": true, "legs": BLACK, "hair": BLACK, "arms": true, "scale": 1.1})
	add_child(f)
	var blk: StandardMaterial3D = lv.mat(BLACK, 0.55, 0.1)
	# no legs: the coat runs to the ground
	for l in f.get_meta("legs"):
		(l as Node3D).visible = false
	lv.cyl(0.21, 0.36, 0.95, Vector3(0, 0.47, 0), blk, 12, f)
	for a in f.get_meta("arms"):
		(a as Node3D).rotation.x = -0.05
	var hd: Node3D = f.get_meta("head")
	var hm := head_mesh(f)
	if hm:
		hm.material_override = blk
	# the hood, and the mask: a flat pale oval, nothing on it
	lv.sphere(0.128, Vector3(0, 0.025, 0.035), blk, 12, hd)
	var mk: MeshInstance3D = lv.sphere(0.1, Vector3(0, 0.0, -0.088), lv.mat(Color(0.9, 0.88, 0.82), 0.25, 0.1), 14, hd)
	mk.scale = Vector3(0.92, 1.32, 0.3)
	# "a mask that shimmered unnaturally under the streetlights"
	_mask_sheen = lv.sphere(0.103, Vector3(0, 0.0, -0.09), lv.newglow(Color(0.65, 0.85, 1.0), 0.0), 14, hd)
	_mask_sheen.scale = Vector3(0.94, 1.34, 0.32)
	f.set_meta("pursuer", true)
	f.set_meta("eyeless", true)
	var it := _collider("night_follower", f, "follower", LINES["scan"]["follower"])
	it.set_meta("pursuer", true)
	f.visible = false
	it.collision_layer = 0
	follower = f


## Park Avenue: thirty in the road, faces up to the tower.
func _crowd(f: int) -> void:
	var coats := [Color(0.12, 0.12, 0.14), Color(0.2, 0.16, 0.12), Color(0.1, 0.14, 0.18), Color(0.25, 0.25, 0.27), Color(0.3, 0.1, 0.12)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66), Color(0.7, 0.52, 0.38)]
	var tp: Vector3 = lv.cfg["tower"] + Vector3(0, 300, 0)
	var r := RandomNumberGenerator.new()
	r.seed = 3030
	for i in 30:
		var c := i % 6
		var row := int(i / 6)
		var p := Vector3(-5.0 + c * 2.0 + r.randf_range(-0.3, 0.3), 0.0, -24.0 - row * 1.8 + r.randf_range(-0.3, 0.3))
		var fg: Node3D = lv.figure(coats[r.randi() % coats.size()], skins[r.randi() % skins.size()], {"visor": true})
		fg.position = p
		add_child(fg)
		var d := tp - p
		fg.rotation.y = atan2(-d.x, -d.z)
		(fg.get_meta("head") as Node3D).rotation.x = 0.55
		if f >= 3:
			var hm := head_mesh(fg)
			if hm:
				hm.material_override = carl_face()
		crowd.append(fg)
		if i % 5 == 2:
			_collider("night_crowd%d" % i, fg, "crowd", LINES["scan"]["crowd"] % 30)
		else:
			lv.solid_box(Vector3(0.6, 1.8, 0.6), p + Vector3(0, 0.9, 0), self)
	if f >= 2:
		main.loop("chant", -8.0, Vector3(0, 1.6, -28.0), 6.0, 55.0)


## Fargona Avenue: the preacher's digital vigil across the road.
func _preacher() -> void:
	var r := RandomNumberGenerator.new()
	r.seed = 4040
	var tab: StandardMaterial3D = lv.glow(Color(0.7, 0.9, 1.0), 2.2)
	for i in 12:
		var p := Vector3(-5.5 + (i % 6) * 2.2 + r.randf_range(-0.4, 0.4), 0.0, -30.0 - int(i / 6) * 2.4 + r.randf_range(-0.4, 0.4))
		var fg: Node3D = lv.figure(Color(0.14, 0.13, 0.15).lightened(r.randf_range(0.0, 0.2)), Color(0.85, 0.66, 0.52).darkened(r.randf_range(0.0, 0.5)), {"visor": true, "arms": true})
		fg.position = p
		fg.rotation.y = r.randf_range(-0.3, 0.3)
		add_child(fg)
		(fg.get_meta("head") as Node3D).rotation.x = 0.7
		var arms: Array = fg.get_meta("arms")
		for a in arms:
			(a as Node3D).rotation.x = -0.9
		lv.box(Vector3(0.2, 0.28, 0.02), Vector3(0, 1.2, -0.36), tab, false, fg)
		vigil.append(fg)
		if i == 3:
			_collider("night_vigil", fg, "vigil", LINES["scan"]["vigil"])
		else:
			lv.solid_box(Vector3(0.6, 1.8, 0.6), p + Vector3(0, 0.9, 0), self)
	# the preacher on a crate at their head, the tablet held up like a bible
	lv.prop("plastic_crate_03", Vector3(0, 0.0, -40.0), 0.0, 1.0, true, self)
	preacher = lv.figure(Color(0.08, 0.08, 0.09), Color(0.7, 0.52, 0.4), {"visor": true, "arms": true, "hair": Color(0.5, 0.5, 0.5)})
	preacher.position = Vector3(0, 0.3, -40.0)
	add_child(preacher)
	var pa: Array = preacher.get_meta("arms")
	for a in pa:
		(a as Node3D).rotation.x = -1.7
	lv.box(Vector3(0.24, 0.32, 0.02), Vector3(0, 1.98, -0.42), lv.glow(Color(0.85, 0.95, 1.0), 3.0), false, preacher)
	lv.light(Vector3(0, 2.3, -39.2), Color(0.7, 0.85, 1.0), 1.2, 5.0, false).reparent(self)
	_collider("night_preacher", preacher, "preacher", LINES["scan"]["preacher"])
	# what they are all looking at: the fractal over the street (the eye layer)
	fractal = MeshInstance3D.new()
	var qm := QuadMesh.new()
	qm.size = Vector2(44, 44)
	fractal.mesh = qm
	var fm := StandardMaterial3D.new()
	fm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	fm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	fm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	fm.cull_mode = BaseMaterial3D.CULL_DISABLED
	fm.albedo_texture = _fractal_tex()
	fm.albedo_color = Color(1, 1, 1, 0.85)
	fractal.material_override = fm
	fractal.position = Vector3(0, 30.0, -34.0)
	fractal.rotation.x = -PI / 2.0
	fractal.visible = false
	add_child(fractal)


## "a large fractal pattern undulating above my head. It glowed in all colors
## and seemed to have no end" (ch.15).
func _fractal_tex() -> ImageTexture:
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	for y in n:
		for x in n:
			var p := Vector2(x - n * 0.5, y - n * 0.5) / (n * 0.5)
			var d := p.length()
			var a := atan2(p.y, p.x)
			var v := sin(d * 34.0 - a * 6.0) * 0.5 + 0.5
			var w := sin(d * 13.0 + a * 12.0) * 0.5 + 0.5
			var fade := clampf(1.0 - d, 0.0, 1.0)
			var c := Color.from_hsv(fmod(d * 1.7 + a / TAU + 1.0, 1.0), 0.8, 1.0)
			img.set_pixel(x, y, Color(c.r, c.g, c.b, pow(v * w, 1.5) * fade))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## Red Rock: an alley mouth on the west front (bins, a wet floor, a dim red lamp).
func _alley() -> void:
	var dark: StandardMaterial3D = lv.mat(Color(0.01, 0.01, 0.012), 0.95)
	var wall: StandardMaterial3D = lv.mat(Color(0.12, 0.1, 0.1), 0.85)
	var z := alley_at.z
	lv.quad(Vector2(2.6, 4.6), Vector3(-12.93, 2.3, z), PI / 2.0, dark, self)
	for s: float in [-1.0, 1.0]:
		lv.box(Vector3(0.9, 4.8, 0.3), Vector3(-12.6, 2.4, z + s * 1.45), wall, true, self)
	lv.floor_quad(Vector2(1.6, 2.6), Vector3(-12.1, 0.13, z), 0.0, lv.mat(Color(0.04, 0.035, 0.035), 0.08, 0.2), self)
	lv.prop("metal_trash_can", Vector3(-12.3, 0.12, z + 1.0), 0.4, 1.0, false, self)
	lv.light(Vector3(-11.8, 3.4, z), Color(1.0, 0.2, 0.15), 0.6, 4.5, false).reparent(self)
	var it: CollisionObject3D = lv.interactable("night_alley", LINES["prompts"]["alley"], Vector3(-12.5, 1.4, z), Vector3(0.6, 2.6, 2.2), "", false, self)
	it.set_meta("encounter", "night")
	it.set_meta("night_kind", "alley")
	it.set_meta("night_node", self)


## The man in the alley: Carl's face, eyes wide, only with the frames on.
func _double() -> void:
	double = lv.figure(Color(0.12, 0.12, 0.14), Color(0.84, 0.66, 0.54), {"hair": Color(0.12, 0.09, 0.07), "legs": Color(0.08, 0.08, 0.1), "arms": true, "knees": true})
	add_child(double)
	var hm := head_mesh(double)
	if hm:
		hm.material_override = double_face()
	double.position = alley_at + Vector3(0.55, -0.12, 0)
	double.rotation.y = -PI / 2.0
	double.set_meta("pursuer", true)
	var it := _collider("night_double", double, "double", LINES["scan"]["double"])
	it.set_meta("pursuer", true)
	double.visible = false


# ------------------------------------------------------------------ the frame loop

func _process(delta: float) -> void:
	_t += delta
	if main == null or main.level != lv or main.loading or not main.player:
		return
	var pp: Vector3 = main.player.global_position
	_yaw_hist.append(main.player.yaw)
	if _yaw_hist.size() > 40:
		_yaw_hist.pop_front()
	_dev_show(pp)
	if _mask_sheen and follower and follower.visible:
		var mt := _mask_sheen.material_override as StandardMaterial3D
		mt.emission_energy_multiplier = 0.25 + 0.25 * sin(_t * 7.0) * sin(_t * 2.3)
		# the glide: two frames at 2 fps, a hover that does not breathe
		follower.position.y = 0.04 if int(_t * 2.0) % 2 == 0 else 0.0
	if fractal:
		fractal.visible = main.frames_on
		fractal.rotation.y += delta * 0.05
	if double and not double.has_meta("gone"):
		double.visible = main.frames_on
		var hd: Node3D = double.get_meta("head")
		if _yaw_hist.size() > 30:
			# he mirrors Carl's last half second
			hd.rotation.y = clampf(-wrapf(float(_yaw_hist[_yaw_hist.size() - 30]) - main.player.yaw, -PI, PI), -0.7, 0.7)
	_faces_tick()
	var cine: bool = main.flags.has("cinematic") or main.ui.busy or busy or main.ui.title.visible
	if not cine:
		_eyeless_tick(delta, pp)
		_triggers(pp)


## With the frames on the eyeless orient to the signal, 45 degrees at a time
## with a hold at each (longer the further Carl is), and close at walking
## speed once they face him. Frames off: statues.
func _eyeless_tick(delta: float, pp: Vector3) -> void:
	_touch_cd = maxf(0.0, _touch_cd - delta)
	for e: Dictionary in eyeless:
		var fg: Node3D = e["fig"]
		var d: Vector3 = pp - fg.global_position
		d.y = 0.0
		var dist := d.length()
		if not main.frames_on or dist > 18.0:
			continue
		var want := atan2(-d.x, -d.z)
		var diff := wrapf(want - float(e["yaw"]), -PI, PI)
		e["hold"] = float(e["hold"]) - delta
		if absf(diff) > 0.15 and float(e["hold"]) <= 0.0:
			e["yaw"] = float(e["yaw"]) + signf(diff) * minf(PI / 4.0, absf(diff))
			e["hold"] = 0.1 + dist * 0.035
			fg.rotation.y = float(e["yaw"])
		if absf(diff) < PI / 4.0 + 0.05 and dist > 0.7 and dist < 13.0:
			fg.position += d.normalized() * minf(1.35 * delta, dist)
			Anim.walk(fg, _t, 0.8, float(fg.get_instance_id() % 7), 0.45)
		if dist < 0.95 and _touch_cd <= 0.0:
			_eyeless_touch.call_deferred()
			return


func _eyeless_touch() -> void:
	if busy:
		return
	busy = true
	_touch_cd = 5.0
	main.flags["cinematic"] = true
	main.player.shake(0.7)
	main.play("whisper", -2.0, 0.5)
	var cf := confront_ui(main)
	cf.set("_red", 1.0)
	cf.visible = true
	cf.create_tween().tween_property(cf, "_red", 0.0, 1.0)
	main.add_connection(5.0, LINES["touch"]["why"])
	await main.ui.think(LINES["touch"]["eyeless"])
	await main.ui.fade_to(1.0, 0.3)
	main.player.global_position = lv.spawn
	main.player.velocity = Vector3.ZERO
	main.player.yaw = deg_to_rad(lv.spawn_yaw)
	for e: Dictionary in eyeless:
		var fg: Node3D = e["fig"]
		fg.position = e["home"]
	await main.ui.fade_to(0.0, 0.6)
	main.ui.close()
	if not cf.active:
		cf.visible = false
	main.log_line("encounter", LINES["log_eyeless"] % main.city.district_name(did))
	main.flags.erase("cinematic")
	busy = false
	last_result = "eyeless_touched"


## The street encounters start when Carl comes within range.
func _triggers(pp: Vector3) -> void:
	var day := int(main.day)
	if follower and not follower.visible and not follower.has_meta("gone") and pp.z < 18.0 and pp.z > STREET_N + 20.0:
		_start("follower")
	elif crowd.size() > 0 and not crowd_turned and pp.z < -10.0 and pp.z > -40.0 and absf(pp.x) < 12.0:
		if not main.flags.has("crowd_d%d" % day):
			_start("crowd")
	elif preacher and not preacher.has_meta("done") and pp.distance_to(preacher.global_position) < 11.0:
		if not main.flags.has("preacher_d%d" % day):
			_start("preacher")
	elif double and not double.has_meta("gone") and main.frames_on and pp.distance_to(double.global_position) < 9.0:
		_start("double")


## Start one now (the triggers, the E key on some of them, the test).
func trigger(kind: String) -> String:
	if busy:
		return ""
	busy = true
	var fig: Node3D = null
	var pp: Vector3 = main.player.global_position
	var day := int(main.day)
	match kind:
		"follower":
			fig = follower
			if fig:
				# it is simply there, at confrontation range, ahead of him
				var fwd := Vector3(-sin(main.player.yaw), 0, -cos(main.player.yaw))
				var at := pp + fwd * 5.5
				at.x = clampf(at.x, -10.5, 10.5)
				at.z = clampf(at.z, STREET_N + 14.0, STREET_S - 4.0)
				at.y = 0.0
				fig.global_position = at
				var d := pp - at
				fig.rotation.y = atan2(-d.x, -d.z)
				fig.visible = true
				for c in fig.find_children("*", "CollisionObject3D", true, false):
					lv.set_active(c, true)
				main.play("static", -10.0, 0.5)
		"crowd":
			crowd_turned = true
			if crowd.size() > 0:
				fig = crowd[14]
			# the unison turn: every one of them, the same frame
			for c: Node3D in crowd:
				var d := pp - c.global_position
				c.rotation.y = atan2(-d.x, -d.z)
				(c.get_meta("head") as Node3D).rotation.x = 0.0
		"preacher":
			fig = preacher
			if preacher:
				preacher.set_meta("done", true)
		"double":
			fig = double
	var res: String = await confront_ui(main).run(main, kind, fig, script_picks)
	script_picks = []
	last_result = res
	main.flags[{"follower": "follower_d%d", "crowd": "crowd_d%d", "preacher": "preacher_d%d", "double": "double_d%d"}.get(kind, kind + "_d%d") % day] = res
	_after(kind, res)
	busy = false
	if res in ["ran", "touched"]:
		street_back(main)
	return res


func _start(kind: String) -> void:
	trigger(kind)


func _after(kind: String, res: String) -> void:
	match kind:
		"crowd":
			if res == "held":
				# a path down the middle, just wide enough for one
				for c: Node3D in crowd:
					var x := c.position.x
					if absf(x) < 2.5:
						c.position.x += 1.2 * signf(x if absf(x) > 0.01 else 1.0)
			for c: Node3D in crowd:
				c.visible = true
				c.remove_meta("gone")
				for b in c.find_children("*", "CollisionObject3D", true, false):
					lv.set_active(b, true)
		"preacher":
			if res == "held":
				for v: Node3D in vigil:
					if absf(v.position.x) < 3.0:
						v.position.x += 1.6 * signf(v.position.x if absf(v.position.x) > 0.01 else 1.0)
			if preacher:
				preacher.visible = true
				preacher.remove_meta("gone")
				for c in preacher.find_children("*", "CollisionObject3D", true, false):
					lv.set_active(c, true)


## Carl's face for one frame, one person in twenty, from 75 (bible-1 thresholds).
func _faces_tick() -> void:
	for pr: Array in _flashed:
		if is_instance_valid(pr[0]):
			(pr[0] as MeshInstance3D).material_override = pr[1]
	_flashed.clear()
	if main.connection < 75.0:
		return
	_face_t += get_process_delta_time()
	if _face_t < 1.0:
		return
	_face_t = 0.0
	var people: Array = []
	for w in lv.walkers:
		people.append(w["node"])
	people.append_array(lv.talkers)
	people.append_array(lv.kneelers)
	people.append_array(vigil)
	if int(lv.faith) < 3:
		people.append_array(crowd)
	for p in people:
		if p is Node3D and (p as Node3D).visible and randf() < 0.05:
			var hm := head_mesh(p)
			if hm:
				_flashed.append([hm, hm.material_override])
				hm.material_override = carl_face()
				face_flashes += 1


## E on them.
func examine(node: Node) -> void:
	var ui = main.ui
	var X: Dictionary = LINES["examine"]
	match str(node.get_meta("night_kind", "")):
		"eyeless":
			await ui.think(X["eyeless"] if main.frames_on else X["eyeless_dark"])
		"follower":
			await ui.think(X["follower_held"])
		"crowd":
			await ui.think(X["crowd_faces"] if int(lv.faith) >= 3 else X["crowd"])
		"preacher":
			await ui.think(X["preacher"])
		"vigil":
			await ui.think(X["vigil"])
		"double":
			await ui.think(X["double"] if main.frames_on else X["alley"])
		"alley":
			await ui.think(X["double"] if double and double.visible else X["alley"])


## Dev: --nightshow=follower|double|crowd|preacher puts it in the shot;
## --confront=<kind> opens the confrontation on the first frame.
func _dev_show(pp: Vector3) -> void:
	if _show_once or not main._args.has("nightshow") and not main._args.has("confront"):
		return
	_show_once = true
	var k := str(main._args.get("nightshow", main._args.get("confront", "")))
	if k == "follower" and follower:
		var fwd := Vector3(-sin(main.player.yaw), 0, -cos(main.player.yaw))
		follower.global_position = Vector3(pp.x, 0.0, pp.z) + fwd * float(main._args.get("range", "5"))
		var d := pp - follower.global_position
		follower.rotation.y = atan2(-d.x, -d.z)
		follower.visible = true
	if main._args.has("confront"):
		script_picks = []
		trigger(k)


# ------------------------------------------------------------------ the --night=1 test

static func _fails_add(st: Dictionary, name: String, ok: bool, info := "") -> void:
	print("NIGHT %s %s  %s" % ["ok  " if ok else "FAIL", name, info])
	if not ok:
		st["fails"] = int(st["fails"]) + 1


## Load a district street at a time, with Connection and the frames set.
static func _street(m: Node, d: String, day: int, hour: int, conn: float, frames: bool) -> Node:
	m.city.district = d
	m.day = day
	m.hour = hour
	m.connection = conn
	m.frames_on = frames
	m.ui.set_frames(1.0 if frames else 0.0, conn)
	var old: Node = m.level
	m.load_level("Street")
	await _level_change(m, old)
	m.frames_on = frames
	m.player.yaw = 0.0
	m.player.pitch = 0.0
	return m.level.get_node_or_null("Night")


static func _level_change(m: Node, old: Node, secs := 90.0) -> bool:
	var t0 := Time.get_ticks_msec()
	while (m.level == old or m.loading or m.level_name != "Street") and Time.get_ticks_msec() - t0 < int(secs * 1000.0):
		await m.get_tree().process_frame
	for i in 6:
		await m.get_tree().process_frame
	return m.level != old and not m.loading


## One confrontation by a scripted set of picks; returns [result, dC].
static func _drive(m: Node, nl: Node, kind: String, picks: Array) -> Array:
	nl.script_picks = picks
	var c0: float = m.connection
	var res: String = await nl.trigger(kind)
	return [res, m.connection - c0]


static func selftest(m: Node) -> void:
	var tree: SceneTree = m.get_tree()
	Engine.time_scale = 4.0
	m.shot_mode = true
	var watchdog := tree.create_timer(1500.0, true, false, true)
	watchdog.timeout.connect(func():
		print("NIGHT TIMEOUT watchdog")
		tree.quit(1))
	var pump := func() -> void:
		while m._selftest:
			await tree.process_frame
			m.ui.advanced.emit()
			m.ui.picked.emit(0)
	pump.call()
	var st := {"fails": 0}
	for fl in ["opening_seen", "scene1_done", "park_done", "home1_done", "warroom1_done", "hospital_done", "southtown_done",
			"home2_done", "ritual_seen", "warroom2_done", "lynx_apartment_done", "desert_done", "mirror_done", "act1_done",
			"facility_done", "hangar_done", "home3_done", "blackout_done", "observatory_done", "watched_observatory",
			"freudbot_1", "holdingcell_done"]:
		m.flags[fl] = true
	for w in ["hush", "look away", "sleeper", "dreamer", "mimic", "bow", "the path", "convene"]:
		m.learn(w)
	for d in m.faith:
		m.faith[d] = 1
	if str(m._args.get("night", "1")) == "faces":
		m.faith["hill_road"] = 2
		await _street(m, "hill_road", 4, 22, 40.0, true)
		await _thresholds(m, st)
		print("NIGHT DONE fails=", st["fails"])
		m._selftest = false
		tree.quit()
		return
	# 1. nightfall: the feed names the follower's street
	m.day = 4
	m.hour = 19
	m.city.advance(1)
	var fed := false
	for l in m.ui.feed_lines:
		if str(l) == "a figure on " + m.city.district_name("hill_road"):
			fed = true
	_fails_add(st, "nightfall feed: a figure on Hill Road", fed and follower_district(4) == "hill_road", str(m.ui.feed_lines.slice(-3)))
	# 2. the follower on Hill Road, Day 4, 21:00: hidden until range, then the confrontation (Look, frames on, C 30)
	m.faith["hill_road"] = 1
	var nl: Node = await _street(m, "hill_road", 4, 21, 30.0, true)
	_fails_add(st, "follower built hidden", nl != null and nl.follower != null and not nl.follower.visible)
	nl.script_picks = [["look"]]
	var c0: float = m.connection
	m.player.global_position = Vector3(3.0, 0.1, 12.0)
	var t0 := Time.get_ticks_msec()
	while nl.last_result == "" and Time.get_ticks_msec() - t0 < 30000:
		await tree.process_frame
	_fails_add(st, "follower appears at range and confronts: Look (frames on, C<50) = seen, +1",
		nl.last_result == "seen" and is_equal_approx(m.connection - c0, 1.0) and not nl.follower.visible and m.flags.get("follower_d4", "") == "seen",
		"%s dC %.0f" % [nl.last_result, m.connection - c0])
	var hk: Node = m.hack
	var sub: Node = hk.subject_of(nl.follower.find_children("*", "CollisionObject3D", true, false)[0])
	_fails_add(st, "follower cannot be hacked", sub != null and hk.kind_of(sub) == "eyeless")
	# 3. Look at C >= 50: seen +1 each round, it stays; three rounds = outlasted, +3
	m.flags.erase("follower_d4")
	nl = await _street(m, "hill_road", 4, 21, 55.0, true)
	var r: Array = await _drive(m, nl, "follower", [["look"], ["look"], ["look"]])
	_fails_add(st, "Look at C>=50 does not end it; three rounds = outlasted, +3", r[0] == "outlasted" and is_equal_approx(r[1], 3.0), str(r))
	# 4. the right word holds it (look away), free; it stays standing where it was
	m.flags.erase("follower_d4")
	nl = await _street(m, "hill_road", 4, 21, 30.0, true)
	r = await _drive(m, nl, "follower", [["speak", "look away"]])
	_fails_add(st, "Speak the right word (look away) holds it, +0", r[0] == "held" and is_equal_approx(r[1], 0.0) and nl.follower.visible and nl.follower.has_meta("held"), str(r))
	# 5. a wrong word draws it (closer 1), then the right word holds it
	m.flags.erase("follower_d4")
	nl = await _street(m, "hill_road", 4, 21, 30.0, true)
	r = await _drive(m, nl, "follower", [["speak", "hush"], ["speak", "look away"]])
	var cf: Control = confront_ui(m)
	_fails_add(st, "wrong word draws it closer, then held", r[0] == "held" and int(cf.closer) == 1 and is_equal_approx(r[1], 0.0), "%s closer %d" % [str(r), int(cf.closer)])
	# 6. bow always ends it, +3
	m.flags.erase("follower_d4")
	nl = await _street(m, "hill_road", 4, 21, 30.0, true)
	r = await _drive(m, nl, "follower", [["speak", "bow"]])
	_fails_add(st, "bow ends it, +3", r[0] == "bowed" and is_equal_approx(r[1], 3.0), str(r))
	# 7. Run: +1, ends it, one street back (+1 hour, the street he came from)
	m.flags.erase("follower_d4")
	nl = await _street(m, "hill_road", 4, 21, 30.0, true)
	m.city.came_from = "heights"
	var old: Node = m.level
	var h0: int = int(m.hour)
	r = await _drive(m, nl, "follower", [["run"]])
	var moved := await _level_change(m, old)
	_fails_add(st, "Run: +1, ends it, one street back", r[0] == "ran" and is_equal_approx(r[1], 1.0) and moved and m.city.district == "heights" and int(m.hour) == h0 + 1,
		"%s %s %s" % [str(r), m.city.district, m.city.clock_text()])
	# 8. frames off, Look twice: closer, closer = touched, +5, one street back
	m.flags.erase("follower_d4")
	nl = await _street(m, "hill_road", 4, 21, 30.0, false)
	m.city.came_from = "heights"
	old = m.level
	r = await _drive(m, nl, "follower", [["look"], ["look"]])
	moved = await _level_change(m, old)
	_fails_add(st, "frames off, Look x2 = touched, +5, one street back, no game over", r[0] == "touched" and is_equal_approx(r[1], 5.0) and moved and m.city.district == "heights",
		"%s %s" % [str(r), m.city.district])
	# 9. the follower is only on its own street, and only from Day 4
	nl = await _street(m, "hill_road", 3, 21, 30.0, true)
	_fails_add(st, "no follower before Day 4", nl != null and nl.follower == null)
	nl = await _street(m, "lamplight", 4, 21, 30.0, true)
	_fails_add(st, "no follower off its street", nl != null and nl.follower == null)
	# 10. the Park Avenue crowd at 50: thirty, the unison turn, sleeper holds it
	m.faith["park_ave"] = 2
	nl = await _street(m, "park_ave", 4, 14, 45.0, true)
	_fails_add(st, "no crowd under 50", nl.crowd.size() == 0)
	nl = await _street(m, "park_ave", 4, 14, 55.0, true)
	_fails_add(st, "Park Avenue crowd of 30 at C 55", nl.crowd.size() == 30, str(nl.crowd.size()))
	await m.level.check_walk("park_ave crowd: spawn->landmark", "landmark")
	nl.script_picks = [["speak", "sleeper"]]
	m.player.global_position = Vector3(9.5, 0.1, -16.0)
	t0 = Time.get_ticks_msec()
	while nl.last_result == "" and Time.get_ticks_msec() - t0 < 30000:
		await tree.process_frame
	_fails_add(st, "crowd confronts on approach; sleeper holds it", nl.last_result == "held" and m.flags.get("crowd_d4", "") == "held", nl.last_result)
	# at Faith 3 every face is Carl's
	m.faith["park_ave"] = 3
	nl = await _street(m, "park_ave", 4, 14, 55.0, true)
	var carl := 0
	for c: Node3D in nl.crowd:
		var hm := head_mesh(c)
		if hm and hm.material_override == carl_face():
			carl += 1
	_fails_add(st, "Faith 3: the crowd has Carl's face", carl == 30, str(carl))
	# 11. Fargona at night: the preacher's vigil; dreamer opens a path
	nl = await _street(m, "fargona", 4, 22, 40.0, true)
	_fails_add(st, "Fargona vigil and preacher at night", nl.preacher != null and nl.vigil.size() == 12)
	await m.level.check_walk("fargona vigil: spawn->landmark", "landmark")
	r = await _drive(m, nl, "preacher", [["speak", "convene"], ["speak", "dreamer"]])
	_fails_add(st, "preacher: wrong word draws, dreamer holds", r[0] == "held" and int(confront_ui(m).closer) == 1 and nl.preacher.visible, str(r))
	# 12. Red Rock at night, C 55: the double, frames-on only; frames off ends it; mimic holds it
	nl = await _street(m, "red_rock", 4, 22, 55.0, false)
	await tree.process_frame
	_fails_add(st, "alley double invisible with the frames off", nl.double != null and not nl.double.visible)
	m.frames_on = true
	await tree.process_frame
	await tree.process_frame
	_fails_add(st, "alley double there with the frames on", nl.double.visible)
	await m.level.check_walk("red_rock: spawn->the alley", "night_alley")
	r = await _drive(m, nl, "double", [["frames"]])
	_fails_add(st, "double: frames off ends it, +0", r[0] == "unseen" and is_equal_approx(r[1], 0.0) and not m.frames_on, str(r))
	m.flags.erase("double_d4")
	nl = await _street(m, "red_rock", 4, 22, 55.0, true)
	r = await _drive(m, nl, "double", [["speak", "mimic"]])
	_fails_add(st, "double: mimic holds it", r[0] == "held", str(r))
	nl = await _street(m, "red_rock", 4, 22, 40.0, true)
	_fails_add(st, "no double under 50", nl.double == null)
	# 13. Dufredy at Lushon's (scripted): the path holds him
	var df: Node3D = m.level.figure(Color(0.3, 0.3, 0.3), Color(0.8, 0.7, 0.6), {})
	m.level.add_child(df)
	df.position = Vector3(3, 0, 40)
	c0 = m.connection
	var rd: String = await confront(m, "dufredy", df, [["look"], ["speak", "the path"]])
	_fails_add(st, "Dufredy (scripted): Look at C<50 = seen, +1", rd == "seen" and is_equal_approx(m.connection - c0, 1.0), rd)
	df.visible = true
	df.remove_meta("gone")
	rd = await confront(m, "dufredy", df, [["speak", "the path"]])
	_fails_add(st, "Dufredy: the path holds him", rd == "held", rd)
	# 14. the eyeless on a Faith 2 street at night: statues with the frames off, close with them on, touch +5
	m.faith["canal_walk"] = 2
	nl = await _street(m, "canal_walk", 4, 22, 40.0, false)
	_fails_add(st, "eyeless on a Faith 2 street at night", nl.eyeless.size() == 4, str(nl.eyeless.size()))
	await m.level.check_walk("canal_walk eyeless: spawn->landmark", "landmark")
	var e0: Dictionary = nl.eyeless[0]
	var ef: Node3D = e0["fig"]
	var sube: Node = hk.subject_of(e0["it"])
	_fails_add(st, "eyeless cannot be hacked", sube != null and hk.kind_of(sube) == "eyeless")
	m.player.global_position = ef.global_position + Vector3(2.5, 0.1, 2.5)
	var p0 := ef.global_position
	var y0 := ef.rotation.y
	var tw0 := Time.get_ticks_msec()
	while Time.get_ticks_msec() - tw0 < 1500:
		await tree.process_frame
	_fails_add(st, "frames off: the eyeless are statues", ef.global_position.distance_to(p0) < 0.01 and is_equal_approx(ef.rotation.y, y0))
	c0 = m.connection
	m.frames_on = true
	tw0 = Time.get_ticks_msec()
	while nl.last_result != "eyeless_touched" and Time.get_ticks_msec() - tw0 < 30000:
		await tree.process_frame
	t0 = Time.get_ticks_msec()
	while nl.busy and Time.get_ticks_msec() - t0 < 20000:
		await tree.process_frame
	_fails_add(st, "frames on: it turns, closes, touches: +5, Carl back at the street's end",
		nl.last_result == "eyeless_touched" and is_equal_approx(m.connection - c0, 5.0) and m.player.global_position.distance_to(m.level.spawn) < 2.0,
		"dC %.0f at %s" % [m.connection - c0, m.player.global_position.snapped(Vector3(0.1, 0.1, 0.1))])
	nl = await _street(m, "canal_walk", 4, 14, 40.0, true)
	_fails_add(st, "no eyeless by day", nl.eyeless.size() == 0)
	m.faith["hill_road"] = 2
	m.flags.erase("follower_d4")
	nl = await _street(m, "hill_road", 4, 22, 40.0, true)
	await m.level.check_walk("hill_road night (eyeless, follower): spawn->landmark", "landmark")
	await _thresholds(m, st)
	print("NIGHT DONE fails=", st["fails"], " conn=", m.connection, " clock=", m.city.clock_text(), " flags=",
		m.flags.keys().filter(func(k): return str(k).ends_with("_d4") or str(k).begins_with("nightfall")))
	m._selftest = false
	tree.quit()


## The 50 and 75 thresholds, on the street that is loaded.
static func _thresholds(m: Node, st: Dictionary) -> void:
	var tree: SceneTree = m.get_tree()
	var nl: Node = m.level.get_node_or_null("Night")
	var tw0 := 0
	# 15. the 50 and 75 thresholds
	m.connection = 55.0
	var g := 0
	var cc := 0
	for i in 1000:
		if objective_text(m, "x") == LINES["gather"]:
			g += 1
		if scan_text(m, "x") == LINES["corrupt"]:
			cc += 1
	_fails_add(st, "C 50: the objective reads 'gather, sleeper' ~10%", g > 50 and g < 160, str(g))
	_fails_add(st, "C 50: ~30% of people's cards are Carl's", cc > 230 and cc < 370, str(cc))
	m.connection = 40.0
	_fails_add(st, "under 50: no lies", objective_text(m, "x") == "x" and scan_text(m, "x") == "x")
	m.connection = 80.0
	nl.face_flashes = 0
	tw0 = Time.get_ticks_msec()
	var stuck := false
	var frames := 0
	while Time.get_ticks_msec() - tw0 < 180000 and frames < 900 and nl.face_flashes < 2:
		await tree.process_frame
		frames += 1
	m.connection = 40.0
	await tree.process_frame
	await tree.process_frame
	await tree.process_frame
	for w in m.level.walkers:
		var hm := head_mesh(w["node"])
		if hm and hm.material_override == carl_face():
			stuck = true
	_fails_add(st, "C 75: someone has Carl's face for one frame", nl.face_flashes >= 1 and not stuck, "flashes %d in %d frames" % [nl.face_flashes, frames])
