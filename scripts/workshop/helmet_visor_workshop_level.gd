extends Control
class_name HelmetVisorWorkshopLevel

signal found_helmet(color_name: String)
signal found_visor
signal examined_object(message: String)

const PLAYER_RADIUS := 0.025
const INTERACTION_DISTANCE := 0.10
const PLAYER_SPEED := 0.42
const WORKBENCH_POSITION := Vector2(0.52, 0.72)
const VISOR_POSITION := Vector2(0.84, 0.24)
const HELMET_POSITIONS: Array[Vector2] = [
	Vector2(0.19, 0.27),
	Vector2(0.42, 0.30),
	Vector2(0.68, 0.28),
	Vector2(0.83, 0.50)
]
const COLOR_OPTIONS: Array[Dictionary] = [
	{"name": "bleu", "color": Color("#638aa8")},
	{"name": "rouge", "color": Color("#b96e61")},
	{"name": "vert", "color": Color("#789477")},
	{"name": "jaune", "color": Color("#d0b66f")},
	{"name": "violet", "color": Color("#8b789e")},
	{"name": "orange", "color": Color("#c98b58")}
]
const WORKSHOP_CLUTTER: Array[Dictionary] = [
	{"position": Vector2(0.17, 0.35), "kind": "crate"},
	{"position": Vector2(0.29, 0.76), "kind": "cloth"},
	{"position": Vector2(0.70, 0.35), "kind": "lamp"},
	{"position": Vector2(0.78, 0.73), "kind": "papers"},
	{"position": Vector2(0.42, 0.24), "kind": "bowl"},
	{"position": Vector2(0.90, 0.55), "kind": "tools"}
]

var player_position := Vector2(0.12, 0.82)
var held_directions: Dictionary = {}
var walking_time := 0.0
var target_color_name := "bleu"
var helmets: Array[Dictionary] = []
var helmet_found := false
var visor_found := false
var room_mode := 0
var obstacles: Array[Rect2] = []
var random_generator := RandomNumberGenerator.new()


func _ready() -> void:
	custom_minimum_size = Vector2(600, 240)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	random_generator.randomize()
	obstacles = [
		Rect2(0.34, 0.45, 0.27, 0.13),
		Rect2(0.60, 0.69, 0.15, 0.12),
		Rect2(0.07, 0.18, 0.13, 0.12)
	]
	_create_helmets()


func _create_helmets() -> void:
	var available_colors: Array[Dictionary] = COLOR_OPTIONS.duplicate()
	var target: Dictionary = {}
	for option in COLOR_OPTIONS:
		if option["name"] == target_color_name:
			target = option
			break
	if target.is_empty():
		target = COLOR_OPTIONS[0]
		target_color_name = target["name"]

	var target_slot := random_generator.randi_range(0, HELMET_POSITIONS.size() - 1)
	var weak_target_slot := (target_slot + random_generator.randi_range(1, HELMET_POSITIONS.size() - 1)) % HELMET_POSITIONS.size()
	helmets.clear()
	for helmet_index in range(HELMET_POSITIONS.size()):
		var helmet_color: Dictionary
		var is_sturdy := helmet_index != weak_target_slot
		if helmet_index == target_slot or helmet_index == weak_target_slot:
			helmet_color = target
		else:
			var color_index := random_generator.randi_range(0, available_colors.size() - 1)
			helmet_color = available_colors[color_index]
			available_colors.remove_at(color_index)
		helmets.append({
			"position": HELMET_POSITIONS[helmet_index],
			"color_name": helmet_color["name"],
			"color": helmet_color["color"],
			"sturdy": is_sturdy
		})


func set_direction(direction: Vector2, pressed: bool) -> void:
	held_directions[str(direction)] = direction if pressed else Vector2.ZERO


func _process(delta: float) -> void:
	if visor_found or size.x <= 0.0 or size.y <= 0.0:
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
	if visor_found:
		examined_object.emit("Le casque solide et sa visière sont prêts pour Thomas !")
		return
	if room_mode == 0:
		_examine_helmet_room()
	else:
		_examine_workshop()


func _examine_helmet_room() -> void:
	for helmet in helmets:
		var helmet_position: Vector2 = helmet["position"]
		if player_position.distance_to(helmet_position) > INTERACTION_DISTANCE:
			continue
		var color_name: String = helmet["color_name"]
		if color_name == target_color_name and helmet["sturdy"]:
			helmet_found = true
			room_mode = 1
			player_position = Vector2(0.12, 0.82)
			examined_object.emit(
				"Bien choisi ! Le casque %s est solide. Tu retournes à l'atelier pour chercher une visière adaptée."
				% target_color_name
			)
			found_helmet.emit(target_color_name)
			queue_redraw()
			return
		if color_name == target_color_name:
			examined_object.emit(
				"Cette couleur est la bonne, mais le casque est fendu et trop fragile. Il nous faut un casque %s solide !"
				% target_color_name
			)
			return
		if not helmet["sturdy"]:
			examined_object.emit(
				"Ce casque %s est solide, mais Thomas a demandé un casque %s."
				% [color_name, target_color_name]
			)
			return
		examined_object.emit(
			"Ce casque %s est solide, mais la couleur demandée est le %s."
			% [color_name, target_color_name]
		)
		return
	examined_object.emit("Approche-toi d'un casque pour vérifier sa couleur et son état.")


func _examine_workshop() -> void:
	if player_position.distance_to(VISOR_POSITION) <= INTERACTION_DISTANCE:
		visor_found = true
		examined_object.emit("Tu as trouvé la visière transparente, cachée derrière les plans ! Elle s'adapte parfaitement au casque.")
		found_visor.emit()
		queue_redraw()
		return
	for clutter in WORKSHOP_CLUTTER:
		var clutter_position: Vector2 = clutter["position"]
		if player_position.distance_to(clutter_position) <= INTERACTION_DISTANCE:
			examined_object.emit(_get_clutter_message(clutter["kind"]))
			return
	if player_position.distance_to(WORKBENCH_POSITION) <= INTERACTION_DISTANCE:
		examined_object.emit("Le casque est prêt sur l'établi. Il manque encore sa visière transparente.")
		return
	examined_object.emit("La visière est dans l'atelier, mais elle se cache parmi les objets. Fouille les environs !")


func _get_clutter_message(kind: String) -> String:
	match kind:
		"crate":
			return "Dans cette caisse, tu trouves des écrous, une vieille clé et un ressort. Pas de visière."
		"cloth":
			return "C'est une chute du tissu utilisé pour la combinaison. Elle est opaque : impossible de voir à travers !"
		"lamp":
			return "La lampe éclaire un établi couvert de poussière. Quelque chose brille près des plans, un peu plus loin."
		"papers":
			return "Les plans sont froissés. Tu aperçois un reflet transparent qui dépasse derrière la pile."
		"bowl":
			return "Ce bol contient des vis et des boutons. Aucun ne ressemble à une visière."
		"tools":
			return "Tu déplaces quelques outils, mais tu ne trouves qu'un chiffon et un tournevis."
		_:
			return "Tu fouilles cet objet, mais il ne contient rien d'utile."


func _draw() -> void:
	if room_mode == 0:
		_draw_helmet_room()
	else:
		_draw_workshop()
	_draw_player(player_position)


func _draw_helmet_room() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#65747a"))
	draw_rect(Rect2(0, 0, size.x, size.y * 0.68), Color("#c5c3b6"))
	draw_rect(Rect2(0, size.y * 0.68, size.x, size.y * 0.32), Color("#8c7762"))
	draw_rect(Rect2(size.x * 0.06, size.y * 0.10, size.x * 0.24, size.y * 0.28), Color("#71888b"))
	draw_rect(Rect2(size.x * 0.08, size.y * 0.12, size.x * 0.20, size.y * 0.24), Color("#a9beb5"))
	draw_line(Vector2(size.x * 0.18, size.y * 0.12), Vector2(size.x * 0.18, size.y * 0.36), Color("#e5ddcb"), 3)
	draw_line(Vector2(size.x * 0.08, size.y * 0.24), Vector2(size.x * 0.28, size.y * 0.24), Color("#e5ddcb"), 3)
	draw_rect(Rect2(size.x * 0.04, size.y * 0.47, size.x * 0.92, 8), Color("#725d47"))
	draw_rect(Rect2(size.x * 0.08, size.y * 0.49, 9, size.y * 0.22), Color("#594633"))
	draw_rect(Rect2(size.x * 0.83, size.y * 0.49, 9, size.y * 0.22), Color("#594633"))
	draw_string(ThemeDB.fallback_font, Vector2(size.x * 0.34, size.y * 0.18), "CHAMBRE DES CASQUES", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#586b68"))
	for helmet in helmets:
		_draw_helmet(helmet["position"], helmet["color"], helmet["sturdy"])
	draw_rect(Rect2(0, size.y * 0.83, size.x, size.y * 0.17), Color("#594d42", 0.75))
	draw_string(
		ThemeDB.fallback_font,
		Vector2(12, size.y * 0.91),
		"À trouver : un casque solide et %s" % target_color_name,
		HORIZONTAL_ALIGNMENT_LEFT,
		size.x - 24,
		14,
		Color("#fff5df")
	)


func _draw_helmet(position: Vector2, helmet_color: Color, sturdy: bool) -> void:
	var center := position * size
	var helmet_rect := Rect2(center + Vector2(-23, -16), Vector2(46, 31))
	draw_arc(center + Vector2(0, 0), 23, PI, TAU, 20, Color("#3f4948"), 5)
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-21, 0),
		center + Vector2(-16, -14),
		center + Vector2(-7, -22),
		center + Vector2(8, -22),
		center + Vector2(19, -12),
		center + Vector2(22, 0),
		center + Vector2(15, 5),
		center + Vector2(-20, 5)
	]), helmet_color)
	draw_rect(helmet_rect, Color("#3f4948", 0.5), false, 2)
	draw_line(center + Vector2(-19, 4), center + Vector2(22, 4), Color("#d1c6aa"), 4)
	if not sturdy:
		draw_line(center + Vector2(-7, -18), center + Vector2(1, -7), Color("#403d39"), 2)
		draw_line(center + Vector2(1, -7), center + Vector2(-5, 1), Color("#403d39"), 2)
		draw_circle(center + Vector2(0, 28), 3, Color("#d3c7ae"))


func _draw_workshop() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#726553"))
	var plank_height := size.y / 10.0
	for row in range(10):
		var y := row * plank_height
		draw_rect(Rect2(0, y, size.x, plank_height - 2), Color("#918064") if row % 2 == 0 else Color("#806e57"))
	draw_rect(Rect2(0, 0, size.x, size.y * 0.08), Color("#625544"))
	draw_rect(Rect2(size.x * 0.07, size.y * 0.10, size.x * 0.22, size.y * 0.23), Color("#819395"))
	draw_rect(Rect2(size.x * 0.09, size.y * 0.12, size.x * 0.18, size.y * 0.19), Color("#b4c1b7"))
	for obstacle in obstacles:
		var rect := Rect2(obstacle.position * size, obstacle.size * size)
		draw_rect(rect.grow(3), Color("#4b4035"))
		draw_rect(rect, Color("#725d47"))
	for clutter in WORKSHOP_CLUTTER:
		_draw_workshop_clutter(clutter["position"], clutter["kind"])
	_draw_workbench()
	if not visor_found:
		_draw_visor(VISOR_POSITION)
	draw_rect(Rect2(0, size.y * 0.88, size.x, size.y * 0.12), Color("#594d42", 0.75))
	draw_string(ThemeDB.fallback_font, Vector2(12, size.y * 0.96), "Atelier de Thomas — cherche la visière", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#fff5df"))


func _draw_workshop_clutter(position: Vector2, kind: String) -> void:
	var center := position * size
	match kind:
		"crate":
			draw_rect(Rect2(center + Vector2(-22, -14), Vector2(44, 28)), Color("#997654"))
			draw_line(center + Vector2(-18, -10), center + Vector2(18, 10), Color("#70563d"), 2)
			draw_line(center + Vector2(18, -10), center + Vector2(-18, 10), Color("#70563d"), 2)
		"cloth":
			draw_colored_polygon(PackedVector2Array([
				center + Vector2(-24, -9), center + Vector2(22, -15),
				center + Vector2(26, 12), center + Vector2(-17, 16)
			]), Color("#9ba79b"))
			draw_line(center + Vector2(-16, -2), center + Vector2(17, -7), Color("#d4d5c7"), 2)
		"lamp":
			draw_line(center + Vector2(0, 15), center + Vector2(0, -13), Color("#615548"), 4)
			draw_colored_polygon(PackedVector2Array([
				center + Vector2(-18, -13), center + Vector2(-11, -27),
				center + Vector2(8, -27), center + Vector2(17, -13)
			]), Color("#b49a71"))
		"papers":
			draw_rect(Rect2(center + Vector2(-21, -16), Vector2(42, 32)), Color("#e4dcc8"))
			draw_rect(Rect2(center + Vector2(-16, -20), Vector2(42, 32)), Color("#d8cfbb"))
			draw_line(center + Vector2(-11, -7), center + Vector2(14, -7), Color("#78877c"), 2)
			draw_line(center + Vector2(-11, 1), center + Vector2(14, 1), Color("#78877c"), 2)
		"bowl":
			draw_arc(center + Vector2(0, -3), 19, 0, PI, 18, Color("#b8a78a"), 4)
			draw_line(center + Vector2(-19, -3), center + Vector2(19, -3), Color("#b8a78a"), 3)
			draw_circle(center + Vector2(-7, -7), 3, Color("#948267"))
			draw_circle(center + Vector2(6, -8), 3, Color("#d0b66f"))
		"tools":
			draw_line(center + Vector2(-18, 13), center + Vector2(11, -13), Color("#c29762"), 5)
			draw_line(center + Vector2(2, 10), center + Vector2(20, -8), Color("#b3a791"), 5)
			draw_line(center + Vector2(15, -13), center + Vector2(24, -4), Color("#b3a791"), 3)


func _draw_workbench() -> void:
	var center := WORKBENCH_POSITION * size
	draw_rect(Rect2(center + Vector2(-86, -17), Vector2(172, 14)), Color("#594633"))
	draw_rect(Rect2(center + Vector2(-80, -21), Vector2(160, 10)), Color("#a48662"))
	draw_rect(Rect2(center + Vector2(-70, -3), Vector2(10, 40)), Color("#66513d"))
	draw_rect(Rect2(center + Vector2(60, -3), Vector2(10, 40)), Color("#66513d"))
	draw_arc(center + Vector2(0, -26), 18, PI, TAU, 20, Color("#718a93"), 5)
	draw_rect(Rect2(center + Vector2(-20, -26), Vector2(40, 6)), Color("#718a93"))


func _draw_visor(position: Vector2) -> void:
	var center := position * size
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-18, -13),
		center + Vector2(12, -13),
		center + Vector2(20, -5),
		center + Vector2(17, 13),
		center + Vector2(-14, 13),
		center + Vector2(-21, 4)
	]), Color("#a9d0cf", 0.75))
	draw_polyline(PackedVector2Array([
		center + Vector2(-18, -13), center + Vector2(12, -13),
		center + Vector2(20, -5), center + Vector2(17, 13),
		center + Vector2(-14, 13), center + Vector2(-21, 4),
		center + Vector2(-18, -13)
	]), Color("#e2eee0"), 3)
	draw_line(center + Vector2(-10, -4), center + Vector2(10, -4), Color("#f2f5e9", 0.8), 2)


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
