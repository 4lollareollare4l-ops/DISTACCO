extends CharacterBody3D

signal interact_requested
signal talk_requested

@export var move_speed := 5.2
@export var mouse_sensitivity := 0.0025

var camera: Camera3D
var head: Node3D
var interact_ray: RayCast3D

func _ready() -> void:
	name = "Player"
	_build_body()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _build_body() -> void:
	var collider := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.38
	shape.height = 1.15
	collider.shape = shape
	collider.position.y = 0.95
	add_child(collider)

	head = Node3D.new()
	head.name = "Head"
	head.position.y = 1.62
	add_child(head)

	camera = Camera3D.new()
	camera.current = true
	camera.fov = 72.0
	head.add_child(camera)

	interact_ray = RayCast3D.new()
	interact_ray.target_position = Vector3(0, 0, -3.2)
	interact_ray.collide_with_areas = true
	interact_ray.collide_with_bodies = true
	camera.add_child(interact_ray)

	var lamp := SpotLight3D.new()
	lamp.name = "Flashlight"
	lamp.light_color = Color(0.90, 0.92, 0.84)
	lamp.light_energy = 3.6
	lamp.spot_range = 24.0
	lamp.spot_angle = 31.0
	lamp.shadow_enabled = true
	camera.add_child(lamp)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-70.0), deg_to_rad(70.0))
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F:
		var lamp := camera.get_node_or_null("Flashlight") as SpotLight3D
		if lamp:
			lamp.visible = not lamp.visible
	elif event is InputEventKey and event.pressed and event.keycode == KEY_E:
		interact_requested.emit()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_T:
		talk_requested.emit()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 18.0 * delta
	else:
		velocity.y = 0.0

	var input_vec := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	if input_vec.length() > 1.0:
		input_vec = input_vec.normalized()
	var basis := global_transform.basis
	var dir := (basis.x * input_vec.x + basis.z * input_vec.y)
	dir.y = 0.0
	if dir.length() > 0.01:
		dir = dir.normalized()
		velocity.x = dir.x * move_speed
		velocity.z = dir.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed * 7.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, move_speed * 7.0 * delta)
	move_and_slide()

func get_interactable() -> Node:
	if interact_ray and interact_ray.is_colliding():
		return interact_ray.get_collider()
	return null
