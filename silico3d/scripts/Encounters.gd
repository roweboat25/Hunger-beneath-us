extends RefCounted
## Builders for the hack and stealth set-ups the open city and the test room
## share: company security, a camera on a pivot, a talking speaker, a patrol
## drone, an addict, a robed watcher, a door a word can open; and
## street(lv), which dresses a district street by its danger tier (bible-1
## "Danger tiers and guarded sites"): every street gets a few hackable
## devices; at tier 2 (night, or Faith 2+) a company district puts a scene
## hold on the east pavement with a guard on the tape and a camera over it
## (cult districts keep their own, with robes instead of uniforms); Red Rock,
## Southtown and Rail Cut at night have addicts in the doorways (Red Rock
## first: combat.md "the first full combat zone").
## Talking to any of them comes here through Main.interact (meta "encounter").
##
## Every line here is (game): written for the game; ian rewrites them.

const LINES := {
	"prompts": {"guard": "Talk to the guard", "addict": "Talk to him", "cultist": "Look at the one in the robe",
		"scene": "Look under the tape", "speaker": "The speaker", "camera": "The camera", "drone": "The patrol drone",
		"door": "The door", "reader": "The badge reader", "terminal": "The screen"},
	"scan": {
		"guard": "PSYONIC SECURITY - CONTRACT\nORA-class: LINKED\nradio: CHANNEL 4\nwatching: THE TAPE",
		"addict": "UNREGISTERED\nPsyon (cracked): sync ???\nstatus: CONVERTING",
		"cultist": "UNKNOWN\nface: COVERED\nframes: ORA (UNISSUED)\nsync: ???  -  DREAMING",
		"speaker": "CIVIC SPEAKER %d\nvoice assistant: ACTIVE\nlast phrase: 'be well, citizen'",
		"camera": "SECURITY CAMERA\nowner: PSYONIC INTEGRATIONS\nfeed: LIVE",
		"drone": "SILICO PD - PATROL DRONE\nstatus: WATCHING\nPsyonic: YES",
		"scene": "SCENE HOLD\nPSYONIC SECURITY\nincident: NOT FOR THE FEED",
	},
	"guard": {"company": ["Keep walking, sir. Company business.", "You're Psyonic? Then you know I can't let you past the tape. Ask your people.",
			"Nothing to see. Nothing on the feed, either. That's how you know it's nothing."],
		"frames": "He looked at my frames, then at me. Something in his own lenses blinked, and he took a step closer to the tape."},
	"cultist": ["Gather, sleeper. Not here. Not yet.", "She didn't answer. Under the hood, the light in the corner of her frames was the same one as in mine."],
	"scene": {
		"company": "A sheet over a man in the gutter, his frames still on under it, the little light in the corner of the lens blinking. Security had put the tape up and gone back to their screens. On the wall above him, in the eye layer, someone had already drawn the rings.",
		"cult": "A ring of sticks round a sheet, and under the sheet a man with his frames on. They had put candles at his head and feet. They hadn't called anyone. They were waiting for him to get up.",
		"again": "The sheet. The light in the lens, still blinking. Nobody had come for him.",
		"log": "A body under a sheet in %s, behind the tape, the frames still on. Not on the feed.",
	},
	"sign": "PSYONIC SECURITY  -  SCENE HOLD",
}

const UNIFORM := Color(0.04, 0.045, 0.06)
const SECURE := ["spine", "cognizo", "hill_road", "zeta_park", "fargona", "heights", "park_ave", "lamplight", "canal_walk", "harmony_green"]
const CULT := ["southtown", "rail_cut", "red_rock", "restricted_road"]
const ADDICTS := ["red_rock", "southtown", "rail_cut"]


static func _person(lv, fig: Node3D, kind: String, id: String) -> CollisionObject3D:
	var b: CollisionObject3D = lv.person(id, LINES["prompts"][kind], fig, LINES["scan"].get(kind, ""))
	b.set_meta("encounter", kind)
	return b


## Company security: black, a visor, a gold badge. cfg goes to Stealth.
static func guard(lv, pos: Vector3, yaw: float, cfg := {}, id := "sec_guard") -> Node3D:
	var g: Node3D = lv.figure(UNIFORM, Color(0.58, 0.42, 0.32), {"arms": true, "knees": true, "visor": true, "legs": UNIFORM,
		"hair": Color(0.04, 0.04, 0.04), "long_coat": false})
	g.position = pos
	g.rotation.y = yaw
	lv.add_child(g)
	(g.get_meta("body") as Node3D).scale = Vector3(1.12, 1.0, 1.08)
	lv.box(Vector3(0.08, 0.05, 0.01), Vector3(-0.1, 1.42, -0.15), lv.glow(Color(0.95, 0.75, 0.3), 1.2), false, g)
	lv.box(Vector3(0.12, 0.07, 0.05), Vector3(0.12, 1.05, -0.18), lv.mat(Color(0.08, 0.08, 0.1), 0.4), false, g)
	g.set_meta("guard", true)
	var c := {"kind": "guard", "faction": "company", "managed": true}
	c.merge(cfg, true)
	g.set_meta("stealth", c)
	_person(lv, g, "guard", id)
	return g


## A robed watcher with frames under the hood (cult faction).
static func cultist(lv, pos: Vector3, yaw: float, cfg := {}, id := "robe") -> Node3D:
	var f: Node3D = lv.figure(Color(0.16, 0.05, 0.05), Color(0.62, 0.5, 0.42), {"arms": true, "knees": true, "visor": true,
		"long_coat": true, "legs": Color(0.1, 0.03, 0.03), "hair": Color(0.03, 0.02, 0.02)})
	f.position = pos
	f.rotation.y = yaw
	lv.add_child(f)
	var hd: Node3D = f.get_meta("head")
	lv.cyl(0.0, 0.19, 0.42, Vector3(0, 0.16, 0.03), lv.mat(Color(0.14, 0.04, 0.04), 0.9), 8, hd)
	f.set_meta("cultist", true)
	var c := {"kind": "cultist", "faction": "cult", "managed": true}
	c.merge(cfg, true)
	f.set_meta("stealth", c)
	_person(lv, f, "cultist", id)
	return f


## A camera head on a pivot (its lens looks down -Z), on a pole or a wall.
## cfg goes to Stealth (yaw, pitch, sweep, zone, safe, passive...).
static func camera(lv, pos: Vector3, yaw: float, cfg := {}, pole := true, id := "sec_camera") -> Node3D:
	if pole:
		lv.cyl(0.08, 0.1, pos.y, Vector3(pos.x, pos.y / 2.0, pos.z), lv.mat(Color(0.12, 0.12, 0.13), 0.5, 0.7), 8)
	var pv := Node3D.new()
	pv.position = pos
	pv.rotation.y = yaw
	lv.add_child(pv)
	var head := Node3D.new()
	pv.add_child(head)
	# the kit camera's lens faces +Z: turned round, it looks down the pivot's -Z
	var pr: Node3D = lv.prop("security_camera_01", Vector3(0, -0.15, 0.1), PI, 1.1, false, head)
	if pr == null:
		lv.box(Vector3(0.25, 0.25, 0.5), Vector3(0, 0, -0.15), lv.mat(Color(0.85, 0.85, 0.85), 0.3), false, head)
	var led: MeshInstance3D = lv.box(Vector3(0.06, 0.06, 0.03), Vector3(0.12, 0.08, -0.3), lv.glow(Color(1, 0.08, 0.06), 3.0), false, head)
	var it: CollisionObject3D = lv.interactable(id, LINES["prompts"]["camera"], Vector3(0, 0, -0.1), Vector3(0.6, 0.5, 0.8), LINES["scan"]["camera"], false, pv)
	it.set_meta("hackable", true)
	pv.set_meta("camera", true)
	var c := {"kind": "camera", "faction": "company", "managed": true, "yaw": yaw, "pivot": pv, "led": led}
	c.merge(cfg, true)
	pv.set_meta("stealth", c)
	return pv


## A civic speaker that never stops talking (hush stops it).
static func speaker(lv, pos: Vector3, yaw: float, id := "civic_speaker") -> Node3D:
	var sp := Node3D.new()
	sp.position = pos
	sp.rotation.y = yaw
	lv.add_child(sp)
	lv.box(Vector3(0.36, 0.5, 0.26), Vector3.ZERO, lv.mat(Color(0.2, 0.21, 0.22), 0.5, 0.6), false, sp)
	var grille: Material = lv.mat(Color(0.03, 0.03, 0.035), 0.5, 0.6)
	for k in 4:
		lv.box(Vector3(0.3, 0.03, 0.02), Vector3(0, -0.15 + k * 0.1, -0.135), grille, false, sp)
	lv.box(Vector3(0.04, 0.04, 0.02), Vector3(0.12, 0.2, -0.14), lv.glow(Color(0.3, 1.0, 0.6), 3.0), false, sp)
	var it: CollisionObject3D = lv.interactable(id, LINES["prompts"]["speaker"], Vector3.ZERO, Vector3(0.5, 0.6, 0.4), LINES["scan"]["speaker"] % (absi(hash(pos)) % 900 + 100), false, sp)
	it.set_meta("hackable", true)
	it.set_meta("hack_kind", "speaker")
	it.set_meta("company", false)
	var ap := AudioStreamPlayer3D.new()
	ap.stream = lv.main.sfx["murmur"]
	ap.volume_db = -12.0
	ap.unit_size = 2.0
	ap.max_distance = 18.0
	ap.autoplay = true
	sp.add_child(ap)
	return sp


## A police drone on a patrol line overhead.
static func drone(lv, pos: Vector3, cfg := {}, id := "patrol_drone") -> Node3D:
	var d := Node3D.new()
	d.position = pos
	lv.add_child(d)
	var pr: Node3D = lv.prop("police_drone", Vector3.ZERO, 0.0, 1.0, false, d)
	if pr == null:
		lv.box(Vector3(0.8, 0.2, 0.8), Vector3.ZERO, lv.mat(Color(0.2, 0.2, 0.22), 0.4, 0.6), false, d)
	lv.box(Vector3(0.08, 0.05, 0.08), Vector3(0, -0.15, -0.3), lv.glow(Color(1, 0.1, 0.08), 3.0), false, d)
	var it: CollisionObject3D = lv.interactable(id, LINES["prompts"]["drone"], Vector3.ZERO, Vector3(1.2, 0.6, 1.2), LINES["scan"]["drone"], false, d)
	it.set_meta("hackable", true)
	d.set_meta("drone", true)
	var c := {"kind": "drone", "faction": "company", "managed": true, "yaw": 0.0, "sweep": 0.8}
	c.merge(cfg, true)
	d.set_meta("stealth", c)
	return d


## Someone mid-conversion: a coat slept in, frames cracked, swaying.
static func addict(lv, pos: Vector3, yaw: float, cfg := {}, id := "addict") -> Node3D:
	var coats := [Color(0.28, 0.22, 0.16), Color(0.22, 0.24, 0.2), Color(0.3, 0.16, 0.14)]
	var f: Node3D = lv.figure(coats[absi(hash(id)) % coats.size()], Color(0.66, 0.5, 0.4), {"arms": true, "knees": true,
		"hair": Color(0.22, 0.18, 0.14), "legs": Color(0.18, 0.17, 0.16), "visor": true})
	f.position = pos
	f.rotation.y = yaw
	lv.add_child(f)
	var v: MeshInstance3D = f.get_meta("visor")
	if v:
		v.material_override = lv.glow(Color(1.0, 0.3, 0.85), 2.0)
	var c := {"managed": true, "hp": 3, "aggro": "frames"}
	c.merge(cfg, true)
	f.set_meta("addict", c)
	var b := _person(lv, f, "addict", id)
	b.set_meta("hackable", true)
	return f


## A door on a hinge that a word can open (dreamer, or we at its reader).
static func door(lv, hinge: Vector3, yaw: float, w := 1.1, id := "test_door") -> Array:
	var h := Node3D.new()
	h.position = hinge
	h.rotation.y = yaw
	lv.add_child(h)
	lv.box(Vector3(w, 2.2, 0.08), Vector3(w / 2.0, 1.1, 0), lv.mat(Color(0.3, 0.3, 0.32), 0.5, 0.5), false, h)
	var blk: StaticBody3D = lv.solid_box(Vector3(w, 2.2, 0.12), hinge + Vector3(cos(yaw) * w / 2.0, 1.1, -sin(yaw) * w / 2.0))
	var it: CollisionObject3D = lv.interactable(id, LINES["prompts"]["door"], Vector3(w / 2.0, 1.1, 0.1), Vector3(w, 2.2, 0.2), "DOOR\nlock: NOT YET", false, h)
	it.set_meta("hackable", true)
	it.set_meta("hack_kind", "door")
	it.set_meta("door_node", h)
	it.set_meta("door_block", blk)
	return [h, it]


# ------------------------------------------------------------------ the open city

## Danger tier of a street now (bible-1): 1 by day at Faith <= 1, 2 at night
## or Faith 2, 3 at Faith 3.
static func tier(lv) -> int:
	if int(lv.faith) >= 3:
		return 3
	if lv.night or int(lv.faith) >= 2:
		return 2
	return 1


static func street(lv) -> void:
	var did: String = lv.did
	var t := tier(lv)
	var safe := Vector3(3.0, 0.1, -46.0)
	# every street: the civic speaker, a camera over the road, the patrol drone
	speaker(lv, Vector3(-7.4, 3.4, 24.0), PI / 2.0, "civic_speaker")
	lv.cyl(0.05, 0.05, 3.2, Vector3(-7.4, 1.6, 24.0), lv.mat(Color(0.12, 0.12, 0.13), 0.5, 0.7), 6)
	camera(lv, Vector3(-8.4, 5.2, -4.0), -PI / 2.0 + 0.5, {"passive": true, "sweep": 0.6}, true, "road_camera")
	drone(lv, Vector3(0.0, 9.0, 20.0), {"passive": true, "path": [Vector3(0, 9, 30), Vector3(0, 9, -70)]}, "patrol_drone")
	for n in lv.find_children("*", "CollisionObject3D", true, false):
		if str(n.get_meta("id", "")) == "kiosk":
			n.set_meta("hackable", true)
			n.set_meta("hack_kind", "terminal")
			n.set_meta("company", true)
	# tier 2+: the scene hold on the east pavement
	if t >= 2 and (did in SECURE or did in CULT):
		var cult: bool = did in CULT
		var z0 := -60.0
		var z1 := -96.0
		var zone := AABB(Vector3(7.0, -1.0, z1 - 1.0), Vector3(7.0, 6.0, z0 - z1 + 2.0))
		var tape: Material = lv.glow(Color(1.0, 0.8, 0.1), 1.6) if not cult else lv.mat(Color(0.42, 0.33, 0.22), 0.9)
		for z: float in [z0, z1]:
			if not cult:
				lv.box(Vector3(5.6, 0.06, 0.02), Vector3(10.1, 1.0, z), tape)
				lv.box(Vector3(5.6, 0.06, 0.02), Vector3(10.1, 0.55, z), tape)
				for x: float in [7.5, 12.7]:
					lv.cyl(0.04, 0.05, 1.1, Vector3(x, 0.66, z), lv.mat(Color(0.9, 0.9, 0.9), 0.5), 6)
			else:
				var flame: Material = lv.glow(Color(1.0, 0.6, 0.25), 3.0)
				for k in 6:
					lv.cyl(0.035, 0.035, 0.16, Vector3(7.8 + k * 0.9, 0.2, z), lv.mat(Color(0.92, 0.88, 0.78), 0.8), 6)
					lv.box(Vector3(0.02, 0.04, 0.02), Vector3(7.8 + k * 0.9, 0.31, z), flame)
		if not cult:
			lv.neon_text(LINES["sign"], Vector3(12.9, 3.3, (z0 + z1) / 2.0), -PI / 2.0, 0.32, Color(1.0, 0.8, 0.2), -1.0, lv)
		# the scene: a sheet over a man, his frames still on
		var sp := Vector3(11.2, 0.13, -84.0)
		lv.box(Vector3(0.7, 0.22, 1.9), sp + Vector3(0, 0.11, 0), lv.mat(Color(0.82, 0.82, 0.8), 0.9))
		lv.floor_quad(Vector2(1.6, 2.4), sp + Vector3(-0.3, 0.01, 0.3), 0.4, lv.mat(Color(0.2, 0.02, 0.02), 0.3))
		lv.box(Vector3(0.12, 0.03, 0.04), sp + Vector3(-0.2, 0.06, -1.05), lv.glow(Color(0.3, 1.0, 0.85), 2.5))
		var light: OmniLight3D = lv.light(sp + Vector3(-1.0, 2.6, 0), Color(0.75, 0.85, 1.0) if not cult else Color(1.0, 0.6, 0.3), 1.0, 6.0, false)
		light.light_energy = 0.9
		var sc: CollisionObject3D = lv.interactable("hold_scene", LINES["prompts"]["scene"], sp + Vector3(0, 0.5, 0), Vector3(1.6, 1.0, 2.4), LINES["scan"]["scene"], false)
		sc.set_meta("encounter", "scene")
		sc.set_meta("faction", "cult" if cult else "company")
		lv._glyph_on(Vector3(12.88, 2.3, -79.0), -PI / 2.0, 0.012, "hold_glyph", true, false,
			"Rings on the wall over the sheet, done in something that had run. The inner ring was a door; the outer one was everybody who had walked through it.")
		if not cult:
			guard(lv, Vector3(9.6, 0.12, z0 - 3.0), PI, {"path": [Vector3(9.6, 0.12, z0 - 3.0), Vector3(9.6, 0.12, z1 + 3.0)], "zone": zone, "safe": safe}, "hold_guard")
			camera(lv, Vector3(12.5, 4.4, z0 - 0.6), 0.25, {"zone": zone, "safe": safe, "sweep": 0.35, "pitch": 0.5}, false, "hold_camera")
		else:
			cultist(lv, Vector3(9.4, 0.12, -70.0), PI, {"zone": zone, "safe": safe}, "hold_robe")
			cultist(lv, Vector3(10.5, 0.12, -90.0), 0.0, {"zone": zone, "safe": safe, "path": [Vector3(10.5, 0.12, -90.0), Vector3(8.6, 0.12, -76.0)]}, "hold_robe2")
	# night in Red Rock, Southtown, Rail Cut: addicts in the doorways
	if lv.night and did in ADDICTS:
		var spots := [[Vector3(-11.2, 0.12, -32.0), PI / 2.0], [Vector3(-11.6, 0.12, -6.0), PI / 2.0 + 0.4]]
		var count := 2 if did == "red_rock" else 1
		for i in count:
			addict(lv, spots[i][0], spots[i][1], {}, "addict%d" % i)


## E on someone these builders made.
static func interact(main: Node, node: Node) -> void:
	var ui = main.ui
	var fig: Node = node.get_parent()
	match str(node.get_meta("encounter")):
		"guard":
			var G: Dictionary = LINES["guard"]
			var L: Array = G["company"]
			if main.frames_on and main.connection >= 25.0:
				await ui.think(G["frames"])
			await ui.say("Security", L[absi(int(main.stealth.now)) % L.size()])
		"cultist":
			var C: Array = LINES["cultist"]
			await ui.think(C[absi(int(main.stealth.now)) % C.size()])
		"addict":
			if fig is Node3D:
				await main.melee.talk(fig as Node3D)
		"scene":
			var S: Dictionary = LINES["scene"]
			var key := "ev_hold_%s_d%d" % [str(main.city.district), int(main.day)]
			if main.flags.has(key):
				await ui.think(S["again"])
			else:
				main.flags[key] = true
				await ui.think(S[str(node.get_meta("faction", "company"))])
				main.log_line("evidence", S["log"] % main.city.district_name(str(main.city.district)))
				main.city.add_devotion(1, "witness")
		_:
			await ui.think("...")
