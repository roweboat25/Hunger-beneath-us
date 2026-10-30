extends Control
## Confrontations (bible-1 "Confrontation" screen and "Core verbs and
## systems: Confrontations"): the screen narrows to a letterbox, a distance
## meter sits between Carl and the threat, and there are up to three rounds
## of three verbs:
##
##   Look   frames on: seen, +1 Connection, and it ends, unless Connection is
##          50 or more (then it stays, and the round is spent);
##          frames off: it gets closer.
##   Speak  a short lexicon pick: the right word holds it (each encounter has
##          its own word), the wrong one draws it closer; "bow" always ends
##          it, +3.
##   Run    +1, ends it, and Carl ends up one street back (the caller moves
##          him: Night.street_back).
##
## Two "closer" results and Carl is touched: a red flash, +5 Connection, and
## the threat is gone; the caller walks him one street back. Never a game
## over. Three rounds without a touch and it lets him go ("outlasted").
## The eye-layer threats (the alley double) also end when the frames come
## off (bible-3 A2-B3: "W:mimic or frames off ends it"); for them the verbs
## carry a fourth line, the frames.
##
## The encounters (bible-1): the follower (roams one district a night from
## Day 4), the Park Avenue crowd (Connection 50), the Fargona preacher, the
## alley double (Red Rock at night, 50), Dufredy at Lushon's (scripted: a
## level calls run(main, "dufredy", fig)). Night.gd starts the street ones.
##
## run() returns the result: seen, held, bowed, ran, touched, unseen,
## outlasted. `picks` scripts the rounds for tests: [["look"], ["speak",
## "sleeper"], ["run"], ["frames"]]; empty means the player chooses.
##
## Every line is in LINES; (game) marks a line written for the game, the
## rest are the book's (chapter given) or the bible's. ian rewrites them.

const LINES := {
	"verbs": ["Look", "Speak", "Run"],
	"frames": "Take the frames off",
	"nothing": "(say nothing)",
	"meter": ["FAR", "NEAR", "TOUCH"],
	"round": "ROUND %d / 3",
	"held": "HELD",
	"distance": "DISTANCE",
	"why": {"seen": "seen", "bow": "bowed to it", "run": "ran from it", "touched": "touched"},
	"log": "Confrontation: %s on %s. %s.",
	"enc": {
		# the follower: Tyson's "tall figure, black coat, full face covering" (ch.2) and Forner's three seconds of footage (ch.4)
		"follower": {
			"name": "THE FOLLOWER",
			"intro": ["Tall figure. Black coat. Full face covering. Not a surgical mask - something ceremonial.",
				"(game) It hadn't walked there. It was simply nearer than the last lamp, the mask shimmering unnaturally under the streetlights, and it was facing me."],
			"seen": "(game) The frames found it and drew the box, and the box had a name in it I couldn't read. Then it turned the corner. It never came out the other side. Like the city swallowed it whole.",
			"seen_stay": "(game) The frames drew the box round it and wrote MATCH FOUND. It didn't go. It had come to be seen, and it had all night.",
			"closer": ["(game) Nearer. I hadn't seen it move. The mask had no eyes in it and it was looking at me anyway.",
				"(game) Close enough to smell it: lavender, and under the lavender something that had been in the ground."],
			"held": "(game) It stopped. Not the way a man stops: the way a film stops. The coat hung in a wind that wasn't blowing, and it let me walk past it.",
			"drawn": "(game) The word went out of me and the mask turned toward it, the way a dog turns toward its name.",
			"bowed": "(game) I bowed my head to it. When I lifted it the pavement was empty, and the frames said THANK YOU in the corner of my eye.",
			"ran": "(game) I ran. Back the way I'd come, a whole street, and when I stopped and looked back there was nothing on the corner but the corner.",
			"touched": "(game) A hand in a black glove on my face, cool and dry, the thumb resting on my eyelid. Not pressing. Measuring.",
			"outlasted": "(game) And then it was a shadow wearing a smile, and then a shadow, and then only the dark between two lamps.",
			"unseen": "(game) With the frames off it was still there. That was the worst of it.",
		},
		# the Park Avenue crowd of thirty (bible-1 "The city": appears at 50, sings at Faith 2, has Carl's face at Faith 3)
		"crowd": {
			"name": "THE CROWD",
			"intro": ["(game) Thirty of them in the road, shoulder to shoulder, faces up to the tower. Everyone was looking up.",
				"(game) Then, in the same frame, every one of them turned and looked at me."],
			"seen": "(game) The frames counted them for me: thirty. Thirty sync bars at a hundred percent. They turned back to the tower in the same frame, and I was nobody again.",
			"seen_stay": "(game) The frames counted them: thirty-one. I counted again. The frames had counted me.",
			"closer": ["(game) The front row took a step. All of them, the same step, the same foot.",
				"(game) They were round me. Nobody pushed. Nobody had to."],
			"held": "Gather, sleeper. (game) They took the word from me and passed it back through themselves, mouth to mouth, and a path opened down the middle of them just wide enough for one.",
			"drawn": "(game) Thirty heads tilted at the word, the way you tilt your head at a song you nearly know.",
			"bowed": "(game) I bowed, and they bowed back, thirty of them and one of me, and when I straightened they were facing the tower again.",
			"ran": "(game) I ran, and they didn't chase me. They didn't have to. The whole street hummed the same note behind me for a block.",
			"touched": "(game) Hands. On my shoulders, my back, my hair, my face. Warm. Patient. A hand over my eyes, gently, the way you shut a dead man's.",
			"outlasted": "(game) The song ran out, or the hour did. They turned back to the tower and I walked through them like walking through a field.",
			"unseen": "(game) Frames off, they were thirty people standing in the road. That was all. That was enough.",
		},
		# the Fargona preacher's digital vigil (ch.15: "Smart glasses lit and tablet in their hand, like a preacher would hold a bible.")
		"preacher": {
			"name": "THE PREACHER",
			"intro": ["Fargona Avenue, and the street was blocked with people holding their digital vigil. They each wore a pair of smart glasses and were staring at the sky.",
				"(game) The preacher at their head held his tablet up like a bible, its light on his face, and stopped reading to look at me."],
			"seen": "(game) The frames gave me his card: no name, no employer, sync 100%, PREACHING. He went back to reading as if I'd paid.",
			"seen_stay": "(game) The frames showed me what they were all looking at: a fractal over the street that glowed in all colours and seemed to have no end. I felt calm for a moment. He kept looking at me.",
			"closer": ["\"You should really stop and enjoy the lights, Carl,\" a voice asked from the crowd.",
				"(game) The vigil had closed behind me. The tablet's light was on my face now."],
			"held": "They sang louder... and louder and began to open a path for me to get through. They smiled and nodded as I passed them by.",
			"drawn": "(game) \"Not that word,\" the preacher said kindly, and read it back to me off the tablet in my own voice.",
			"bowed": "(game) I bowed. The whole vigil said amen with the same breath, and the preacher turned the page.",
			"ran": "(game) I ran, and the hymn followed me down Fargona, every pair of glasses lit, every face turned up to the sky.",
			"touched": "(game) His palm on my forehead, the tablet's edge cold against my cheek. \"Look up,\" he said, and my eyes did, without me.",
			"outlasted": "(game) The hymn went on without me. They were looking at the sky again. I walked through the gap the song had left.",
			"unseen": "(game) Frames off: people in the road with their glasses dark, staring at nothing.",
		},
		# the alley double (ch.19; bible-3 A2-B3: "a man with Carl's face; W:mimic or frames off ends it")
		"double": {
			"name": "THE MAN IN THE ALLEY",
			"intro": ["I saw a man stare at me from behind an alley, his eyes wide and full of glee.", "He had my face..."],
			"seen": "(game) The frames boxed him and wrote my name in the box.",
			"seen_stay": "(game) The frames boxed him and wrote DRAKE, CARL. MATCH: 100%. He raised a hand, slowly, and I felt my own hand want to answer.",
			"closer": ["(game) He was closer. I hadn't seen him walk. He was smiling with my mouth, and the scar on my jaw was on the wrong side.",
				"(game) Near enough to hear him breathe. He breathed when I did, half a second late."],
			"held": "(game) Mimic. His mouth made the word with mine, half a second late, like an echo that had learned to lie. Then the alley was an alley.",
			"drawn": "(game) He said it back to me before I'd finished saying it.",
			"bowed": "(game) I bowed. He bowed too, a little deeper. When I straightened, the alley was empty.",
			"ran": "(game) I ran, and the footsteps behind me were mine, half a second late, all the way to the next street.",
			"touched": "(game) His hand was on my face. It was warm. It was my hand.",
			"outlasted": "(game) Then he stepped back into the alley like a man stepping back into a mirror.",
			"unseen": "I tore my glasses off, and he disappeared.",
		},
		# Dufredy at Lushon's (ch.20; scripted by the level that has him)
		"dufredy": {
			"name": "HAROLD DUFREDY",
			"intro": ["Then, like a candle blown out by the same gust, Harold Dufredy walked in the door.",
				"The black voids that filled his sockets absorbed all thought from my brain, all thought from the room."],
			"seen": "(game) The frames would not make him a card. They drew a box and left it empty.",
			"seen_stay": "(game) The frames drew a box round him and filled it with my own file.",
			"closer": ["He stood feet from me and eyed me up and down.",
				"(game) The voids were all I could see. Something in them was moving."],
			"held": "\"The day of glory is almost upon us; we all must walk our path...\" With that, he left.",
			"drawn": "\"The Mimic sits from the outer wall of the prison. The Mimic doesn't know what constitutes the mirror, but the Eye can see.\"",
			"bowed": "(game) I bowed my head. He laid his hand on it like a priest. \"Good,\" he said. \"Mira will be so proud.\"",
			"ran": "(game) I was out of the door before I knew I'd stood, and the street outside was the wrong street.",
			"touched": "(game) His fingers on my eyelids, dry as paper. \"The beast beneath the world waits for you, Carl.\"",
			"outlasted": "With that, he left. I was like a skyscraper being removed from the top of my heart. Color returned to the world.",
			"unseen": "(game) Frames off, he was an old man with gauze where his eyes had been. That didn't help.",
		},
	},
}

## Each encounter's right word (lexicon, bible-1 "Speak use"): look away
## breaks a stare; sleeper passes a congregation; dreamer opens a "not yet"
## (the vigil blocks the road); mimic names the double; the path is
## Dufredy's riddle. eye_layer: drawn only with the frames on.
const ENC := {
	"follower": {"right": "look away"},
	"crowd": {"right": "sleeper"},
	"preacher": {"right": "dreamer"},
	"double": {"right": "mimic", "eye_layer": true},
	"dufredy": {"right": "the path"},
}

const RED := Color(1.0, 0.1, 0.08)
const INK := Color(0.85, 0.9, 0.92)
const CYAN := Color(0.37, 0.91, 1.0)

var main: Node
var kind := ""
var fig: Node3D
var closer := 0
var round_i := 0
var result := ""
var active := false
var where := ""
## Connection when it started, for the log and the tests.
var c0 := 0.0
var _bars := 0.0
var _red := 0.0
var _t := 0.0
var _font: Font
var _home := Vector3.ZERO


func setup(m: Node) -> void:
	main = m
	name = "Confront"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_font = ThemeDB.fallback_font
	visible = false
	get_viewport().size_changed.connect(_fit)
	_fit()


func _fit() -> void:
	size = get_viewport().get_visible_rect().size
	queue_redraw()


static func right_word(k: String) -> String:
	return str(ENC.get(k, {}).get("right", ""))


static func eye_layer(k: String) -> bool:
	return bool(ENC.get(k, {}).get("eye_layer", false))


func _e(key: String):
	return LINES["enc"][kind][key]


# ------------------------------------------------------------------ the rounds

func run(m: Node, k: String, f: Node3D = null, picks: Array = []) -> String:
	main = m
	kind = k if LINES["enc"].has(k) else "follower"
	fig = f
	closer = 0
	round_i = 0
	result = ""
	active = true
	c0 = main.connection
	where = main.city.district_name(str(main.city.district)) if main.level_name == "Street" else main.level_name
	if fig and is_instance_valid(fig):
		_home = fig.global_position
	var ui = main.ui
	main.flags["cinematic"] = true
	visible = true
	_red = 0.0
	create_tween().tween_property(self, "_bars", 1.0, 0.35)
	main.play("sting", -8.0, 0.8)
	main.play("whisper", -8.0, 0.7)
	if fig and is_instance_valid(fig):
		await main.player.face(_head_of(fig), 0.6)
	for t: String in _e("intro"):
		await ui.think(t)
	while result == "" and round_i < 3:
		queue_redraw()
		var v: Array = await _verb(picks)
		await _resolve(str(v[0]), str(v[1]))
		round_i += 1
	if result == "":
		result = "outlasted"
		_vanish()
		await ui.think(_e("outlasted"))
	ui.close()
	main.flags.erase("cinematic")
	main.log_line("encounter", LINES["log"] % [str(_e("name")).capitalize(), where, result])
	var tw := create_tween()
	tw.tween_property(self, "_bars", 0.0, 0.35)
	tw.tween_callback(func(): visible = active)
	active = false
	main.update_hud()
	return result


## One round's verb: a scripted pick, or the player's.
func _verb(picks: Array) -> Array:
	if not picks.is_empty():
		var p: Array = picks.pop_front()
		return [p[0], p[1] if p.size() > 1 else ""]
	var ui = main.ui
	var opts: Array = LINES["verbs"].duplicate()
	if eye_layer(kind) and main.frames_on:
		opts.append(LINES["frames"])
	var i: int = await ui.choose(opts)
	match i:
		0:
			return ["look", ""]
		1:
			var words: Array = main.lexicon.duplicate()
			var o2: Array = words.duplicate()
			o2.append(LINES["nothing"])
			var j: int = await ui.choose(o2)
			return ["speak", str(words[j]) if j >= 0 and j < words.size() else ""]
		2:
			return ["run", ""]
	return ["frames", ""]


func _resolve(verb: String, word: String) -> void:
	var ui = main.ui
	var W: Dictionary = LINES["why"]
	match verb:
		"look":
			if main.frames_on:
				var was: float = main.connection
				main.add_connection(1.0, W["seen"])
				main.ui.glitch(0.4, 0.4)
				if was < 50.0:
					result = "seen"
					_vanish()
					await ui.think(_e("seen"))
				else:
					await ui.think(_e("seen_stay"))
			else:
				await _closer()
		"speak":
			if word != "":
				await ui.say("Carl", word.capitalize() + ".")
			if word == "bow":
				main.add_connection(3.0, W["bow"])
				result = "bowed"
				_vanish()
				await ui.think(_e("bowed"))
			elif word != "" and word == right_word(kind):
				result = "held"
				_hold()
				await ui.think(_e("held"))
			else:
				await ui.think(_e("drawn"))
				await _closer()
		"run":
			main.add_connection(1.0, W["run"])
			result = "ran"
			await ui.think(_e("ran"))
		"frames":
			if main.frames_on:
				main.toggle_frames()
			if eye_layer(kind):
				result = "unseen"
				_vanish()
			await ui.think(_e("unseen"))
		_:
			await _closer()


## It gets closer; the second time, Carl is touched.
func _closer() -> void:
	closer += 1
	queue_redraw()
	main.play("whisper", -4.0, 0.55)
	_approach()
	if closer >= 2:
		result = "touched"
		_red = 1.0
		create_tween().tween_property(self, "_red", 0.0, 1.1)
		main.player.shake(0.6)
		main.play("sting", -2.0, 0.6)
		main.add_connection(5.0, LINES["why"]["touched"])
		await main.ui.think(_e("touched"))
		_vanish()
		return
	var cl: Array = _e("closer")
	await main.ui.think(str(cl[mini(closer - 1, cl.size() - 1)]))


## It does not walk: it is nearer, in two cuts half a second apart (the
## follower's glide is two frames at 2 fps; the double "hadn't seen him walk").
func _approach() -> void:
	if fig == null or not is_instance_valid(fig):
		return
	var pp: Vector3 = main.player.global_position
	var flat := (_home - pp) * Vector3(1, 0, 1)
	var want: float = 2.4 if closer == 1 else 0.75
	var to := pp + flat.normalized() * minf(want, flat.length())
	to.y = fig.global_position.y
	var mid := fig.global_position.lerp(to, 0.5)
	var tw := fig.create_tween()
	tw.tween_property(fig, "global_position", mid, 0.0)
	tw.tween_interval(0.5)
	tw.tween_property(fig, "global_position", to, 0.0)
	var d := pp - to
	fig.rotation.y = atan2(-d.x, -d.z)


func _vanish() -> void:
	if fig and is_instance_valid(fig):
		fig.visible = false
		fig.set_meta("gone", true)
		for c in fig.find_children("*", "CollisionObject3D", true, false):
			(c as CollisionObject3D).collision_layer = 0


func _hold() -> void:
	if fig and is_instance_valid(fig):
		fig.set_meta("held", true)


func _head_of(f: Node3D) -> Vector3:
	var h = f.get_meta("head") if f.has_meta("head") else null
	if h is Node3D:
		return (h as Node3D).global_position
	return f.global_position + Vector3(0, 1.65, 0)


# ------------------------------------------------------------------ the screen

func _process(delta: float) -> void:
	if visible:
		_t += delta
		queue_redraw()


func _draw() -> void:
	var s := size
	if _bars <= 0.0 and _red <= 0.0:
		return
	var bh := s.y * 0.11 * _bars
	draw_rect(Rect2(0, 0, s.x, bh), Color(0, 0, 0, 1.0))
	draw_rect(Rect2(0, s.y - bh, s.x, bh), Color(0, 0, 0, 1.0))
	if _bars > 0.6 and kind != "":
		var f := _font
		var fs := 16
		var y := bh * 0.5 + 6.0
		draw_string(f, Vector2(32, y), str(_e("name")), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(RED, 0.85))
		# the distance meter: FAR - NEAR - TOUCH, the marker on where it is now
		var mw := minf(420.0, s.x * 0.34)
		var mx := (s.x - mw) / 2.0
		var my := bh * 0.52
		draw_string(f, Vector2(mx, my - 14.0), LINES["distance"], HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(INK, 0.6))
		draw_line(Vector2(mx, my), Vector2(mx + mw, my), Color(INK, 0.35), 2.0)
		var marks: Array = LINES["meter"]
		for i in 3:
			var px := mx + mw * i / 2.0
			var lit := i == closer
			var c := RED if i == 2 else (CYAN if i == 0 else Color(1.0, 0.6, 0.3))
			draw_circle(Vector2(px, my), 7.0 if lit else 4.0, Color(c, 1.0 if lit else 0.35))
			var tw := f.get_string_size(str(marks[i]), HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x
			draw_string(f, Vector2(px - tw / 2.0, my + 22.0), str(marks[i]), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(c, 0.9 if lit else 0.45))
		var r := LINES["round"] % mini(round_i + 1, 3)
		if result == "held":
			r = LINES["held"]
		var rw := f.get_string_size(r, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		draw_string(f, Vector2(s.x - 32 - rw, y), r, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(INK, 0.8))
	if _red > 0.0:
		# touched: a red flash and a red border (the border alone stays a moment)
		draw_rect(Rect2(Vector2.ZERO, s), Color(RED, 0.45 * _red * _red))
		var bw := 10.0
		var bc := Color(RED, minf(1.0, _red * 1.6))
		draw_rect(Rect2(0, 0, s.x, bw), bc)
		draw_rect(Rect2(0, s.y - bw, s.x, bw), bc)
		draw_rect(Rect2(0, 0, bw, s.y), bc)
		draw_rect(Rect2(s.x - bw, 0, bw, s.y), bc)
