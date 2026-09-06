extends Node

signal objective_changed(title: String, description: String, target: Vector3)
signal quest_completed(quest_id: String)

var current_index := 0
var active_title := ""
var active_description := ""
var active_target := Vector3.ZERO

var quests: Array[Dictionary] = [
	{
		"id": "camp",
		"title": "TRACCE NELLA PIOGGIA",
		"description": "Raggiungi l'accampamento abbandonato oltre la strada.",
		"target": Vector3(-14.0, 0.0, 23.0)
	},
	{
		"id": "tower",
		"title": "IL SEGNALE",
		"description": "Il taccuino cita una torre. Trovala e controlla il pannello.",
		"target": Vector3(8.0, 0.0, 4.0)
	},
	{
		"id": "house",
		"title": "CASA 14",
		"description": "Le coordinate portano a Casa 14, sul margine occidentale del bosco.",
		"target": Vector3(-28.0, 0.0, -12.0)
	}
]

func _ready() -> void:
	call_deferred("start_current")

func start_current() -> void:
	if quests.is_empty() or current_index >= quests.size():
		active_title = "NESSUN OBIETTIVO"
		active_description = "Esplora liberamente."
		active_target = Vector3.ZERO
		objective_changed.emit(active_title, active_description, active_target)
		return
	var q: Dictionary = quests[current_index]
	active_title = q["title"]
	active_description = q["description"]
	active_target = q["target"]
	objective_changed.emit(active_title, active_description, active_target)

func complete_current() -> void:
	if current_index >= quests.size():
		return
	var q: Dictionary = quests[current_index]
	quest_completed.emit(q["id"])
	current_index += 1
	start_current()

func distance_to_target(from: Vector3) -> float:
	return from.distance_to(active_target)
