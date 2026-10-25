extends Control
class_name SuitAssemblyWorkshopLevel

signal found_fabric
signal found_thread
signal examined_object(message: String)
signal suit_assembled

const PLAYER_RADIUS := 0.025
const INTERACTION_DISTANCE := 0.10
const PLAYER_SPEED := 0.42
const FABRIC_POSITION := Vector2(0.20, 0.60)
const THREAD_POSITION := Vector2(0.84, 0.28)
const WORKBENCH_POSITION := Vector2(0.53, 0.68)
const CLUTTER: Array[Dictionary] = [
	{"position": Vector2(0.12, 0.43), "kind": "crate"},
	{"position": Vector2(0.28, 0.30), "kind": "lamp"},
	{"position": Vector2(0.69, 0.31), "kind": "papers"},
	{"position": Vector2(0.90, 0.46), "kind": "boots"},
	{"position": Vector2(0.25, 0.84), "kind": "box"},
	{"position": Vector2(0.80, 0.84), "kind": "tools"}
]

var player_position := Vector2(0.12, 0.82)
var held_directions: Dictionary = {}
var walking_time := 0.0
var fabric_collected := false
var thread_collected := false
var assembled := false
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
	if assembled or size.x <= 0.0 or size.y <= 0.0:
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
	if assembled:
		examined_object.emit("La combinaison est assemblée et prête pour les vérifications !")
		return
	if not fabric_collected and player_position.distance_to(FABRIC_POSITION) <= INTERACTION_DISTANCE:
		fabric_collected = true
		examined_object.emit("Tu as trouvé un rouleau de tissu argenté ! Il sera assez souple pour la combinaison.")
		found_fabric.emit()
		queue_redraw()
		return
	if fabric_collected and not thread_collected and player_position.distance_to(THREAD_POSITION) <= INTERACTION_DISTANCE:
		thread_collected = true
		examined_object.emit("La bobine de fil était cachée sous les plans. Tu as tout ce qu'il faut pour assembler les pièces.")
		found_thread.emit()
		queue_redraw()
		return
	if not fabric_collected and player_position.distance_to(THREAD_POSITION) <= INTERACTION_DISTANCE:
		examined_object.emit("C'est une bobine de fil. Trouvons d'abord le tissu pour savoir de quelle couleur il nous faut.")
		return
	for clutter in CLUTTER:
		var clutter_position: Vector2 = clutter["position"]
		if player_position.distance_to(clutter_position) <= INTERACTION_DISTANCE:
			examined_object.emit(_get_clutter_message(clutter["kind"]))
			return
	if player_position.distance_to(WORKBENCH_POSITION) <= INTERACTION_DISTANCE:
		examined_object.emit("L'établi est prêt. Il faudra le tissu, la bobine de fil et les trois pièces mesurées.")
		return
	examined_object.emit("Explore l'atelier : le tissu est près des cartons et la bobine se cache près des plans.")


func _get_clutter_message(kind: String) -> String:
	match kind:
		"crate":
			return "Tu ouvres une vieille caisse... juste des boulons rouillés et un gant plein de poussière. Pas de tissu ici !"
		"lamp":
			return "La lampe éclaire un tas de chutes de papier. Une note dit : « Ranger les fournitures de couture près des plans ». Voilà une piste !"
		"papers":
			if not fabric_collected:
				return "Sous ces plans, tu aperçois une note de Thomas : « Le tissu argenté devrait être près des vieux cartons. »"
			return "Tu fouilles les plans : « La bobine de fil est rangée près du coin bureau. » Tu sais maintenant où chercher !"
		"boots":
			return "Ces vieilles bottes sont beaucoup trop petites pour Thomas. Elles sentent la poussière et ne feront pas une combinaison !"
		"box":
			return "Dans cette boîte, il y a des boutons dépareillés et une fermeture éclair cassée. Ce n'est pas ce qu'il nous faut."
		"tools":
			return "Des pinces, un tournevis et un marteau... utiles pour bricoler, mais pas pour coudre la combinaison."
		_:
			return "Tu fouilles un peu, mais tu ne trouves rien d'utile ici."


func assemble_suit() -> void:
	if not fabric_collected:
		examined_object.emit("Il faut d'abord trouver le rouleau de tissu argenté.")
		return
	if not thread_collected:
		examined_object.emit("La bobine de fil manque encore. Cherche près des plans de Thomas.")
		return
	if player_position.distance_to(WORKBENCH_POSITION) > INTERACTION_DISTANCE:
		examined_object.emit("Retourne à l'établi avec le tissu et le fil pour assembler la combinaison.")
		return
	assembled = true
	examined_object.emit("Le haut, le pantalon et les gants sont assemblés ! La combinaison prend forme.")
	suit_assembled.emit()
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
	for obstacle in obstacles:
		var rect := Rect2(obstacle.position * size, obstacle.size * size)
		draw_rect(rect.grow(3), Color("#4b4035"))
		draw_rect(rect, Color("#725d47"))
		draw_line(rect.position + Vector2(5, 5), Vector2(rect.end.x - 5, rect.position.y + 5), Color("#aa906d"), 3)
	for clutter in CLUTTER:
		_draw_clutter(clutter["position"], clutter["kind"])
	_draw_workbench()
	if not fabric_collected:
		_draw_fabric(FABRIC_POSITION)
	if not thread_collected:
		_draw_thread(THREAD_POSITION)
	_draw_player(player_position)


func _draw_clutter(position: Vector2, kind: String) -> void:
	var center := position * size
	match kind:
		"crate":
			draw_rect(Rect2(center + Vector2(-23, -15), Vector2(46, 30)), Color("#594633"))
			draw_rect(Rect2(center + Vector2(-19, -11), Vector2(38, 22)), Color("#a4815f"))
			draw_line(center + Vector2(-16, -8), center + Vector2(16, 8), Color("#765c40"), 2)
			draw_line(center + Vector2(16, -8), center + Vector2(-16, 8), Color("#765c40"), 2)
		"lamp":
			draw_line(center + Vector2(0, 17), center + Vector2(0, -13), Color("#615548"), 4)
			draw_colored_polygon(PackedVector2Array([
				center + Vector2(-18, -13),
				center + Vector2(-11, -27),
				center + Vector2(8, -27),
				center + Vector2(17, -13)
			]), Color("#b49a71"))
			draw_line(center + Vector2(-10, 18), center + Vector2(10, 18), Color("#615548"), 4)
		"papers":
			draw_rect(Rect2(center + Vector2(-21, -16), Vector2(42, 32)), Color("#e4dcc8"))
			draw_rect(Rect2(center + Vector2(-16, -20), Vector2(42, 32)), Color("#d8cfbb"))
			for line_index in range(3):
				var line_y := center.y - 10 + line_index * 8
				draw_line(Vector2(center.x - 11, line_y), Vector2(center.x + 17, line_y), Color("#78877c"), 2)
		"boots":
			draw_colored_polygon(PackedVector2Array([
				center + Vector2(-18, -19),
				center + Vector2(-4, -19),
				center + Vector2(-1, 5),
				center + Vector2(13, 9),
				center + Vector2(13, 16),
				center + Vector2(-14, 16),
				center + Vector2(-17, 8)
			]), Color("#74604d"))
			draw_colored_polygon(PackedVector2Array([
				center + Vector2(5, -17),
				center + Vector2(18, -17),
				center + Vector2(18, 3),
				center + Vector2(28, 9),
				center + Vector2(27, 16),
				center + Vector2(2, 16),
				center + Vector2(3, 7)
			]), Color("#8c7157"))
		"box":
			draw_rect(Rect2(center + Vector2(-21, -14), Vector2(42, 28)), Color("#997654"))
			draw_line(center + Vector2(-18, -8), center + Vector2(18, -8), Color("#d0b58d"), 2)
			draw_line(center + Vector2(0, -13), center + Vector2(0, 13), Color("#806a50"), 2)
			draw_circle(center + Vector2(-8, 0), 3, Color("#d9c293"))
			draw_circle(center + Vector2(8, 3), 3, Color("#d9c293"))
		"tools":
			draw_line(center + Vector2(-20, 13), center + Vector2(9, -12), Color("#806348"), 6)
			draw_line(center + Vector2(-20, 13), center + Vector2(9, -12), Color("#c29762"), 3)
			draw_line(center + Vector2(2, 11), center + Vector2(21, -8), Color("#b3a791"), 6)
			draw_line(center + Vector2(16, -13), center + Vector2(24, -5), Color("#b3a791"), 3)
			draw_line(center + Vector2(20, -17), center + Vector2(28, -9), Color("#b3a791"), 3)


func _draw_workbench() -> void:
	var center := WORKBENCH_POSITION * size
	draw_rect(Rect2(center + Vector2(-92, -17), Vector2(184, 16)), Color("#594633"))
	draw_rect(Rect2(center + Vector2(-86, -21), Vector2(172, 10)), Color("#a48662"))
	draw_rect(Rect2(center + Vector2(-77, -1), Vector2(10, 48)), Color("#66513d"))
	draw_rect(Rect2(center + Vector2(67, -1), Vector2(10, 48)), Color("#66513d"))
	if assembled:
		draw_colored_polygon(PackedVector2Array([
			center + Vector2(-28, -10),
			center + Vector2(24, -10),
			center + Vector2(19, 29),
			center + Vector2(-23, 29)
		]), Color("#aeb7ad"))
		draw_rect(Rect2(center + Vector2(-28, 25), Vector2(23, 15)), Color("#8c9c94"))
		draw_rect(Rect2(center + Vector2(4, 25), Vector2(23, 15)), Color("#8c9c94"))
		draw_circle(center + Vector2(-33, 5), 8, Color("#aeb7ad"))
		draw_circle(center + Vector2(29, 5), 8, Color("#aeb7ad"))


func _draw_fabric(position: Vector2) -> void:
	var center := position * size
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-30, -12),
		center + Vector2(20, -18),
		center + Vector2(31, 13),
		center + Vector2(-18, 19)
	]), Color("#aeb7ad"))
	draw_line(center + Vector2(-27, -10), center + Vector2(18, -15), Color("#e2e2d6"), 3)
	draw_line(center + Vector2(-18, 14), center + Vector2(25, 9), Color("#82928b"), 2)


func _draw_thread(position: Vector2) -> void:
	var center := position * size
	draw_rect(Rect2(center + Vector2(-12, -15), Vector2(24, 30)), Color("#c78968"))
	draw_line(center + Vector2(-11, -7), center + Vector2(11, -7), Color("#f0d7bd"), 3)
	draw_line(center + Vector2(-11, 1), center + Vector2(11, 1), Color("#f0d7bd"), 3)
	draw_line(center + Vector2(-11, 9), center + Vector2(11, 9), Color("#f0d7bd"), 3)
	draw_line(center + Vector2(0, -15), center + Vector2(0, -23), Color("#d5bd8a"), 3)


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
