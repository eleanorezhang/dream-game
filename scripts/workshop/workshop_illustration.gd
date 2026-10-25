extends Control
class_name WorkshopIllustration

var animation_time := 0.0

func _ready() -> void:
	custom_minimum_size = Vector2(420, 220)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	animation_time += delta
	queue_redraw()

func _draw() -> void:
	var room := Rect2(Vector2.ZERO, size)
	draw_rect(room, Color("#d9d5c9"))
	draw_rect(Rect2(0, 0, size.x, size.y * 0.70), Color("#ddd9cd"))
	draw_rect(Rect2(0, size.y * 0.70, size.x, size.y * 0.30), Color("#a8957e"))
	draw_line(Vector2(0, size.y * 0.70), Vector2(size.x, size.y * 0.70), Color("#8d806f"), 3)

	var window := Rect2(size.x * 0.07, size.y * 0.10, size.x * 0.32, size.y * 0.32)
	draw_rect(window, Color("#849da1"))
	draw_rect(window.grow(-6), Color("#b9c8c0"))
	draw_line(
		Vector2(window.position.x + window.size.x * 0.5, window.position.y),
		Vector2(window.position.x + window.size.x * 0.5, window.end.y),
		Color("#f3eee0"),
		5
	)
	draw_line(
		Vector2(window.position.x, window.position.y + window.size.y * 0.52),
		Vector2(window.end.x, window.position.y + window.size.y * 0.52),
		Color("#f3eee0"),
		5
	)
	draw_circle(window.position + Vector2(window.size.x * 0.74, window.size.y * 0.24), 11, Color("#eee2bd"))

	draw_rect(Rect2(size.x * 0.05, size.y * 0.47, size.x * 0.38, 5), Color("#806f5d"))
	for box_index in range(3):
		var box_position := Vector2(size.x * (0.07 + box_index * 0.12), size.y * 0.36)
		draw_rect(Rect2(box_position, Vector2(30, size.y * 0.10)), Color("#b69a78"))
		draw_line(box_position + Vector2(4, 4), box_position + Vector2(25, 4), Color("#ddc6a3"), 2)
	draw_circle(Vector2(size.x * 0.12, size.y * 0.27), 8, Color("#a68d72"))

	for shelf_x in [0.48, 0.69, 0.88]:
		var x: float = size.x * float(shelf_x)
		draw_line(Vector2(x, size.y * 0.15), Vector2(x, size.y * 0.46), Color("#806f5d"), 5)
		draw_line(Vector2(x - 17, size.y * 0.29), Vector2(x + 17, size.y * 0.29), Color("#806f5d"), 4)
	draw_rect(Rect2(size.x * 0.53, size.y * 0.19, 24, 18), Color("#b98562"), true)
	draw_rect(Rect2(size.x * 0.75, size.y * 0.19, 29, 22), Color("#80918a"), true)
	draw_circle(Vector2(size.x * 0.88, size.y * 0.24), 11, Color("#d1b680"))
	draw_rect(Rect2(size.x * 0.65, size.y * 0.34, 35, 20), Color("#9f7861"))
	draw_rect(Rect2(size.x * 0.67, size.y * 0.36, 31, 17), Color("#d8d0bb"))
	draw_circle(Vector2(size.x * 0.74, size.y * 0.37), 4, Color("#8e765f"))

	var table_y := size.y * 0.62
	draw_rect(Rect2(size.x * 0.46, table_y, size.x * 0.51, 13), Color("#785f4b"), true)
	draw_rect(Rect2(size.x * 0.50, table_y + 13, 10, size.y * 0.25), Color("#785f4b"), true)
	draw_rect(Rect2(size.x * 0.91, table_y + 13, 10, size.y * 0.25), Color("#785f4b"), true)
	draw_rect(Rect2(size.x * 0.51, table_y - 22, 42, 17), Color("#eee7d7"))
	draw_line(Vector2(size.x * 0.53, table_y - 18), Vector2(size.x * 0.59, table_y - 18), Color("#7f9791"), 2)
	draw_line(Vector2(size.x * 0.53, table_y - 13), Vector2(size.x * 0.57, table_y - 13), Color("#7f9791"), 2)
	draw_circle(Vector2(size.x * 0.61, table_y - 13), 6, Color("#b88363"))
	draw_circle(Vector2(size.x * 0.61, table_y - 13), 3, Color("#e8d8bf"))
	draw_rect(Rect2(size.x * 0.84, table_y - 13, 29, 12), Color("#86938a"))
	draw_circle(Vector2(size.x * 0.855, table_y - 14), 5, Color("#86938a"))
	draw_circle(Vector2(size.x * 0.855, table_y - 14), 2, Color("#dcd6c4"))
	draw_line(Vector2(size.x * 0.91, table_y - 16), Vector2(size.x * 0.94, table_y - 25), Color("#b87c5d"), 3)
	draw_line(Vector2(size.x * 0.91, table_y - 16), Vector2(size.x * 0.89, table_y - 26), Color("#b87c5d"), 3)

	var rocket_base := Vector2(size.x * 0.70, table_y - 9)
	draw_colored_polygon(PackedVector2Array([
		rocket_base + Vector2(0, 0),
		rocket_base + Vector2(22, 0),
		rocket_base + Vector2(17, -44),
		rocket_base + Vector2(11, -54),
		rocket_base + Vector2(5, -44)
	]), Color("#e6e1d4"))
	draw_circle(rocket_base + Vector2(11, -29), 4, Color("#8099a0"))
	draw_colored_polygon(PackedVector2Array([
		rocket_base + Vector2(2, -8),
		rocket_base + Vector2(-5, 2),
		rocket_base + Vector2(4, 2)
	]), Color("#bd8061"))
	draw_colored_polygon(PackedVector2Array([
		rocket_base + Vector2(20, -8),
		rocket_base + Vector2(27, 2),
		rocket_base + Vector2(18, 2)
	]), Color("#bd8061"))
	draw_line(rocket_base + Vector2(11, -48), rocket_base + Vector2(20, -42), Color("#bd8061"), 2)

	draw_rect(Rect2(size.x * 0.45, size.y * 0.49, 18, 12), Color("#bd8061"), true)
	draw_rect(Rect2(size.x * 0.48, size.y * 0.49, 18, 12), Color("#d2b28a"), true)
	draw_circle(Vector2(size.x * 0.55, size.y * 0.52), 4, Color("#657d77"))

	var player := Vector2(size.x * 0.19, size.y * 0.76)
	draw_circle(player + Vector2(0, -37), 15, Color("#d3aa87"))
	_draw_rounded_rect(Rect2(player + Vector2(-17, -23), Vector2(34, 48)), Color("#7b8c83"), 10)
	draw_line(player + Vector2(-8, 22), player + Vector2(-11, 43), Color("#555d59"), 7, true)
	draw_line(player + Vector2(8, 22), player + Vector2(11, 43), Color("#555d59"), 7, true)

	var thomas := Vector2(size.x * 0.48, size.y * 0.73)
	draw_line(thomas + Vector2(-12, 18), thomas + Vector2(-15, 53), Color("#535b62"), 9, true)
	draw_line(thomas + Vector2(12, 18), thomas + Vector2(15, 53), Color("#535b62"), 9, true)
	_draw_rounded_rect(Rect2(thomas + Vector2(-22, -24), Vector2(44, 48)), Color("#718a82"), 12)
	draw_circle(thomas + Vector2(0, -45), 16, Color("#d6ae8b"))
	draw_arc(thomas + Vector2(0, -47), 16, PI, TAU, 24, Color("#77715f"), 6, true)
	draw_circle(thomas + Vector2(-5, -45), 1.8, Color("#454747"))
	draw_circle(thomas + Vector2(5, -45), 1.8, Color("#454747"))
	draw_arc(thomas + Vector2(0, -39), 4, 0, PI, 12, Color("#8a6256"), 1.5, true)

	var wave := sin(animation_time * 2.0) * 4.0
	draw_line(thomas + Vector2(16, -13), thomas + Vector2(31, -28 + wave), Color("#718a82"), 10, true)
	draw_circle(thomas + Vector2(31, -28 + wave), 6, Color("#d6ae8b"))

func _draw_rounded_rect(rect: Rect2, color: Color, radius: int) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(radius)
	style.set_content_margin_all(0)
	draw_style_box(style, rect)
