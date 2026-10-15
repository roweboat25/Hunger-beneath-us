extends Node2D
class_name Waypoint
## A bouncing chevron over the thing the objective points at: the door to
## take, the exit, the sedan. Drawn, not a sprite, so it reads at any zoom.

var _t := 0.0


func _ready() -> void:
	z_index = 60


func _process(delta: float) -> void:
	_t += delta
	queue_redraw()


func _draw() -> void:
	var bob := sin(_t * 4.0) * 3.0
	var col := Color("f5d6a0")
	var dark := Color("050608", 0.8)
	var p := Vector2(0, bob)
	for w in [3.0, 1.5]:
		var c := dark if w > 2.0 else col
		draw_line(p + Vector2(-7, -10), p + Vector2(0, -3), c, w)
		draw_line(p + Vector2(7, -10), p + Vector2(0, -3), c, w)
		draw_line(p + Vector2(-7, -18), p + Vector2(0, -11), c, w)
		draw_line(p + Vector2(7, -18), p + Vector2(0, -11), c, w)
