extends Control
class_name SuitPiecesWorkshopLevel

signal found_wood
signal cut_pieces_done
signal found_ruler
signal examined_object(message: String)
signal measured_pieces

const PLAYER_RADIUS := 0.025
const INTERACTION_DISTANCE := 0.10
const PLAYER_SPEED := 0.42
const WOOD_POSITION := Vector2(0.20, 0.55)
const RULER_POSITION := Vector2(0.84, 0.25)
const WORKBENCH_POSITION := Vector2(0.53, 0.68)

var player_position := Vector2(0.12, 0.82)
var held_directions: Dictionary = {}
var walking_time := 0.0
var wood_collected := false
var pieces_cut := false
var ruler_collected := false
var pieces_measured := false
var obstacles: Array[Rect2] = []

func _ready() -> void:
	custom_minimum_size = Vector2(600, 240)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	obstacles = [
		Rect2(0.34, 0.44, 0.27, 0.14),
		Rect2(0.60, 0.69, 0.15, 0.12),
		Rect2(0.07, 0.18, 0.13, 0.12)
	]

func set_direction(direction: Vector2, pressed: bool) -> void:
	held_directions[str(direction)] = direction if pressed else Vector2.ZERO

func _process(delta: float) -> void:
	if pieces_measured or size.x <= 0.0 or size.y <= 0.0:
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
		if obstacle.grow(PLAYER_RADIUS).has_point(position):
			return true
	return false

func examine_nearby_object() -> void:
	if pieces_measured:
		examined_object.emit("Les pièces sont déjà mesurées. Beau travail !")
		return
	if not wood_collected and player_position.distance_to(WOOD_POSITION) <= INTERACTION_DISTANCE:
		wood_collected = true
		examined_object.emit("Tu as trouvé une planche fine et solide. Elle peut servir à fabriquer les pièces de la combinaison !")
		found_wood.emit()
		queue_redraw()
		return
	if not pieces_cut and player_position.distance_to(WORKBENCH_POSITION) <= INTERACTION_DISTANCE:
		examined_object.emit("L'établi est prêt. Utilise le bouton « Découper les pièces » pour travailler le bois.")
		return
	if pieces_cut and not ruler_collected and player_position.distance_to(RULER_POSITION) <= INTERACTION_DISTANCE:
		ruler_collected = true
		examined_object.emit("Tu as trouvé la règle de Thomas, cachée sous des plans ! Retourne à l'établi pour mesurer les pièces.")
		found_ruler.emit()
		queue_redraw()
		return
	if not ruler_collected and player_position.distance_to(RULER_POSITION) <= INTERACTION_DISTANCE:
		examined_object.emit("C'est une règle, mais vérifie d'abord que les pièces en bois sont bien découpées.")
		return
	if player_position.distance_to(Vector2(0.72, 0.35)) <= INTERACTION_DISTANCE:
		examined_object.emit("Ce sont les plans de Thomas. Les mesures y sont notées, mais il nous faut d'abord les pièces et une règle.")
		return
	examined_object.emit("Approche-toi de la planche, de l'établi ou de l'étagère pour examiner les objets.")

func cut_pieces() -> void:
	if not wood_collected:
		examined_object.emit("Il faut d'abord trouver une planche de bois solide dans l'atelier.")
		return
	if pieces_cut:
		examined_object.emit("Les pièces en bois sont déjà découpées. Il faut maintenant trouver la règle.")
		return
	if player_position.distance_to(WORKBENCH_POSITION) > INTERACTION_DISTANCE:
		examined_object.emit("Approche-toi de l'établi pour découper les pièces en bois.")
		return
	pieces_cut = true
	examined_object.emit("Bien joué ! Tu as découpé trois pièces en bois pour préparer la combinaison. Il faut maintenant trouver la règle de Thomas pour les mesurer.")
	cut_pieces_done.emit()
	queue_redraw()

func measure_pieces() -> void:
	if not pieces_cut:
		examined_object.emit("Découpe d'abord les pièces dans la planche en bois.")
		return
	if not ruler_collected:
		examined_object.emit("Il te faut d'abord trouver la règle de Thomas dans l'atelier.")
		return
	if player_position.distance_to(WORKBENCH_POSITION) > INTERACTION_DISTANCE:
		examined_object.emit("Retourne près de l'établi avec la règle pour mesurer les pièces.")
		return
	pieces_measured = true
	examined_object.emit("Les trois pièces sont mesurées ! Elles ont la bonne longueur pour préparer la combinaison.")
	measured_pieces.emit()
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#726553"))
	var plank_height := size.y / 10.0
	for row in range(10):
		var y := row * plank_height
		draw_rect(
			Rect2(0, y, size.x, plank_height - 2),
			Color("#918064") if row % 2 == 0 else Color("#806e57")
		)
	draw_rect(Rect2(0, 0, size.x, size.y * 0.08), Color("#625544"))
	draw_rect(Rect2(size.x * 0.07, size.y * 0.10, size.x * 0.22, size.y * 0.23), Color("#819395"))
	draw_rect(Rect2(size.x * 0.09, size.y * 0.12, size.x * 0.18, size.y * 0.19), Color("#b4c1b7"))
	draw_line(Vector2(size.x * 0.18, size.y * 0.12), Vector2(size.x * 0.18, size.y * 0.31), Color("#e6dfcf"), 4)
	for obstacle in obstacles:
		var rect := Rect2(obstacle.position * size, obstacle.size * size)
		draw_rect(rect.grow(3), Color("#4b4035"))
		draw_rect(rect, Color("#725d47"))
		draw_line(rect.position + Vector2(5, 5), Vector2(rect.end.x - 5, rect.position.y + 5), Color("#aa906d"), 3)
	_draw_box(Vector2(0.12, 0.47), Color("#a4815f"))
	_draw_box(Vector2(0.88, 0.54), Color("#997654"))
	_draw_documents(Vector2(0.72, 0.35))
	if not wood_collected:
		_draw_wood(WOOD_POSITION)
	_draw_workbench()
	if not ruler_collected:
		_draw_ruler(RULER_POSITION)
	_draw_player(player_position)

func _draw_wood(position: Vector2) -> void:
	var center := position * size
	draw_line(center + Vector2(-28, 5), center + Vector2(28, -5), Color("#604832"), 16, true)
	draw_line(center + Vector2(-28, 2), center + Vector2(28, -8), Color("#bd9460"), 10, true)
	draw_line(center + Vector2(-18, 0), center + Vector2(20, -7), Color("#dfc18b"), 2, true)

func _draw_ruler(position: Vector2) -> void:
	var center := position * size
	var ruler := Rect2(center + Vector2(-32, -5), Vector2(64, 10))
	draw_rect(ruler, Color("#d8bd7d"))
	draw_rect(ruler.grow(-2), Color("#e8d7a8"))
	for mark in range(1, 8):
		var x := ruler.position.x + mark * 7.0
		draw_line(Vector2(x, ruler.position.y + 1), Vector2(x, ruler.position.y + (5 if mark % 2 == 0 else 3)), Color("#69583e"), 1)

func _draw_workbench() -> void:
	var center := WORKBENCH_POSITION * size
	draw_rect(Rect2(center + Vector2(-92, -17), Vector2(184, 16)), Color("#594633"))
	draw_rect(Rect2(center + Vector2(-86, -21), Vector2(172, 10)), Color("#a48662"))
	draw_rect(Rect2(center + Vector2(-77, -1), Vector2(10, 48)), Color("#66513d"))
	draw_rect(Rect2(center + Vector2(67, -1), Vector2(10, 48)), Color("#66513d"))
	if pieces_cut:
		for piece_index in range(3):
			var piece_x := center.x - 38 + piece_index * 36
			draw_rect(Rect2(piece_x, center.y - 39, 27, 9), Color("#c49a66"))
			draw_line(Vector2(piece_x + 4, center.y - 35), Vector2(piece_x + 22, center.y - 35), Color("#e0c18f"), 1)
	if ruler_collected:
		draw_line(center + Vector2(-42, -32), center + Vector2(40, -32), Color("#e8d7a8"), 6)

func _draw_box(position: Vector2, color: Color) -> void:
	var center := position * size
	var rect := Rect2(center - Vector2(28, 19), Vector2(56, 38))
	draw_rect(rect, Color("#594633"))
	draw_rect(rect.grow(-3), color)
	draw_line(rect.position + Vector2(4, 5), rect.end - Vector2(4, 5), Color("#d0b58d"), 2)

func _draw_documents(position: Vector2) -> void:
	var center := position * size
	draw_rect(Rect2(center + Vector2(-24, -17), Vector2(48, 34)), Color("#e4dcc8"))
	for line_index in range(3):
		var line_y := center.y - 8 + line_index * 8
		draw_line(Vector2(center.x - 16, line_y), Vector2(center.x + 15, line_y), Color("#78877c"), 2)

func _draw_player(position: Vector2) -> void:
	var center := position * size
	var scale := minf(size.x, size.y)
	var step := sin(walking_time * 13.0) * scale * 0.006
	draw_circle(center + Vector2(0, scale * 0.032), scale * 0.032, Color("#594a3d", 0.55))
	draw_line(center + Vector2(-scale * 0.012, scale * 0.035), center + Vector2(-scale * 0.015 + step, scale * 0.060), Color("#434a48"), 7, true)
	draw_line(center + Vector2(scale * 0.012, scale * 0.035), center + Vector2(scale * 0.015 - step, scale * 0.060), Color("#434a48"), 7, true)
	draw_rect(Rect2(center + Vector2(-scale * 0.026, -scale * 0.006), Vector2(scale * 0.052, scale * 0.050)), Color("#748a7d"))
	draw_circle(center + Vector2(0, -scale * 0.030), scale * 0.027, Color("#d6ae8b"))
	draw_arc(center + Vector2(0, -scale * 0.036), scale * 0.027, PI, TAU, 16, Color("#706754"), 6, true)
