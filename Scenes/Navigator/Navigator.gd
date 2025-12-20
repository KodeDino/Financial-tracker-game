extends Control

var DASHBOARD = load("uid://g6s6plaeu4e")
var HISTORY = load("uid://ca4wy1cuat0tg")
var INSTRUCTION = load("uid://8im65jqwxdqf")
var TRACKER = load("uid://by278ayxqjxf5")


func _on_dashboard_button_pressed() -> void:
	go_to_scene(DASHBOARD)


func _on_tracker_button_pressed() -> void:
	go_to_scene(TRACKER)


func _on_history_button_pressed() -> void:
	go_to_scene(HISTORY)


func _on_instruction_button_pressed() -> void:
	go_to_scene(INSTRUCTION)


func go_to_scene(next_scene: PackedScene) -> void:
	get_tree().call_deferred("change_scene_to_packed", next_scene)
