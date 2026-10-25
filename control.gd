extends Control

@onready var label: Label = $Label

const WIN_SCORE := 100
const GREEN_GROW := 0.002
const YELLOW_GROW := 0.004
const GREEN_SHRINK := 0.001
const YELLOW_SHRINK := 0.002
const MAX_SCALE := 4.6
const GOLD_HALF := 0.01

var pos := 0.0
var dir := 1.0
var speed := 1.2
var green_half := 0.03
var yellow_half := 0.10
var score := 0
var fatigue := 0.0
var msg_time := 0.0
var dip := 0.0
var gold_unlocked := false
var only_gold := true

func _ready():
	label.add_theme_font_size_override("font_size", 40)
	label.text = "0"

func restart(message: String = ""):
	pos = 0.0
	dir = 1.0
	green_half = 0.03
	yellow_half = 0.10
	score = 0
	fatigue = 0.0
	only_gold = true
	if message != "":
		label.text = message
		msg_time = 2.0
	else:
		label.text = "0"

func _process(delta):
	if msg_time > 0.0:
		msg_time -= delta
		if msg_time <= 0.0:
			label.text = str(score)
	fatigue = max(0.0, fatigue - 0.8 * delta)
	label.add_theme_color_override("font_color", Color.RED if fatigue >= 0.5 else Color.WHITE)
	pos += dir * speed * delta
	if pos >= 1.0: pos = 1.0; dir = -1.0
	if pos <= 0.0: pos = 0.0; dir = 1.0
	var w := size.x * 0.75
	var x := (size.x - w) / 2.0
	label.position = Vector2(x, size.y * 0.5 - 100)
	queue_redraw()

func _input(e):
	var clicked: bool = (e is InputEventMouseButton and e.pressed) or e.is_action_pressed("ui_accept")
	if not clicked:
		return
	dip = 1.0
	var t = create_tween()
	t.tween_property(self, "dip", 0.0, 0.25)
	var d = abs(pos - 0.5)
	var fatigue_add := 0.5
	var is_gold: bool = gold_unlocked and d <= GOLD_HALF
	if not is_gold:
		only_gold = false
	if is_gold:
		score += 2
		fatigue_add = 0.0
		if score >= 0:
			green_half += GREEN_GROW
			yellow_half += YELLOW_GROW
	elif d <= green_half:
		score += 1
		if score >= 0:
			green_half += GREEN_GROW
			yellow_half += YELLOW_GROW
	elif d > yellow_half:
		score -= 1
		green_half = max(0.03, green_half - GREEN_SHRINK)
		yellow_half = max(0.10, yellow_half - YELLOW_SHRINK)
	fatigue += fatigue_add
	if fatigue >= 1.0:
		restart("you tired and collapse. restarty time")
	elif score >= WIN_SCORE:
		var msg := "congrats you are win"
		if only_gold:
			msg = "woah you so fast reaction such good job yay!!"
		elif not gold_unlocked:
			msg = "congrats you are win also u get special challenge yay"
		gold_unlocked = true
		restart(msg)
	elif msg_time <= 0.0:
		label.text = str(score)

func _draw():
	var w := size.x * 0.75
	var x := (size.x - w) / 2.0
	var y := size.y * 0.5
	var h := 60.0
	var yh: float = min(yellow_half, 0.5)
	var gh: float = min(green_half, 0.5)
	draw_rect(Rect2(x, y, w, h), Color.RED)
	draw_rect(Rect2(x + (0.5 - yh) * w, y, yh * 2.0 * w, h), Color.ORANGE)
	draw_rect(Rect2(x + (0.5 - gh) * w, y, gh * 2.0 * w, h), Color.GREEN)
	if gold_unlocked:
		draw_rect(Rect2(x + (0.5 - GOLD_HALF) * w, y, GOLD_HALF * 2.0 * w, h), Color.GOLD)
	draw_rect(Rect2(x + pos * w - 2, y - 8, 4, h + 16), Color.WHITE)

	var s: float = 0.6 + (float(max(score, 0)) / WIN_SCORE) * (MAX_SCALE - 0.6)
	var gx := size.x * 0.5
	var gy := size.y * 0.5 + 250.0
	var body_len := 140.0 * s
	var arm_len := 45.0 * s
	var up: float = 10.0 * s + (arm_len - 10.0 * s) * (1.0 - dip)
	var feet := Vector2(gx - body_len / 2.0, gy)
	var hands := Vector2(gx + body_len / 2.0 - 10.0 * s, gy)
	var shoulder := Vector2(hands.x, gy - up)
	var head_dir := (shoulder - feet).normalized()
	var head := shoulder + head_dir * 16.0 * s
	var lw: float = 3.0 + s * 1.5
	draw_line(feet, shoulder, Color.WHITE, lw)
	draw_line(shoulder, hands, Color.WHITE, lw)
	draw_arc(head, 12.0 * s, 0.0, TAU, 32, Color.WHITE, lw)
