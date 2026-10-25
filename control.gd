extends Control

var pos := 0.0
var dir := 1.0
var speed := 1.5
var zone_w := 0.12
var zone_c := 0.5
var reps := 0
var guy_scale := 1.0

func _process(delta):
	pos += dir * speed * delta
	if pos >= 1.0: pos = 1.0; dir = -1.0
	if pos <= 0.0: pos = 0.0; dir = 1.0
	queue_redraw()

func _input(e):
	if (e is InputEventMouseButton and e.pressed) or e.is_action_pressed("ui_accept"):
		check()

func check():
	if abs(pos - zone_c) <= zone_w / 2.0:
		reps += 1
		zone_w = min(0.5, 0.12 + reps * 0.01)
		speed = max(0.6, 1.5 - reps * 0.02)
		zone_c = randf_range(zone_w / 2.0, 1.0 - zone_w / 2.0)
		guy_scale = 1.0 + reps * 0.03
	else:
		reps = max(0, reps - 1)
		guy_scale = 1.0 + reps * 0.03

func _draw():
	var x := 100.0
	var w := 900.0
	var y := 300.0
	draw_rect(Rect2(x, y, w, 40), Color(0.2, 0.2, 0.2))
	draw_rect(Rect2(x + (zone_c - zone_w / 2.0) * w, y, zone_w * w, 40), Color.GREEN)
	draw_rect(Rect2(x + pos * w - 3, y - 10, 6, 60), Color.WHITE)
	draw_string(ThemeDB.fallback_font, Vector2(x, 200), "Reps: %d" % reps, HORIZONTAL_ALIGNMENT_LEFT, -1, 40)

	# the guy
	var gx := 540.0
	var gy := 550.0
	var s := guy_scale
	draw_rect(Rect2(gx - 60 * s, gy - 30 * s, 120 * s, 30 * s), Color.TAN)
	draw_circle(Vector2(gx + 75 * s, gy - 35 * s), 15 * s, Color.TAN)
	draw_rect(Rect2(gx + 40 * s, gy - 30 * s, 10 * s, 30 * s), Color.SADDLE_BROWN)
