extends CharacterBody3D

@export var follow_speed := 3.4
@export var preferred_distance := 2.4

var target: Node3D
var mesh_root: Node3D

func _ready() -> void:
	name = "Kengan"
	_build_body()

func _build_body() -> void:
	var collider := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.36
	shape.height = 1.15
	collider.shape = shape
	collider.position.y = 0.95
	add_child(collider)

	mesh_root = Node3D.new()
	add_child(mesh_root)
	var torso := MeshInstance3D.new()
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = 0.34
	body_mesh.height = 1.3
	torso.mesh = body_mesh
	torso.position.y = 0.95
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.18, 0.17, 0.15)
	mat.roughness = 0.82
	torso.material_override = mat
	mesh_root.add_child(torso)

	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.29
	head_mesh.height = 0.58
	head.mesh = head_mesh
	head.position.y = 1.86
	var skin := StandardMaterial3D.new()
	skin.albedo_color = Color(0.43, 0.34, 0.28)
	skin.roughness = 0.9
	head.material_override = skin
	mesh_root.add_child(head)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 18.0 * delta
	else:
		velocity.y = 0.0
	if target:
		var flat := target.global_position - global_position
		flat.y = 0.0
		if flat.length() > preferred_distance:
			var dir := flat.normalized()
			velocity.x = dir.x * follow_speed
			velocity.z = dir.z * follow_speed
			look_at(global_position + Vector3(dir.x, 0.0, dir.z), Vector3.UP)
		else:
			velocity.x = move_toward(velocity.x, 0.0, 10.0 * delta)
			velocity.z = move_toward(velocity.z, 0.0, 10.0 * delta)
	move_and_slide()

func greeting() -> String:
	match GameState.kengan_romance_stage():
		"committed":
			return "Non allontanarti troppo. E no, non è un ordine."
		"mutual":
			return "Stai facendo quella cosa in cui fingi che non ci sia niente da dire tra noi."
		"charged":
			return "Se continui a guardarmi così poi non puoi dare la colpa al bosco."
		"close":
			return "Resto con te. Non perché penso che tu ne abbia bisogno."
		_:
			return "Controlliamo il perimetro e poi decidiamo dove dormire."

func romance_choices() -> Array[Dictionary]:
	var stage := GameState.kengan_romance_stage()
	if stage == "guarded":
		return [
			{"text":"Mi fido di te.","trust":10,"tension":0,"romance":2,"reply":"Non dirlo troppo forte. Potrei abituarmici."},
			{"text":"Non ho bisogno di una guardia del corpo.","trust":-2,"tension":6,"romance":0,"reply":"Bene. Perché non avevo intenzione di fare la guardia del corpo."}
		]
	if stage == "close":
		return [
			{"text":"Sei sempre così vicino apposta?","trust":2,"tension":10,"romance":8,"reply":"No. Cioè... adesso sì."},
			{"text":"Grazie per essere rimasto.","trust":8,"tension":0,"romance":5,"reply":"Non avevo intenzione di andare da nessuna parte."}
		]
	if stage == "charged":
		return [
			{"text":"Forse mi piace quando mi segui.","trust":4,"tension":10,"romance":12,"reply":"Okay. Questa informazione è pericolosa nelle mie mani."},
			{"text":"Non montarti la testa.","trust":1,"tension":7,"romance":4,"reply":"Troppo tardi."}
		]
	return [
		{"text":"Vieni qui.","trust":4,"tension":6,"romance":10,"reply":"Pensavo non me l'avresti mai chiesto."},
		{"text":"Rimani con me stanotte.","trust":8,"tension":4,"romance":12,"reply":"Sì. Questa volta niente battute."}
	]

func apply_romance_choice(choice: Dictionary) -> String:
	GameState.change_relationship("kengan", int(choice.get("trust",0)), int(choice.get("tension",0)), int(choice.get("romance",0)))
	return String(choice.get("reply",""))
