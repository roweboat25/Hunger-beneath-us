extends Control
class_name CutScene
## Painted cut scenes: full-screen panels (assets/closeups/*.png) with a slow
## camera move, letterbox bars and a caption that advances with E or Enter.
## Esc skips the whole scene. A panel is a Dictionary:
##   {"image": "cs_opening_1", "lines": [...], "move": "zoom"|"pan"|"pan_left"|"flicker"|"still"}
## play(panels) is awaited by the scene that triggers it; play(panels, true)
## leaves the last panel on screen for a choice drawn over it, until finish().

const PANELS := {
	"opening": [
		{"image": "cs_opening_1", "move": "zoom", "lines": [
			"Silico, after midnight. The elevated road into Lamplight, sand drifting across the lane the way it always did when the wind came off the flats.",
			"Every window in the tower lit teal. Psyonic Integrations never slept. Neither, lately, did I."]},
		{"image": "cs_opening_2", "move": "flicker", "lines": [
			"The dashboard rebooted twice between the flyover and the exit. The ORA frames on the passenger seat lit up on their own, as if something had been waiting for me to look.",
			"One job. Protect the brand. A retired man had gouged out his eyes, and the company needed it to be anything but Psyon."]},
		{"image": "cs_opening_3", "move": "pan", "lines": [
			"Dufredy's building. A police cruiser at the kerb, lights off. One dark window high up among all the lit ones.",
			"A thin line of sand ran along the pavement to the door. I put the frames on. ORA said good evening."]},
	],
	"outage": [
		{"image": "cs_outage_1", "move": "pan_left", "lines": [
			"It went in sequence. Every screen on the boulevard cut to static in the same second, and then the lamps died one after another, down the street, toward the tower.",
			"The tower was the only light left in Silico."]},
		{"image": "cs_outage_2", "move": "zoom", "lines": [
			"Nobody ran. Everyone on the pavement turned the same way and tilted their faces up, lit only by their frames.",
			"They were all looking at the tower. Its windows made a shape I knew. I closed my eyes until the lamps came back."]},
	],
	"tower": [
		{"image": "cs_tower_1", "move": "zoom", "lines": [
			"Psyonic Tower. Eighty-six floors of glass and metal musculature in the middle of the Spine, and every window lit teal, at seven in the morning, the way they were lit at midnight.",
			"The company car dropped me at the door it always dropped me at. The frames said good morning. The lobby said it too, in the same voice."]},
		{"image": "cs_tower_2", "move": "pan", "lines": [
			"Floor 86. Integrations. The elevator opened on the smell of my team's collective stress and a wall of screens running the same three seconds of footage.",
			"A retired man had gouged out his eyes, and the company's stock price was on every one of those screens, tanking. Turan was already looking at me."]},
	],
	"drive": [
		{"image": "cs_drive_1", "move": "pan_left", "lines": [
			"The Restricted Road at night. The checkpoint waved the company car through without waking up. Sand drifted across the lane in the headlights, and the lane stopped being a lane.",
			"I entered the coordinates from the map. Once, restricted had felt like bureaucracy. Now it felt like containment."]},
		{"image": "cs_drive_2", "move": "zoom", "lines": [
			"Lynx's sedan, doors open, out on the flats, under a cliff that had a door in it.",
			"I turned the engine off and the frames kept running. They had been recording since the checkpoint. They had not asked."]},
	],
	"vigil": [
		{"image": "cs_vigil_1", "move": "pan", "lines": [
			"I left Fargona Avenue the way I'd come, down the steps, and from the top of them the vigil was a street of lit faces, every one tilted back, every one smiling at the thing above them.",
			"None of them watched me go. The lights did."]},
	],
	"ending_company": [
		{"image": "ending_company", "move": "still", "lines": [
			"The mirror cleared and I was in it, with the badge on, and behind me, where nobody stood, stood Turan, and Monica, and the company car with its door open.",
			"PROTECT THE BRAND, the frames wrote across the glass, in my handwriting. I had filed everything. The file had become the man."]},
	],
	"ending_investigator": [
		{"image": "ending_investigator", "move": "still", "lines": [
			"The mirror cleared and I was in it, and behind me, where nobody stood, stood Lynx, holding her smashed frames, looking at the door and not at the glass.",
			"FIND OUT WHAT HAPPENED TO HIM, the frames wrote across the glass. I had refused enough to still be asking. It had noticed. It had kept a list."]},
	],
	"ending_sleeper": [
		{"image": "ending_sleeper", "move": "still", "lines": [
			"The mirror cleared and I was in it, already bowing, and behind me, where nobody stood, stood the whole of Fargona Avenue with its heads back.",
			"BOW, the frames wrote across the glass. I had been on the path since the first glyph. I had only been pretending to walk it slowly."]},
	],
	"ending_none": [
		{"image": "ending_none", "move": "still", "lines": [
			"The mirror cleared and I was in it, alone. Behind me, where nobody stood, nobody stood.",
			"The frames wrote nothing across the glass. The file had not decided what I was yet. Neither had I. It could wait. It was patient."]},
	],
	"altar": [
		{"image": "cs_altar", "move": "zoom", "lines": [
			"Directly under the light, in the exact centre of the hangar: a plush, black leather recliner. It sat there like a throne awaiting its king.",
			"Two thick cables came down out of the dark and ended in two rust-red probes, one on each arm, at the height of a man's temples."]},
	],
	"ritual_1": [
		{"image": "cs_ritual_1", "move": "pan", "lines": [
			"A hundred of them, in robes, in a circle around the throne, a living amphitheatre, with one open path down the middle.",
			"Three in white came down the stairwell. The one in the centre wore a blank ceremonial mask. I knew the way he held his head. Subject 41."]},
	],
	"ritual_2": [
		{"image": "cs_ritual_2", "move": "zoom", "lines": [
			"Above the congregation a sea of tiny white lights formed, one for each of them, moving like a sea, bobbing as if on a wave. The lights flaked off the crest and rose.",
			"For a moment it looked like a full moon on the ocean. Then the lights joined, and it was the eye. It rotated over the crowd. Then it turned and stared directly at me."]},
	],
	"ritual_3": [
		{"image": "cs_ritual_3", "move": "zoom", "lines": [
			"The cube opened on a hinge nobody could see. The Prophet's hands went into the dark inside it and came out holding a black blade, and after it something that looked like an electrical outlet on a black stick.",
			"Beside him, the bowl. Eren Elontiel held it the way you hold a thing you have held many times."]},
	],
	"ritual_4": [
		{"image": "cs_ritual_4", "move": "flicker", "lines": [
			"Subject 1395 raised their head.",
			"And the face was mine."]},
	],
	"ritual_all": [
		{"image": "cs_ritual_1", "move": "pan", "lines": ["A hundred of them, in robes, in a circle around the throne. Three in white came down the stairwell."]},
		{"image": "cs_ritual_2", "move": "zoom", "lines": ["The lights joined, and it was the eye. It turned and stared directly at me."]},
		{"image": "cs_ritual_3", "move": "zoom", "lines": ["The removal of the first filter. Our holiest rite."]},
		{"image": "cs_ritual_4", "move": "flicker", "lines": ["Subject 1395 raised their head. And the face was mine."]},
	],
	"s41": [
		{"image": "cs_s41", "move": "flicker", "lines": [
			"Observation_Log_S41_09-03-19. The camera high in a corner of the room we had just left, looking down on a single chair. A man in it, electrodes taped to his temples. He looked bored.",
			"The fluorescent lights in the video began to flicker. Erratically at first. Then in a steady, pulsing rhythm."]},
	],
	"escape": [
		{"image": "cs_escape", "move": "pan", "lines": [
			"We emerged from the facility at dusk. A full moon was rising on the horizon. My blood was cold, and the laughter in my glasses subsided as my muscles were pushed to their limit.",
			"We got to my corporate car in what seemed like seconds. I got in the driver's seat and headed toward the city."]},
	],
}

signal finished

var _bg: ColorRect
var _frame: Control
var _img: TextureRect
var _caption: Label
var _band: ColorRect
var _bars: Array[ColorRect] = []
var _playing := false
var _advance := false
var _skipped := false
var _tween: Tween
var _flicker := false
## True once the current panel has faded in (the flicker must not fight the fade).
var _shown := false
var _time := 0.0
var _hint: Label


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bg = ColorRect.new()
	_bg.color = Color("050608")
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg)
	_frame = Control.new()
	_frame.clip_contents = true
	_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_frame)
	_img = TextureRect.new()
	_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_img.stretch_mode = TextureRect.STRETCH_SCALE
	_img.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_img.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame.add_child(_img)
	for i in 2:
		var bar := ColorRect.new()
		bar.color = Color("050608")
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bar)
		_bars.append(bar)
	_band = ColorRect.new()
	_band.color = Color("050608", 0.72)
	_band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_band)
	_caption = Label.new()
	_caption.add_theme_font_size_override("font_size", 10)
	_caption.add_theme_color_override("font_color", Color("e8ecef"))
	_caption.add_theme_color_override("font_shadow_color", Color("050608"))
	_caption.add_theme_constant_override("shadow_offset_x", 1)
	_caption.add_theme_constant_override("shadow_offset_y", 1)
	_caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(_caption)
	_hint = Label.new()
	_hint.text = "E next   ·   Esc skip"
	_hint.add_theme_font_size_override("font_size", 8)
	_hint.add_theme_color_override("font_color", Color("b9c2c9", 0.8))
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(_hint)
	_fit()
	get_viewport().size_changed.connect(_fit)
	hide()


func _fit() -> void:
	var s: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2.ZERO
	size = s
	_bg.position = Vector2.ZERO
	_bg.size = s
	_frame.position = Vector2.ZERO
	_frame.size = s
	_img.size = s
	_img.pivot_offset = s / 2.0
	var bar_h := s.y * 0.1
	_bars[0].position = Vector2.ZERO
	_bars[0].size = Vector2(s.x, bar_h)
	_bars[1].position = Vector2(0, s.y - bar_h)
	_bars[1].size = Vector2(s.x, bar_h)
	_band.position = Vector2(0, s.y - bar_h - 56)
	_band.size = Vector2(s.x, 56)
	_caption.position = Vector2(s.x * 0.06, s.y - bar_h - 56)
	_caption.size = Vector2(s.x * 0.88, 56)
	_hint.position = Vector2(s.x - 200, s.y - bar_h + 4)
	_hint.size = Vector2(190, 12)


## Plays a scene by name from PANELS, or an Array of panels.
func play(what, keep := false) -> void:
	var panels: Array = PANELS[what] if what is String else what
	_playing = true
	_skipped = false
	_advance = false
	Game.input_locked = true
	_caption.text = ""
	_img.modulate.a = 0.0
	show()
	for panel in panels:
		if _skipped:
			break
		await _show_panel(panel)
		for line in panel.get("lines", []):
			if _skipped:
				break
			_caption.text = line
			_caption.modulate.a = 0.0
			var t := create_tween()
			t.tween_property(_caption, "modulate:a", 1.0, 0.4)
			await _wait(2.6 + 0.045 * line.length())
		_shown = false
		if not _skipped and not keep:
			var f := create_tween()
			f.tween_property(_img, "modulate:a", 0.0, 0.5)
			await f.finished
	_playing = false
	if keep and not _skipped:
		_caption.text = ""
		return
	await finish()


## Takes the scene down (after a choice drawn over a kept panel).
func finish() -> void:
	if _tween:
		_tween.kill()
	_flicker = false
	var f := create_tween()
	f.tween_property(_img, "modulate:a", 0.0, 0.4)
	await f.finished
	_caption.text = ""
	hide()
	Game.input_locked = false
	finished.emit()


func skip() -> void:
	_skipped = true


func _show_panel(panel: Dictionary) -> void:
	var tex := load("res://assets/closeups/" + String(panel["image"]) + ".png")
	_img.texture = tex
	if _tween:
		_tween.kill()
	_flicker = false
	var s: Vector2 = _frame.size
	_img.position = Vector2.ZERO
	_img.scale = Vector2.ONE
	var move := String(panel.get("move", "zoom"))
	var lines: Array = panel.get("lines", [])
	var dur: float = 2.6 * lines.size() + 4.0
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	match move:
		"zoom":
			_img.scale = Vector2(1.12, 1.12)
			_tween.tween_property(_img, "scale", Vector2(1.0, 1.0), dur)
		"pan":
			_img.scale = Vector2(1.15, 1.15)
			_img.position = Vector2(-s.x * 0.075, 0)
			_tween.tween_property(_img, "position", Vector2(s.x * 0.075, 0), dur)
		"pan_left":
			_img.scale = Vector2(1.15, 1.15)
			_img.position = Vector2(s.x * 0.075, 0)
			_tween.tween_property(_img, "position", Vector2(-s.x * 0.075, 0), dur)
		"flicker":
			_img.scale = Vector2(1.06, 1.06)
			_tween.tween_property(_img, "scale", Vector2(1.0, 1.0), dur)
			_flicker = true
		_:
			_tween.tween_interval(dur)
	_shown = false
	var f := create_tween()
	f.tween_property(_img, "modulate:a", 1.0, 0.7)
	await _wait(0.7)
	_img.modulate.a = 1.0
	_shown = true


func _wait(seconds: float) -> void:
	var t := 0.0
	while t < seconds and not _advance and not _skipped:
		await get_tree().process_frame
		t += get_process_delta_time()
	_advance = false


func _process(delta: float) -> void:
	if not visible:
		return
	_time += delta
	if _flicker and _playing and _shown:
		_img.modulate.a = 0.55 if (fmod(_time, 1.7) < 0.08 or fmod(_time, 2.9) < 0.05) else 1.0


func _unhandled_input(event: InputEvent) -> void:
	if not visible or not _playing:
		return
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		_skipped = true
	elif event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_advance = true
