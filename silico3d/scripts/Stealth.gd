extends Node
## Sighted enemies (bible-1 "Danger tiers and guarded sites": "patrols with
## line of sight"; combat.md "Enemies": security and guards, cultists, police
## drones; "Being caught by company security = escorted out, +5 pressure,
## retry"). Opt-in only: a level tags a node with meta "stealth" (true or a
## config Dictionary, below) and it becomes a watcher. Guards that a level's
## own code drives stay driven by it: Stealth only looks through their eyes
## (perception), unless the config says "managed", in which case Stealth walks
## the patrol, turns to noises, follows convene and lies down for sleeper.
##
## A watcher has a vision cone (angle, range, raycast for walls). Carl is
## harder to see in the dark (the level's lamps near him) and crouched (C),
## and quieter crouched; running is loud. Suspicion fills while he is seen and
## drains when he is not; it shows as a subtle arc round the crosshair, pointing
## at whoever is looking. With the frames on, ORA draws the cones on the floor.
## Full suspicion is never a game over: a line, +5 pressure (company) or +5
## Connection (cult), and Carl is walked back to the last safe point.
##
## Config keys (all optional): kind guard|camera|cultist|drone, faction
## company|cult, fov (degrees), range (m), managed, path [Vector3...], yaw and
## pitch and sweep (cameras, radians), pivot (Node3D the camera head turns),
## led (Node3D that goes dark asleep), when (flag that must be set), unless
## (flag that ends it), pivot_offset (a prop whose lens faces +Z: PI), role
## (orderly: who says the caught line), zone (AABB Carl must be in), safe (Vector3), who (name
## in the caught line), lines ([[who, text], ...]), rate, passive (driven and
## hackable, but never watching: street cameras and drones over a public road).
##
## Every line here is (game): written for the game; ian rewrites them.

signal caught(w: Dictionary)

const GREEN := Color(0.25, 0.88, 0.54)
const AMBER := Color(1.0, 0.72, 0.25)
const RED := Color(1.0, 0.16, 0.1)
const ALERT := 0.35

const LINES := {
	"caught": {
		"company": [["Security", "Sir. This area's closed. I'll walk you out."],
			["Security", "Psyonic or not, you're not on my list. Back to the street."],
			["Security", "Again? I'm logging it this time. Out."]],
		"cult": [["", "They didn't grab me. They turned me round, gently, and walked me back, a hand flat on my spine the whole way. Not yet, sleeper. Not yet."],
			["", "A hand on each shoulder, and a voice at my ear that wasn't one voice. You'll walk with us. Not here. Not tonight."]],
	},
	"walked": {
		"company": "He walked me back with a hand on my elbow, and his frames logged every step of it.",
		"cult": "When they let go of me the hands stayed on my back, the way a hand stays when you've slept on it.",
	},
	"why": {"company": "caught by security", "cult": "the hands on my back"},
	"log": {"company": "Caught where I shouldn't be by company security; escorted out.",
		"cult": "Caught by them and walked back. They were gentle about it."},
	"crouch": "CROUCHED",
	"who": {"orderly": "Orderly", "guard": "Security"},
}

var main: Node
var now := 0.0
var watchers: Array = []
var catching := false
## The --hacks test lets the catches happen; the story self-test does not.
var test_mode := false
## Screenshots (--nocatch=1): suspicion fills but nobody is walked back.
var no_catch := false
var catches := 0
var exposure := 1.0
var last_safe := Vector3.ZERO
var has_safe := false
var hud: Control
var _mask_until := 0.0
var _exp_t := 0.0
var _safe_t := 0.0
var _frame := 0
var _cone_mat: StandardMaterial3D
var _excl_player: Array = []


func setup(m: Node) -> void:
	main = m
	_cone_mat = StandardMaterial3D.new()
	_cone_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_cone_mat.vertex_color_use_as_albedo = true
	_cone_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_cone_mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	_cone_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_cone_mat.no_depth_test = false
	hud = SusHUD.new()
	hud.st = self
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main.ui.root.add_child(hud)
	main.ui.root.move_child(hud, main.ui.fade.get_index())


func clear() -> void:
	watchers.clear()
	has_safe = false
	catching = false


## After a level is built: every node tagged "stealth" becomes a watcher.
func on_level(lv: Node) -> void:
	clear()
	for n in main._all_with_meta(lv, "stealth"):
		if n is Node3D and Hack_m(n, "stealth"):
			var c = n.get_meta("stealth")
			add(n, c if c is Dictionary else {})
	last_safe = lv.spawn
	has_safe = true


static func Hack_m(n: Node, k: String) -> bool:
	if not n.has_meta(k):
		return false
	var v = n.get_meta(k)
	return v != null and not (v is bool and v == false)


func add(n: Node3D, cfg := {}) -> Dictionary:
	var kind: String = str(cfg.get("kind", ""))
	if kind == "":
		kind = "camera" if Hack_m(n, "camera") else ("drone" if Hack_m(n, "drone") else ("cultist" if Hack_m(n, "cultist") else "guard"))
	var w := {
		"node": n, "kind": kind,
		"faction": str(cfg.get("faction", "cult" if kind == "cultist" else "company")),
		"fov": float(cfg.get("fov", {"camera": 64.0, "drone": 70.0, "cultist": 90.0}.get(kind, 84.0))),
		"range": float(cfg.get("range", {"camera": 15.0, "drone": 14.0, "cultist": 11.0}.get(kind, 13.0))),
		"rate": float(cfg.get("rate", {"camera": 0.5, "drone": 0.5, "cultist": 0.5}.get(kind, 0.55))),
		"managed": bool(cfg.get("managed", false)),
		"path": cfg.get("path", []), "path_i": 0, "wait": 0.0,
		"post": n.global_position, "post_yaw": n.global_rotation.y, "base_y": n.position.y,
		"yaw0": float(cfg.get("yaw", n.global_rotation.y)), "has_yaw": cfg.has("yaw"),
		"pitch": float(cfg.get("pitch", 0.45 if kind in ["camera", "drone"] else 0.0)),
		"sweep": float(cfg.get("sweep", 0.0)), "sweep_speed": float(cfg.get("sweep_speed", 0.45)),
		"pivot": cfg.get("pivot", null), "led": cfg.get("led", null),
		"when": str(cfg.get("when", "")), "unless": str(cfg.get("unless", "")),
		"zone": cfg.get("zone", null), "safe": cfg.get("safe", null),
		"who": str(cfg.get("who", "")), "lines": cfg.get("lines", []),
		"sus": 0.0, "seen_t": -10.0, "last_seen": n.global_position, "state": "patrol",
		"inv_point": Vector3.ZERO, "inv_until": 0.0, "pose": "", "active": false, "sees": false,
		"yaw_now": float(cfg.get("yaw", n.global_rotation.y)), "phase": randf() * TAU,
		"eye_h": float(cfg.get("eye", 0.0 if kind in ["camera", "drone"] else 1.62)), "cone": null,
		"excl": [], "ground": float(cfg.get("ground", 0.0)), "hover_y": n.position.y,
		"passive": bool(cfg.get("passive", false)), "look_yaw": n.global_rotation.y,
		"pivot_offset": float(cfg.get("pivot_offset", 0.0)), "role": str(cfg.get("role", "")),
	}
	for c in n.find_children("*", "CollisionObject3D", true, false):
		(w["excl"] as Array).append((c as CollisionObject3D).get_rid())
	if n is CollisionObject3D:
		(w["excl"] as Array).append((n as CollisionObject3D).get_rid())
	if not cfg.has("ground"):
		w["ground"] = n.global_position.y if kind not in ["camera", "drone"] else _floor_below(n.global_position)
	var cone := MeshInstance3D.new()
	cone.mesh = ImmediateMesh.new()
	cone.material_override = _cone_mat
	cone.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	cone.top_level = true
	cone.visible = false
	main.level.add_child(cone)
	w["cone"] = cone
	watchers.append(w)
	return w


func watcher_of(n: Node) -> Dictionary:
	for w: Dictionary in watchers:
		if w["node"] == n:
			return w
	return {}


func _floor_below(p: Vector3) -> float:
	var space: PhysicsDirectSpaceState3D = main.player.get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(p, p + Vector3(0, -30, 0), 1)
	var hit := space.intersect_ray(q)
	return float((hit["position"] as Vector3).y) if not hit.is_empty() else 0.0


# ------------------------------------------------------------------ what Hack asks of us

func mask_steps(secs: float) -> void:
	_mask_until = maxf(_mask_until, now + secs)


func turn_away(n: Node) -> void:
	var w := watcher_of(n)
	if not w.is_empty():
		w["sus"] = minf(float(w["sus"]), 0.2)


## Pull the people Stealth drives toward a point; returns how many came.
func convene(p: Vector3, radius: float, secs: float, _src: Node = null) -> int:
	var k := 0
	for w: Dictionary in watchers:
		var n: Node3D = w["node"]
		if not is_instance_valid(n) or not w["managed"] or w["kind"] in ["camera"]:
			continue
		if n.global_position.distance_to(p) < radius:
			w["inv_point"] = p
			w["inv_until"] = now + secs
			k += 1
	return k


func sleep(n: Node, _secs: float) -> void:
	var w := watcher_of(n)
	if not w.is_empty():
		w["sus"] = 0.0


func bow_near(p: Vector3, radius: float, secs: float) -> void:
	for w: Dictionary in watchers:
		var n: Node3D = w["node"]
		if is_instance_valid(n) and w["kind"] == "cultist" and n.global_position.distance_to(p) < radius:
			main.hack.set_state(n, "bow", secs)
			w["sus"] = 0.0


func call_off(n: Node) -> void:
	var w := watcher_of(n)
	if not w.is_empty():
		w["sus"] = 0.0
		w["inv_until"] = 0.0


func is_sneaking() -> bool:
	return main.player.sneak


# ------------------------------------------------------------------ the loop

func _ctx() -> bool:
	return main.started and main.level != null and not main.loading and not main.ui.busy and not main.flags.has("cinematic") \
		and not main.player.seated and not main.ui.title.visible and not catching


func _physics_process(delta: float) -> void:
	now += delta
	if watchers.is_empty() or main.level == null:
		return
	_frame += 1
	var ctx := _ctx()
	var pp: Vector3 = main.player.global_position
	_exp_t -= delta
	if _exp_t <= 0.0:
		_exp_t = 0.25
		exposure = _exposure(pp)
	var max_sus := 0.0
	var any_sees := false
	var near_any := false
	for w: Dictionary in watchers.duplicate():
		var n: Node3D = w["node"]
		if not is_instance_valid(n):
			watchers.erase(w)
			continue
		var active := ctx and n.is_visible_in_tree() and _gate(w, pp)
		w["active"] = active
		_face(w)
		var v := 0.0
		var heard := 0.0
		if active and not _disabled(w):
			v = _sight(w, pp)
			heard = _noise(w, pp)
		w["sees"] = v > 0.0
		if v > 0.0:
			w["sus"] = float(w["sus"]) + delta * float(w["rate"]) * (0.45 + 1.4 * v) * (0.7 if is_sneaking() else 1.0)
			w["seen_t"] = now
			w["last_seen"] = pp
			any_sees = true
		elif heard > 0.0:
			w["sus"] = float(w["sus"]) + delta * 0.4 * heard
			w["last_seen"] = pp
			w["seen_t"] = now - 0.6
		elif not active:
			w["sus"] = maxf(0.0, float(w["sus"]) - delta * 1.0)
		elif now - float(w["seen_t"]) > 1.2:
			w["sus"] = maxf(0.0, float(w["sus"]) - delta * 0.22)
		if main.hack.has_state(n, "we"):
			w["sus"] = maxf(0.0, float(w["sus"]) - delta * 1.5)
		w["sus"] = clampf(float(w["sus"]), 0.0, 1.0)
		if float(w["sus"]) >= 1.0:
			if (w["kind"] == "camera" and main.hack.has_state(n, "hushed")) or not (test_mode or not main._selftest) or catching or no_catch:
				w["sus"] = 0.97
			else:
				_caught(w)
		max_sus = maxf(max_sus, float(w["sus"]))
		if active and n.global_position.distance_to(pp) < 6.0:
			near_any = true
		if w["managed"]:
			_drive(w, delta, pp)
		if _frame % 3 == 0:
			_cone(w)
	# the last safe point: unwatched, on the floor, nobody near
	_safe_t -= delta
	if _safe_t <= 0.0:
		_safe_t = 0.5
		if ctx and max_sus < 0.05 and not any_sees and not near_any and main.player.is_on_floor():
			last_safe = pp
			has_safe = true


func _gate(w: Dictionary, pp: Vector3) -> bool:
	if w["passive"]:
		return false
	var f: Dictionary = main.flags
	if w["when"] != "" and not f.has(w["when"]):
		return false
	if w["unless"] != "" and f.has(w["unless"]):
		return false
	var z = w["zone"]
	if z is AABB and not (z as AABB).has_point(pp + Vector3(0, 0.5, 0)):
		return false
	return true


func _disabled(w: Dictionary) -> bool:
	var n: Node = w["node"]
	var h = main.hack
	return h.has_state(n, "blind") or h.has_state(n, "asleep") or h.has_state(n, "bow") or h.has_state(n, "calledoff") \
		or h.has_state(n, "we")


## How lit Carl is: 1 by day, else from the level's lamps near him.
func _exposure(pp: Vector3) -> float:
	var lv = main.level
	if lv.kit_day:
		return 1.0
	var s := 0.0
	for l: Array in lv.lamps:
		var o := l[0] as OmniLight3D
		if not is_instance_valid(o) or not o.is_visible_in_tree() or o.light_energy < 0.05:
			continue
		var d := o.global_position.distance_to(pp)
		if d < o.omni_range:
			s += o.light_energy * (1.0 - d / o.omni_range)
	return clampf(0.3 + s * 0.45, 0.3, 1.0)


func _eye(w: Dictionary) -> Vector3:
	var n: Node3D = w["node"]
	return n.global_position + Vector3(0, float(w["eye_h"]) * n.global_transform.basis.get_scale().y, 0)


func _face(w: Dictionary) -> void:
	var n: Node3D = w["node"]
	if w["kind"] in ["camera", "drone"] and (w["has_yaw"] or w["managed"]):
		return  # yaw_now is set by _drive (managed) or fixed (cfg yaw)
	if w["kind"] in ["camera", "drone"] and not w["managed"]:
		w["yaw_now"] = float(w["yaw0"])
		return
	w["yaw_now"] = n.global_rotation.y


func _fwd(w: Dictionary, with_pitch := false) -> Vector3:
	var y := float(w["yaw_now"])
	var f := Vector3(-sin(y), 0, -cos(y))
	if with_pitch:
		var p := float(w["pitch"])
		f = (f * cos(p) + Vector3(0, -sin(p), 0)).normalized()
	return f


func eff_range(w: Dictionary) -> float:
	return float(w["range"]) * lerpf(0.45, 1.0, exposure) * (0.6 if is_sneaking() else 1.0)


## How well a watcher sees Carl right now, 0..1.
func _sight(w: Dictionary, pp: Vector3) -> float:
	var eye := _eye(w)
	var head: Vector3 = main.player.cam.global_position
	var chest := pp + Vector3(0, 0.6 if is_sneaking() else 1.0, 0)
	var to := head - eye
	var d := to.length()
	var r := eff_range(w)
	if d > r:
		return 0.0
	var inside := false
	var half := deg_to_rad(float(w["fov"])) / 2.0
	if w["kind"] in ["camera", "drone"]:
		inside = _fwd(w, true).angle_to(to) <= half
	else:
		var flat := Vector3(to.x, 0, to.z)
		inside = flat.length() < 0.01 or _fwd(w).angle_to(flat) <= half
	if not inside:
		if d < 1.4 and not is_sneaking() and w["kind"] not in ["camera", "drone"]:
			inside = true
		else:
			return 0.0
	if not (_los(eye, head, w) or _los(eye, chest, w)):
		return 0.0
	return clampf(1.0 - d / r, 0.12, 1.0)


func _los(a: Vector3, b: Vector3, w: Dictionary) -> bool:
	var space: PhysicsDirectSpaceState3D = main.player.get_world_3d().direct_space_state
	var ex: Array = (w["excl"] as Array).duplicate()
	ex.append(main.player.get_rid())
	var q := PhysicsRayQueryParameters3D.create(a, b, 1, ex)
	return space.intersect_ray(q).is_empty()


func _noise(w: Dictionary, pp: Vector3) -> float:
	var n: Node = w["node"]
	if w["kind"] in ["camera", "drone"] or main.hack.has_state(n, "deaf") or now < _mask_until:
		return 0.0
	var spd := Vector2(main.player.velocity.x, main.player.velocity.z).length()
	var r := 0.0
	if spd > 3.4:
		r = 9.0
	elif spd > 0.6 and not is_sneaking():
		r = 2.8
	var d := (n as Node3D).global_position.distance_to(pp)
	return 0.0 if d >= r else 1.0 - d / r


# ------------------------------------------------------------------ caught

func _caught(w: Dictionary) -> void:
	if catching:
		return
	catching = true
	var lv = main.level
	var ui = main.ui
	var n: Node3D = w["node"]
	var fac: String = w["faction"]
	w["state"] = "caught"
	main.play("sting", -6.0)
	ui.glitch(0.3, 0.4)
	var eye := _eye(w)
	main.player.face(eye, 0.5)
	var pool: Array = w["lines"] if not (w["lines"] as Array).is_empty() else LINES["caught"][fac]
	var ln: Array = pool[catches % pool.size()]
	var who: String = w["who"] if w["who"] != "" else (str(LINES["who"][w["role"]]) if LINES["who"].has(w["role"]) else str(ln[0]))
	await ui.say(who, str(ln[1]).trim_prefix("(game) "))
	await ui.think(str(LINES["walked"][fac]).trim_prefix("(game) "))
	if main.level != lv:
		catching = false
		return
	await ui.fade_to(1.0, 0.5)
	var safe: Vector3 = w["safe"] if w["safe"] is Vector3 else (last_safe if has_safe else lv.spawn)
	main.player.global_position = safe
	main.player.velocity = Vector3.ZERO
	var away := safe - n.global_position
	main.player.yaw = atan2(away.x, away.z) + PI
	main.player.pitch = 0.0
	main.player.sneak = false
	for o: Dictionary in watchers:
		o["sus"] = 0.0
		o["state"] = "patrol"
		o["inv_until"] = 0.0
		o["seen_t"] = -10.0
	if fac == "company":
		main.add_pressure(5.0, LINES["why"][fac])
	else:
		main.add_connection(5.0, LINES["why"][fac])
	main.log_line("caught", LINES["log"][fac])
	catches += 1
	ui.close()
	await ui.fade_to(0.0, 0.6)
	catching = false
	caught.emit(w)


# ------------------------------------------------------------------ the ones Stealth walks

func _drive(w: Dictionary, delta: float, pp: Vector3) -> void:
	var n: Node3D = w["node"]
	var h = main.hack
	match w["kind"]:
		"camera":
			_drive_camera(w, delta, pp)
			return
		"drone":
			_drive_drone(w, delta, pp)
			return
	if h.has_state(n, "asleep"):
		_pose(w, "slump")
		Anim.look(n, n.global_position + _fwd(w) * 2.0 + Vector3(0, 0.6, 0), 1.0, 0.05)
		return
	if h.has_state(n, "bow"):
		_pose(w, "kneel")
		return
	_pose(w, "")
	if h.has_state(n, "blind"):
		# look away: he turns from Carl, and keeps turned
		var d := n.global_position - pp
		_turn(n, atan2(-d.x, -d.z), delta, 3.0)
		Anim.idle(n, now, float(w["phase"]))
		return
	if h.has_state(n, "calledoff"):
		if _walk_to(w, w["post"], 1.6, delta):
			_turn(n, float(w["post_yaw"]) + PI, delta, 2.0)
			Anim.idle(n, now, float(w["phase"]))
		return
	if float(w["inv_until"]) > now:
		if _walk_to(w, w["inv_point"], 1.4, delta, 1.2):
			_turn(n, float(w["yaw_now"]) + sin(now * 1.3) * 0.04, delta, 1.0)
			Anim.idle(n, now, float(w["phase"]))
			Anim.look(n, w["inv_point"] + Vector3(0, 0.8, 0), 1.0, 0.1)
		return
	var sus := float(w["sus"])
	if sus >= ALERT and now - float(w["seen_t"]) < 1.5:
		# he has seen something: stop and turn to it
		var d2: Vector3 = w["last_seen"] - n.global_position
		_turn(n, atan2(-d2.x, -d2.z), delta, 2.6)
		Anim.idle(n, now, float(w["phase"]))
		Anim.look(n, pp + Vector3(0, 1.6, 0), 1.0, 0.12)
		return
	if sus >= 0.15:
		# not sure: go and look where it was
		if _walk_to(w, w["last_seen"], 0.9, delta, 1.5):
			_turn(n, float(w["yaw_now"]) + delta * 0.8, delta, 1.0)
			Anim.idle(n, now, float(w["phase"]))
		return
	var path: Array = w["path"]
	if path.size() >= 2:
		if float(w["wait"]) > 0.0:
			w["wait"] = float(w["wait"]) - delta
			_turn(n, float(w["look_yaw"]) + sin(now * 0.7 + float(w["phase"])) * 0.6, delta, 1.2)
			Anim.idle(n, now, float(w["phase"]))
			Anim.look(n, n.global_position + _fwd(w) * 4.0 + Vector3(0, 1.6, 0), 0.0, 0.05)
			return
		var tgt: Vector3 = path[int(w["path_i"]) % path.size()]
		if _walk_to(w, tgt, 1.05, delta):
			w["path_i"] = (int(w["path_i"]) + 1) % path.size()
			w["wait"] = 2.6
			w["look_yaw"] = n.global_rotation.y
	else:
		if _walk_to(w, w["post"], 1.0, delta):
			_turn(n, float(w["post_yaw"]) + sin(now * 0.4 + float(w["phase"])) * 0.7, delta, 1.0)
			Anim.idle(n, now, float(w["phase"]))


func _turn(n: Node3D, want: float, delta: float, speed: float) -> void:
	n.rotation.y = lerp_angle(n.rotation.y, want, minf(1.0, delta * speed))


## Walk a managed figure toward a point; true when there.
func _walk_to(w: Dictionary, p: Vector3, speed: float, delta: float, near := 0.3) -> bool:
	var n: Node3D = w["node"]
	var d := p - n.global_position
	d.y = 0.0
	if d.length() < near:
		return true
	n.global_position += d.normalized() * minf(speed * delta, d.length())
	_turn(n, atan2(-d.x, -d.z), delta, 6.0)
	Anim.walk(n, now, speed * 0.9, float(w["phase"]))
	return false


func _pose(w: Dictionary, p: String) -> void:
	if w["pose"] == p:
		return
	var n: Node3D = w["node"]
	w["pose"] = p
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
			head.rotation.x = 0.0
		n.position.y = float(w["base_y"])
	else:
		Anim.crouch(n)
		n.position.y = float(w["base_y"]) - 0.45
		var head2: Node3D = n.get_meta("head", null)
		if head2:
			head2.rotation.x = 0.85 if p == "slump" else 0.5


func _drive_camera(w: Dictionary, delta: float, pp: Vector3) -> void:
	var n: Node3D = w["node"]
	var h = main.hack
	var y0 := float(w["yaw0"])
	var want := y0 + sin(now * float(w["sweep_speed"]) + float(w["phase"])) * float(w["sweep"])
	var pitch := float(w["pitch"])
	if h.has_state(n, "asleep"):
		pitch = 1.2
	elif h.has_state(n, "blind"):
		want = y0 + PI * 0.75
	elif float(w["sus"]) >= ALERT and now - float(w["seen_t"]) < 1.5:
		var d: Vector3 = pp - n.global_position
		want = y0 + clampf(wrapf(atan2(-d.x, -d.z) - y0, -PI, PI), -float(w["sweep"]) - 0.5, float(w["sweep"]) + 0.5)
	w["yaw_now"] = lerp_angle(float(w["yaw_now"]), want, minf(1.0, delta * 2.5))
	var pv = w["pivot"]
	if pv is Node3D and is_instance_valid(pv):
		var off := float(w["pivot_offset"])
		(pv as Node3D).rotation.y = float(w["yaw_now"]) + off
		(pv as Node3D).rotation.x = lerpf((pv as Node3D).rotation.x, -pitch * cos(off), minf(1.0, delta * 3.0))
	var led = w["led"]
	if led is Node3D and is_instance_valid(led):
		(led as Node3D).visible = not h.has_state(n, "asleep") and not h.has_state(n, "blind") or fmod(now, 0.5) < 0.1


func _drive_drone(w: Dictionary, delta: float, pp: Vector3) -> void:
	var n: Node3D = w["node"]
	var h = main.hack
	if h.has_state(n, "asleep"):
		n.position.y = lerpf(n.position.y, float(w["ground"]) + 0.25, minf(1.0, delta * 4.0))
		n.rotation.z = lerpf(n.rotation.z, 0.5, minf(1.0, delta * 3.0))
		return
	n.rotation.z = lerpf(n.rotation.z, 0.0, minf(1.0, delta * 3.0))
	n.position.y = lerpf(n.position.y, float(w["hover_y"]) + sin(now * 1.7 + float(w["phase"])) * 0.15, minf(1.0, delta * 2.0))
	var want := float(w["yaw0"]) + sin(now * float(w["sweep_speed"]) + float(w["phase"])) * float(w["sweep"])
	if h.has_state(n, "blind"):
		want += PI * 0.8
	elif float(w["sus"]) >= ALERT and now - float(w["seen_t"]) < 1.5:
		var d: Vector3 = pp - n.global_position
		want = atan2(-d.x, -d.z)
	var path: Array = w["path"]
	if path.size() >= 2 and float(w["sus"]) < ALERT and not h.has_state(n, "blind"):
		var tgt: Vector3 = path[int(w["path_i"]) % path.size()]
		var d2 := tgt - n.global_position
		d2.y = 0.0
		if d2.length() < 0.5:
			w["path_i"] = (int(w["path_i"]) + 1) % path.size()
		else:
			n.global_position += d2.normalized() * minf(1.6 * delta, d2.length())
			want = atan2(-d2.x, -d2.z)
	w["yaw_now"] = lerp_angle(float(w["yaw_now"]), want, minf(1.0, delta * 2.0))
	n.rotation.y = float(w["yaw_now"])


# ------------------------------------------------------------------ the cones (frames on)

func _cone(w: Dictionary) -> void:
	var cone: MeshInstance3D = w["cone"]
	if not is_instance_valid(cone):
		return
	var n: Node3D = w["node"]
	var vis: bool = main.frames_on and w["active"] and not main.hack.has_state(n, "asleep")
	cone.visible = vis
	if not vis:
		return
	var im := cone.mesh as ImmediateMesh
	im.clear_surfaces()
	var eye := _eye(w)
	var gy := float(w["ground"]) + 0.06
	var o := Vector3(eye.x, gy, eye.z)
	var r := eff_range(w)
	var half := deg_to_rad(float(w["fov"])) / 2.0
	var col := GREEN
	var sus := float(w["sus"])
	if main.hack.has_state(n, "we"):
		col = Color(0.4, 1.0, 0.75)
	elif _disabled(w):
		col = Color(0.35, 0.4, 0.5)
	elif sus > 0.02:
		col = AMBER.lerp(RED, clampf((sus - ALERT) / (1.0 - ALERT), 0.0, 1.0)) if sus >= ALERT else GREEN.lerp(AMBER, sus / ALERT)
	var a0 := 0.28 + 0.3 * sus
	var y := float(w["yaw_now"])
	var space: PhysicsDirectSpaceState3D = main.player.get_world_3d().direct_space_state
	var segs := 14
	var pts := []
	var ray_y := gy + 1.0
	for i in segs + 1:
		var a := y - half + (2.0 * half) * float(i) / segs
		var dir := Vector3(-sin(a), 0, -cos(a))
		var ln := r
		var q := PhysicsRayQueryParameters3D.create(Vector3(o.x, ray_y, o.z), Vector3(o.x, ray_y, o.z) + dir * r, 1, w["excl"])
		var hit := space.intersect_ray(q)
		if not hit.is_empty():
			ln = (Vector3(o.x, ray_y, o.z)).distance_to(hit["position"])
		pts.append(o + dir * ln)
	im.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in segs:
		im.surface_set_color(Color(col.r, col.g, col.b, a0))
		im.surface_add_vertex(o)
		im.surface_set_color(Color(col.r, col.g, col.b, 0.0))
		im.surface_add_vertex(pts[i])
		im.surface_set_color(Color(col.r, col.g, col.b, 0.0))
		im.surface_add_vertex(pts[i + 1])
	im.surface_end()


# ------------------------------------------------------------------ the arc round the crosshair

class SusHUD extends Control:
	var st: Node

	func _process(_d: float) -> void:
		queue_redraw()

	func _draw() -> void:
		if st == null or st.main == null:
			return
		var main: Node = st.main
		size = get_viewport_rect().size
		if not main.started or main.ui.title.visible or not main.ui.overlay.visible or main.level == null:
			return
		var c := size / 2.0
		var font := ThemeDB.fallback_font
		if main.player.sneak:
			draw_string(font, Vector2(24, size.y - 40.0), LINES["crouch"], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.75, 0.8, 0.78, 0.7))
		var cam: Camera3D = main.player.cam
		var fwd := -cam.global_basis.z
		fwd.y = 0.0
		fwd = fwd.normalized()
		for w: Dictionary in st.watchers:
			var sus := float(w["sus"])
			if sus < 0.03 or not is_instance_valid(w["node"]):
				continue
			var d: Vector3 = (w["node"] as Node3D).global_position - cam.global_position
			d.y = 0.0
			if d.length() < 0.01:
				continue
			d = d.normalized()
			var ang := atan2(fwd.cross(d).y, fwd.dot(d))
			var a := -PI / 2.0 - ang
			var col: Color = AMBER.lerp(RED, clampf((sus - ALERT) / (1.0 - ALERT), 0.0, 1.0)) if sus >= ALERT else Color(0.85, 0.85, 0.8)
			col.a = 0.25 + 0.65 * sus
			var spread := 0.22 + 0.25 * sus
			draw_arc(c, 46.0, a - spread, a + spread, 16, col, 2.0 + 3.0 * sus)
			if sus >= ALERT:
				var tip := c + Vector2(cos(a), sin(a)) * 58.0
				draw_line(tip, tip + Vector2(cos(a), sin(a)) * (6.0 + 8.0 * sus), col, 3.0)
