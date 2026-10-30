extends Node
## Melee, rare and ugly (bible-1 "Melee"; combat.md "Melee is the
## fallback", "Enemies": addicts and drunks, Red Rock first). Only people
## tagged with meta "addict" (true or a config Dictionary: hp, aggro
## frames|always|never, managed, home) can be fought. V (or the left mouse
## button) at arm's length: a shove or a strike. Two or three of them put a
## man down, and every one costs Carl too: the man swings back, the screen
## shakes, Carl staggers. A takedown is +2 Connection and the frames paint an
## eye where he fell. Three hits taken in one place and Carl is overwhelmed:
## the god saves him (black, "You wake somewhere safe", +10 Connection, a
## ledger line "debt"), never a game over.
## Addicts can also be talked down (E), or given what's in Carl's coat; the
## quick-hack "sleeper" through their phone sits them down for a while.
## By default an addict comes at Carl only with the frames on (bible-1:
## "another attacks if Carl's frames are on").
##
## Every line here is (game) unless marked: written for the game; ian
## rewrites them.

const LINES := {
	"strike": ["I hit him. It was nothing like the films. It was like hitting a sack of wet laundry that hit back.",
		"I shoved him off me. My hand came away from his coat wet, and I didn't look at what with.",
		"I hit him again. Something in my wrist said it would remember this."],
	"hit_me": ["His fist caught me over the ear. The frames rang like a struck pan.",
		"He got a hand in my collar and pulled, and the street tipped.",
		"An elbow, somewhere under my ribs. I tasted the noodles from lunch."],
	"down": "He went down the way people do when they've stopped expecting the ground. Where his head lay, the frames drew an eye.",
	"mutter": ["Turn them off. Turn them off, they're looking at me through you.",
		"You've got its light in your glasses. I can see it. I can see it.",
		"Gather, gather, it says gather, I didn't want to gather."],
	"overwhelmed": "I didn't remember getting here. Something had carried me, or walked me, and it wanted me to know that it could.",
	"overwhelmed_card": "[b]You wake somewhere safe.[/b]",
	"debt": "debt: carried out of a fight I was losing",
	"why_down": "takedown",
	"why_debt": "debt",
	"log_down": "Put a man down in the street. The frames painted an eye where he fell.",
	"talk": ["Easy. I'm not here for you.", "Here. Take it. (the cash in my coat)", "Leave him be."],
	"talk_ok": "He looked at me for a long time. Then he sat down on the kerb and put his hands over his ears, like the street was too loud.",
	"talk_frames": "He wasn't looking at me. He was looking at the frames, at the little light in the corner of them, and his lips were moving.",
	# the second sentence is the book's (ch.19, the scripture on the Red Rock wall), in his mouth
	"talk_cash": "He took it without looking at it. They want us, he said. The ones like me. It wanted drunks and ketamine addicts; it wanted to clean the streets. I thought it meant the streets.",
	"talk_leave": "I left him to it. Whatever it was.",
	"talk_down": "He didn't say anything. He was breathing, and the eye under him was drying.",
	"talk_calm": "He was sitting with his back to the wall, humming three notes. He didn't look up.",
	"log_talk": "Talked a man down in the street instead of hitting him.",
	"log_cash": "Gave a man the cash in my coat. He told me what the fork wanted.",
}

var main: Node
var addicts: Array = []
var touches := 0
var _cool := 0.0
var _busy := false
var _last_touch := -100.0
var rng := RandomNumberGenerator.new()


func setup(m: Node) -> void:
	main = m
	rng.randomize()


func on_level(lv: Node) -> void:
	addicts.clear()
	touches = 0
	_busy = false
	for n in main._all_with_meta(lv, "addict"):
		if n is Node3D and not (n is CollisionObject3D):
			var c = n.get_meta("addict")
			if c is bool and c == false:
				continue
			add(n, c if c is Dictionary else {})


func add(n: Node3D, cfg := {}) -> Dictionary:
	var a := {"node": n, "hp": int(cfg.get("hp", 3)), "aggro": str(cfg.get("aggro", "frames")), "managed": bool(cfg.get("managed", false)),
		"home": n.global_position, "home_yaw": n.global_rotation.y, "base_y": n.position.y, "state": "idle", "swing": 1.0,
		"inv_point": Vector3.ZERO, "inv_until": 0.0, "muttered": false, "phase": rng.randf() * TAU, "pose": ""}
	addicts.append(a)
	return a


func addict_of(n: Node) -> Dictionary:
	for a: Dictionary in addicts:
		if a["node"] == n:
			return a
	return {}


# ------------------------------------------------------------------ Hack asks

func convene(p: Vector3, radius: float, secs: float) -> int:
	var k := 0
	for a: Dictionary in addicts:
		var n: Node3D = a["node"]
		if is_instance_valid(n) and a["managed"] and a["state"] not in ["down"] and n.global_position.distance_to(p) < radius:
			a["inv_point"] = p
			a["inv_until"] = main.stealth.now + secs
			k += 1
	return k


func sleep(n: Node, _secs: float) -> void:
	var a := addict_of(n)
	if not a.is_empty() and a["state"] != "down":
		a["state"] = "idle"


# ------------------------------------------------------------------ the strike

## V / left mouse: the addict at arm's length in front of Carl, if any.
func reach_target() -> Dictionary:
	var cam: Camera3D = main.player.cam
	var fwd := -cam.global_basis.z
	fwd.y = 0.0
	fwd = fwd.normalized()
	var best := {}
	var bd := 99.0
	for a: Dictionary in addicts:
		var n: Node3D = a["node"]
		if not is_instance_valid(n) or a["state"] == "down" or not n.is_visible_in_tree():
			continue
		var d: Vector3 = n.global_position - main.player.global_position
		d.y = 0.0
		if d.length() < 1.9 and d.length() < bd and (d.length() < 0.5 or fwd.dot(d.normalized()) > 0.45):
			best = a
			bd = d.length()
	return best


func strike() -> bool:
	if _busy or main.stealth.now < _cool:
		return false
	var a := reach_target()
	if a.is_empty():
		return false
	_cool = main.stealth.now + 0.7
	var n: Node3D = a["node"]
	var p = main.player
	p.shake(0.35)
	p.pitch = clampf(p.pitch - 0.05, -1.45, 1.45)
	main.play("slam", -7.0, rng.randf_range(0.65, 0.8))
	main.ui.glitch(0.15, 0.2)
	var S: Array = LINES["strike"]
	main.hack.say_line(S[mini(3 - int(a["hp"]), S.size() - 1) if int(a["hp"]) <= 3 else 0])
	a["hp"] = int(a["hp"]) - 1
	a["aggro"] = "always"
	a["swing"] = 1.4  # staggered: he hits back once, then has to find his feet
	if a["state"] in ["idle", "calm"]:
		a["state"] = "approach"
	# knocked back, head snapped round
	var away: Vector3 = n.global_position - p.global_position
	away.y = 0.0
	away = away.normalized()
	var tw := n.create_tween()
	tw.tween_property(n, "global_position", n.global_position + away * 0.45, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var head: Node3D = n.get_meta("head", null)
	if head:
		head.rotation.y = rng.randf_range(-0.8, 0.8)
		head.rotation.x = -0.4
	if int(a["hp"]) <= 0:
		_down(a)
		return true
	# it costs Carl too: the man hits back
	main.get_tree().create_timer(0.35).timeout.connect(func():
		if is_instance_valid(n) and a["state"] != "down" and n.global_position.distance_to(main.player.global_position) < 2.4:
			hit_carl(a))
	return true


func hit_carl(a: Dictionary) -> void:
	if _busy:
		return
	var n: Node3D = a["node"]
	var p = main.player
	var d: Vector3 = p.global_position - n.global_position
	d.y = 0.0
	d = d.normalized() if d.length() > 0.01 else Vector3(0, 0, 1)
	p.shake(0.7)
	p.pitch = clampf(p.pitch + 0.14, -1.45, 1.45)
	p.yaw += rng.randf_range(-0.12, 0.12)
	p.move_and_collide(d * 0.5)
	main.ui.flash(0.35)
	main.play("slam", -5.0, 0.55)
	var arms: Array = n.get_meta("arms", [])
	if arms.size() > 0:
		(arms[0] as Node3D).rotation.x = -1.8
	var H: Array = LINES["hit_me"]
	main.hack.say_line(H[touches % H.size()])
	touches += 1
	_last_touch = main.stealth.now
	if touches >= overwhelm_at():
		overwhelmed()


## Hits taken before the god carries Carl off: three, or four with Carl's
## Tower's Courage room (the hands stay steady when someone puts theirs on him).
func overwhelm_at() -> int:
	return 4 if main.tower_rooms.has("courage") else 3


func _down(a: Dictionary) -> void:
	var n: Node3D = a["node"]
	a["state"] = "down"
	_pose(a, "")
	var tw := n.create_tween().set_parallel(true)
	tw.tween_property(n, "rotation:x", PI / 2.0, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.tween_property(n, "position:y", float(a["base_y"]) + 0.16, 0.45)
	main.play("slam", -4.0, 0.45)
	main.player.shake(0.3)
	# the eye where he fell (bible-1 "Melee")
	var lv = main.level
	var s := Sprite3D.new()
	s.texture = lv._glyph_tex
	s.pixel_size = 0.011
	s.modulate = Color(0.55, 0.02, 0.02, 0.9)
	s.shaded = false
	s.rotation.x = -PI / 2.0
	s.position = n.global_position + Vector3(0, 0.03, 0) + (n.global_basis.z * 0.9)
	lv.add_child(s)
	a["eye"] = s
	main.hack.say_line(LINES["down"], 3.5)
	main.add_connection(2.0, LINES["why_down"])
	main.log_line("takedown", LINES["log_down"])
	var b := _body_of(n)
	if b:
		b.set_meta("prompt", "Look at him")


func _body_of(n: Node) -> CollisionObject3D:
	for c in n.get_children():
		if c is CollisionObject3D and c.has_meta("id"):
			return c
	return null


## Three hits taken: the god saves Carl (bible-1: "Overwhelmed").
func overwhelmed() -> void:
	if _busy:
		return
	_busy = true
	var ui = main.ui
	var lv = main.level
	await main.get_tree().create_timer(0.3).timeout
	await ui.fade_to(1.0, 0.4)
	if main.level != lv:
		_busy = false
		return
	var safe: Vector3 = main.stealth.last_safe if main.stealth.has_safe else lv.spawn
	main.player.global_position = safe
	main.player.velocity = Vector3.ZERO
	main.player.pitch = 0.0
	for a: Dictionary in addicts:
		if a["state"] != "down":
			a["state"] = "calm"
			a["aggro"] = "never"
	touches = 0
	await ui.show_card(LINES["overwhelmed_card"], 1.6)
	main.add_connection(10.0, LINES["why_debt"])
	main.log_line("debt", LINES["debt"])
	await ui.think(LINES["overwhelmed"])
	ui.close()
	_busy = false


# ------------------------------------------------------------------ talking

func talk(n: Node3D) -> void:
	var a := addict_of(n)
	var ui = main.ui
	if a.is_empty():
		return
	match str(a["state"]):
		"down":
			await ui.think(LINES["talk_down"])
			return
		"calm":
			await ui.think(LINES["talk_calm"])
			return
	var i: int = await ui.choose(LINES["talk"])
	match i:
		0:
			# Courage: a steadier voice; he hears it through the frames half as often
			if main.frames_on and rng.randf() < (0.3 if main.tower_rooms.has("courage") else 0.6):
				await ui.think(LINES["talk_frames"])
				a["aggro"] = "always"
				a["state"] = "approach"
			else:
				await ui.think(LINES["talk_ok"])
				a["state"] = "calm"
				a["aggro"] = "never"
				main.log_line("street", LINES["log_talk"])
		1:
			await ui.think(LINES["talk_cash"])
			a["state"] = "calm"
			a["aggro"] = "never"
			main.log_line("street", LINES["log_cash"])
		_:
			await ui.think(LINES["talk_leave"])


# ------------------------------------------------------------------ the loop

func _physics_process(delta: float) -> void:
	if addicts.is_empty() or main.level == null or not main.started:
		return
	var pp: Vector3 = main.player.global_position
	var ctx: bool = not main.ui.busy and not main.loading and not main.flags.has("cinematic") and not _busy and not main.stealth.catching
	var t: float = main.stealth.now
	# a fight forgotten: the hits taken count toward overwhelm for 25 seconds
	if touches > 0 and t - _last_touch > 25.0:
		touches = 0
	for a: Dictionary in addicts:
		var n: Node3D = a["node"]
		if not is_instance_valid(n) or not a["managed"]:
			continue
		var st: String = a["state"]
		if st == "down":
			continue
		var d := n.global_position.distance_to(pp)
		if main.hack.has_state(n, "asleep") or st == "calm":
			_pose(a, "sit")
			Anim.look(n, n.global_position + n.global_basis.z * -2.0 + Vector3(0, 0.3, 0), 1.0, 0.04)
			continue
		_pose(a, "")
		var arms: Array = n.get_meta("arms", [])
		if arms.size() > 0:
			(arms[0] as Node3D).rotation.x = lerpf((arms[0] as Node3D).rotation.x, 0.0, minf(1.0, delta * 3.0))
		if float(a["inv_until"]) > t:
			if not _walk(a, a["inv_point"], 1.2, delta, 1.4):
				continue
			Anim.idle(n, t, float(a["phase"]))
			continue
		var want: bool = ctx and (a["aggro"] == "always" and d < 9.0 or a["aggro"] == "frames" and main.frames_on and d < 6.0)
		if st == "idle" and want:
			a["state"] = "approach"
			st = "approach"
		if st == "approach":
			if not want or d > 11.0:
				a["state"] = "idle"
				continue
			if not a["muttered"]:
				a["muttered"] = true
				var M: Array = LINES["mutter"]
				main.hack.say_line(M[rng.randi() % M.size()], 3.0)
			if d > 1.15:
				var wob := Vector3(sin(t * 2.3 + float(a["phase"])), 0, cos(t * 1.7)) * 0.6
				_walk(a, pp + wob, 1.5, delta, 1.0)
			else:
				var dd := pp - n.global_position
				n.rotation.y = lerp_angle(n.rotation.y, atan2(-dd.x, -dd.z), minf(1.0, delta * 5.0))
				Anim.idle(n, t, float(a["phase"]))
				Anim.look(n, main.player.cam.global_position, 1.0, 0.2)
			a["swing"] = float(a["swing"]) - delta
			if d < 1.3 and float(a["swing"]) <= 0.0:
				a["swing"] = 1.9
				hit_carl(a)
			continue
		# idle: swaying at home, the head going round
		if n.global_position.distance_to(a["home"]) > 0.6:
			_walk(a, a["home"], 0.9, delta)
		else:
			n.rotation.y = lerp_angle(n.rotation.y, float(a["home_yaw"]), minf(1.0, delta * 1.5))
			Anim.idle(n, t * 1.6, float(a["phase"]))
			var hd: Node3D = n.get_meta("head", null)
			if hd:
				hd.rotation.z = sin(t * 0.9 + float(a["phase"])) * 0.18


func _walk(a: Dictionary, p: Vector3, speed: float, delta: float, near := 0.4) -> bool:
	var n: Node3D = a["node"]
	var d := p - n.global_position
	d.y = 0.0
	if d.length() < near:
		return true
	n.global_position += d.normalized() * minf(speed * delta, d.length())
	n.rotation.y = lerp_angle(n.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 5.0))
	Anim.walk(n, main.stealth.now, speed * 0.8, float(a["phase"]), 1.2)
	return false


func _pose(a: Dictionary, p: String) -> void:
	if a["pose"] == p:
		return
	var n: Node3D = a["node"]
	a["pose"] = p
	if p == "":
		for l in n.get_meta("legs", []):
			(l as Node3D).rotation.x = 0.0
		for k in n.get_meta("knees", []):
			(k as Node3D).rotation.x = 0.0
		var body: Node3D = n.get_meta("body", null)
		if body:
			body.rotation.x = 0.0
		var head: Node3D = n.get_meta("head", null)
		if head:
			head.position.z = 0.0
		n.position.y = float(a["base_y"])
	else:
		Anim.crouch(n)
		n.position.y = float(a["base_y"]) - 0.45
