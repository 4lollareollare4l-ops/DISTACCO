extends Node3D

var player: CharacterBody3D
var saturnino: Node3D
var kengan: CharacterBody3D
var interactables: Array[Dictionary] = []

var objective_label: Label
var guide_label: Label
var prompt_label: Label
var speaker_label: Label
var dialogue_label: Label
var choice_box: VBoxContainer
var dialogue_panel: PanelContainer
var location_label: Label

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = 2033
	_build_environment()
	_build_world()
	_spawn_cast()
	_build_hud()
	QuestManager.objective_changed.connect(_on_objective_changed)
	QuestManager.start_current()
	_show_dialogue("SATURNINO", "Okay. Bosco enorme, pioggia, una torre che non dovrebbe funzionare e Kengan con una pistola. Io rimango vicino a te.")

func _build_environment() -> void:
	var world_env := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.018, 0.03, 0.035)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.22, 0.29, 0.30)
	env.ambient_light_energy = 0.72
	env.fog_enabled = true
	env.fog_light_color = Color(0.14, 0.19, 0.20)
	env.fog_density = 0.026
	env.fog_sky_affect = 0.8
	world_env.environment = env
	add_child(world_env)

	var moon := DirectionalLight3D.new()
	moon.rotation_degrees = Vector3(-58.0, -28.0, 0.0)
	moon.light_color = Color(0.64, 0.76, 0.79)
	moon.light_energy = 1.15
	moon.shadow_enabled = true
	add_child(moon)

func _build_world() -> void:
	_add_static_box(Vector3(0, -0.25, 0), Vector3(100, 0.5, 100), Color(0.045, 0.075, 0.06), true)
	_add_visual_box(Vector3(0, 0.015, 7), Vector3(5.8, 0.03, 70), Color(0.11, 0.13, 0.115))

	_build_forest()
	_build_stream()
	_build_camp(Vector3(-14, 0, 23))
	_build_tower(Vector3(8, 0, 4))
	_build_house(Vector3(-28, 0, -12))
	_build_station(Vector3(28, 0, -8))
	_build_anomaly(Vector3(19, 0, -18))
	_build_blue_field(Vector3(-8, 0, -25))
	_build_rain()

	interactables = [
		{"id":"camp","name":"taccuino dell'accampamento","position":Vector3(-14,0,23)},
		{"id":"tower","name":"pannello della torre","position":Vector3(8,0,6.1)},
		{"id":"house","name":"Casa 14","position":Vector3(-28,0,-8.7)},
		{"id":"station","name":"posto di blocco del Direttorato","position":Vector3(28,0,-5.0)},
		{"id":"anomaly","name":"anomalia pallida","position":Vector3(19,0,-18)},
		{"id":"flowers","name":"fiori blu","position":Vector3(-8,0,-25)}
	]

func _build_forest() -> void:
	for i in range(95):
		var x := rng.randf_range(-47.0, 47.0)
		var z := rng.randf_range(-47.0, 47.0)
		if absf(x) < 4.5:
			continue
		if Vector2(x + 14.0, z - 23.0).length() < 6.0:
			continue
		if Vector2(x - 8.0, z - 4.0).length() < 6.0:
			continue
		var scale := rng.randf_range(0.75, 1.45)
		_add_tree(Vector3(x, 0, z), scale)

func _add_tree(pos: Vector3, scale_value: float) -> void:
	var trunk := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.16 * scale_value
	cyl.bottom_radius = 0.29 * scale_value
	cyl.height = 4.7 * scale_value
	trunk.mesh = cyl
	trunk.position = pos + Vector3.UP * 2.35 * scale_value
	trunk.material_override = _material(Color(0.12, 0.10, 0.085), 0.95)
	add_child(trunk)

	var crown := MeshInstance3D.new()
	var cone := CylinderMesh.new()
	cone.top_radius = 0.0
	cone.bottom_radius = 1.35 * scale_value
	cone.height = 3.8 * scale_value
	crown.mesh = cone
	crown.position = pos + Vector3.UP * 5.2 * scale_value
	crown.material_override = _material(Color(0.035, 0.09, 0.055), 0.92)
	add_child(crown)

func _build_stream() -> void:
	var water := MeshInstance3D.new()
	var mesh := PlaneMesh.new()
	mesh.size = Vector2(100, 5.8)
	water.mesh = mesh
	water.position = Vector3(0, 0.035, -2)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.04, 0.12, 0.14, 0.82)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.metallic = 0.25
	mat.roughness = 0.18
	water.material_override = mat
	add_child(water)

	for x in range(5, 12):
		_add_static_box(Vector3(float(x), 0.18, -2), Vector3(0.86, 0.36, 6.4), Color(0.19, 0.15, 0.11), true)

func _build_camp(pos: Vector3) -> void:
	var tent := MeshInstance3D.new()
	var tent_mesh := CylinderMesh.new()
	tent_mesh.radial_segments = 4
	tent_mesh.top_radius = 0.0
	tent_mesh.bottom_radius = 2.2
	tent_mesh.height = 2.3
	tent.mesh = tent_mesh
	tent.rotation_degrees.y = 45
	tent.position = pos + Vector3(0, 1.15, 0)
	tent.material_override = _material(Color(0.24, 0.23, 0.19), 1.0)
	add_child(tent)

	var fire := OmniLight3D.new()
	fire.position = pos + Vector3(2.6, 0.9, 1.4)
	fire.light_color = Color(0.78, 0.42, 0.22)
	fire.light_energy = 2.2
	fire.omni_range = 7.0
	add_child(fire)
	_add_visual_box(pos + Vector3(0.8, 0.28, 2.2), Vector3(2.4, 0.12, 0.8), Color(0.20, 0.16, 0.12))

func _build_tower(pos: Vector3) -> void:
	for sx in [-1.2, 1.2]:
		for sz in [-1.2, 1.2]:
			_add_visual_box(pos + Vector3(sx, 8.5, sz), Vector3(0.13, 17.0, 0.13), Color(0.34, 0.38, 0.37))
	for y in range(1, 17, 2):
		_add_visual_box(pos + Vector3(0, float(y), 0), Vector3(2.6, 0.08, 0.08), Color(0.34, 0.38, 0.37))
		_add_visual_box(pos + Vector3(0, float(y), 0), Vector3(0.08, 0.08, 2.6), Color(0.34, 0.38, 0.37))

	var beacon := OmniLight3D.new()
	beacon.name = "TowerBeacon"
	beacon.position = pos + Vector3(0, 18.0, 0)
	beacon.light_color = Color(0.50, 0.75, 0.63)
	beacon.light_energy = 3.4
	beacon.omni_range = 22.0
	add_child(beacon)
	_add_static_box(pos + Vector3(0, 0.9, 2.2), Vector3(1.25, 1.8, 0.4), Color(0.12, 0.15, 0.14), true)

func _build_house(pos: Vector3) -> void:
	_add_static_box(pos + Vector3(0, 1.8, 0), Vector3(7.5, 3.6, 5.8), Color(0.15, 0.135, 0.12), true)
	var roof := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.radial_segments = 4
	mesh.top_radius = 0.0
	mesh.bottom_radius = 5.0
	mesh.height = 2.4
	roof.mesh = mesh
	roof.rotation_degrees.y = 45
	roof.position = pos + Vector3(0, 4.6, 0)
	roof.material_override = _material(Color(0.055, 0.05, 0.045), 0.98)
	add_child(roof)
	_add_visual_box(pos + Vector3(0, 1.25, 3.02), Vector3(1.25, 2.5, 0.14), Color(0.04, 0.045, 0.04))

func _build_station(pos: Vector3) -> void:
	_add_static_box(pos + Vector3(0, 1.6, 0), Vector3(9, 3.2, 5), Color(0.14, 0.17, 0.16), true)
	_add_visual_box(pos + Vector3(0, 0.18, 4), Vector3(14, 0.36, 2.6), Color(0.19, 0.21, 0.20))

func _build_anomaly(pos: Vector3) -> void:
	var anomaly := MeshInstance3D.new()
	anomaly.name = "PaleAnomaly"
	var sphere := SphereMesh.new()
	sphere.radius = 1.1
	sphere.height = 2.2
	anomaly.mesh = sphere
	anomaly.scale = Vector3(0.65, 1.5, 0.65)
	anomaly.position = pos + Vector3.UP * 1.5
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.48, 0.58, 0.45)
	mat.emission_enabled = true
	mat.emission = Color(0.18, 0.32, 0.19)
	mat.emission_energy_multiplier = 2.3
	mat.roughness = 0.22
	anomaly.material_override = mat
	add_child(anomaly)

func _build_blue_field(center: Vector3) -> void:
	for i in range(28):
		var a := rng.randf_range(0.0, TAU)
		var r := rng.randf_range(0.7, 5.0)
		var flower := MeshInstance3D.new()
		var mesh := SphereMesh.new()
		mesh.radius = 0.08
		mesh.height = 0.16
		flower.mesh = mesh
		flower.position = center + Vector3(cos(a) * r, 0.12, sin(a) * r)
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.25, 0.46, 0.56)
		mat.emission_enabled = true
		mat.emission = Color(0.08, 0.24, 0.32)
		mat.emission_energy_multiplier = 1.3
		flower.material_override = mat
		add_child(flower)

func _build_rain() -> void:
	var rain := GPUParticles3D.new()
	rain.name = "Rain"
	rain.amount = 1100
	rain.lifetime = 2.2
	rain.position = Vector3(0, 18, 0)
	rain.visibility_aabb = AABB(Vector3(-55, -25, -55), Vector3(110, 50, 110))
	var process := ParticleProcessMaterial.new()
	process.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	process.emission_box_extents = Vector3(48, 1, 48)
	process.direction = Vector3(0.15, -1.0, 0.05)
	process.spread = 4.0
	process.initial_velocity_min = 18.0
	process.initial_velocity_max = 25.0
	process.gravity = Vector3(0, -11, 0)
	rain.process_material = process
	var quad := QuadMesh.new()
	quad.size = Vector2(0.018, 0.72)
	var rain_mat := StandardMaterial3D.new()
	rain_mat.albedo_color = Color(0.62, 0.72, 0.75, 0.55)
	rain_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	rain_mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	quad.material = rain_mat
	rain.draw_pass_1 = quad
	add_child(rain)

func _spawn_cast() -> void:
	var player_script = load("res://scripts/player_controller.gd")
	player = player_script.new()
	player.position = Vector3(0, 0.2, 36)
	add_child(player)
	player.interact_requested.connect(_on_interact)
	player.talk_requested.connect(_talk_saturnino)
	player.kengan_requested.connect(_talk_kengan)

	var saturn_script = load("res://scripts/saturnino.gd")
	saturnino = saturn_script.new()
	saturnino.target = player
	saturnino.position = player.position + Vector3(1.0, 1.5, 0.7)
	add_child(saturnino)

	var kengan_script = load("res://scripts/kengan.gd")
	kengan = kengan_script.new()
	kengan.target = player
	kengan.position = player.position + Vector3(-2.2, 0.1, 1.5)
	add_child(kengan)

func _build_hud() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)

	var top_left := VBoxContainer.new()
	top_left.position = Vector2(24, 20)
	top_left.size = Vector2(610, 110)
	canvas.add_child(top_left)
	var title := Label.new()
	title.text = "DISTACCO · 2065"
	title.add_theme_font_size_override("font_size", 18)
	top_left.add_child(title)
	objective_label = Label.new()
	objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective_label.add_theme_font_size_override("font_size", 16)
	top_left.add_child(objective_label)
	location_label = Label.new()
	location_label.text = "Bosco occidentale"
	location_label.modulate = Color(0.72,0.76,0.72)
	top_left.add_child(location_label)

	guide_label = Label.new()
	guide_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	guide_label.position = Vector2(1010, 24)
	guide_label.size = Vector2(240, 80)
	guide_label.add_theme_font_size_override("font_size", 18)
	canvas.add_child(guide_label)

	prompt_label = Label.new()
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.position = Vector2(390, 630)
	prompt_label.size = Vector2(500, 40)
	prompt_label.add_theme_font_size_override("font_size", 16)
	canvas.add_child(prompt_label)

	dialogue_panel = PanelContainer.new()
	dialogue_panel.position = Vector2(210, 475)
	dialogue_panel.size = Vector2(860, 145)
	canvas.add_child(dialogue_panel)
	var box := VBoxContainer.new()
	dialogue_panel.add_child(box)
	speaker_label = Label.new()
	speaker_label.add_theme_font_size_override("font_size", 13)
	box.add_child(speaker_label)
	dialogue_label = Label.new()
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_label.add_theme_font_size_override("font_size", 17)
	box.add_child(dialogue_label)
	choice_box = VBoxContainer.new()
	box.add_child(choice_box)

	var controls := Label.new()
	controls.text = "WASD muovi · mouse guarda · E interagisci · F torcia · T Saturnino · R Kengan · ESC cursore"
	controls.position = Vector2(24, 686)
	controls.size = Vector2(900, 26)
	controls.modulate = Color(0.62,0.66,0.63)
	canvas.add_child(controls)

func _process(_delta: float) -> void:
	if not player:
		return
	location_label.text = _location_name(player.global_position)
	var near := _nearest_interactable()
	if near.is_empty():
		prompt_label.text = ""
	else:
		prompt_label.text = "[E] " + String(near["name"])

	if QuestManager.current_index < QuestManager.quests.size():
		var target := QuestManager.active_target
		var flat := Vector2(target.x - player.global_position.x, target.z - player.global_position.z)
		var distance := flat.length()
		var forward := -player.global_transform.basis.z
		var target_dir := Vector3(flat.x, 0, flat.y).normalized()
		var cross := forward.x * target_dir.z - forward.z * target_dir.x
		var dot := forward.x * target_dir.x + forward.z * target_dir.z
		var symbol := "↑"
		if dot < -0.45:
			symbol = "↓"
		elif cross > 0.28:
			symbol = "←"
		elif cross < -0.28:
			symbol = "→"
		guide_label.text = symbol + "  " + str(roundi(distance)) + " m"
	else:
		guide_label.text = "ESPLORA"

func _nearest_interactable() -> Dictionary:
	if not player:
		return {}
	var best: Dictionary = {}
	var best_distance := 3.3
	for item in interactables:
		var p: Vector3 = item["position"]
		var d := Vector2(player.global_position.x - p.x, player.global_position.z - p.z).length()
		if d < best_distance:
			best_distance = d
			best = item
	return best

func _on_interact() -> void:
	var item := _nearest_interactable()
	if item.is_empty():
		_show_dialogue("SATURNINO", "Qui non c'è niente abbastanza vicino da toccare. Il che, per questo posto, è quasi rassicurante.")
		return
	match String(item["id"]):
		"camp":
			_interact_camp()
		"tower":
			_interact_tower()
		"house":
			_interact_house()
		"station":
			_show_dialogue("KENGAN", "Direttorato. Guarda il muro: qualcuno ha scritto 'NON È UNA MALATTIA'.")
		"anomaly":
			if not GameState.has_item("pale_fragment"):
				GameState.add_item("pale_fragment")
				_show_dialogue("SATURNINO", "Hai staccato un pezzo da una cosa che non capiamo. Okay. Adesso pulsa. Fantastico.")
			else:
				_show_dialogue("SATURNINO", "Il resto dell'anomalia vibra quando ti avvicini. Credo rivoglia il suo pezzo.")
		"flowers":
			_show_dialogue("SATURNINO", "I fiori si illuminano quando passo vicino. Questa è adorabile e terribile allo stesso tempo.")

func _interact_camp() -> void:
	if QuestManager.current_index == 0:
		GameState.add_item("field_journal")
		GameState.change_relationship("kengan", 4, 0, 0)
		QuestManager.complete_current()
		_show_dialogue("KENGAN", "Il fuoco non è completamente freddo. Il proprietario del taccuino potrebbe essere ancora qui.")
	else:
		_show_dialogue("SATURNINO", "Le braci sono ancora più calde di quanto dovrebbero essere.")

func _interact_tower() -> void:
	if QuestManager.current_index < 1:
		_show_dialogue("KENGAN", "Prima controlliamo l'accampamento. Voglio sapere chi stava osservando questa torre.")
		return
	if not GameState.get_flag("tower_active"):
		GameState.set_flag("tower_active", true)
		GameState.change_relationship("kengan", 1, 3, 0)
		var beacon := get_node_or_null("TowerBeacon") as OmniLight3D
		if beacon:
			beacon.light_energy = 8.0
		if QuestManager.current_index == 1:
			QuestManager.complete_current()
		_show_dialogue("SATURNINO", "La torre ha risposto. Non acceso: risposto. Sul pannello c'è una parola sola. RITORNO.")
	else:
		_show_dialogue("KENGAN", "Continua a trasmettere verso ovest. Verso Casa 14.")

func _interact_house() -> void:
	if QuestManager.current_index < 2:
		_show_dialogue("KENGAN", "Numero quattordici. Ricordiamocelo e torniamo quando sappiamo perché conta.")
		return
	if not GameState.get_flag("house_open"):
		GameState.set_flag("house_open", true)
		GameState.change_relationship("kengan", 6, 5, 4)
		QuestManager.complete_current()
		_show_dialogue("KENGAN", "La porta non era chiusa. Qualcosa dall'altra parte la stava tenendo. Resta dietro di me.")
	else:
		_show_dialogue("SATURNINO", "Da sotto il pavimento arrivano due colpi. Sempre due. Questa sarà la prossima parte.")

func _talk_saturnino() -> void:
	_show_dialogue("SATURNINO", saturnino.contextual_line())

func _talk_kengan() -> void:
	if player.global_position.distance_to(kengan.global_position) > 5.0:
		_show_dialogue("SATURNINO", "Kengan è troppo lontano per sentirti. Posso urlare io, ma sarebbe umiliante per entrambi.")
		return
	_clear_choices()
	speaker_label.text = "KENGAN"
	dialogue_label.text = kengan.greeting()
	var options: Array[Dictionary] = kengan.romance_choices()
	for choice in options:
		var button := Button.new()
		button.text = String(choice["text"])
		button.pressed.connect(func(): _choose_kengan(choice))
		choice_box.add_child(button)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _choose_kengan(choice: Dictionary) -> void:
	var reply: String = kengan.apply_romance_choice(choice)
	_show_dialogue("KENGAN", reply)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _show_dialogue(who: String, text: String) -> void:
	_clear_choices()
	speaker_label.text = who
	dialogue_label.text = text
	dialogue_panel.visible = true

func _clear_choices() -> void:
	if not choice_box:
		return
	for child in choice_box.get_children():
		child.queue_free()

func _on_objective_changed(title: String, description: String, _target: Vector3) -> void:
	objective_label.text = title + "\n" + description

func _location_name(pos: Vector3) -> String:
	if pos.distance_to(Vector3(-14,0,23)) < 8:
		return "Accampamento"
	if pos.distance_to(Vector3(8,0,4)) < 9:
		return "Torre"
	if pos.distance_to(Vector3(-28,0,-12)) < 9:
		return "Casa 14"
	if pos.distance_to(Vector3(28,0,-8)) < 10:
		return "Posto di blocco"
	if pos.distance_to(Vector3(19,0,-18)) < 9:
		return "Bosco pallido"
	if pos.distance_to(Vector3(-8,0,-25)) < 8:
		return "Campo dei fiori blu"
	if absf(pos.z + 2) < 5:
		return "Torrente"
	return "Bosco occidentale"

func _material(color: Color, roughness: float = 0.8) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = roughness
	return mat

func _add_visual_box(pos: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.position = pos
	mesh_instance.material_override = _material(color)
	add_child(mesh_instance)
	return mesh_instance

func _add_static_box(pos: Vector3, size: Vector3, color: Color, collision: bool) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.position = pos
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color)
	body.add_child(mesh_instance)
	if collision:
		var shape_node := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		shape_node.shape = shape
		body.add_child(shape_node)
	add_child(body)
	return body
