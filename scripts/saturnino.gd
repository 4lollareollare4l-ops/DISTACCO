extends Node3D

@export var follow_distance := 1.35
@export var follow_height := 1.45
@export var smoothing := 4.2

var target: Node3D
var ring: MeshInstance3D
var body: MeshInstance3D
var phase := 0.0

func _ready() -> void:
	name = "Saturnino"
	_build_visual()

func _build_visual() -> void:
	body = MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.27
	sphere.height = 0.54
	body.mesh = sphere
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.82, 0.86, 0.82)
	mat.emission_enabled = true
	mat.emission = Color(0.28, 0.45, 0.39)
	mat.emission_energy_multiplier = 2.1
	mat.roughness = 0.34
	body.material_override = mat
	add_child(body)

	ring = MeshInstance3D.new()
	var torus := TorusMesh.new()
	torus.inner_radius = 0.38
	torus.outer_radius = 0.46
	ring.mesh = torus
	ring.rotation_degrees.x = 67.0
	var ring_mat := StandardMaterial3D.new()
	ring_mat.albedo_color = Color(0.70, 0.80, 0.75)
	ring_mat.emission_enabled = true
	ring_mat.emission = Color(0.20, 0.32, 0.27)
	ring_mat.emission_energy_multiplier = 1.6
	ring.material_override = ring_mat
	add_child(ring)

	var glow := OmniLight3D.new()
	glow.light_color = Color(0.65, 0.82, 0.74)
	glow.light_energy = 1.1
	glow.omni_range = 4.5
	add_child(glow)

func _process(delta: float) -> void:
	phase += delta
	if target:
		var right := target.global_transform.basis.x.normalized()
		var desired := target.global_position + right * follow_distance + Vector3.UP * follow_height
		global_position = global_position.lerp(desired, minf(1.0, delta * smoothing))
	position.y += sin(phase * 2.2) * 0.0015
	ring.rotate_y(delta * 0.55)

func contextual_line() -> String:
	if GameState.get_flag("house_open"):
		return "La casa è aperta. Io rimango vicino a te. Molto vicino, in realtà."
	if GameState.has_item("pale_fragment"):
		return "Quel frammento pulsa ogni volta che mi avvicino. Non mi piace quanto sembri interessato al mio anello."
	if GameState.get_flag("tower_active"):
		return "La torre ci ha risposto. Non so se sia peggio che ci abbia sentiti o che ci stesse già aspettando."
	return "Io ti seguo. Se vuoi ignorare l'obiettivo e curiosare, non ti fermo."
