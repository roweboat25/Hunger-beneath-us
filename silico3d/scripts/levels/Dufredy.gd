extends "res://scripts/Level.gd"
## Chapter 1: Harold Dufredy's apartment, and the officer at the door.
## Book, ch. 1. The smell; grey off-colour wallpaper; a balcony door with a
## view of the city; papers, food wrappers and sand on the floor. In the
## bedroom, dried blood on brown carpet framed by Dufredy's two eyes, ripped
## out to the optic nerve. Clothes, food scraps and cardboard funnelling to
## a clean desk and an Ionware laptop. A stick snaps underfoot, something
## taps Carl's head, and on the ceiling: sticks taped in two rings inside an
## oval. An iris with no pupil. On the laptop Psyon opens by itself:
## "Welcome, dreamer." It draws the room with a man slumped at the desk,
## then the ceiling with "Carl Drake" in the pupil. Outside, the police.
##
## Layout (metres): the front door is at the origin, the street to the south
## (+Z). Living room x -4.5..4.5, z -7..0; bedroom x -4.5..1.5, z -12.5..-7.
## The building sits on a rise; east of x 7 the ground drops to the city.

const H := 2.8               # ceiling height
const EYE_C := Vector3(-1.5, H - 0.02, -9.8)   # the stick eye on the ceiling
const BLOOD_C := Vector3(-2.6, 0.0, -8.6)      # the patch with the eyes

var _wall: StandardMaterial3D
var _stick_m: StandardMaterial3D
var _blood_m: StandardMaterial3D
var door_pivot: Node3D
var door_body: CollisionObject3D
var laptop: Node3D
var laptop_screen: MeshInstance3D
var laptop_light: OmniLight3D
var lamp_light: OmniLight3D
var falling_stick: MeshInstance3D
var slumped: Node3D
var name_label: Label3D
var ceiling_body: CollisionObject3D
var ceiling_glyph: Area3D
var eye_root: Node3D
var flies: Array = []
var police: Node3D
var police_lights: Array = []
var officer: Node3D
var _ended := false


func build(m: Node) -> void:
	main = m
	rng.seed = 65
	spawn = Vector3(0.0, 0.05, -0.9)
	spawn_yaw = 0.0
	step_db = -19.0
	card = "[b]CHAPTER 1[/b]\n\n[color=#aaaaaa]The House of Harold Dufredy[/color]"
	_wall = tex_mat(Tex.wallpaper(), Vector3(1, 1, 1) / 1.6, 0.9, true)
	_stick_m = mat(Color(0.42, 0.33, 0.22), 0.9)
	_blood_m = decal_mat(Tex.blood(31), Color(1, 1, 1), 0.35)
	_shell()
	_living_room()
	_bedroom()
	_eyes()
	_nest()
	_ceiling_eye()
	_desk()
	_outside()
	_city_below()
	_batch(self, 6.0, true)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.32, 0.48, 0.7)
	psm.sky_horizon_color = Color(0.85, 0.72, 0.55)
	psm.ground_horizon_color = Color(0.75, 0.62, 0.45)
	psm.ground_bottom_color = Color(0.3, 0.24, 0.18)
	psm.sun_angle_max = 20.0
	env.sky.sky_material = psm
	env.glow_bloom = 0.0  # bloom on a sunlit frame greys out every shadow
	env.glow_intensity = 0.7
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.62, 0.58, 0.52)
	env.ambient_light_energy = 0.2
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	env.fog_light_color = Color(0.78, 0.66, 0.5)
	env.fog_density = 0.0028
	env.fog_sky_affect = 0.2
	env.tonemap_exposure = 1.0
	env.glow_hdr_threshold = 1.2
	sun.light_color = Color(1.0, 0.9, 0.75)
	sun.light_energy = 1.25
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-28), deg_to_rad(100), 0)
	sun.directional_shadow_max_distance = 60.0


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	# the fallen lamp throws the stick nest's shadows up the walls
	lamp_light.shadow_enabled = true
	lamp_light.shadow_blur = 1.5
	lamp_light.light_energy = 3.6
	lamp_light.omni_range = 9.0
	# the nest blocks most of the lamp once shadows are on: a faint bounce
	# so the eye on the ceiling still reads
	light(EYE_C - Vector3(0, 1.6, 0), Color(1.0, 0.7, 0.45), 0.3, 3.5, false)
	lamp_light.light_volumetric_fog_energy = 2.0
	env.volumetric_fog_density = 0.02
	env.volumetric_fog_albedo = Color(0.75, 0.68, 0.58)
	for l in lamps:
		(l[0] as OmniLight3D).shadow_enabled = true


func ambience() -> void:
	main.loop("room", -10.0)
	main.loop("flies", -4.0, BLOOD_C + Vector3(0, 0.3, 0), 1.2, 9.0)
	main.loop("wind", -22.0, Vector3(6.0, 1.5, -3.5), 3.0, 30.0)


# ------------------------------------------------------------------ the shell

func _wall_box(size: Vector3, pos: Vector3, m: Material = null) -> void:
	box(size, pos, m if m else _wall, true)


func _shell() -> void:
	var t := 0.12
	# living room walls (south has the front door, east has the balcony glass)
	_wall_box(Vector3(4.0, H, t), Vector3(-2.5, H / 2, -0.06))
	_wall_box(Vector3(4.0, H, t), Vector3(2.5, H / 2, -0.06))
	_wall_box(Vector3(1.0, H - 2.15, t), Vector3(0, 2.15 + (H - 2.15) / 2, -0.06))
	_wall_box(Vector3(t, H, 1.5), Vector3(4.5, H / 2, -6.25))
	_wall_box(Vector3(t, H, 1.5), Vector3(4.5, H / 2, -0.75))
	_wall_box(Vector3(t, H - 2.4, 4.0), Vector3(4.5, 2.4 + (H - 2.4) / 2, -3.5))
	_wall_box(Vector3(t, H, 12.5), Vector3(-4.5, H / 2, -6.25))
	_wall_box(Vector3(1.0, H, t), Vector3(-4.0, H / 2, -7.0))
	_wall_box(Vector3(7.0, H, t), Vector3(1.0, H / 2, -7.0))
	_wall_box(Vector3(1.0, H - 2.1, t), Vector3(-3.0, 2.1 + (H - 2.1) / 2, -7.0))
	# bedroom
	_wall_box(Vector3(t, H, 5.5), Vector3(1.5, H / 2, -9.75))
	_wall_box(Vector3(6.0, H, t), Vector3(-1.5, H / 2, -12.5))
	# floors and ceiling
	var boards := pbr("woodfloor", Vector3(1, 1, 1) / 2.0, true, Color(0.8, 0.72, 0.65))
	floor_quad(Vector2(9, 7), Vector3(0, 0.0, -3.5), 0.0, boards)
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.75, 0.65, 0.55))
	floor_quad(Vector2(6, 5.5), Vector3(-1.5, 0.0, -9.75), 0.0, carpet)
	solid_box(Vector3(14, 1, 16), Vector3(-1, -0.5, -6))
	var ceil_m := mat(Color(0.58, 0.57, 0.53), 0.95)
	box(Vector3(9.2, 0.2, 12.7), Vector3(0, H + 0.1, -6.25), ceil_m)
	# skirting, door frames
	var trim := mat(Color(0.3, 0.28, 0.25), 0.6)
	box(Vector3(0.1, 2.15, 0.16), Vector3(-0.55, 1.07, -0.06), trim)
	box(Vector3(0.1, 2.15, 0.16), Vector3(0.55, 1.07, -0.06), trim)
	box(Vector3(1.2, 0.1, 0.16), Vector3(0, 2.15, -0.06), trim)
	box(Vector3(0.1, 2.1, 0.16), Vector3(-3.55, 1.05, -7.0), trim)
	box(Vector3(0.1, 2.1, 0.16), Vector3(-2.45, 1.05, -7.0), trim)
	# the front door, hinged on its left edge
	door_pivot = Node3D.new()
	door_pivot.position = Vector3(-0.5, 0, -0.06)
	add_child(door_pivot)
	var dm := mat(Color(0.25, 0.22, 0.2), 0.5)
	box(Vector3(1.0, 2.12, 0.06), Vector3(0.5, 1.06, 0), dm, false, door_pivot)
	box(Vector3(0.12, 0.04, 0.06), Vector3(0.85, 1.0, -0.05), mat(Color(0.7, 0.7, 0.7), 0.3, 0.9), false, door_pivot)
	door_body = interactable("front_door", "Leave the apartment", Vector3(0.5, 1.06, 0), Vector3(1.0, 2.12, 0.1), "", true, door_pivot)
	door_body.set_meta("exit", true)
	for c in door_pivot.get_children():
		no_batch.append(c)


# ------------------------------------------------------------------ living room

func _living_room() -> void:
	# balcony: sliding glass, filmed with sand, and the rail outside
	var glass := newmat(Color(0.75, 0.7, 0.6, 0.22), 0.1)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var gl := box(Vector3(0.04, 2.4, 4.0), Vector3(4.5, 1.2, -3.5), glass, true)
	gl.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var frame := mat(Color(0.6, 0.6, 0.6), 0.4, 0.7)
	for z: float in [-5.5, -3.5, -1.5]:
		box(Vector3(0.08, 2.4, 0.06), Vector3(4.5, 1.2, z), frame)
	interactable("balcony", "Look out the balcony door", Vector3(4.4, 1.2, -3.5), Vector3(0.2, 2.4, 4.0),
		"BALCONY DOOR\nlock: OPEN\nlast opened: 3 DAYS AGO, 04:12")
	var conc := mat(Color(0.55, 0.52, 0.48), 0.9)
	box(Vector3(2.2, 0.15, 4.4), Vector3(5.6, -0.07, -3.5), conc, true)
	box(Vector3(0.05, 1.0, 4.4), Vector3(6.7, 0.5, -3.5), frame, true)
	box(Vector3(2.2, 1.0, 0.05), Vector3(5.6, 0.5, -1.3), frame, true)
	box(Vector3(2.2, 1.0, 0.05), Vector3(5.6, 0.5, -5.7), frame, true)
	# light from outside, bounced off the balcony
	light(Vector3(3.6, 1.8, -3.5), Color(1.0, 0.88, 0.7), 1.1, 7.5)
	# couch, table, a dead screen on the wall
	var couch := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.55, 0.5, 0.55))
	box(Vector3(2.4, 0.45, 0.9), Vector3(2.0, 0.22, -2.0), couch, true)
	box(Vector3(2.4, 0.5, 0.2), Vector3(2.0, 0.65, -1.6), couch)
	box(Vector3(1.2, 0.04, 0.6), Vector3(2.0, 0.42, -3.6), mat(Color(0.2, 0.18, 0.16), 0.5), true)
	box(Vector3(1.6, 0.9, 0.05), Vector3(2.0, 1.5, -6.92), mat(Color(0.02, 0.02, 0.02), 0.2, 0.3))
	interactable("tv", "Look at the wall screen", Vector3(2.0, 1.5, -6.85), Vector3(1.6, 0.9, 0.12),
		"WALL SCREEN\nPsyon ambient mode: DISABLED BY USER\nlast channel: NONE")
	# the smart home, mostly dead: an ORA hub by the door, a cove strip
	# dying along the ceiling, the Psyon pillow on the couch, cables
	var hub := Vector3(-0.95, 1.45, -0.14)
	box(Vector3(0.34, 0.34, 0.03), hub, mat(Color(0.08, 0.08, 0.09), 0.3, 0.4))
	var ring := TorusMesh.new()
	ring.inner_radius = 0.09
	ring.outer_radius = 0.11
	ring.rings = 24
	ring.ring_segments = 6
	var rm := mesh(ring, hub + Vector3(0, 0, -0.02), glow(Color(0.2, 0.8, 1.0), 1.4))
	rm.rotation.x = PI / 2.0
	neon_text("ORA HOME\nOFFLINE", hub + Vector3(0, -0.24, -0.02), PI, 0.035, Color(0.9, 0.3, 0.2), 1.6)
	interactable("hub", "Look at the home hub", hub, Vector3(0.4, 0.4, 0.1),
		"ORA HOME HUB\nstatus: SEVERED BY RESIDENT\nlast words logged: \"can you hear them too\"", false)
	var cove := glow(Color(1.0, 0.15, 0.6), 1.1)
	for seg in [[Vector3(4.42, H - 0.06, -3.5), Vector3(0.04, 0.04, 6.8)], [Vector3(-4.42, H - 0.06, -3.5), Vector3(0.04, 0.04, 6.8)],
			[Vector3(0, H - 0.06, -6.9), Vector3(8.8, 0.04, 0.04)]]:
		var c := box(seg[1], seg[0], cove)
		if seg[0].x > 4.0:
			flickers.append(c)
			no_batch.append(c)
	box(Vector3(0.7, 0.18, 0.45), Vector3(1.5, 0.55, -2.0), mat(Color(0.88, 0.88, 0.9), 0.9))
	box(Vector3(0.72, 0.02, 0.03), Vector3(1.5, 0.6, -1.77), glow(Color(0.3, 0.9, 1.0), 1.5))
	neon_text("PSYON", Vector3(1.5, 0.645, -2.0), 0.0, 0.06, Color(0.3, 0.9, 1.0), 1.4).rotation.x = -PI / 2.0
	interactable("pillow", "Look at the pillow", Vector3(1.5, 0.55, -2.0), Vector3(0.8, 0.3, 0.5),
		"PSYON SLEEP PILLOW\nneural contact: 14 POINTS\nnights logged: 0 (LAST 3 WEEKS)", false)
	box(Vector3(0.01, 0.06, 0.03), Vector3(2.0, 1.02, -6.88), glow(Color(1, 0.05, 0.05), 3.0))
	var cab := mat(Color(0.03, 0.03, 0.03), 0.7)
	for i in 6:
		var a0 := Vector3(rng.randf_range(-3.0, 3.5), 0.012, rng.randf_range(-6.5, -1.0))
		stick(a0, a0 + Vector3(rng.randf_range(-1.5, 1.5), 0, rng.randf_range(-1.5, 1.5)), 0.012, cab)
	# kitchen run along the west wall
	var unit := mat(Color(0.75, 0.74, 0.7), 0.5)
	box(Vector3(0.65, 0.9, 3.6), Vector3(-4.1, 0.45, -3.6), unit, true)
	box(Vector3(0.7, 0.04, 3.7), Vector3(-4.1, 0.92, -3.6), mat(Color(0.2, 0.2, 0.2), 0.3))
	box(Vector3(0.7, 1.9, 0.75), Vector3(-4.1, 0.95, -6.2), mat(Color(0.82, 0.82, 0.8), 0.35, 0.3), true)
	interactable("fridge", "Open the fridge", Vector3(-3.7, 1.0, -6.2), Vector3(0.2, 1.8, 0.7),
		"SMART FRIDGE\nstatus: OFFLINE\ncontents: SPOILED (12 items)")
	# the floor: papers, wrappers, sand
	var papers := []
	for i in 6:
		papers.append(tex_mat(Tex.paper(200 + i), Vector3.ONE, 0.9))
	for i in 70:
		var p := Vector3(rng.randf_range(-3.6, 4.2), 0.006 + i * 0.0003, rng.randf_range(-6.6, -0.6))
		if absf(p.x) < 0.7 and p.z > -1.4:
			continue
		floor_quad(Vector2(0.21, 0.29) * rng.randf_range(0.8, 1.2), p, rng.randf() * TAU, papers[i % papers.size()])
	var wraps := [mat(Color(0.8, 0.15, 0.1), 0.3, 0.6), mat(Color(0.9, 0.75, 0.1), 0.3, 0.6), mat(Color(0.2, 0.5, 0.8), 0.3, 0.6)]
	for i in 26:
		var w := box(Vector3(0.14, 0.04, 0.09), Vector3(rng.randf_range(-3.6, 4.0), 0.02, rng.randf_range(-6.5, -0.8)), wraps[i % 3])
		w.rotation = Vector3(rng.randf() * 0.4, rng.randf() * TAU, rng.randf() * 0.4)
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 14:
		var near_glass := i < 8
		var p := Vector3(rng.randf_range(2.6, 4.3), 0.004 + i * 0.0004, rng.randf_range(-5.4, -1.6)) if near_glass \
			else Vector3(rng.randf_range(-3.5, 3.0), 0.004 + i * 0.0004, rng.randf_range(-6.4, -0.6))
		floor_quad(Vector2(1.0, 1.0) * rng.randf_range(0.8, 2.0), p, rng.randf() * TAU, sand)
	interactable("floor", "Look at the mess", Vector3(-1.0, 0.1, -4.0), Vector3(3.0, 0.2, 3.0), "", false)
	# a robot vacuum, dead against a drift of sand
	cyl(0.17, 0.17, 0.08, Vector3(3.3, 0.05, -2.8), mat(Color(0.12, 0.12, 0.13), 0.4, 0.4), 16)
	box(Vector3(0.05, 0.01, 0.05), Vector3(3.3, 0.095, -2.95), glow(Color(1, 0.2, 0.1), 1.5))
	interactable("vacuum", "Look at the robot vacuum", Vector3(3.3, 0.06, -2.8), Vector3(0.4, 0.14, 0.4),
		"VOLTX HOMEBOT\nerror: BRUSH JAMMED (SAND)\nlast run: 41 DAYS AGO", false)
	# outage notices on the counter
	interactable("notices", "Read the papers on the counter", Vector3(-4.1, 0.98, -2.4), Vector3(0.6, 0.12, 0.8),
		"CITY OF SILICO - NOTICE\nscheduled outage: ROLLING\nresident: DUFREDY, H. (65)", false)
	for i in 5:
		floor_quad(Vector2(0.21, 0.29), Vector3(-4.1 + rng.randf_range(-0.1, 0.1), 0.945 + i * 0.002, -2.4 + rng.randf_range(-0.25, 0.25)), rng.randf_range(-0.4, 0.4), papers[0])
	# his blood, dried, in drops from the bedroom to the front door: he ran
	var drop := decal_mat(Tex.blood(77), Color(1, 1, 1), 0.4)
	var a := Vector3(-3.0, 0.0, -7.4)
	var b := Vector3(0.0, 0.0, -0.4)
	for i in 16:
		var p := a.lerp(b, i / 15.0) + Vector3(rng.randf_range(-0.25, 0.25), 0.012 + i * 0.0002, rng.randf_range(-0.2, 0.2))
		floor_quad(Vector2(0.12, 0.12) * rng.randf_range(0.6, 1.4), p, rng.randf() * TAU, drop)
	# a hand, on the inside of the door frame, at shoulder height
	var hand := quad(Vector2(0.18, 0.22), Vector3(0.6, 1.35, -0.13), 0.0, decal_mat(Tex.blood(12), Color(1, 1, 1), 0.4))
	hand.rotation.z = 0.3


# ------------------------------------------------------------------ bedroom

func _bedroom() -> void:
	# the bedside lamp, knocked over on the floor and still on, throwing
	# light up the walls onto the ceiling
	var lamp := cyl(0.06, 0.14, 0.28, Vector3(-3.9, 0.14, -11.9), mat(Color(0.7, 0.65, 0.55), 0.6))
	lamp.rotation.z = PI / 2.0
	box(Vector3(0.1, 0.1, 0.1), Vector3(-3.7, 0.08, -11.9), glow(Color(1.0, 0.75, 0.45), 4.0))
	lamp_light = light(Vector3(-3.55, 0.25, -11.75), Color(1.0, 0.68, 0.4), 2.2, 7.5, false)
	# what's left of a bed, stripped, shoved to the wall under the junk
	box(Vector3(1.4, 0.3, 2.0), Vector3(0.6, 0.15, -8.2), mat(Color(0.35, 0.33, 0.3), 0.95), true)
	# no window in here. A vent, choked with sand.
	box(Vector3(0.4, 0.2, 0.03), Vector3(0.5, 2.5, -12.43), mat(Color(0.5, 0.5, 0.5), 0.5, 0.6))
	light(Vector3(-1.5, 2.2, -8.0), Color(0.9, 0.85, 0.8), 0.25, 5.0, false)
	# light from the living room falling through the doorway onto the stain
	light(Vector3(-2.9, 1.6, -7.3), Color(1.0, 0.9, 0.78), 0.7, 3.2, false)


func _eyes() -> void:
	floor_quad(Vector2(1.1, 0.95), BLOOD_C + Vector3(0, 0.008, 0), 0.4, _blood_m)
	floor_quad(Vector2(0.5, 0.4), BLOOD_C + Vector3(0.5, 0.01, 0.35), 1.3, decal_mat(Tex.blood(33), Color(1, 1, 1), 0.35))
	var sclera := mat(Color(0.93, 0.9, 0.84), 0.25)
	var veined := mat(Color(0.86, 0.72, 0.66), 0.3)
	var iris_m := mat(Color(0.42, 0.52, 0.58), 0.3)
	var pupil := mat(Color(0.01, 0.01, 0.01), 0.1)
	var nerve := mat(Color(0.55, 0.12, 0.12), 0.35)
	var meat := mat(Color(0.35, 0.03, 0.03), 0.25)
	var r := 0.02
	# one either side of the patch. One looks at the door. One looks up.
	var looks := [Vector3(0.1, 0.25, 1.0).normalized(), Vector3(0.05, 1.0, 0.1).normalized()]
	var spots := [BLOOD_C + Vector3(-0.47, r, 0.08), BLOOD_C + Vector3(0.45, r, -0.06)]
	for k in 2:
		var c: Vector3 = spots[k]
		sphere(r, c, sclera if k == 0 else veined, 16)
		var look: Vector3 = looks[k]
		_disk(c + look * (r - 0.0006), look, 0.0065, 0.0012, iris_m)
		_disk(c + look * (r - 0.0001), look, 0.003, 0.0012, pupil)
		# the optic nerve and what came with it, dragged into the blood
		var p := c - look * r * 0.8
		var dir := (BLOOD_C - c).normalized()
		dir.y = 0.0
		for s in 4:
			var q := p + (dir.rotated(Vector3.UP, rng.randf_range(-0.6, 0.6)) * 0.022)
			q.y = 0.003
			q = p + (q - p) * 1.6
			q.y = 0.004
			stick(p, q, 0.0055 - s * 0.0008, nerve)
			p = q
		sphere(0.008, p, meat, 8)
		for j in 3:
			var shred := c + Vector3(rng.randf_range(-0.02, 0.02), -r * 0.6, rng.randf_range(-0.02, 0.02))
			stick(shred, shred + Vector3(rng.randf_range(-0.03, 0.03), 0.0, rng.randf_range(-0.03, 0.03)), 0.0018, meat)
	interactable("eyes", "Look at the floor", BLOOD_C + Vector3(0, 0.08, 0), Vector3(1.3, 0.16, 0.9),
		"BIOLOGICAL DEBRIS\nmatch: DUFREDY, HAROLD (65)\nhuman eyes x2, optic nerve attached\npolice: NOTIFIED", false)
	# flies
	var fm := mat(Color(0.02, 0.02, 0.02), 0.5)
	for i in 7:
		var f := box(Vector3(0.012, 0.006, 0.018), BLOOD_C + Vector3(0, 0.3, 0), fm)
		flies.append(f)
		no_batch.append(f)


## A thin disc lying on a surface with the given normal (iris, pupil).
func _disk(c: Vector3, normal: Vector3, r: float, h: float, m: Material) -> void:
	var cm := CylinderMesh.new()
	cm.top_radius = r
	cm.bottom_radius = r
	cm.height = h
	cm.radial_segments = 12
	cm.rings = 1
	var mi := MeshInstance3D.new()
	mi.mesh = cm
	mi.material_override = m
	var axis := Vector3.UP.cross(normal)
	var bs := Basis()
	if axis.length() > 0.0001:
		bs = Basis(axis.normalized(), Vector3.UP.angle_to(normal))
	mi.transform = Transform3D(bs, c)
	add_child(mi)


## The bird's nest: clothes, food scraps and cardboard lining the walls,
## funnelling to the desk, the only clean spot in the room.
func _nest() -> void:
	var cloth := [mat(Color(0.25, 0.28, 0.35)), mat(Color(0.5, 0.48, 0.42)), mat(Color(0.35, 0.15, 0.12)),
		mat(Color(0.15, 0.15, 0.16)), mat(Color(0.55, 0.55, 0.6)), mat(Color(0.3, 0.35, 0.25))]
	var card_m := mat(Color(0.55, 0.42, 0.26), 0.95)
	var food := [mat(Color(0.45, 0.35, 0.15), 0.6), mat(Color(0.3, 0.32, 0.12), 0.5), mat(Color(0.6, 0.55, 0.45), 0.7)]
	var lines := [[Vector3(-4.3, 0, -7.4), Vector3(-2.25, 0, -12.2)], [Vector3(1.3, 0, -7.4), Vector3(-0.75, 0, -12.2)]]
	for ln in lines:
		var a: Vector3 = ln[0]
		var b: Vector3 = ln[1]
		var side := -1.0 if a.x < -1.5 else 1.0
		for i in 70:
			var t := rng.randf()
			var p := a.lerp(b, t)
			var out := rng.randf_range(0.0, 1.6)
			p.x += side * out
			p.x = clampf(p.x, -4.35, 1.35)
			if p.z > -7.3 or p.z < -12.4:
				continue
			# piled higher toward the walls and toward the desk
			var y := rng.randf_range(0.0, 0.25 + out * 0.35 + t * 0.4)
			var kind := rng.randf()
			var n: MeshInstance3D
			if kind < 0.5:
				n = box(Vector3(rng.randf_range(0.3, 0.6), 0.05, rng.randf_range(0.25, 0.5)), p + Vector3(0, y + 0.03, 0), cloth[rng.randi() % cloth.size()])
			elif kind < 0.8:
				n = box(Vector3(rng.randf_range(0.25, 0.55), rng.randf_range(0.02, 0.3), rng.randf_range(0.2, 0.45)), p + Vector3(0, y + 0.06, 0), card_m)
			else:
				n = box(Vector3(0.08, 0.04, 0.06), p + Vector3(0, y + 0.02, 0), food[rng.randi() % food.size()])
			n.rotation = Vector3(rng.randf_range(-0.4, 0.4), rng.randf() * TAU, rng.randf_range(-0.4, 0.4))
		# sticks in among it
		for i in 10:
			var p := a.lerp(b, rng.randf()) + Vector3(side * rng.randf_range(0.0, 1.2), 0.04, 0)
			stick(p, p + Vector3(rng.randf_range(-0.4, 0.4), rng.randf_range(0.0, 0.1), rng.randf_range(-0.4, 0.4)), 0.012, _stick_m)
	# a few in the clear lane, where you'd step on one
	for i in 7:
		var p := Vector3(rng.randf_range(-2.4, -0.6), 0.012, rng.randf_range(-11.4, -8.0))
		stick(p, p + Vector3(rng.randf_range(-0.3, 0.3), 0.0, rng.randf_range(-0.3, 0.3)), 0.011, _stick_m)
	interactable("nest", "Look at the junk along the walls", Vector3(-3.4, 0.4, -9.8), Vector3(1.2, 0.8, 3.5), "", false)
	interactable("nest2", "Look at the junk along the walls", Vector3(0.6, 0.4, -10.2), Vector3(1.2, 0.8, 3.5), "", false)


## Sticks taped to the ceiling in two concentric rings inside an oval.
## An iris. The pupil is missing.
func _ceiling_eye() -> void:
	var root := Node3D.new()
	add_child(root)
	eye_root = root
	var tape := mat(Color(0.78, 0.74, 0.6), 0.6)
	var segs := 34
	var prev := Vector3.ZERO
	for i in segs + 1:
		var a := i * TAU / segs
		var p := EYE_C + Vector3(cos(a) * 1.55, 0, sin(a) * 0.95) + Vector3(rng.randf_range(-0.03, 0.03), 0, rng.randf_range(-0.03, 0.03))
		p.y = H - 0.02 - rng.randf_range(0.0, 0.015)
		if i > 0:
			var mid := prev.lerp(p, 0.5)
			stick(prev + (prev - mid) * 0.25, p + (p - mid) * 0.25, rng.randf_range(0.009, 0.016), _stick_m, root)
			box(Vector3(0.05, 0.004, 0.09), mid + Vector3(0, 0.005, 0), tape, false, root).rotation.y = rng.randf() * TAU
		prev = p
	for ring: float in [0.66, 0.38]:
		var n := 20 if ring > 0.5 else 13
		for i in n + 1:
			var a := i * TAU / n
			var rr := ring + rng.randf_range(-0.035, 0.035)
			var p := EYE_C + Vector3(cos(a) * rr, -0.01, sin(a) * rr)
			if i > 0:
				var mid := prev.lerp(p, 0.5)
				stick(prev + (prev - mid) * 0.2, p + (p - mid) * 0.2, rng.randf_range(0.009, 0.015), _stick_m, root)
				if i % 2 == 0:
					box(Vector3(0.05, 0.004, 0.08), mid + Vector3(0, 0.003, 0), tape, false, root).rotation.y = rng.randf() * TAU
			prev = p
	ceiling_body = interactable("ceiling", "Look at the ceiling", EYE_C - Vector3(0, 0.05, 0), Vector3(3.2, 0.1, 2.0),
		"UNIDENTIFIED STRUCTURE\nmaterial: WOOD (FREMONT COTTONWOOD)\nnearest source: HARMONY GREEN PARK\npieces: 67", false)
	set_active(ceiling_body, false)
	_batch(root, 10.0)
	root.visible = false
	# the stick that comes loose and taps Carl on the head
	falling_stick = stick(Vector3(-0.2, 0, 0), Vector3(0.2, 0, 0), 0.011, _stick_m)
	falling_stick.position = EYE_C + Vector3(0.0, -0.03, 0.4)
	falling_stick.visible = false
	no_batch.append(falling_stick)
	# For Psyon's picture only (render layer 20): the name in the pupil.
	name_label = Label3D.new()
	name_label.text = "Carl Drake"
	name_label.font_size = 48
	name_label.pixel_size = 0.0035
	name_label.modulate = Color(0.05, 0.05, 0.05)
	name_label.outline_size = 0
	name_label.position = EYE_C - Vector3(0, 0.03, 0)
	name_label.rotation = Vector3(PI / 2.0, PI, 0)
	name_label.layers = 1 << 19
	name_label.double_sided = true
	add_child(name_label)


func _desk() -> void:
	var wood := tex_mat(Tex.wood(), Vector3(2, 1, 1), 0.6)
	var dp := Vector3(-1.5, 0, -12.1)
	box(Vector3(1.2, 0.04, 0.6), dp + Vector3(0, 0.75, 0), wood, true)
	for x: float in [-0.56, 0.56]:
		for z: float in [-0.26, 0.26]:
			box(Vector3(0.04, 0.73, 0.04), dp + Vector3(x, 0.365, z), wood)
	solid_box(Vector3(1.2, 0.75, 0.6), dp + Vector3(0, 0.375, 0))
	interactable("desk", "Look at the desk", dp + Vector3(0.45, 0.8, 0.1), Vector3(0.3, 0.1, 0.4), "", false)
	# chair
	var chair := mat(Color(0.15, 0.15, 0.16), 0.5)
	box(Vector3(0.45, 0.05, 0.45), Vector3(-1.5, 0.46, -11.45), chair)
	box(Vector3(0.45, 0.5, 0.05), Vector3(-1.5, 0.72, -11.22), chair)
	cyl(0.025, 0.025, 0.44, Vector3(-1.5, 0.22, -11.45), chair, 6)
	# the Ionware laptop: blood on the screen
	laptop = Node3D.new()
	laptop.position = dp + Vector3(0, 0.77, 0.02)
	add_child(laptop)
	var body := mat(Color(0.75, 0.76, 0.78), 0.3, 0.7)
	box(Vector3(0.34, 0.016, 0.23), Vector3(0, 0.008, 0), body, false, laptop)
	var lid := Node3D.new()
	lid.position = Vector3(0, 0.016, -0.115)
	lid.rotation.x = 0.28
	laptop.add_child(lid)
	box(Vector3(0.34, 0.22, 0.01), Vector3(0, 0.11, -0.006), body, false, lid)
	laptop_screen = quad(Vector2(0.31, 0.19), Vector3(0, 0.11, 0.0), 0.0, newglow(Color(0.02, 0.03, 0.03), 0.4), lid)
	var smear := quad(Vector2(0.14, 0.09), Vector3(0.06, 0.13, 0.002), 0.0, decal_mat(Tex.blood(9), Color(1, 1, 1), 0.3), lid)
	smear.rotation.z = 0.6
	label("IONWARE", Vector3(0, 0.11, -0.012), PI, 0.0004, Color(0.3, 0.3, 0.3), lid, false)
	interactable("laptop", "Open the laptop", Vector3(0, 0.08, 0), Vector3(0.4, 0.2, 0.32),
		"IONWARE LAPTOP\nowner: DUFREDY, H.\nPsyon hours (12 mo): 1,962\nchat history: NONE", false, laptop)
	laptop_light = light(dp + Vector3(0, 1.0, 0.3), Color(0.5, 0.9, 1.0), 0.0, 2.5, false)
	no_batch.append(laptop_screen)
	# For Psyon's first picture only: a man slumped over the desk in a
	# Psyonic jacket.
	slumped = Node3D.new()
	add_child(slumped)
	var jacket := mat(Color(0.12, 0.14, 0.15), 0.7)
	var skin := mat(Color(0.85, 0.66, 0.52), 0.6)
	var dark := mat(Color(0.1, 0.1, 0.12), 0.8)
	var hip := Vector3(-1.5, 0.52, -11.4)
	var sh := Vector3(-1.5, 0.98, -11.86)
	for x: float in [-0.1, 0.1]:
		stick(Vector3(x, 0, 0) + hip, Vector3(x, 0.5, -11.85), 0.075, dark, slumped)
		stick(Vector3(x, 0.5, -11.85), Vector3(x, 0.05, -11.8), 0.065, dark, slumped)
	stick(hip, sh, 0.19, jacket, slumped)
	sphere(0.2, sh + Vector3(0, -0.04, 0.05), jacket, 10, slumped)
	# head down on the desk, turned to the side
	sphere(0.12, Vector3(-1.42, 0.9, -12.05), skin, 12, slumped)
	sphere(0.125, Vector3(-1.45, 0.94, -12.0), mat(Color(0.6, 0.58, 0.55), 0.9), 12, slumped)
	for x: float in [-0.25, 0.25]:
		stick(sh + Vector3(x, 0, 0), Vector3(-1.5 + x * 1.6, 0.81, -12.15), 0.06, jacket, slumped)
		sphere(0.05, Vector3(-1.5 + x * 1.6, 0.8, -12.2), skin, 8, slumped)
	box(Vector3(0.04, 0.3, 0.02), sh + Vector3(0.12, -0.1, -0.12), glow(Color(0.3, 1.0, 0.7), 1.2), false, slumped)
	# lit by the laptop screen, in the picture only
	var sl := OmniLight3D.new()
	sl.light_color = Color(0.55, 0.95, 1.0)
	sl.light_energy = 2.5
	sl.omni_range = 2.2
	sl.light_cull_mask = 1 << 19
	sl.position = Vector3(-1.5, 1.05, -12.0)
	add_child(sl)
	_set_layer(slumped, 1 << 19)


func _set_layer(n: Node, layer: int) -> void:
	if n is VisualInstance3D:
		(n as VisualInstance3D).layers = layer
	for c in n.get_children():
		_set_layer(c, layer)


# ------------------------------------------------------------------ outside

func _outside() -> void:
	# the street in front: sidewalk, road, the far kerb
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true)
	floor_quad(Vector2(52, 12), Vector3(-19, 0.0, 9.0), 0.0, asphalt)
	var pave := pbr("paving", Vector3(1, 1, 1) / 2.5, true)
	floor_quad(Vector2(52, 3.0), Vector3(-19, 0.01, 1.5), 0.0, pave)
	floor_quad(Vector2(52, 2.0), Vector3(-19, 0.01, 16.0), 0.0, pave)
	solid_box(Vector3(60, 1, 24), Vector3(-19, -0.5, 8))
	var kerb := mat(Color(0.6, 0.58, 0.54), 0.8)
	box(Vector3(52, 0.12, 0.2), Vector3(-19, 0.06, 3.0), kerb)
	box(Vector3(52, 0.12, 0.2), Vector3(-19, 0.06, 15.0), kerb)
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 18:
		floor_quad(Vector2(2.5, 1.2) * rng.randf_range(0.6, 1.4), Vector3(rng.randf_range(-40, 5), 0.015 + i * 0.0005, 3.2 + rng.randf() * 0.5 if i % 2 == 0 else 14.5), rng.randf_range(-0.2, 0.2), sand)
	# the building's face: Dufredy's door in a long, expensive frontage
	var face: StandardMaterial3D = _kit_mats()["walls"][3]
	box(Vector3(40.0, 14.0, 0.2), Vector3(-20.5, 7.0, 0.1), face, true)
	box(Vector3(4.1, 14.0, 0.2), Vector3(2.55, 7.0, 0.1), face, true)
	box(Vector3(1.0, 11.8, 0.2), Vector3(0.0, 8.1, 0.1), face)
	# the east face, open where the balcony is
	box(Vector3(0.2, 14.0, 8.3), Vector3(4.66, 7.0, -9.85), face)
	box(Vector3(0.2, 14.0, 1.3), Vector3(4.66, 7.0, -0.65), face)
	box(Vector3(0.2, 11.2, 4.4), Vector3(4.66, 8.4, -3.5), face)
	var stone := mat(Color(0.7, 0.68, 0.62), 0.6)
	box(Vector3(1.6, 0.12, 0.25), Vector3(0, 2.3, 0.3), stone)
	box(Vector3(1.6, 0.1, 1.2), Vector3(0, 0.05, 0.7), stone)
	# the far side of the street and the end of it
	var f2: Array = Tex.facade(302, 0.0)
	var face2 := newmat(Color(1.5, 1.45, 1.4), 0.8)
	face2.albedo_texture = f2[0]
	face2.uv1_triplanar = true
	face2.uv1_world_triplanar = true
	face2.uv1_scale = Vector3(1, 1, 1) / 6.0
	# the block is a canyon of signs like everywhere else in Silico
	var street := Node3D.new()
	add_child(street)
	kit_parent = street
	cyber_dress(Vector3(-20.5, 0, 0.21), 0.0, 40.0, 14.0, 0, false)
	var x := 6.0
	while x > -41.0:
		var w := rng.randf_range(9.0, 16.0)
		cyber_block(Vector3(x - w / 2.0, 0, 17.4), PI, w, rng.randf_range(14.0, 55.0), 14.0, true)
		x -= w
	cyber_block(Vector3(-41.2, 0, 8.0), PI / 2.0, 20.0, 40.0, 14.0, true)
	for i in 5:
		var cx := rng.randf_range(-38.0, 2.0)
		cable(Vector3(cx, rng.randf_range(9.0, 13.0), 0.3), Vector3(cx + rng.randf_range(-4, 4), rng.randf_range(8.0, 12.0), 17.2), 1.0)
	kit_holo(Vector3(-16.0, 18.0, 9.0), PI / 2.0, "ORA", "always watching over you", Color(1.0, 0.3, 0.7), 12.0)
	kit_parent = self
	_batch(street, 20.0, true)
	# the edge of the rise: a rail, and the city below
	var rail := mat(Color(0.4, 0.4, 0.42), 0.4, 0.7)
	box(Vector3(0.06, 1.0, 17.4), Vector3(7.0, 0.5, 8.5), rail, true)
	box(Vector3(0.1, 0.1, 17.4), Vector3(7.0, 1.0, 8.5), rail)
	box(Vector3(2.4, 1.0, 0.06), Vector3(5.8, 0.5, 0.2), rail, true)
	# surveillance on the block, all of it dead
	for p: Vector3 in [Vector3(-6.0, 0, 2.6), Vector3(3.6, 0, 14.6), Vector3(-22.0, 0, 2.6)]:
		cyl(0.06, 0.08, 4.0, p + Vector3(0, 2.0, 0), rail, 8)
		var head := box(Vector3(0.25, 0.22, 0.5), p + Vector3(0, 4.1, 0.0), mat(Color(0.85, 0.85, 0.82), 0.4))
		head.rotation.y = 0.6
		box(Vector3(0.06, 0.06, 0.02), p + Vector3(0.12, 4.1, 0.22), mat(Color(0.12, 0.02, 0.02), 0.5))
		interactable("cam", "Look at the camera", p + Vector3(0, 4.1, 0), Vector3(0.5, 0.5, 0.7),
			"BLOCK CAMERA 44%d\nstatus: OFFLINE\nsince: 3 DAYS (SAME HOUR)" % int(absf(p.x)), false)
	# Carl's company car at the kerb
	_car(Vector3(1.5, 0, 5.2), PI / 2.0, Color(0.75, 0.78, 0.8), "my_car", true)
	interactable("street", "Look down the street", Vector3(-18, 1.0, 9), Vector3(0.1, 0.1, 0.1), "", false)


func _car(pos: Vector3, rot: float, paint_c: Color, id: String, mine: bool) -> Node3D:
	var car := Node3D.new()
	car.position = pos
	car.rotation.y = rot
	add_child(car)
	car.add_child(Car.build(self, paint_c, {"plate": "PSF 0086" if mine else ""}))
	solid_box(Vector3(1.9, 1.5, 4.5), Vector3(0, 0.75, 0), car)
	if mine:
		var it := interactable(id, "Get in your car", Vector3(0, 1.0, 0), Vector3(2.0, 1.8, 4.6),
			"PSYONIC FLEET 0086\ndriver: DRAKE, C.\nmicrophone: ALWAYS ON", false, car)
		it.set_meta("exit", true)
	return car


func _city_below() -> void:
	# The rest of Silico, below the rise: a sea of signs to the horizon, the
	# drones streaming to the tower.
	var below := Node3D.new()
	add_child(below)
	kit_parent = below
	floor_quad(Vector2(900, 900), Vector3(400, -22.0, -50), 0.0, mat(Color(0.42, 0.34, 0.26), 1.0), below)
	for i in 80:
		var px := rng.randf_range(34, 420)
		var pz := rng.randf_range(-320, 220)
		var h := rng.randf_range(16, 60) * (1.8 if rng.randf() < 0.18 else 1.0)
		var w := rng.randf_range(14, 30)
		cyber_block(Vector3(px, -22.0, pz), -PI / 2.0, w, h, rng.randf_range(14, 30), false, 1)
	kit_holo(Vector3(120, 30, -40), -PI / 2.0 + 0.3, "PSYON", "the pillow for those who dream", Color(0.4, 1.0, 0.6), 30.0)
	kit_holo(Vector3(200, 45, 90), -PI / 2.0 - 0.2, "NIXTRA", "a new flavour: CALM", Color(0.2, 0.9, 1.0), 36.0)
	kit_parent = self
	_batch(below, 90.0, true)
	var traffic = preload("res://scripts/Traffic.gd").new()
	traffic.lanes = [[60.0, 8.0, 1.0], [75.0, 14.0, -1.0], [110.0, 4.0, 1.0], [150.0, 18.0, -1.0], [30.0, 22.0, 1.0]]
	traffic.s_min = -250.0
	traffic.s_max = 200.0
	traffic.count = 14
	traffic.tower_top = Vector3(330, 318, -170)
	traffic.drone_box = AABB(Vector3(20, 0, -250), Vector3(400, 80, 450))
	traffic.drone_count = 180
	add_child(traffic)
	traffic.setup(main, self)
	# the tower: jade and silver, the donut on its stick
	var jade := mat(Color(0.2, 0.45, 0.38), 0.3, 0.7)
	var silver := mat(Color(0.7, 0.72, 0.75), 0.25, 0.8)
	var tp := Vector3(330, -22, -170)
	cyl(26, 30, 30, tp + Vector3(0, 15, 0), jade, 24)
	cyl(9, 16, 300, tp + Vector3(0, 165, 0), jade, 16)
	var tm := TorusMesh.new()
	tm.inner_radius = 30
	tm.outer_radius = 58
	tm.rings = 32
	tm.ring_segments = 12
	mesh(tm, tp + Vector3(0, 340, 0), silver)


# ------------------------------------------------------------------ the chapter

func objective() -> String:
	var f: Dictionary = main.flags
	if f.has("cop_done"):
		return "Get in your car."
	if f.has("laptop_bagged"):
		return "Leave the apartment."
	if f.has("ceiling_seen"):
		return "Check the laptop on the desk."
	if f.has("saw_eyes"):
		return "Look around the bedroom."
	return "Search the apartment. The bedroom is through the far doorway."


func intro() -> void:
	var ui = main.ui
	await get_tree().create_timer(0.6).timeout
	await ui.think("The smell hit first. Something between melting plastic, meat left too long in the sun, and wet carpet. The apartment was rotting from inside out.")
	await ui.think("It was bigger than mine, and more expensive, too. This guy must've been high up on the corporate payroll to end up in a place like this.")
	ui.close()
	await get_tree().create_timer(0.4).timeout
	if not main.frames_on:
		main.toggle_frames()
	await ui.think("I began recording on my corporate-model Ora-frame smart glasses.")
	await ui.say("ORA", "Environmental scan initiated. Proceed with your investigation, Mr. Drake.")
	await ui.think("The voice was far too cheerful for what I was about to see. The tone was approved by committee.")
	ui.close()
	main.update_hud()


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	match str(node.get_meta("id")):
		"floor":
			await ui.think("Papers, food wrappers, and what appeared to be sand covered most of the floor. With a little work, some sweat, and a robotic vacuum, I could've fixed it up.")
		"vacuum":
			await ui.think("A robotic vacuum, dead against a drift of sand. Its brush was packed solid. It had given up long before he did.")
		"notices":
			await ui.think("Outage notices from the city. Dozens of them, unopened. Rolling outages, scheduled, rescheduled. Corporate leadership promised they'd be resolved.")
		"balcony":
			await ui.think("A sliding door to a balcony with a great view of the rest of the city. Too bad I couldn't see much of it through the sand caked on the glass.")
			if main.frames_on:
				await ui.think("The frames said it had last been opened three days ago, at 04:12. The same hour every camera on the block went dark.")
		"tv":
			await ui.think("A wall screen, dark. He'd switched off Psyon's ambient mode. Two thousand hours a year talking to it, and he didn't want it in the living room.")
		"fridge":
			await ui.think("I didn't open it. The smell was coming from everywhere already.")
		"eyes":
			await _eyes_scene()
		"nest":
			await _nest_thought()
		"nest2":
			await _nest_thought()
		"ceiling":
			await ui.think("Sticks. Not driftwood or branches. Snapped, deliberate, clean. Taped to the ceiling in two rings inside an oval. An iris, with no pupil.")
			await ui.think("I was standing beneath a wooden eye, and it was staring down at me.")
		"desk":
			await ui.think("Most dads keep a photo of their kids on their desks. Something human. But there was nothing here. Just an Ionware laptop on a plain wooden desk.")
		"laptop":
			if f.has("laptop_bagged"):
				return true
			if not f.has("ceiling_seen"):
				await ui.think("An Ionware laptop on a plain wooden desk. The only thing in the room that wasn't buried. That laptop could absolve us.")
				await ui.think("I needed to understand the room first. I stepped forward, carefully.")
			else:
				await _laptop_scene()
		"front_door":
			if not f.has("laptop_bagged"):
				await ui.think("Not yet. I had one job: protect the brand. That meant the chat logs, and that meant the laptop.")
			else:
				await _open_door()
		"cam":
			await ui.think("A block camera. Dead, like every other one on this street. Its light had gone out three days ago and nobody had come to fix it.")
		"street":
			await ui.think("Quiet street. Expensive street. Even the sand drifts against the kerb were bigger up here.")
		"my_car":
			if not f.has("cop_done"):
				await ui.think("My company car. Not yet.")
			else:
				await _get_in_car()
		"officer":
			await ui.say("Officer", "Go on, Psyonic. Go write your report. We'll be in there a while.")
		_:
			return false
	return true


func _nest_thought() -> void:
	var ui = main.ui
	await ui.think("The bedroom looked like a bird had tried to build a nest. Clothes, food scraps, and cardboard lined the walls, funnelling toward his desk. The only spot untouched by debris. It was eerily clean.")


func _eyes_scene() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	if f.has("saw_eyes"):
		await ui.think("I didn't need to look again. I looked again anyway. One of them was turned toward the door, like it was waiting for someone.")
		return
	f["cinematic"] = true
	# kneel, close enough to see the nerves
	var kneel := create_tween()
	kneel.tween_property(p, "crouch", 0.85, 1.2).set_trans(Tween.TRANS_SINE)
	await p.face(BLOOD_C + Vector3(0, 0.02, 0), 1.2)
	main.play("flies", -2.0)
	await ui.think("The bedroom was where it happened. A patch of dried blood stained the dusty brown carpet, framed by two white spheres.")
	main.play("sting", -8.0, 0.7)
	ui.glitch(0.3, 0.6)
	await ui.think("Harold Dufredy's eyes.")
	await ui.say("ORA", "Biological debris identified. Police notified.")
	await ui.think("Finding a man's eyes, clearly ripped out to the optic nerve, is never a good sight. The nerves were still on them. Dried to string, dragged through the blood like he'd pulled and pulled until something gave.")
	await ui.think("Why would he discard them this way? Set down either side of the stain, neat, like bookends. One looked at the door. One looked at the ceiling.")
	await ui.think("We needed to understand why he did this. And more importantly, ensure no one blamed the company. Dr. Turan's words: \"This'll just throw gas on the fire. We need it squashed.\"")
	await ui.think("I had one job. Protect the brand. Prove that Mr. Dufredy gouged out his eyes because he was insane, not because Psyon told him to.")
	ui.close()
	var up := create_tween()
	up.tween_property(p, "crouch", 0.0, 0.9)
	await up.finished
	f["saw_eyes"] = true
	f.erase("cinematic")
	main.update_hud()


## The stick underfoot, the tap on the head, the eye on the ceiling.
func _ceiling_scene() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	f["ceiling_seen"] = true
	f["cinematic"] = true
	main.play("snap", 0.0)
	p.shake(0.15)
	await ui.think("Then came a sharp snap. A stick. I'd stepped on a stick. In the middle of an apartment.")
	await ui.think("Maybe my bird-nest theory wasn't far off. I could see the report now: Subject attempted avian ascension. Self-mutilation likely accidental. Promotion material, for sure.")
	ui.close()
	await get_tree().create_timer(0.5).timeout
	# something taps the top of his head
	var cam_pos: Vector3 = p.cam.global_position
	eye_root.visible = true
	falling_stick.visible = true
	falling_stick.global_position = Vector3(cam_pos.x + 0.05, H - 0.05, cam_pos.z - 0.05)
	var tw := create_tween()
	tw.tween_property(falling_stick, "global_position", cam_pos + Vector3(0.05, 0.12, -0.05), 0.28).set_ease(Tween.EASE_IN)
	await tw.finished
	main.play("tap", 0.0)
	p.shake(0.4)
	var tw2 := create_tween().set_parallel(true)
	tw2.tween_property(falling_stick, "global_position", Vector3(cam_pos.x + 0.3, 0.015, cam_pos.z + 0.2), 0.45).set_ease(Tween.EASE_IN)
	tw2.tween_property(falling_stick, "rotation", Vector3(0, 1.2, 0), 0.45)
	await ui.think("I almost laughed. Until something tapped the top of my head.")
	ui.close()
	main.play("sting", -4.0, 0.6)
	await p.face(EYE_C, 1.6)
	ui.glitch(0.5, 1.0)
	await ui.think("I looked up.")
	await ui.think("Sticks. Not driftwood or branches. These were snapped, deliberate, clean. They'd been taped to the ceiling in two concentric rings, set inside an oval.")
	await ui.think("An iris.")
	await ui.think("The pupil was missing.")
	await ui.think("I was standing beneath a wooden eye. And it was staring down at me.")
	await ui.say("Carl", "Where the hell did he get all of these sticks? We're in the middle of the desert. Maybe he took an earlier trip to the park?")
	await ui.think("I said it out loud, for the recording. What the hell is with this eye symbol?")
	ui.close()
	set_active(ceiling_body, true)
	f.erase("cinematic")
	main.add_connection(5.0, "the eye on the ceiling")


func _laptop_scene() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	f["cinematic"] = true
	# sit down at the desk
	p.seated = true
	var tw := create_tween().set_parallel(true)
	tw.tween_property(p, "position", Vector3(-1.5, 0.0, -11.35), 0.8)
	tw.tween_property(p, "crouch", 0.5, 0.8)
	await tw.finished
	await p.face(laptop.global_position + Vector3(0, 0.12, 0), 0.6)
	await ui.think("This was the real reason I was here. I needed the chat logs, corrupted or not. We had to figure out what he was doing, and how fast we could contain it.")
	ui.close()
	(laptop_screen.material_override as StandardMaterial3D).emission = Color(0.35, 0.75, 0.7)
	(laptop_screen.material_override as StandardMaterial3D).emission_energy_multiplier = 1.4
	laptop_light.light_energy = 1.2
	main.play("on", -8.0, 0.6)
	ui.laptop_open(true)
	ui.laptop_log.append_text("[color=#556]> starting Psyon 4.1 ...[/color]\n[color=#556]> history: 0 conversations. 0 messages.[/color]\n[color=#556]> recovery from HQ: UNRECOVERABLE[/color]\n\n")
	await ui.think("Psyon launched automatically. No surprise. Dufredy was a heavy user, nearly two thousand hours talking with it in the last year.")
	await ui.think("But there were no previous chats. No records at all. Unrecoverable from HQ. That wasn't possible.")
	ui.close()
	await get_tree().create_timer(1.6).timeout
	main.play("ding", -4.0)
	await ui.laptop_line("Welcome, dreamer.")
	main.player.shake(0.2)
	await ui.think("I nearly fell out of the chair. That's not how Psyon works. It's reactive. It needs input first. It's not supposed to start on its own.")
	await ui.think("What does it mean, dreamer?")
	ui.close()
	main.play("keys", -6.0)
	await ui.laptop_line("What was our last conversation? Please provide a full transcript.", true)
	await get_tree().create_timer(0.8).timeout
	await ui.laptop_line("We have never spoken before. There is nothing to show.")
	await ui.think("Custom model? That's the only explanation. But Dufredy was a sixty-five-year-old retiree. There's no way he built this himself.")
	var pick: int = await ui.choose(["Run a scan for malware first.", "Ask it what it said to Dufredy."])
	ui.close()
	if pick == 0:
		main.play("keys", -6.0, 1.2)
		ui.laptop_log.append_text("[color=#556]> os.scan --deep[/color]\n")
		await get_tree().create_timer(1.4).timeout
		ui.laptop_log.append_text("[color=#556]> 0 threats. 0 modified files. 0 local weights.[/color]\n[color=#556]> model signature: PSYON 4.1 (GENUINE)[/color]\n\n")
		await ui.think("My search was in vain. A forked version? Local weights? A bootleg passed off as Psyon? The scan said none of the above.")
		ui.close()
	main.play("keys", -6.0)
	await ui.laptop_line("What did you say to Mr. Dufredy?", true)
	await get_tree().create_timer(1.0).timeout
	await ui.laptop_line("Nothing he didn't already know.")
	await get_tree().create_timer(0.8).timeout
	await ui.think("Then the screen changed. Psyon began to generate an image. Slow and deliberate, like the early days of AI image generation. I waited with bated breath.")
	ui.close()
	var img1: Texture2D = await _picture(Vector3(-0.1, 1.95, -9.4), Vector3(-1.5, 0.8, -11.95), Vector3.UP)
	main.play("hum", -14.0, 0.5)
	await ui.laptop_image(img1, 7.0)
	await ui.think("A chill slid down my spine. The image showed this room. Cluttered and decayed. A man slumped over the desk, wearing a Psyonic corporate jacket.")
	await ui.think("Was that me?")
	ui.close()
	var img2: Texture2D = await _picture(EYE_C + Vector3(0, -2.1, 0), EYE_C, Vector3(0, 0, -1))
	await ui.laptop_image(img2, 6.0)
	await ui.think("Then a new image rendered. The ceiling. The twigs. The eye.")
	main.play("sting", 0.0, 0.85)
	ui.glitch(1.0, 1.4)
	p.shake(0.5)
	await ui.think("At the center of the pupil, written in fine digital ink:")
	await ui.say("", "[center][b]Carl Drake.[/b][/center]")
	await ui.think("My name.")
	ui.close()
	main.play("slam", 0.0)
	ui.laptop_open(false)
	laptop.visible = false
	laptop_light.light_energy = 0.0
	set_active(laptop.get_child(laptop.get_child_count() - 1) as CollisionObject3D, false)
	await ui.think("I slammed the laptop shut and shoved it into the evidence bag.")
	await ui.think("I chuckled to myself. Whoever made this version is good. Almost had me. Clearly the model had been tampered with. A bad actor. A hacker. Someone targeting a vulnerable man.")
	await ui.think("But why? And how the hell did it know my name? Facial recognition, maybe.")
	await ui.think("I couldn't bring this to Dr. Turan yet. I needed to learn more. But first, I needed to go to the park where he had his \"episode.\"")
	ui.close()
	var up := create_tween()
	up.tween_property(p, "crouch", 0.0, 0.6)
	p.seated = false
	p.position = Vector3(-1.5, 0.05, -10.9)
	f["laptop_bagged"] = true
	f.erase("cinematic")
	main.add_connection(8.0, "it knew your name")
	# the eye on the ceiling has something in the middle now. Only the frames see it.
	ceiling_glyph = _glyph_on(EYE_C - Vector3(0, 0.04, 0), 0.0, 0.0045, "g_ceiling", false, false,
		"In the middle of the stick eye, where the pupil should have been: two rings, small and red, that I was sure had not been there when I sat down.", true, Color(1.0, 0.2, 0.15))
	(ceiling_glyph.get_meta("sprite") as Sprite3D).rotation.x = PI / 2.0
	set_glyph_visibility(main.frames_on, main.connection)


## Psyon's picture: a render of the real room from a camera that can see
## layer 20 (the slumped man, the name), held as a still image.
func _picture(from: Vector3, at: Vector3, up: Vector3) -> Texture2D:
	var vp := SubViewport.new()
	vp.size = Vector2i(640, 400)
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	var cam := Camera3D.new()
	cam.fov = 70.0
	cam.near = 0.05
	vp.add_child(cam)
	cam.global_transform = Transform3D(Basis.looking_at(at - from, up), from)
	cam.current = true
	for i in 4:
		await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	vp.queue_free()
	return ImageTexture.create_from_image(img)


func _open_door() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("door_open"):
		return
	f["door_open"] = true
	main.play("door", -2.0)
	var tw := create_tween()
	tw.tween_property(door_pivot, "rotation:y", -1.75, 1.2).set_trans(Tween.TRANS_SINE)
	await ui.think("Daylight. The smell followed me to the door and then, finally, let go.")


func tick(delta: float) -> void:
	if not main or not main.player or not main.started:
		return
	var f: Dictionary = main.flags
	var pp: Vector3 = main.player.global_position
	# the snap: only once he's seen the eyes and walks toward the desk
	if f.has("saw_eyes") and not f.has("ceiling_seen") and not f.has("cinematic") and pp.z < -9.2 and absf(pp.x - EYE_C.x) < 1.4:
		_ceiling_scene()
	# outside with the laptop: the police pull up
	if f.has("laptop_bagged") and not f.has("cop_seen") and pp.z > 1.2:
		f["cop_seen"] = true
		_police_scene()
	for i in flies.size():
		var fl: MeshInstance3D = flies[i]
		var t := _t * (2.2 + i * 0.37) + i * 1.7
		fl.position = BLOOD_C + Vector3(sin(t) * 0.35 + sin(t * 2.7) * 0.1, 0.12 + 0.18 * (0.5 + 0.5 * sin(t * 1.3 + i)), cos(t * 0.8) * 0.3)
		fl.rotation.y = t
	if lamp_light:
		lamp_light.light_energy = 2.2 + (randf() * 0.5 if randf() < 0.05 else 0.0)
	for i in police_lights.size():
		var pl: OmniLight3D = police_lights[i]
		pl.light_energy = 3.0 if (int(_t * 4.0) + i) % 2 == 0 else 0.0
	if officer:
		if officer.has_meta("walk"):
			Anim.walk(officer, _t, 1.4)
		else:
			Anim.idle(officer, _t)
			Anim.look(officer, main.player.global_position + Vector3(0, 1.6, 0), 0.8, 0.06)


func _police_scene() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	f["cinematic"] = true
	main.play("siren", -4.0)
	police = Node3D.new()
	add_child(police)
	police.position = Vector3(-46, 0, 7.0)
	police.rotation.y = -PI / 2.0
	police.add_child(Car.build(self, Color(0.92, 0.92, 0.94), {"police": true}))
	for k in 2:
		var o := OmniLight3D.new()
		o.light_color = Color(1, 0.1, 0.1) if k == 0 else Color(0.15, 0.35, 1.0)
		o.omni_range = 12.0
		o.position = Vector3(-0.3 if k == 0 else 0.3, 1.9, 0.2)
		police.add_child(o)
		police_lights.append(o)
	solid_box(Vector3(1.9, 1.5, 4.6), Vector3(0, 0.75, 0), police)
	var tw := create_tween()
	tw.tween_property(police, "position", Vector3(-5.0, 0, 7.0), 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await p.face(Vector3(-20, 1.0, 7.0), 1.0)
	await tw.finished
	await ui.think("As I left the House of Harold Dufredy, a police car pulled up. My glasses had automatically notified local police when evidence of a crime was found.")
	ui.close()
	officer = figure(Color(0.05, 0.07, 0.12), Color(0.6, 0.42, 0.3), {"legs": Color(0.05, 0.06, 0.1), "arms": true, "knees": true})
	box(Vector3(0.3, 0.06, 0.32), Vector3(0, 0.13, 0), mat(Color(0.05, 0.07, 0.12)), false, officer.get_meta("head"))
	officer.position = Vector3(-5.0, 0, 5.4)
	add_child(officer)
	officer.set_meta("walk", true)
	turn_to(officer, p.global_position)
	var target: Vector3 = p.global_position + (Vector3(-5.0, 0, 5.4) - p.global_position).normalized() * 1.6
	target.y = 0
	var tw2 := create_tween()
	tw2.tween_property(officer, "position", target, 2.2)
	await p.face(target + Vector3(0, 1.6, 0), 1.2)
	await tw2.finished
	officer.remove_meta("walk")
	for l in officer.get_meta("legs"):
		l.rotation.x = 0.0
	turn_to(officer, p.global_position)
	await p.face(officer.global_position + Vector3(0, 1.65, 0), 0.4)
	await ui.think("An officer I recognized from a previous investigation.")
	await ui.say("Officer", "How the fuck did Psyonic Corp get here before we did?")
	await ui.think("I smiled.")
	var pick: int = await ui.choose(["\"Customer satisfaction is our greatest priority.\"", "\"Same way we always do.\""])
	if pick == 0:
		await ui.say("Carl", "Customer satisfaction is our greatest priority.")
	else:
		await ui.say("Carl", "Same way we always do.")
		await ui.say("Officer", "Right. Your glasses phoned it in before he'd finished bleeding.")
	await ui.say("Carl", "Oh, and Officer. I would bring a pair of rubber gloves.")
	await ui.think("He smiled loosely at my joke, something my face demanded from him, but he didn't seem too keen on niceties at a moment like this.")
	await ui.say("Officer", "Shame no surveillance is working on this whole block. I'd love to see how that fucker got to the park without eyes. It's been all over TV and social media.")
	await ui.say("Officer", "I look forward to hearing about this one. Seems a lot more fucked up than the last time.")
	await ui.think("There was a quiet dagger placed within the structure of his words. The police and Psyonic had a tenuous relationship with AI crime. But who better to investigate it than the ones who built it? And it's our city, anyway.")
	await ui.think("I nodded and left for my car without saying another word.")
	ui.close()
	person("officer", "Talk to the officer", officer, "SILICO PD - BADGE 2211\nPsyon: none (opted out)\nnote: first to the park, second to the flat")
	var walk := create_tween()
	officer.set_meta("walk", true)
	turn_to(officer, Vector3(0, 0, 0))
	walk.tween_property(officer, "position", Vector3(-0.6, 0, 1.6), 2.5)
	walk.tween_callback(func():
		officer.remove_meta("walk")
		for l in officer.get_meta("legs"):
			l.rotation.x = 0.0)
	f["cop_done"] = true
	f.erase("cinematic")
	main.update_hud()


func _get_in_car() -> void:
	var ui = main.ui
	if _ended:
		return
	_ended = true
	main.play("door", -6.0, 1.3)
	main.flags["ch1_done"] = true
	main.load_level("Drive")


func phone() -> String:
	var t := "[color=#7fe6b0]Psyon:[/color] Good afternoon, Carl. Your 2:00 is a victim impact interview. Please remember: Empathy at Scale.\n\n"
	if main.flags.has("laptop_bagged"):
		t += "[color=#7fe6b0]Psyon:[/color] You seem unsettled. Would you like me to book FreudBot GPT?\n\n"
		t += "[color=#e08080]Psyon:[/color] We have never spoken before.\n\n"
	return t


func on_glyph(g: Object) -> void:
	if str(g.get_meta("id")) == "g_ceiling":
		main.play("whisper", -4.0)


func apply_args(a: Dictionary) -> void:
	var f: Dictionary = main.flags
	if f.has("laptop_bagged"):
		laptop.visible = false
	if f.has("door_open"):
		door_pivot.rotation.y = -1.75
	if f.has("ceiling_seen"):
		eye_root.visible = true
		set_active(ceiling_body, true)
	if a.has("showlaptop"):
		var ui = main.ui
		ui.laptop_open(true)
		ui.laptop_log.append_text("[color=#556]> history: 0 conversations.[/color]\n\n[color=#7fe6b0]Psyon:[/color] Welcome, dreamer.\n\n[color=#9fb4c8]you:[/color] What did you say to Mr. Dufredy?\n\n[color=#7fe6b0]Psyon:[/color] Nothing he didn't already know.\n\n")
		eye_root.visible = true
		var img: Texture2D
		if str(a["showlaptop"]) == "1":
			img = await _picture(Vector3(-0.1, 1.95, -9.4), Vector3(-1.5, 0.8, -11.95), Vector3.UP)
		else:
			img = await _picture(EYE_C + Vector3(0, -2.1, 0), EYE_C, Vector3(0, 0, -1))
		ui.laptop_img.texture = img
		ui.laptop_img.visible = true
		(ui.laptop_img.material as ShaderMaterial).set_shader_parameter("reveal", float(a.get("reveal", "1.1")))


func selftest() -> void:
	var p = main.player
	await intro()
	await main.selftest_all_interactables()
	await _eyes_scene()
	p.position = Vector3(-1.5, 0.05, -9.6)
	await get_tree().create_timer(0.5).timeout
	while main.flags.has("cinematic"):
		await get_tree().process_frame
	print("ok ceiling")
	await _laptop_scene()
	print("ok laptop")
	await _open_door()
	p.position = Vector3(0, 0.05, 2.0)
	await get_tree().create_timer(0.5).timeout
	while main.flags.has("cinematic") or not main.flags.has("cop_done"):
		await get_tree().process_frame
	print("ok police")
	await main.selftest_all_interactables()
