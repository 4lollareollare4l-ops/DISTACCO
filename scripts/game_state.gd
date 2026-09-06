extends Node

signal relationship_changed(character: String, trust: int, tension: int, romance: int)
signal item_added(item_id: String)
signal flag_changed(flag: String, value: Variant)

var inventory: Array[String] = []
var flags: Dictionary = {}

var relationships := {
	"kengan": {"trust": 0, "tension": 0, "romance": 0, "route_open": true},
	"saturnino": {"trust": 100, "tension": 0, "romance": 0, "route_open": false}
}

func add_item(item_id: String) -> void:
	if item_id in inventory:
		return
	inventory.append(item_id)
	item_added.emit(item_id)

func has_item(item_id: String) -> bool:
	return item_id in inventory

func set_flag(flag: String, value: Variant = true) -> void:
	flags[flag] = value
	flag_changed.emit(flag, value)

func get_flag(flag: String, default_value: Variant = false) -> Variant:
	return flags.get(flag, default_value)

func change_relationship(character: String, trust_delta := 0, tension_delta := 0, romance_delta := 0) -> void:
	if not relationships.has(character):
		return
	var rel: Dictionary = relationships[character]
	rel["trust"] = clampi(int(rel["trust"]) + trust_delta, -100, 100)
	rel["tension"] = clampi(int(rel["tension"]) + tension_delta, -100, 100)
	rel["romance"] = clampi(int(rel["romance"]) + romance_delta, -100, 100)
	relationships[character] = rel
	relationship_changed.emit(character, rel["trust"], rel["tension"], rel["romance"])

func relationship(character: String) -> Dictionary:
	return relationships.get(character, {}).duplicate(true)

func kengan_romance_stage() -> String:
	var rel: Dictionary = relationships["kengan"]
	var trust := int(rel["trust"])
	var romance := int(rel["romance"])
	var tension := int(rel["tension"])
	if romance >= 70 and trust >= 55:
		return "committed"
	if romance >= 40 and trust >= 30:
		return "mutual"
	if tension >= 25 or romance >= 20:
		return "charged"
	if trust >= 15:
		return "close"
	return "guarded"
