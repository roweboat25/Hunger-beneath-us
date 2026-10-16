extends Node
class_name StreetFX
## The cyberpunk dressing of a street at runtime: neon signs and lamp posts
## throw light, holo ads shimmer, big screens cycle their adverts, vents
## breathe steam, a hover car drifts along the elevated lane, and rain falls
## after dark. Props are found by the metadata gen_maps.py wrote on them:
##   neon = "hex"   a sign; the light takes that colour
##   holo = true    a holographic ad (<name>2.png is its second frame)
##   big = true     a billboard screen, pair "bigscreen" (cycles 1..4)
##   steam = true   a vent
##   hover = true   a hover car
## A Psyon outage dims every powered light; the outage handler in
## StreetScene swaps the big screens to static like the other screens.

const LIGHT_TEX := "res://assets/ui/light.png"
const NEON_SCALE := 0.75
const LAMP_SCALE := 0.8
const BIG_FRAMES := ["bigscreen", "bigscreen2", "bigscreen3", "bigscreen4"]

var _lights: Array[PointLight2D] = []
var _powered: Array[PointLight2D] = []
var _holos: Array = []
var _bigs: Array[Sprite2D] = []
var _vents: Array[Sprite2D] = []
var _hovers: Array[Sprite2D] = []
var _rain: Node2D
var _time := 0.0
var _big_t := 0.0
var _big_i := 0
var _map_w := 1280.0
var _map_h := 720.0
var _light_tex: Texture2D
var _puff_tex: Array[Texture2D] = []


func setup(map: Node2D, rain := true) -> void:
	_light_tex = load(LIGHT_TEX)
	_puff_tex = [load("res://assets/props/steam_puff.png"), load("res://assets/props/steam_puff2.png")]
	var ground: TileMapLayer = map.get_node_or_null("Ground")
	if ground:
		var r := ground.get_used_rect()
		_map_w = (r.position.x + r.size.x) * 32.0
		_map_h = (r.position.y + r.size.y) * 32.0
	var actors := map.get_node_or_null("Actors")
	if actors == null:
		return
	for node in actors.get_children():
		if not (node is Sprite2D):
			continue
		var s: Sprite2D = node
		if s.has_meta("neon"):
			_add_light(s, Color("#" + String(s.get_meta("neon"))), NEON_SCALE, 1.4, true)
		elif s.has_meta("holo"):
			var alt := load(s.texture.resource_path.replace(".png", "2.png"))
			_holos.append({"node": s, "a": s.texture, "b": alt, "t": randf()})
			_add_light(s, Color("4be0ff"), 0.45, 0.6, true)
		elif s.has_meta("big"):
			_bigs.append(s)
			_add_light(s, Color("7fb6ff"), 1.1, 0.9, true)
		elif s.has_meta("steam"):
			_vents.append(s)
		elif s.has_meta("hover"):
			_hovers.append(s)
		elif s.name.ends_with("_lamp_post"):
			_add_light(s, Color("ffc46a"), LAMP_SCALE, 0.75, true, false)
	_set_day_night()
	Game.outage_changed.connect(_on_outage)
	if rain and Game.is_night():
		_make_rain(map)


func _add_light(s: Sprite2D, col: Color, scl: float, energy: float, powered: bool, flicker := true) -> void:
	var l := PointLight2D.new()
	l.texture = _light_tex
	l.color = col
	l.energy = energy
	l.texture_scale = scl
	l.blend_mode = Light2D.BLEND_MODE_ADD
	l.shadow_enabled = false
	l.position = s.offset + Vector2(0, -4)
	l.set_meta("base", energy)
	s.add_child(l)
	# A light only brightens what it falls on, so a dark wall shows nothing;
	# an additive halo behind the sign is the glow the eye expects.
	var g := Sprite2D.new()
	g.texture = _light_tex
	g.position = l.position
	g.scale = Vector2(scl * 0.7, scl * 0.7)
	g.modulate = Color(col, 0.4 * energy)
	g.set_meta("alpha", g.modulate.a)
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	g.material = mat
	g.show_behind_parent = true
	s.add_child(g)
	l.set_meta("glow", g)
	_lights.append(l)
	if powered:
		_powered.append(l)
		if flicker and randf() < 0.45:
			_flicker(l)


func _flicker(l: PointLight2D) -> void:
	var base: float = l.get_meta("base")
	var g: Sprite2D = l.get_meta("glow")
	var ga: float = g.get_meta("alpha")
	var t := create_tween().set_loops()
	t.set_parallel(false)
	t.tween_property(l, "energy", base * 0.35, 0.05).set_delay(randf_range(1.5, 5.0))
	t.parallel().tween_property(g, "modulate:a", ga * 0.3, 0.05)
	t.tween_property(l, "energy", base, 0.08)
	t.parallel().tween_property(g, "modulate:a", ga, 0.08)
	t.tween_property(l, "energy", base * 0.6, 0.04).set_delay(0.12)
	t.parallel().tween_property(g, "modulate:a", ga * 0.5, 0.04)
	t.tween_property(l, "energy", base, 0.06)
	t.parallel().tween_property(g, "modulate:a", ga, 0.06)


func _set_day_night() -> void:
	var k := 1.0 if Game.is_night() else 0.5
	for l in _lights:
		l.energy = float(l.get_meta("base")) * k
		l.set_meta("base", l.energy)
		var g: Sprite2D = l.get_meta("glow")
		g.modulate.a = float(g.get_meta("alpha")) * k
		g.set_meta("alpha", g.modulate.a)


func _on_outage(on: bool) -> void:
	for l in _powered:
		l.visible = not on
		(l.get_meta("glow") as Sprite2D).visible = not on
	for h in _holos:
		h["node"].visible = not on


func _process(delta: float) -> void:
	_time += delta
	# Holograms: flip frames and pulse.
	for h in _holos:
		var s: Sprite2D = h["node"]
		if not s.visible:
			continue
		h["t"] += delta
		s.texture = h["b"] if fmod(h["t"], 0.5) < 0.25 else h["a"]
		s.modulate.a = 0.72 + 0.2 * sin(_time * 5.0 + s.position.x)
		if fmod(h["t"], 3.7) < 0.06:
			s.offset.x = randf_range(-2, 2)
		else:
			s.offset.x = 0
	# Big screens cycle adverts every few seconds.
	_big_t += delta
	if _big_t > 3.2 and not _bigs.is_empty():
		_big_t = 0.0
		_big_i = (_big_i + 1) % BIG_FRAMES.size()
		var tex: Texture2D = load("res://assets/props/" + BIG_FRAMES[_big_i] + ".png")
		for b in _bigs:
			b.texture = tex
	# Vents breathe.
	for v in _vents:
		if randf() < delta * 0.7:
			_puff(v)
	# Hover cars drift along their lane and wrap.
	for c in _hovers:
		c.position.x += delta * 38.0
		c.offset.y = -17 + 2.0 * sin(_time * 2.0 + c.position.x)
		if c.position.x > _map_w + 40:
			c.position.x = -40


func _puff(v: Sprite2D) -> void:
	var p := Sprite2D.new()
	p.texture = _puff_tex[randi() % 2]
	p.position = Vector2(randf_range(-4, 4), -8)
	p.modulate = Color(1, 1, 1, 0.0)
	p.scale = Vector2(0.6, 0.6)
	p.z_index = 1
	v.add_child(p)
	var t := create_tween()
	t.set_parallel(true)
	t.tween_property(p, "modulate:a", 0.55, 0.4)
	t.tween_property(p, "position:y", -60.0, 2.6)
	t.tween_property(p, "scale", Vector2(1.3, 1.3), 2.6)
	t.chain().tween_property(p, "modulate:a", 0.0, 1.0)
	t.chain().tween_callback(p.queue_free)


## Rain after dark: a scrolling field of streaks over the whole map.
func _make_rain(map: Node2D) -> void:
	_rain = Node2D.new()
	_rain.name = "Rain"
	_rain.z_index = 50
	map.add_child(_rain)
	var drops := int(_map_w * _map_h / 2600.0)
	for i in drops:
		var d := Line2D.new()
		d.width = 1.0
		d.default_color = Color(0.72, 0.82, 1.0, randf_range(0.18, 0.4))
		d.add_point(Vector2.ZERO)
		d.add_point(Vector2(1.5, 9))
		d.position = Vector2(randf() * _map_w, randf() * _map_h)
		d.set_meta("v", randf_range(260.0, 380.0))
		_rain.add_child(d)


func _physics_process(delta: float) -> void:
	if _rain == null:
		return
	for d in _rain.get_children():
		d.position.y += float(d.get_meta("v")) * delta
		d.position.x += 40.0 * delta
		if d.position.y > _map_h:
			d.position.y = -10
			d.position.x = randf() * _map_w
