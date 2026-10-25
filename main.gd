extends Control

const WorkshopIllustration = preload("res://scripts/workshop/workshop_illustration.gd")
const CardboardWorkshopLevel = preload("res://scripts/workshop/cardboard_workshop_level.gd")
const SuitPiecesWorkshopLevel = preload("res://scripts/workshop/suit_pieces_workshop_level.gd")
const SuitAssemblyWorkshopLevel = preload("res://scripts/workshop/suit_assembly_workshop_level.gd")
const HelmetVisorWorkshopLevel = preload("res://scripts/workshop/helmet_visor_workshop_level.gd")


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
			"Retrouver le carton résistant dans les cartons",
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
var cardboard_found := false
var suit_pieces_stage := 0
var workshop_speaker_label: Label
var workshop_dialogue_label: Label
var workshop_next_button: Button
var workshop_page_title: Label
var workshop_scene_panel: PanelContainer
var workshop_missions_panel: PanelContainer
var workshop_task_progress_label: Label
var workshop_task_checkboxes: Array[CheckBox] = []
var completed_workshop_tasks: Dictionary = {}
var workshop_tasks_ready_for_checking: Dictionary = {}
var cardboard_level: CardboardWorkshopLevel
var cardboard_status_label: Label
var cardboard_interact_button: Button
var suit_pieces_level: SuitPiecesWorkshopLevel
var suit_pieces_status_label: Label
var suit_pieces_action_button: Button
var suit_assembly_stage := 0
var suit_assembly_level: SuitAssemblyWorkshopLevel
var suit_assembly_status_label: Label
var suit_assembly_action_button: Button
var helmet_visor_stage := 0
var helmet_visor_target_color := ""
var helmet_visor_previous_color := ""
var helmet_visor_level: HelmetVisorWorkshopLevel
var helmet_visor_status_label: Label


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

	var page_scroll := ScrollContainer.new()
	page_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	layout.add_child(page_scroll)

	page = VBoxContainer.new()
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.add_theme_constant_override("separation", 18)
	page_scroll.add_child(page)


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

	workshop_next_button = _make_button("Continuer")
	workshop_next_button.pressed.connect(_advance_workshop_dialogue)
	var button_row := CenterContainer.new()
	button_row.add_child(workshop_next_button)
	page.add_child(button_row)

	workshop_missions_panel = _build_workshop_missions_panel()
	page.add_child(workshop_missions_panel)
	_update_workshop_dialogue()


func _build_workshop_missions_panel() -> PanelContainer:
	workshop_task_checkboxes.clear()
	var panel := _make_panel(Color("#f5f1e9"))
	var mission_content := VBoxContainer.new()
	mission_content.add_theme_constant_override("separation", 6)
	panel.add_child(mission_content)

	var mission_heading := HBoxContainer.new()
	mission_content.add_child(mission_heading)
	var mission_title := _make_label("Nos premières missions", 24, COLOR_ACCENT)
	mission_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_heading.add_child(mission_title)
	workshop_task_progress_label = _make_label("", 16, COLOR_MUTED)
	workshop_task_progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	workshop_task_progress_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	mission_heading.add_child(workshop_task_progress_label)
	mission_content.add_child(_make_label(
		"Une tâche ne peut être cochée qu'après avoir terminé sa mission.",
		15,
		COLOR_MUTED
	))

	if cardboard_found:
		mission_content.add_child(_make_label(
			"Carton trouvé ! Coche la première case pour valider toi-même cette mission.",
			16,
			COLOR_ACCENT
		))

	var task_viewport := Control.new()
	task_viewport.custom_minimum_size = Vector2(0, 380)
	task_viewport.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_content.add_child(task_viewport)

	var task_scroll := ScrollContainer.new()
	task_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	task_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	task_viewport.add_child(task_scroll)

	var task_groups := VBoxContainer.new()
	task_groups.add_theme_constant_override("separation", 12)
	task_groups.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	task_scroll.add_child(task_groups)

	for group_index in range(WORKSHOP_TASK_GROUPS.size()):
		var group_data: Dictionary = WORKSHOP_TASK_GROUPS[group_index]
		var group_panel := _make_panel(Color("#fffdf8"))
		group_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		task_groups.add_child(group_panel)

		var group_content := VBoxContainer.new()
		group_content.add_theme_constant_override("separation", 6)
		group_panel.add_child(group_content)
		group_content.add_child(_make_label(group_data["title"], 21, COLOR_ACCENT))

		for group_task_index in range(group_data["tasks"].size()):
			var task_row := HBoxContainer.new()
			task_row.add_theme_constant_override("separation", 10)
			group_content.add_child(task_row)

			var task := CheckBox.new()
			task.text = group_data["tasks"][group_task_index]
			task.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			task.add_theme_font_size_override("font_size", 18)
			task.add_theme_color_override("font_color", COLOR_TEXT)
			task.add_theme_color_override("font_hover_color", COLOR_ACCENT)
			task.add_theme_color_override("font_disabled_color", COLOR_TEXT)
			var task_id := "%d:%d" % [group_index, group_task_index]
			var task_completed: bool = completed_workshop_tasks.get(task_id, false)
			task.disabled = not task_completed and not workshop_tasks_ready_for_checking.get(task_id, false)
			task.set_pressed_no_signal(task_completed)
			task_row.add_child(task)
			workshop_task_checkboxes.append(task)

			var start_button := _make_button("Commencer")
			start_button.custom_minimum_size = Vector2(138, 44)
			start_button.add_theme_font_size_override("font_size", 15)
			start_button.visible = not task_completed
			start_button.pressed.connect(
				_start_workshop_task.bind(group_index, group_task_index)
			)
			task_row.add_child(start_button)
			task.toggled.connect(
				_on_workshop_task_toggled.bind(task_id, start_button, task)
			)

	_update_workshop_task_progress()
	return panel


func _update_workshop_task_progress(_toggled: bool = false) -> void:
	if not is_instance_valid(workshop_task_progress_label):
		return
	var completed := 0
	for task_index in range(workshop_task_checkboxes.size()):
		var task: CheckBox = workshop_task_checkboxes[task_index]
		if task.button_pressed:
			completed += 1
			completed_workshop_tasks[_task_id_for_index(task_index)] = true
		elif completed_workshop_tasks.has(_task_id_for_index(task_index)):
			completed_workshop_tasks.erase(_task_id_for_index(task_index))
	workshop_task_progress_label.text = "%d / %d tâches cochées" % [
		completed,
		workshop_task_checkboxes.size()
	]


func _on_workshop_task_toggled(
	pressed: bool,
	task_id: String,
	start_button: Button,
	task_checkbox: CheckBox
) -> void:
	if pressed and not workshop_tasks_ready_for_checking.get(task_id, false):
		task_checkbox.set_pressed_no_signal(false)
		return
	if pressed:
		completed_workshop_tasks[task_id] = true
	else:
		completed_workshop_tasks.erase(task_id)
	start_button.visible = not pressed
	_update_workshop_task_progress()


func _task_id_for_index(task_index: int) -> String:
	var remaining_index := task_index
	for group_index in range(WORKSHOP_TASK_GROUPS.size()):
		var task_count: int = WORKSHOP_TASK_GROUPS[group_index]["tasks"].size()
		if remaining_index < task_count:
			return "%d:%d" % [group_index, remaining_index]
		remaining_index -= task_count
	return ""


func _start_workshop_task(group_index: int, task_index: int) -> void:
	if group_index == 0 and task_index == 0:
		if cardboard_found:
			_show_workshop_mission_board()
			return
		_show_cardboard_task()
		return
	if group_index == 0 and task_index == 1:
		_show_suit_pieces_task()
		return
	if group_index == 0 and task_index == 2:
		_show_suit_assembly_task()
		return
	if group_index == 0 and task_index == 3:
		_show_helmet_visor_task()
		return
	_show_workshop_task_preview(group_index, task_index)


func _show_workshop_task_preview(group_index: int, task_index: int) -> void:
	_clear_page()
	var group_data: Dictionary = WORKSHOP_TASK_GROUPS[group_index]
	var task_title: String = group_data["tasks"][task_index]
	page.add_child(_make_label(group_data["title"], 26, COLOR_ACCENT))
	page.add_child(_make_label(task_title, 22, COLOR_TEXT))

	var panel := _make_panel(Color("#fffdf8"))
	page.add_child(panel)
	panel.add_child(_make_label(
		"Cette mission sera bientôt jouable ! Pour l'instant, Thomas a besoin de toi pour retrouver le carton résistant dans l'atelier.",
		18,
		COLOR_MUTED
	))

	var return_button := _make_button("Retour aux missions")
	return_button.pressed.connect(_show_workshop_mission_board)
	page.add_child(return_button)


func _show_workshop_mission_board() -> void:
	_clear_page()
	page.add_theme_constant_override("separation", 18)
	page.add_child(_make_label("Préparons le départ !", 26, COLOR_TEXT))
	workshop_missions_panel = _build_workshop_missions_panel()
	page.add_child(workshop_missions_panel)
	var return_button := _make_button("Retour aux rêves")
	return_button.pressed.connect(_show_dream_menu)
	page.add_child(return_button)


func _show_cardboard_task() -> void:
	_clear_page()
	page.add_theme_constant_override("separation", 12)
	page.add_child(_make_label("À la recherche du carton résistant", 26, COLOR_TEXT))
	page.add_child(_make_label(
		"Explore le vieil atelier en désordre. Utilise les flèches pour te déplacer, puis approche-toi des objets et examine-les. Attention aux faux amis !",
		16,
		COLOR_MUTED
	))

	var game_panel := _make_panel(COLOR_PANEL)
	page.add_child(game_panel)
	var game_row := HBoxContainer.new()
	game_row.add_theme_constant_override("separation", 16)
	game_panel.add_child(game_row)

	cardboard_level = CardboardWorkshopLevel.new()
	cardboard_level.custom_minimum_size = Vector2(600, 240)
	cardboard_level.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cardboard_level.found_cardboard.connect(_on_cardboard_found)
	cardboard_level.examined_object.connect(_on_cardboard_examined)
	game_row.add_child(cardboard_level)
	game_row.add_child(_make_movement_controls())

	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 12)
	page.add_child(action_row)
	cardboard_status_label = _make_label(
		"Le carton solide est quelque part dans l'atelier. Va voir ce qui se cache près des établis.",
		16,
		COLOR_TEXT
	)
	cardboard_status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	action_row.add_child(cardboard_status_label)

	cardboard_interact_button = _make_button("Examiner l'objet")
	cardboard_interact_button.custom_minimum_size = Vector2(210, 52)
	cardboard_interact_button.pressed.connect(cardboard_level.examine_nearby_object)
	action_row.add_child(cardboard_interact_button)

	var return_button := _make_button("Retour aux missions")
	return_button.pressed.connect(_show_workshop_mission_board)
	var return_row := CenterContainer.new()
	return_row.add_child(return_button)
	page.add_child(return_row)


func _show_suit_pieces_task() -> void:
	_clear_page()
	page.add_theme_constant_override("separation", 12)
	page.add_child(_make_label("Découper et mesurer les pièces", 26, COLOR_TEXT))
	page.add_child(_make_label(
		"Trouve une planche fine, découpe trois pièces pour la combinaison, puis cherche la règle de Thomas et mesure-les à l'établi.",
		16,
		COLOR_MUTED
	))

	var game_panel := _make_panel(COLOR_PANEL)
	page.add_child(game_panel)
	var game_row := HBoxContainer.new()
	game_row.add_theme_constant_override("separation", 16)
	game_panel.add_child(game_row)

	suit_pieces_level = SuitPiecesWorkshopLevel.new()
	suit_pieces_level.custom_minimum_size = Vector2(600, 240)
	suit_pieces_level.wood_collected = suit_pieces_stage >= 1
	suit_pieces_level.pieces_cut = suit_pieces_stage >= 2
	suit_pieces_level.ruler_collected = suit_pieces_stage >= 3
	suit_pieces_level.pieces_measured = suit_pieces_stage >= 4
	suit_pieces_level.found_wood.connect(_on_suit_pieces_wood_found)
	suit_pieces_level.cut_pieces_done.connect(_on_suit_pieces_cut)
	suit_pieces_level.found_ruler.connect(_on_suit_pieces_ruler_found)
	suit_pieces_level.examined_object.connect(_on_suit_pieces_examined)
	suit_pieces_level.measured_pieces.connect(_on_suit_pieces_measured)
	game_row.add_child(suit_pieces_level)
	game_row.add_child(_make_suit_pieces_movement_controls())

	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 12)
	page.add_child(action_row)
	suit_pieces_status_label = _make_label(
		_get_suit_pieces_instruction(),
		16,
		COLOR_TEXT
	)
	suit_pieces_status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	action_row.add_child(suit_pieces_status_label)

	suit_pieces_action_button = _make_button(_get_suit_pieces_action_text())
	suit_pieces_action_button.custom_minimum_size = Vector2(230, 52)
	suit_pieces_action_button.pressed.connect(_on_suit_pieces_action)
	action_row.add_child(suit_pieces_action_button)

	var return_button := _make_button("Retour aux missions")
	return_button.pressed.connect(_show_workshop_mission_board)
	var return_row := CenterContainer.new()
	return_row.add_child(return_button)
	page.add_child(return_row)


func _get_suit_pieces_instruction() -> String:
	match suit_pieces_stage:
		0:
			return "Thomas : « Trouvons une planche fine dans le désordre. Elle nous servira à fabriquer les pièces ! »"
		1:
			return "Tu as la planche ! Va près de l'établi et découpe trois pièces pour la combinaison."
		2:
			return "Les pièces sont prêtes. Explore l'atelier pour retrouver la règle de Thomas."
		3:
			return "Tu as trouvé la règle. Retourne à l'établi pour mesurer les pièces en bois."
		_:
			return "Les pièces sont déjà découpées et mesurées. Tu peux revenir à la to-do list."


func _get_suit_pieces_action_text() -> String:
	match suit_pieces_stage:
		1:
			return "Découper les pièces"
		3:
			return "Mesurer les pièces"
		4:
			return "Retour aux missions"
		_:
			return "Examiner l'objet"


func _on_suit_pieces_action() -> void:
	match suit_pieces_stage:
		1:
			suit_pieces_level.cut_pieces()
		3:
			suit_pieces_level.measure_pieces()
		4:
			_show_workshop_mission_board()
		_:
			suit_pieces_level.examine_nearby_object()


func _on_suit_pieces_examined(message: String) -> void:
	if is_instance_valid(suit_pieces_status_label):
		suit_pieces_status_label.text = message


func _on_suit_pieces_wood_found() -> void:
	suit_pieces_stage = 1
	suit_pieces_action_button.text = _get_suit_pieces_action_text()
	suit_pieces_status_label.text = "Tu as trouvé le bois ! Va à l'établi et appuie sur « Découper les pièces »."


func _on_suit_pieces_cut() -> void:
	suit_pieces_stage = 2
	suit_pieces_action_button.text = _get_suit_pieces_action_text()
	suit_pieces_status_label.text = "Les pièces sont découpées ! Explore l'atelier pour trouver la règle de Thomas."


func _on_suit_pieces_ruler_found() -> void:
	suit_pieces_stage = 3
	suit_pieces_action_button.text = _get_suit_pieces_action_text()
	suit_pieces_status_label.text = "La règle est dans ton sac. Retourne près de l'établi pour mesurer les pièces."


func _on_suit_pieces_measured() -> void:
	suit_pieces_stage = 4
	workshop_tasks_ready_for_checking["0:1"] = true
	call_deferred("_show_suit_pieces_success")


func _show_suit_pieces_success() -> void:
	_clear_page()
	page.add_theme_constant_override("separation", 22)
	page.add_child(_make_label("Les pièces sont prêtes !", 32, COLOR_ACCENT))
	page.add_child(_make_label(
		"Tu as découpé trois pièces dans le bois et tu les as mesurées avec la règle de Thomas. Elles ont la bonne longueur pour la combinaison !",
		22,
		COLOR_TEXT
	))

	var success_panel := _make_panel(Color("#fffdf8"))
	page.add_child(success_panel)
	success_panel.add_child(_make_label(
		"Thomas sourit : « Parfait ! Avec des pièces bien mesurées, on pourra préparer une combinaison à la bonne taille. La prochaine fois, on s'occupera de leur assemblage. »",
		19,
		COLOR_ACCENT
	))
	success_panel.add_child(_make_label(
		"Cette tâche n'est pas cochée automatiquement. Retourne à la liste et coche-la toi-même quand tu veux.",
		17,
		COLOR_MUTED
	))

	var return_button := _make_button("Retour à la to-do list")
	return_button.pressed.connect(_show_workshop_mission_board)
	var button_row := CenterContainer.new()
	button_row.add_child(return_button)
	page.add_child(button_row)


func _show_suit_assembly_task() -> void:
	_clear_page()
	page.add_theme_constant_override("separation", 12)
	page.add_child(_make_label("Assembler la combinaison", 26, COLOR_TEXT))
	if not cardboard_found or suit_pieces_stage < 4:
		page.add_child(_make_label(
			"Thomas a besoin du carton résistant et des pièces découpées et mesurées avant de pouvoir assembler la combinaison. Termine d'abord les missions précédentes !",
			18,
			COLOR_MUTED
		))
		var back_button := _make_button("Retour aux missions")
		back_button.pressed.connect(_show_workshop_mission_board)
		page.add_child(back_button)
		return

	page.add_child(_make_label(
		"Trouve le tissu argenté et une bobine de fil dans l'atelier. Puis rejoins l'établi pour assembler le haut, le pantalon et les gants.",
		16,
		COLOR_MUTED
	))

	var game_panel := _make_panel(COLOR_PANEL)
	page.add_child(game_panel)
	var game_row := HBoxContainer.new()
	game_row.add_theme_constant_override("separation", 16)
	game_panel.add_child(game_row)

	suit_assembly_level = SuitAssemblyWorkshopLevel.new()
	suit_assembly_level.custom_minimum_size = Vector2(600, 240)
	suit_assembly_level.fabric_collected = suit_assembly_stage >= 1
	suit_assembly_level.thread_collected = suit_assembly_stage >= 2
	suit_assembly_level.assembled = suit_assembly_stage >= 3
	suit_assembly_level.found_fabric.connect(_on_suit_assembly_fabric_found)
	suit_assembly_level.found_thread.connect(_on_suit_assembly_thread_found)
	suit_assembly_level.examined_object.connect(_on_suit_assembly_examined)
	suit_assembly_level.suit_assembled.connect(_on_suit_assembled)
	game_row.add_child(suit_assembly_level)
	game_row.add_child(_make_suit_assembly_movement_controls())

	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 12)
	page.add_child(action_row)
	suit_assembly_status_label = _make_label(
		_get_suit_assembly_instruction(),
		16,
		COLOR_TEXT
	)
	suit_assembly_status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	action_row.add_child(suit_assembly_status_label)

	suit_assembly_action_button = _make_button(_get_suit_assembly_action_text())
	suit_assembly_action_button.custom_minimum_size = Vector2(230, 52)
	suit_assembly_action_button.pressed.connect(_on_suit_assembly_action)
	action_row.add_child(suit_assembly_action_button)

	var return_button := _make_button("Retour aux missions")
	return_button.pressed.connect(_show_workshop_mission_board)
	var return_row := CenterContainer.new()
	return_row.add_child(return_button)
	page.add_child(return_row)


func _get_suit_assembly_instruction() -> String:
	match suit_assembly_stage:
		0:
			return "Thomas : « Les patrons sont prêts ! Trouvons du tissu souple pour tailler le haut, le pantalon et les gants. »"
		1:
			return "Le tissu argenté est trouvé ! Cherche maintenant une bobine de fil près des plans."
		2:
			return "Tu as le tissu et le fil. Rejoins l'établi pour assembler les trois parties de la combinaison."
		_:
			return "La combinaison est assemblée ! Tu peux revenir à la liste des missions."


func _get_suit_assembly_action_text() -> String:
	match suit_assembly_stage:
		2:
			return "Assembler la combinaison"
		3:
			return "Retour aux missions"
		_:
			return "Examiner l'objet"


func _on_suit_assembly_action() -> void:
	match suit_assembly_stage:
		2:
			suit_assembly_level.assemble_suit()
		3:
			_show_workshop_mission_board()
		_:
			suit_assembly_level.examine_nearby_object()


func _on_suit_assembly_examined(message: String) -> void:
	if is_instance_valid(suit_assembly_status_label):
		suit_assembly_status_label.text = message


func _on_suit_assembly_fabric_found() -> void:
	suit_assembly_stage = 1
	suit_assembly_action_button.text = _get_suit_assembly_action_text()
	suit_assembly_status_label.text = "Beau travail ! Le tissu est prêt. Il te faut maintenant une bobine de fil."


func _on_suit_assembly_thread_found() -> void:
	suit_assembly_stage = 2
	suit_assembly_action_button.text = _get_suit_assembly_action_text()
	suit_assembly_status_label.text = "Tu as trouvé le fil ! Retourne à l'établi pour assembler le haut, le pantalon et les gants."


func _on_suit_assembled() -> void:
	suit_assembly_stage = 3
	workshop_tasks_ready_for_checking["0:2"] = true
	call_deferred("_show_suit_assembly_success")


func _show_suit_assembly_success() -> void:
	_clear_page()
	page.add_theme_constant_override("separation", 22)
	page.add_child(_make_label("La combinaison prend forme !", 32, COLOR_ACCENT))
	page.add_child(_make_label(
		"Le haut, le pantalon et les gants sont assemblés. Le tissu argenté est solide, les coutures tiennent bien et Thomas peut enfin essayer sa combinaison.",
		22,
		COLOR_TEXT
	))

	var success_panel := _make_panel(Color("#fffdf8"))
	page.add_child(success_panel)
	success_panel.add_child(_make_label(
		"Thomas rit : « Elle est un peu brillante, mais elle me va parfaitement ! Il ne reste plus qu'à vérifier le casque avant le grand départ. »",
		19,
		COLOR_ACCENT
	))
	success_panel.add_child(_make_label(
		"Mission réussie ! La tâche reste à cocher par toi dans la to-do list.",
		17,
		COLOR_MUTED
	))

	var return_button := _make_button("Retour à la to-do list")
	return_button.pressed.connect(_show_workshop_mission_board)
	var button_row := CenterContainer.new()
	button_row.add_child(return_button)
	page.add_child(button_row)


func _show_helmet_visor_task() -> void:
	if helmet_visor_stage >= 2:
		_show_workshop_mission_board()
		return

	_clear_page()
	page.add_theme_constant_override("separation", 12)
	page.add_child(_make_label("Préparer le casque et sa visière", 26, COLOR_TEXT))
	if not cardboard_found or suit_pieces_stage < 4 or suit_assembly_stage < 3:
		page.add_child(_make_label(
			"Avant de préparer le casque, il faut avoir trouvé le carton, mesuré les pièces et assemblé la combinaison. Termine les missions précédentes avec Thomas !",
			18,
			COLOR_MUTED
		))
		var back_button := _make_button("Retour aux missions")
		back_button.pressed.connect(_show_workshop_mission_board)
		page.add_child(back_button)
		return

	if helmet_visor_target_color.is_empty():
		var color_options: Array[String] = ["bleu", "rouge", "vert", "jaune", "violet", "orange"]
		var random_generator := RandomNumberGenerator.new()
		random_generator.randomize()
		if color_options.size() > 1 and not helmet_visor_previous_color.is_empty():
			color_options.erase(helmet_visor_previous_color)
		var target_index := random_generator.randi_range(0, color_options.size() - 1)
		helmet_visor_target_color = color_options[target_index]
		helmet_visor_previous_color = helmet_visor_target_color

	page.add_child(_make_label(
		"Dans la chambre des casques, trouve un casque solide de couleur %s. Ensuite, retourne à l'atelier et fouille parmi les objets pour retrouver sa visière."
		% helmet_visor_target_color,
		16,
		COLOR_MUTED
	))

	var game_panel := _make_panel(COLOR_PANEL)
	page.add_child(game_panel)
	var game_row := HBoxContainer.new()
	game_row.add_theme_constant_override("separation", 16)
	game_panel.add_child(game_row)

	helmet_visor_level = HelmetVisorWorkshopLevel.new()
	helmet_visor_level.custom_minimum_size = Vector2(600, 240)
	helmet_visor_level.target_color_name = helmet_visor_target_color
	helmet_visor_level.helmet_found = helmet_visor_stage >= 1
	helmet_visor_level.visor_found = helmet_visor_stage >= 2
	helmet_visor_level.room_mode = 1 if helmet_visor_stage >= 1 else 0
	helmet_visor_level.found_helmet.connect(_on_helmet_found)
	helmet_visor_level.found_visor.connect(_on_visor_found)
	helmet_visor_level.examined_object.connect(_on_helmet_visor_examined)
	game_row.add_child(helmet_visor_level)
	game_row.add_child(_make_helmet_visor_movement_controls())

	helmet_visor_status_label = _make_label(
		_get_helmet_visor_instruction(),
		16,
		COLOR_TEXT
	)
	page.add_child(helmet_visor_status_label)

	var action_row := HBoxContainer.new()
	action_row.alignment = BoxContainer.ALIGNMENT_CENTER
	page.add_child(action_row)
	var examine_button := _make_button("Examiner l'objet")
	examine_button.custom_minimum_size = Vector2(230, 52)
	examine_button.pressed.connect(helmet_visor_level.examine_nearby_object)
	action_row.add_child(examine_button)

	var return_button := _make_button("Retour aux missions")
	return_button.pressed.connect(_show_workshop_mission_board)
	var return_row := CenterContainer.new()
	return_row.add_child(return_button)
	page.add_child(return_row)


func _get_helmet_visor_instruction() -> String:
	if helmet_visor_stage == 0:
		return "Thomas : « La chambre des casques est juste à côté. Il nous faut un casque solide, et cette fois la couleur demandée est le %s ! »" % helmet_visor_target_color
	return "Le casque %s est avec toi. Retourne dans l'atelier et cherche une visière transparente parmi les affaires." % helmet_visor_target_color


func _on_helmet_visor_examined(message: String) -> void:
	if is_instance_valid(helmet_visor_status_label):
		helmet_visor_status_label.text = message


func _on_helmet_found(color_name: String) -> void:
	helmet_visor_stage = 1
	helmet_visor_status_label.text = "Tu as choisi le casque solide %s. Tu retournes dans l'atelier pour chercher la visière." % color_name


func _on_visor_found() -> void:
	helmet_visor_stage = 2
	workshop_tasks_ready_for_checking["0:3"] = true
	call_deferred("_show_helmet_visor_success")


func _show_helmet_visor_success() -> void:
	_clear_page()
	page.add_theme_constant_override("separation", 22)
	page.add_child(_make_label("Le casque est prêt !", 32, COLOR_ACCENT))
	page.add_child(_make_label(
		"Tu as choisi un casque solide de couleur %s et retrouvé la visière transparente dans le désordre de l'atelier. Elle s'ajuste parfaitement au casque."
		% helmet_visor_target_color,
		22,
		COLOR_TEXT
	))

	var success_panel := _make_panel(Color("#fffdf8"))
	page.add_child(success_panel)
	success_panel.add_child(_make_label(
		"Thomas examine le casque : « Exactement la bonne couleur, une coque bien solide et une visière claire pour voir les étoiles. Notre combinaison est presque prête ! »",
		19,
		COLOR_ACCENT
	))
	success_panel.add_child(_make_label(
		"Mission réussie ! La tâche reste à cocher par toi dans la to-do list.",
		17,
		COLOR_MUTED
	))

	var return_button := _make_button("Retour à la to-do list")
	return_button.pressed.connect(_show_workshop_mission_board)
	var button_row := CenterContainer.new()
	button_row.add_child(return_button)
	page.add_child(button_row)


func _make_helmet_visor_movement_controls() -> Control:
	var controls := VBoxContainer.new()
	controls.custom_minimum_size.x = 244
	controls.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	controls.add_theme_constant_override("separation", 6)
	var heading := _make_label("Déplacements", 18, COLOR_ACCENT)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls.add_child(heading)

	var top_row := HBoxContainer.new()
	top_row.alignment = BoxContainer.ALIGNMENT_CENTER
	controls.add_child(top_row)
	top_row.add_child(_make_helmet_visor_direction_button("↑", Vector2.UP))

	var bottom_row := HBoxContainer.new()
	bottom_row.alignment = BoxContainer.ALIGNMENT_CENTER
	bottom_row.add_theme_constant_override("separation", 6)
	controls.add_child(bottom_row)
	bottom_row.add_child(_make_helmet_visor_direction_button("←", Vector2.LEFT))
	bottom_row.add_child(_make_helmet_visor_direction_button("↓", Vector2.DOWN))
	bottom_row.add_child(_make_helmet_visor_direction_button("→", Vector2.RIGHT))
	return controls


func _make_helmet_visor_direction_button(symbol: String, direction: Vector2) -> Button:
	var button := _make_button(symbol)
	button.custom_minimum_size = Vector2(72, 62)
	button.add_theme_font_size_override("font_size", 28)
	button.button_down.connect(helmet_visor_level.set_direction.bind(direction, true))
	button.button_up.connect(helmet_visor_level.set_direction.bind(direction, false))
	return button


func _make_suit_assembly_movement_controls() -> Control:
	var controls := VBoxContainer.new()
	controls.custom_minimum_size.x = 244
	controls.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	controls.add_theme_constant_override("separation", 6)
	var heading := _make_label("Déplacements", 18, COLOR_ACCENT)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls.add_child(heading)

	var top_row := HBoxContainer.new()
	top_row.alignment = BoxContainer.ALIGNMENT_CENTER
	controls.add_child(top_row)
	top_row.add_child(_make_suit_assembly_direction_button("↑", Vector2.UP))

	var bottom_row := HBoxContainer.new()
	bottom_row.alignment = BoxContainer.ALIGNMENT_CENTER
	bottom_row.add_theme_constant_override("separation", 6)
	controls.add_child(bottom_row)
	bottom_row.add_child(_make_suit_assembly_direction_button("←", Vector2.LEFT))
	bottom_row.add_child(_make_suit_assembly_direction_button("↓", Vector2.DOWN))
	bottom_row.add_child(_make_suit_assembly_direction_button("→", Vector2.RIGHT))
	return controls


func _make_suit_assembly_direction_button(symbol: String, direction: Vector2) -> Button:
	var button := _make_button(symbol)
	button.custom_minimum_size = Vector2(72, 62)
	button.add_theme_font_size_override("font_size", 28)
	button.button_down.connect(suit_assembly_level.set_direction.bind(direction, true))
	button.button_up.connect(suit_assembly_level.set_direction.bind(direction, false))
	return button


func _make_movement_controls() -> Control:
	var controls := VBoxContainer.new()
	controls.custom_minimum_size.x = 244
	controls.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	controls.add_theme_constant_override("separation", 6)
	var heading := _make_label("Déplacements", 18, COLOR_ACCENT)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls.add_child(heading)

	var top_row := HBoxContainer.new()
	top_row.alignment = BoxContainer.ALIGNMENT_CENTER
	controls.add_child(top_row)
	top_row.add_child(_make_direction_button("↑", Vector2.UP))

	var bottom_row := HBoxContainer.new()
	bottom_row.alignment = BoxContainer.ALIGNMENT_CENTER
	bottom_row.add_theme_constant_override("separation", 6)
	controls.add_child(bottom_row)
	bottom_row.add_child(_make_direction_button("←", Vector2.LEFT))
	bottom_row.add_child(_make_direction_button("↓", Vector2.DOWN))
	bottom_row.add_child(_make_direction_button("→", Vector2.RIGHT))
	return controls


func _make_suit_pieces_movement_controls() -> Control:
	var controls := VBoxContainer.new()
	controls.custom_minimum_size.x = 244
	controls.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	controls.add_theme_constant_override("separation", 6)
	var heading := _make_label("Déplacements", 18, COLOR_ACCENT)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls.add_child(heading)

	var top_row := HBoxContainer.new()
	top_row.alignment = BoxContainer.ALIGNMENT_CENTER
	controls.add_child(top_row)
	top_row.add_child(_make_suit_pieces_direction_button("↑", Vector2.UP))

	var bottom_row := HBoxContainer.new()
	bottom_row.alignment = BoxContainer.ALIGNMENT_CENTER
	bottom_row.add_theme_constant_override("separation", 6)
	controls.add_child(bottom_row)
	bottom_row.add_child(_make_suit_pieces_direction_button("←", Vector2.LEFT))
	bottom_row.add_child(_make_suit_pieces_direction_button("↓", Vector2.DOWN))
	bottom_row.add_child(_make_suit_pieces_direction_button("→", Vector2.RIGHT))
	return controls


func _make_suit_pieces_direction_button(symbol: String, direction: Vector2) -> Button:
	var button := _make_button(symbol)
	button.custom_minimum_size = Vector2(72, 62)
	button.add_theme_font_size_override("font_size", 28)
	button.button_down.connect(suit_pieces_level.set_direction.bind(direction, true))
	button.button_up.connect(suit_pieces_level.set_direction.bind(direction, false))
	return button


func _make_direction_button(symbol: String, direction: Vector2) -> Button:
	var button := _make_button(symbol)
	button.custom_minimum_size = Vector2(72, 62)
	button.add_theme_font_size_override("font_size", 28)
	button.button_down.connect(cardboard_level.set_direction.bind(direction, true))
	button.button_up.connect(cardboard_level.set_direction.bind(direction, false))
	return button


func _on_cardboard_examined(message: String) -> void:
	cardboard_status_label.text = message
	if cardboard_level.found:
		cardboard_interact_button.text = "Carton trouvé !"
		cardboard_interact_button.disabled = true


func _on_cardboard_found() -> void:
	cardboard_found = true
	workshop_tasks_ready_for_checking["0:0"] = true
	call_deferred("_show_cardboard_success")


func _show_cardboard_success() -> void:
	_clear_page()
	page.add_theme_constant_override("separation", 22)
	page.add_child(_make_label("Carton trouvé !", 32, COLOR_ACCENT))
	page.add_child(_make_label(
		"Bravo, tu as trouvé le morceau de carton épais et résistant ! Il est parfait pour protéger les pièces de la combinaison.",
		22,
		COLOR_TEXT
	))

	var celebration_panel := _make_panel(Color("#fffdf8"))
	page.add_child(celebration_panel)
	var celebration_content := VBoxContainer.new()
	celebration_content.add_theme_constant_override("separation", 12)
	celebration_panel.add_child(celebration_content)
	celebration_content.add_child(_make_label(
		"Thomas est ravi : « Super travail ! Je vais le mettre de côté pour notre combinaison. Une première étape de réussie ! »",
		19,
		COLOR_ACCENT
	))
	celebration_content.add_child(_make_label(
		"La mission n'est pas encore cochée. Retourne à ta to-do list et coche-la toi-même quand tu es prêt.",
		17,
		COLOR_MUTED
	))

	var return_button := _make_button("Retour à la to-do list")
	return_button.pressed.connect(_show_workshop_mission_board)
	var button_row := CenterContainer.new()
	button_row.add_child(return_button)
	page.add_child(button_row)


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
	workshop_task_checkboxes.clear()
	workshop_task_progress_label = null
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
