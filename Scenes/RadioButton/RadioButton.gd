extends Control

signal type_changed(type: String)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cd_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		type_changed.emit('cd')


func _on_tbill_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		type_changed.emit('tbill')
