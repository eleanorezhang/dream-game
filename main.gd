extends Control

class RobotIllustration extends Control:
	var animation_time := 0.0
	var rounded_styles: Dictionary = {}

	func _ready() -> void:
		custom_minimum_size = Vector2(250, 310)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _process(delta: float) -> void:
		animation_time += delta
		queue_redraw()

	func _draw() -> void:
		var bob := sin(animation_time * 2.2) * 5.0
		var center := Vector2(size.x * 0.5, size.y * 0.52 + bob)
		var shell := Color("#81958d")
		var shell_light := Color("#a8b8ad")
		var outline := Color("#596b67")
		var face := Color("#344a4a")
		var eye_color := Color("#f4e6bd")
		var blink := fposmod(animation_time, 3.4) > 3.22

		draw_set_transform(center + Vector2(0, 119), 0.0, Vector2(1.0, 0.24))
		draw_circle(Vector2.ZERO, 66, Color("#59645e", 0.16))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

		draw_line(center + Vector2(-61, 34), center + Vector2(-84, 66), outline, 20, true)
		draw_line(center + Vector2(61, 34), center + Vector2(84, 66), outline, 20, true)
		draw_line(center + Vector2(-61, 34), center + Vector2(-84, 66), shell, 14, true)
		draw_line(center + Vector2(61, 34), center + Vector2(84, 66), shell, 14, true)
		draw_circle(center + Vector2(-87, 69), 11, shell_light)
		draw_circle(center + Vector2(87, 69), 11, shell_light)

		draw_rect(Rect2(center + Vector2(-37, 88), Vector2(25, 28)), outline, true)
		draw_rect(Rect2(center + Vector2(12, 88), Vector2(25, 28)), outline, true)
		draw_rect(Rect2(center + Vector2(-48, 110), Vector2(47, 13)), shell, true)
		draw_rect(Rect2(center + Vector2(1, 110), Vector2(47, 13)), shell, true)

		_draw_rounded_rect(Rect2(center + Vector2(-60, 12), Vector2(120, 82)), outline, 16)
		_draw_rounded_rect(Rect2(center + Vector2(-54, 17), Vector2(108, 70)), shell, 13)
		draw_circle(center + Vector2(0, 48), 12, Color("#d8cda9"))
		draw_circle(center + Vector2(0, 48), 6, Color("#f4e6bd"))

		draw_line(center + Vector2(0, -98), center + Vector2(0, -116), outline, 6, true)
		draw_circle(center + Vector2(0, -121), 10 + sin(animation_time * 4.0) * 1.5, Color("#d0a77d"))
		draw_circle(center + Vector2(0, -121), 5, Color("#f1dcc0"))

		_draw_rounded_rect(Rect2(center + Vector2(-76, -106), Vector2(152, 105)), outline, 29)
		_draw_rounded_rect(Rect2(center + Vector2(-69, -112), Vector2(138, 101)), shell_light, 26)
		_draw_rounded_rect(Rect2(center + Vector2(-56, -98), Vector2(112, 74)), face, 23)

		if blink:
			draw_line(center + Vector2(-36, -67), center + Vector2(-19, -67), eye_color, 4, true)
			draw_line(center + Vector2(19, -67), center + Vector2(36, -67), eye_color, 4, true)
		else:
			draw_circle(center + Vector2(-27, -68), 6, eye_color)
			draw_circle(center + Vector2(27, -68), 6, eye_color)

		var talking := absf(sin(animation_time * 7.0))
		draw_arc(
			center + Vector2(0, -42),
			8 + talking * 5,
			deg_to_rad(18),
			deg_to_rad(162),
			20,
			Color("#f0cfa8"),
			3.0,
			true
		)
		draw_circle(center + Vector2(-61, -49), 5, Color("#d49d8e", 0.75))
		draw_circle(center + Vector2(61, -49), 5, Color("#d49d8e", 0.75))

	func _draw_rounded_rect(rect: Rect2, color: Color, radius: int) -> void:
		var key := "%s:%d" % [color.to_html(), radius]
		if not rounded_styles.has(key):
			var style := StyleBoxFlat.new()
			style.bg_color = color
			style.set_corner_radius_all(radius)
			style.set_content_margin_all(0)
			rounded_styles[key] = style
		draw_style_box(rounded_styles[key], rect)


class WorkshopIllustration extends Control:
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


const DREAMS: Array[Dictionary] = [
	{
		"title": "Le grand voyage spatial",
		"subtitle": "Un rêve d'exploration et d'étoiles",
		"description": "Aide Thomas à préparer une fusée, à construire une combinaison et à partir explorer l'espace. Une aventure fictive inspirée par les rêves d'exploration spatiale."
	},
	{
		"title": "Le monde en chocolat",
		"subtitle": "Un rêve gourmand et merveilleux",
		"description": "Découvre un pays entièrement fait de chocolat, rencontre ses habitants et aide-les à protéger leur drôle de monde."
	}
]

const WORKSHOP_DIALOGUE: Array[Dictionary] = [
	{
		"speaker": "Thomas",
		"text": "Ah, tu dois être la personne venue m'aider ! Entre, entre. Attention au carton près de la porte : j'ai voulu ranger l'atelier hier soir... et j'ai surtout déplacé le désordre."
	},
	{
		"speaker": "Thomas",
		"text": "Je m'appelle Thomas. Depuis que je suis petit, je rêve de voir la Terre depuis l'espace. Le matin, je regarde les étoiles par cette fenêtre et je me demande ce qu'on peut bien découvrir là-haut."
	},
	{
		"speaker": "Thomas",
		"text": "J'ai déjà commencé une fusée miniature pour tester mes idées. Son aile gauche tient avec du ruban adhésif, et je crois que j'ai posé le plan sous ma tasse... Voilà, je l'ai trouvé !"
	},
	{
		"speaker": "Thomas",
		"text": "Pour notre vrai départ, il faudra préparer une combinaison, trouver les pièces qui manquent et construire un robot pour nous aider à l'atelier. Tu veux qu'on regarde ça ensemble ?"
	}
]

const WORKSHOP_TASK_GROUPS: Array[Dictionary] = [
	{
		"title": "Combinaison",
		"tasks": [
			"Retrouver le tissu résistant dans les cartons",
			"Mesurer et découper les pièces de la combinaison",
			"Assembler le haut, le pantalon et les gants",
			"Préparer le casque et vérifier sa visière"
		]
	},
	{
		"title": "Fusée",
		"tasks": [
			"Retrouver le plan caché sous les affaires de l'atelier",
			"Trier les pièces et repérer celles qui manquent",
			"Assembler le moteur avec le réservoir",
			"Fixer les ailes et installer le hublot",
			"Vérifier chaque pièce avant le premier essai"
		]
	},
	{
		"title": "Robot",
		"tasks": [
			"Préparer une liste des pièces à acheter",
			"Aider les voisins pour gagner quelques pièces",
			"Aller au marché choisir un robot d'atelier",
			"Ramener le robot et lui donner ses premières consignes"
		]
	}
]

const COLOR_PANEL := Color("#f5f1e9")
const COLOR_PANEL_SELECTED := Color("#dce4df")
const COLOR_ACCENT := Color("#657d77")
const COLOR_TEXT := Color("#373c43")
const COLOR_MUTED := Color("#737a80")

var selected_dream_index := 0
var page: VBoxContainer
var workshop_dialogue_index := 0
var workshop_speaker_label: Label
var workshop_dialogue_label: Label
var workshop_next_button: Button
var workshop_page_title: Label
var workshop_scene_panel: PanelContainer
var workshop_missions_panel: PanelContainer
var workshop_task_progress_label: Label
var workshop_task_checkboxes: Array[CheckBox] = []


func _draw() -> void:
	var top_color := Color("#e9e5dc")
	var bottom_color := Color("#cbd4d3")
	var band_height := 8
	var band_count := ceili(size.y / float(band_height))

	for band in range(band_count):
		var amount := float(band) / maxf(float(band_count - 1), 1.0)
		var band_color := top_color.lerp(bottom_color, amount)
		draw_rect(
			Rect2(0, band * band_height, size.x, band_height + 1),
			band_color
		)

	draw_circle(Vector2(size.x * 0.83, size.y * 0.24), 190, Color("#f6eee1").lerp(Color("#f6eee1", 0.0), 0.65))
	draw_circle(Vector2(size.x * 0.83, size.y * 0.24), 118, Color("#f8f1e6"))
	draw_arc(
		Vector2(size.x * 0.83, size.y * 0.24),
		157,
		deg_to_rad(200),
		deg_to_rad(340),
		80,
		Color("#b7b9ae", 0.65),
		1.5
	)
	draw_arc(
		Vector2(size.x * 0.83, size.y * 0.24),
		176,
		deg_to_rad(202),
		deg_to_rad(338),
		80,
		Color("#f8f3ea", 0.8),
		1.0
	)

	var stars := [
		Vector2(0.68, 0.17), Vector2(0.91, 0.12), Vector2(0.95, 0.34),
		Vector2(0.72, 0.42), Vector2(0.88, 0.49), Vector2(0.59, 0.31),
		Vector2(0.98, 0.22), Vector2(0.77, 0.08)
	]
	for star in stars:
		draw_circle(Vector2(star.x * size.x, star.y * size.y), 2.0, Color("#fffaf1", 0.9))

	var distant_hill := PackedVector2Array([
		Vector2(0, size.y * 0.80),
		Vector2(size.x * 0.15, size.y * 0.74),
		Vector2(size.x * 0.34, size.y * 0.80),
		Vector2(size.x * 0.56, size.y * 0.73),
		Vector2(size.x * 0.77, size.y * 0.79),
		Vector2(size.x, size.y * 0.72),
		Vector2(size.x, size.y),
		Vector2(0, size.y)
	])
	draw_colored_polygon(distant_hill, Color("#bfcac5", 0.52))

	var foreground_hill := PackedVector2Array([
		Vector2(0, size.y * 0.90),
		Vector2(size.x * 0.20, size.y * 0.83),
		Vector2(size.x * 0.42, size.y * 0.89),
		Vector2(size.x * 0.66, size.y * 0.82),
		Vector2(size.x * 0.85, size.y * 0.87),
		Vector2(size.x, size.y * 0.82),
		Vector2(size.x, size.y),
		Vector2(0, size.y)
	])
	draw_colored_polygon(foreground_hill, Color("#aebdb6", 0.48))


func _ready() -> void:
	_build_layout()
	_show_intro()


func _build_layout() -> void:
	queue_redraw()

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 72)
	margin.add_theme_constant_override("margin_top", 42)
	margin.add_theme_constant_override("margin_right", 72)
	margin.add_theme_constant_override("margin_bottom", 42)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 22)
	margin.add_child(layout)

	var eyebrow := _make_label("UNE AVENTURE AU CŒUR DES RÊVES", 16, COLOR_ACCENT)
	layout.add_child(eyebrow)

	var title := _make_label("Les rêves éveillés", 38, COLOR_TEXT)
	layout.add_child(title)

	page = VBoxContainer.new()
	page.add_theme_constant_override("separation", 18)
	layout.add_child(page)


func _show_intro() -> void:
	_clear_page()

	var panel := _make_panel(COLOR_PANEL)
	page.add_child(panel)

	var scene := HBoxContainer.new()
	scene.add_theme_constant_override("separation", 22)
	panel.add_child(scene)

	var robot := RobotIllustration.new()
	robot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	scene.add_child(robot)

	var bubble := _make_panel(Color("#fffdf8"))
	bubble.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bubble.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	scene.add_child(bubble)

	var tail := Polygon2D.new()
	tail.polygon = PackedVector2Array([
		Vector2(0, 24),
		Vector2(23, 13),
		Vector2(23, 43)
	])
	tail.color = Color("#fffdf8")
	tail.position = Vector2(-9, 46)
	bubble.add_child(tail)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	bubble.add_child(content)

	content.add_child(_make_label("Robi, ton guide", 26, COLOR_ACCENT))
	content.add_child(_make_label("J'ai hâte de te montrer tous ces mondes !", 17, COLOR_MUTED))
	content.add_child(_make_label(
		"On dit que chacun porte en lui un rêve extraordinaire. Certains rêvent de voyager dans l'espace, d'autres de découvrir des mondes incroyables...",
		20,
		COLOR_TEXT
	))
	content.add_child(_make_label(
		"Dans ce jeu, tu vas explorer les rêves de différentes personnes, les aider à relever des défis et découvrir où leurs aventures les mènent.",
		18,
		COLOR_MUTED
	))

	var continue_button := _make_button("Découvrir les rêves")
	continue_button.pressed.connect(_show_dream_menu)
	var button_row := CenterContainer.new()
	button_row.add_child(continue_button)
	page.add_child(button_row)


func _show_dream_menu() -> void:
	_clear_page()
	page.add_child(_make_label("Choisis un rêve à explorer", 26, COLOR_TEXT))
	page.add_child(_make_label(
		"Chaque rêve est une nouvelle aventure. Tu pourras en découvrir d'autres au fil du jeu.",
		17,
		COLOR_MUTED
	))

	var dream_list := HBoxContainer.new()
	dream_list.add_theme_constant_override("separation", 16)
	page.add_child(dream_list)

	for index in range(DREAMS.size()):
		var dream: Dictionary = DREAMS[index]
		var card := _make_button("%s\n\n%s" % [dream["title"], dream["subtitle"]])
		card.custom_minimum_size = Vector2(330, 132)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.alignment = HORIZONTAL_ALIGNMENT_LEFT
		card.add_theme_font_size_override("font_size", 20)
		card.add_theme_stylebox_override(
			"normal",
			_make_style(COLOR_PANEL_SELECTED if index == selected_dream_index else COLOR_PANEL)
		)
		card.pressed.connect(_on_dream_selected.bind(index))
		dream_list.add_child(card)

	var selected: Dictionary = DREAMS[selected_dream_index]
	var details := _make_panel(COLOR_PANEL)
	page.add_child(details)

	var detail_content := VBoxContainer.new()
	detail_content.add_theme_constant_override("separation", 8)
	details.add_child(detail_content)
	detail_content.add_child(_make_label(selected["title"], 23, COLOR_ACCENT))
	detail_content.add_child(_make_label(selected["description"], 17, COLOR_TEXT))

	var explore_button := _make_button("Explorer ce rêve")
	explore_button.pressed.connect(_show_mission_briefing)
	page.add_child(explore_button)


func _on_dream_selected(index: int) -> void:
	selected_dream_index = index
	_show_dream_menu()


func _show_mission_briefing() -> void:
	if selected_dream_index == 0:
		_show_workshop_scene()
		return

	_clear_page()

	var selected: Dictionary = DREAMS[selected_dream_index]
	page.add_child(_make_label(selected["title"], 28, COLOR_ACCENT))
	page.add_child(_make_label(
		"Première mission : rends-toi à l'atelier et aide Thomas à préparer son grand départ. Robi t'accompagnera à chaque étape.",
		20,
		COLOR_TEXT
	))

	var panel := _make_panel(COLOR_PANEL)
	page.add_child(panel)
	panel.add_child(_make_label(
		"Prototype en construction : les prochaines étapes ajouteront les déplacements, les missions et les interactions.",
		16,
		COLOR_MUTED
	))

	var back_button := _make_button("Retour aux rêves")
	back_button.pressed.connect(_show_dream_menu)
	page.add_child(back_button)


func _show_workshop_scene() -> void:
	_clear_page()
	workshop_dialogue_index = 0
	workshop_task_checkboxes.clear()
	workshop_page_title = _make_label("L'atelier de Thomas", 26, COLOR_TEXT)
	page.add_child(workshop_page_title)

	workshop_scene_panel = _make_panel(COLOR_PANEL)
	page.add_child(workshop_scene_panel)

	var scene_row := HBoxContainer.new()
	scene_row.add_theme_constant_override("separation", 18)
	workshop_scene_panel.add_child(scene_row)

	var illustration := WorkshopIllustration.new()
	illustration.custom_minimum_size.y = 190
	illustration.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	illustration.size_flags_stretch_ratio = 1.1
	scene_row.add_child(illustration)

	var dialogue := _make_panel(Color("#fffdf8"))
	dialogue.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue.size_flags_stretch_ratio = 1.0
	scene_row.add_child(dialogue)

	var dialogue_content := VBoxContainer.new()
	dialogue_content.add_theme_constant_override("separation", 10)
	dialogue.add_child(dialogue_content)
	workshop_speaker_label = _make_label("", 23, COLOR_ACCENT)
	dialogue_content.add_child(workshop_speaker_label)
	workshop_dialogue_label = _make_label("", 16, COLOR_TEXT)
	dialogue_content.add_child(workshop_dialogue_label)

	workshop_missions_panel = _make_panel(Color("#f5f1e9"))
	page.add_child(workshop_missions_panel)

	var mission_content := VBoxContainer.new()
	mission_content.add_theme_constant_override("separation", 6)
	workshop_missions_panel.add_child(mission_content)
	var mission_heading := HBoxContainer.new()
	mission_content.add_child(mission_heading)
	var mission_title := _make_label("Nos premières missions", 20, COLOR_ACCENT)
	mission_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_heading.add_child(mission_title)
	workshop_task_progress_label = _make_label("", 14, COLOR_MUTED)
	workshop_task_progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	workshop_task_progress_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	mission_heading.add_child(workshop_task_progress_label)

	var task_viewport := Control.new()
	task_viewport.custom_minimum_size = Vector2(0, 150)
	task_viewport.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_content.add_child(task_viewport)

	var task_scroll := ScrollContainer.new()
	task_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	task_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	task_viewport.add_child(task_scroll)

	var task_groups := VBoxContainer.new()
	task_groups.add_theme_constant_override("separation", 8)
	task_groups.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	task_scroll.add_child(task_groups)

	for group_data in WORKSHOP_TASK_GROUPS:
		var group_panel := _make_panel(Color("#fffdf8"))
		group_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		task_groups.add_child(group_panel)

		var group_content := VBoxContainer.new()
		group_content.add_theme_constant_override("separation", 2)
		group_panel.add_child(group_content)
		group_content.add_child(_make_label(group_data["title"], 17, COLOR_ACCENT))

		for task_text in group_data["tasks"]:
			var task := CheckBox.new()
			task.text = task_text
			task.add_theme_font_size_override("font_size", 14)
			task.add_theme_color_override("font_color", COLOR_TEXT)
			task.add_theme_color_override("font_hover_color", COLOR_ACCENT)
			task.toggled.connect(_update_workshop_task_progress)
			group_content.add_child(task)
			workshop_task_checkboxes.append(task)

	workshop_missions_panel.hide()
	_update_workshop_task_progress()

	workshop_next_button = _make_button("Continuer")
	workshop_next_button.pressed.connect(_advance_workshop_dialogue)
	var button_row := CenterContainer.new()
	button_row.add_child(workshop_next_button)
	page.add_child(button_row)
	_update_workshop_dialogue()


func _update_workshop_task_progress(_toggled: bool = false) -> void:
	if workshop_task_progress_label == null:
		return
	var completed := 0
	for task in workshop_task_checkboxes:
		if task.button_pressed:
			completed += 1
	workshop_task_progress_label.text = "%d / %d tâches cochées" % [
		completed,
		workshop_task_checkboxes.size()
	]


func _update_workshop_dialogue() -> void:
	var line: Dictionary = WORKSHOP_DIALOGUE[workshop_dialogue_index]
	workshop_speaker_label.text = line["speaker"]
	workshop_dialogue_label.text = line["text"]
	workshop_next_button.text = (
		"Voir les missions" if workshop_dialogue_index == WORKSHOP_DIALOGUE.size() - 1
		else "Continuer"
	)


func _advance_workshop_dialogue() -> void:
	if workshop_dialogue_index < WORKSHOP_DIALOGUE.size() - 1:
		workshop_dialogue_index += 1
		_update_workshop_dialogue()
		return

	workshop_missions_panel.show()
	workshop_scene_panel.hide()
	workshop_page_title.text = "Préparons le départ !"
	workshop_next_button.text = "Retour aux rêves"
	workshop_next_button.pressed.disconnect(_advance_workshop_dialogue)
	workshop_next_button.pressed.connect(_show_dream_menu)


func _clear_page() -> void:
	for child in page.get_children():
		page.remove_child(child)
		child.queue_free()


func _make_label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _make_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(250, 56)
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", COLOR_TEXT)
	button.add_theme_color_override("font_hover_color", COLOR_TEXT)
	button.add_theme_stylebox_override("normal", _make_style(Color("#e3ddd1")))
	button.add_theme_stylebox_override("hover", _make_style(Color("#d5ded7")))
	button.add_theme_stylebox_override("pressed", _make_style(Color("#c8d2ca")))
	var focus_style := StyleBoxFlat.new()
	focus_style.bg_color = Color(0, 0, 0, 0)
	focus_style.set_corner_radius_all(14)
	focus_style.set_border_width_all(2)
	focus_style.border_color = Color("#8ca198")
	button.add_theme_stylebox_override("focus", focus_style)
	return button


func _make_panel(color: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _make_style(color))
	return panel


func _make_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(14)
	style.set_border_width_all(1)
	style.border_color = Color("#ffffff", 0.55)
	style.shadow_color = Color("#56605a", 0.12)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 3)
	style.content_margin_left = 22
	style.content_margin_top = 18
	style.content_margin_right = 22
	style.content_margin_bottom = 18
	return style
