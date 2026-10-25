extends Control
class_name CardboardWorkshopLevel

signal found_cardboard
signal examined_object(message: String)

const PLAYER_RADIUS := 0.025
const INTERACTION_DISTANCE := 0.09
const PLAYER_SPEED := 0.42

var player_position := Vector2(0.12, 0.79)
var held_directions: Dictionary = {}
var object_message := "Approche-toi d'un objet et appuie sur « Examiner »."
var found := false
var wood_position := Vector2(0.43, 0.54)
var weak_cardboard_position := Vector2(0.69, 0.77)
var real_cardboard_position := Vector2(0.84, 0.20)
var printer_position := Vector2(0.34, 0.20)
var documents_position := Vector2(0.57, 0.20)
var lamp_position := Vector2(0.88, 0.40)
var walking_time := 0.0
var obstacles: Array[Rect2] = []
var random_generator := RandomNumberGenerator.new()

func _ready() -> void:
	custom_minimum_size = Vector2(600, 240)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	obstacles = [
		Rect2(0.30, 0.36, 0.25, 0.13),
		Rect2(0.58, 0.49, 0.20, 0.13),
		Rect2(0.08, 0.16, 0.12, 0.12),
		Rect2(0.35, 0.76, 0.19, 0.08)
	]
	_place_cardboard_randomly()

func _place_cardboard_randomly() -> void:
	var possible_positions: Array[Vector2] = [
		Vector2(0.88, 0.22),
		Vector2(0.22, 0.31),
		Vector2(0.91, 0.86),
		Vector2(0.78, 0.28),
		Vector2(0.27, 0.67),
		Vector2(0.90, 0.66)
	]
	var valid_positions: Array[Vector2] = []
	for position in possible_positions:
		if not _hits_obstacle(position):
			valid_positions.append(position)
	if valid_positions.is_empty():
		push_error("No valid workshop spawn position for the sturdy cardboard.")
		return
	random_generator.randomize()
	real_cardboard_position = valid_positions[random_generator.randi_range(0, valid_positions.size() - 1)]

func set_direction(direction: Vector2, pressed: bool) -> void:
	var key := str(direction)
	held_directions[key] = direction if pressed else Vector2.ZERO

func _process(delta: float) -> void:
	if found or size.x <= 0.0 or size.y <= 0.0:
		return
	var direction := Vector2.ZERO
	for value in held_directions.values():
		direction += value
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		direction.x += 1.0
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		direction.y += 1.0
	if direction == Vector2.ZERO:
		return

	direction = direction.normalized()
	walking_time += delta
	var next_position := player_position
	next_position.x += direction.x * PLAYER_SPEED * delta * size.y / size.x
	if not _hits_obstacle(next_position):
		player_position.x = clampf(next_position.x, PLAYER_RADIUS, 1.0 - PLAYER_RADIUS)
	next_position = player_position
	next_position.y += direction.y * PLAYER_SPEED * delta
	if not _hits_obstacle(next_position):
		player_position.y = clampf(next_position.y, PLAYER_RADIUS, 1.0 - PLAYER_RADIUS)
	queue_redraw()

func _hits_obstacle(position: Vector2) -> bool:
	for obstacle in obstacles:
		var expanded := obstacle.grow(PLAYER_RADIUS)
		if expanded.has_point(position):
			return true
	return false

func examine_nearby_object() -> void:
	if found:
		examined_object.emit("Le carton résistant est déjà dans ton sac. Mission accomplie !")
		return
	var candidates: Array[Dictionary] = [
		{"position": printer_position, "message": "Bien pensé, mais c'est une vieille imprimante ! Elle clignote, ronronne... et imprime une page presque toute blanche."},
		{"position": documents_position, "message": "Tu as trouvé des documents de Thomas : des plans, des mesures et une liste de pièces. Très utile pour la fusée, mais ce n'est pas le carton."},
		{"position": lamp_position, "message": "C'est une vieille lampe d'atelier. Elle éclaire bien les coins poussiéreux, mais elle ne fera pas une combinaison !"},
		{"position": wood_position, "message": "Aïe, c'est une planche en bois ! Elle est bien trop lourde pour une combinaison."},
		{"position": weak_cardboard_position, "message": "Tu as trouvé un vieux carton tout mou. Il se déchire : il ne sera pas assez résistant."},
		{"position": real_cardboard_position, "message": "Bien joué ! C'est du carton épais et solide. Thomas pourra l'utiliser pour protéger les pièces fragiles de la combinaison."}
	]
	for candidate in candidates:
		var distance := player_position.distance_to(candidate["position"])
		if distance <= INTERACTION_DISTANCE:
			object_message = candidate["message"]
			if candidate["position"] == real_cardboard_position:
				found = true
				queue_redraw()
				examined_object.emit(object_message)
				found_cardboard.emit()
				return
			examined_object.emit(object_message)
			queue_redraw()
			return
	object_message = "Il n'y a rien à portée. Explore l'atelier et approche-toi des objets."
	examined_object.emit(object_message)

func _draw() -> void:
	var room := Rect2(Vector2.ZERO, size)
	draw_rect(room, Color("#726553"))
	var plank_height := size.y / 10.0
	for row in range(10):
		var y := row * plank_height
		var plank_color := Color("#9a8061") if row % 2 == 0 else Color("#8c7459")
		draw_rect(Rect2(0, y, size.x, plank_height - 2), plank_color)
		for seam in range(5):
			var seam_x := (seam + (row % 2) * 0.5) * size.x / 4.5
			draw_line(Vector2(seam_x, y + 2), Vector2(seam_x, y + plank_height - 4), Color("#735f4b", 0.7), 2)
	draw_rect(Rect2(0, 0, size.x, size.y * 0.08), Color("#655747"))
	draw_rect(Rect2(0, size.y * 0.08, size.x * 0.19, size.y * 0.18), Color("#809092"))
	draw_rect(Rect2(size.x * 0.02, size.y * 0.10, size.x * 0.15, size.y * 0.14), Color("#b2c1b8"))
	draw_line(Vector2(size.x * 0.095, size.y * 0.10), Vector2(size.x * 0.095, size.y * 0.24), Color("#e6dfcf"), 4)
	draw_line(Vector2(size.x * 0.02, size.y * 0.17), Vector2(size.x * 0.17, size.y * 0.17), Color("#e6dfcf"), 4)

	for obstacle in obstacles:
		_draw_obstacle(obstacle)
	_draw_box(Vector2(0.12, 0.43), Color("#a4815f"), 0.12)
	_draw_box(Vector2(0.23, 0.59), Color("#b0916f"), 0.10)
	_draw_box(Vector2(0.81, 0.55), Color("#997654"), 0.12)
	_draw_tools(Vector2(0.64, 0.25))
	_draw_printer(printer_position)
	_draw_documents(documents_position)
	_draw_lamp(lamp_position)
	_draw_wood(wood_position)
	_draw_cardboard(weak_cardboard_position, false)
	_draw_cardboard(real_cardboard_position, true)
	_draw_player(player_position)

	if found:
		draw_circle(_to_screen(real_cardboard_position), minf(size.x, size.y) * 0.075, Color("#e5d1a4", 0.35))

func _draw_obstacle(obstacle: Rect2) -> void:
	var rect := Rect2(obstacle.position * size, obstacle.size * size)
	draw_rect(rect.grow(4), Color("#493f34"))
	draw_rect(rect, Color("#695747"))
	draw_line(rect.position + Vector2(4, 5), rect.position + Vector2(rect.size.x - 4, 5), Color("#ac9271"), 3)
	for leg_x in [0.12, 0.82]:
		var x: float = rect.position.x + rect.size.x * float(leg_x)
		draw_rect(Rect2(x, rect.end.y - 2, 8, 13), Color("#574838"))

func _draw_box(position: Vector2, color: Color, box_size: float) -> void:
	var center := _to_screen(position)
	var dimensions := Vector2(size.x * box_size, size.y * box_size * 0.62)
	var rect := Rect2(center - dimensions * 0.5, dimensions)
	draw_rect(rect, Color("#5e4b39"))
	draw_rect(rect.grow(-3), color)
	draw_line(rect.position + Vector2(3, 4), rect.end - Vector2(3, 4), Color("#d0b58d"), 2)
	draw_line(Vector2(rect.position.x + rect.size.x * 0.5, rect.position.y), Vector2(rect.position.x + rect.size.x * 0.5, rect.end.y), Color("#806a50"), 2)

func _draw_tools(position: Vector2) -> void:
	var center := _to_screen(position)
	for index in range(4):
		var tool_start := center + Vector2(index * 12 - 18, 4)
		draw_line(tool_start, tool_start + Vector2(10, -22), Color("#765a42"), 4)
		draw_circle(tool_start + Vector2(10, -22), 4, Color("#b0a58f"))

func _draw_printer(position: Vector2) -> void:
	var center := _to_screen(position)
	var width := size.x * 0.095
	var height := size.y * 0.115
	draw_rect(Rect2(center + Vector2(-width * 0.5, -height * 0.38), Vector2(width, height * 0.78)), Color("#594e43"))
	draw_rect(Rect2(center + Vector2(-width * 0.42, -height * 0.52), Vector2(width * 0.84, height * 0.62)), Color("#aaa18e"))
	draw_rect(Rect2(center + Vector2(-width * 0.34, -height * 0.22), Vector2(width * 0.68, height * 0.28)), Color("#756d60"))
	draw_rect(Rect2(center + Vector2(-width * 0.16, -height * 0.72), Vector2(width * 0.52, height * 0.42)), Color("#eee9dc"))
	draw_circle(center + Vector2(width * 0.30, -height * 0.28), 3, Color("#b9825d"))
	draw_line(center + Vector2(-width * 0.27, height * 0.08), center + Vector2(width * 0.28, height * 0.08), Color("#d0c7b5"), 2)

func _draw_documents(position: Vector2) -> void:
	var center := _to_screen(position)
	var width := size.x * 0.065
	var height := size.y * 0.09
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-width * 0.5, -height * 0.45),
		center + Vector2(width * 0.33, -height * 0.5),
		center + Vector2(width * 0.5, height * 0.4),
		center + Vector2(-width * 0.42, height * 0.48)
	]), Color("#e1dac6"))
	for line_index in range(3):
		var y: float = center.y - height * 0.2 + line_index * height * 0.18
		draw_line(Vector2(center.x - width * 0.28, y), Vector2(center.x + width * 0.27, y), Color("#77877d"), 2)
	draw_line(center + Vector2(width * 0.24, -height * 0.49), center + Vector2(width * 0.24, -height * 0.24), Color("#b7aa91"), 2)

func _draw_lamp(position: Vector2) -> void:
	var center := _to_screen(position)
	draw_line(center + Vector2(0, 12), center + Vector2(0, -20), Color("#615548"), 5)
	draw_line(center + Vector2(0, -18), center + Vector2(-17, -31), Color("#615548"), 5)
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-28, -32),
		center + Vector2(-19, -49),
		center + Vector2(-5, -49),
		center + Vector2(1, -32)
	]), Color("#b49a71"))
	draw_arc(center + Vector2(-12, -31), 15, 0, PI, 12, Color("#78664e"), 2)
	draw_line(center + Vector2(-7, 12), center + Vector2(8, 12), Color("#615548"), 4)

func _draw_wood(position: Vector2) -> void:
	var center := _to_screen(position)
	draw_line(center + Vector2(-size.x * 0.035, 3), center + Vector2(size.x * 0.035, -5), Color("#644832"), 13, true)
	draw_line(center + Vector2(-size.x * 0.035, 1), center + Vector2(size.x * 0.035, -7), Color("#b58858"), 8, true)
	draw_line(center + Vector2(-size.x * 0.017, -1), center + Vector2(size.x * 0.015, -5), Color("#d4b27e"), 2, true)

func _draw_cardboard(position: Vector2, sturdy: bool) -> void:
	var center := _to_screen(position)
	var cardboard_color := Color("#b18a5e") if sturdy else Color("#c4a77b")
	var width := size.x * 0.055
	var height := size.y * 0.075
	var panel := PackedVector2Array([
		center + Vector2(-width * 0.5, -height * 0.25),
		center + Vector2(-width * 0.42, -height * 0.58),
		center + Vector2(width * 0.38, -height * 0.58),
		center + Vector2(width * 0.5, -height * 0.18),
		center + Vector2(width * 0.37, height * 0.38),
		center + Vector2(-width * 0.35, height * 0.42)
	])
	draw_colored_polygon(panel, cardboard_color)
	draw_polyline(PackedVector2Array([panel[0], panel[1], panel[2], panel[3], panel[4], panel[5], panel[0]]), Color("#73593e"), 3)
	draw_line(center + Vector2(-width * 0.3, -height * 0.12), center + Vector2(width * 0.25, height * 0.12), Color("#ddc39a"), 2)
	if not sturdy:
		draw_line(center + Vector2(-width * 0.12, -height * 0.54), center + Vector2(width * 0.05, height * 0.45), Color("#765c40"), 3)

func _draw_player(position: Vector2) -> void:
	var center := _to_screen(position)
	var scale := minf(size.x, size.y)
	var step := sin(walking_time * 13.0) * scale * 0.006
	draw_circle(center + Vector2(0, scale * 0.032), scale * 0.032, Color("#594a3d", 0.55))
	draw_line(center + Vector2(-scale * 0.012, scale * 0.035), center + Vector2(-scale * 0.015 + step, scale * 0.060), Color("#434a48"), 7, true)
	draw_line(center + Vector2(scale * 0.012, scale * 0.035), center + Vector2(scale * 0.015 - step, scale * 0.060), Color("#434a48"), 7, true)
	draw_line(center + Vector2(-scale * 0.015 + step, scale * 0.060), center + Vector2(-scale * 0.027 + step, scale * 0.061), Color("#514638"), 5, true)
	draw_line(center + Vector2(scale * 0.015 - step, scale * 0.060), center + Vector2(scale * 0.027 - step, scale * 0.061), Color("#514638"), 5, true)
	draw_rect(Rect2(center + Vector2(-scale * 0.026, -scale * 0.006), Vector2(scale * 0.052, scale * 0.050)), Color("#748a7d"))
	draw_line(center + Vector2(-scale * 0.022, scale * 0.002), center + Vector2(-scale * 0.039, scale * 0.028), Color("#748a7d"), 6, true)
	draw_line(center + Vector2(scale * 0.022, scale * 0.002), center + Vector2(scale * 0.039, scale * 0.028), Color("#748a7d"), 6, true)
	draw_circle(center + Vector2(0, -scale * 0.030), scale * 0.027, Color("#d6ae8b"))
	draw_arc(center + Vector2(0, -scale * 0.036), scale * 0.027, PI, TAU, 16, Color("#706754"), 6, true)
	draw_circle(center + Vector2(-scale * 0.009, -scale * 0.030), scale * 0.0025, Color("#454747"))
	draw_circle(center + Vector2(scale * 0.009, -scale * 0.030), scale * 0.0025, Color("#454747"))

func _to_screen(position: Vector2) -> Vector2:
	return position * size
