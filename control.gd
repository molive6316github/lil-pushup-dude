extends Control

@onready var label: Label = $Label

var pos := 0.0
var dir := 1.0
var speed := 1.2
var green_half := 0.03
var yellow_half := 0.10
var score := 0
var fatigue := 0.0

func _ready():
	label.add_theme_font_size_override("font_size", 40)
	label.text = "0"

func restart():
	pos = 0.0
	dir = 1.0
	green_half = 0.03
	yellow_half = 0.10
	score = 0
	fatigue = 0.0
	label.text = "0"

func _process(delta):
	fatigue = max(0.0, fatigue - 0.8 * delta)
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
	var d = abs(pos - 0.5)
	if d <= green_half:
		score += 1
		if score >= 0:
			green_half += 0.005
			yellow_half += 0.01
	elif d > yellow_half:
		score -= 1
		green_half = max(0.03, green_half - 0.002)
		yellow_half = max(0.10, yellow_half - 0.004)
	fatigue += 0.5
	if fatigue >= 1.0 or score >= 100:
		restart()
	else:
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
	draw_rect(Rect2(x + pos * w - 2, y - 8, 4, h + 16), Color.WHITE)
