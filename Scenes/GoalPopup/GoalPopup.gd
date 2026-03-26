extends Control

signal goal_created

@onready var cancel_button: TextureButton = $NinePatchRect/CancelButton
@onready var input_field: Control = $NinePatchRect/MarginContainer/VBoxContainer/InputField/LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_cancel_button_pressed() -> void:
	hide()


func _on_submit_button_pressed() -> void:
	DataManager.save_current_goal(float(input_field.text))
	goal_created.emit()
	hide()
	input_field.text = ""
