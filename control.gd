extends Control

@onready var label: Label = $Label

var pos := 0.0
var dir := 1.0
var speed := 1.2
var green_half := 0.03
var yellow_half := 0.10

func _ready():
	label.add_theme_font_size_override("font_size", 40)
	label.text = ""

func _process(delta):
	pos += dir * speed * delta
	if pos >= 1.0: pos = 1.0; dir = -1.0
	if pos <= 0.0: pos = 0.0; dir = 1.0
	var w := size.x * 0.75
	label.position = Vector2((size.x - w) / 2.0, size.y * 0.5 + 80)
	queue_redraw()

func _input(e):
	if (e is InputEventMouseButton and e.pressed) or e.is_action_pressed("ui_accept"):
		var d = abs(pos - 0.5)
		if d <= green_half:
			label.text = "+"
		elif d <= yellow_half:
			label.text = "="
		else:
			label.text = "-"

func _draw():
	var w := size.x * 0.75
	var x := (size.x - w) / 2.0
	var y := size.y * 0.5
	var h := 60.0
	draw_rect(Rect2(x, y, w, h), Color.RED)
	draw_rect(Rect2(x + (0.5 - yellow_half) * w, y, yellow_half * 2.0 * w, h), Color.ORANGE)
	draw_rect(Rect2(x + (0.5 - green_half) * w, y, green_half * 2.0 * w, h), Color.GREEN)
	draw_rect(Rect2(x + pos * w - 2, y - 8, 4, h + 16), Color.WHITE)
