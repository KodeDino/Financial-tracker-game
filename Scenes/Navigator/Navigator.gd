extends Control

@onready var dashboard_button: TextureButton = $HBoxContainer/DashboardButton
@onready var tracker_button: TextureButton = $HBoxContainer/TrackerButton
@onready var history_button: TextureButton = $HBoxContainer/HistoryButton
@onready var instruction_button: TextureButton = $HBoxContainer/InstructionButton


var DASHBOARD = load("uid://g6s6plaeu4e")
var HISTORY = load("uid://ca4wy1cuat0tg")
var INSTRUCTION = load("uid://8im65jqwxdqf")
var TRACKER = load("uid://by278ayxqjxf5")

const HOVER_FRAME_DURATION := 0.15
var _spritesheet: Texture2D = preload("res://Assets/Sprites/FT_sprites_6x.png")
# Stores per-button animation state: {frames: Array[AtlasTexture], timer: Timer, index: int}
var _hover_data := {}


func _ready() -> void:
	_setup_hover(dashboard_button, [
		Rect2(6, 414, 120, 120),
		Rect2(6, 666, 120, 120),
		Rect2(6, 792, 120, 120),
		Rect2(6, 918, 120, 120),
		Rect2(6, 1044, 120, 120),
		Rect2(6, 1170, 120, 120),
		Rect2(6, 1296, 120, 120),
	])
	_setup_hover(tracker_button, [
		Rect2(132, 414, 120, 120),
		Rect2(132, 666, 120, 120),
		Rect2(132, 792, 120, 120),
		Rect2(132, 918, 120, 120),
		Rect2(132, 1044, 120, 120),
		Rect2(132, 1170, 120, 120),
		Rect2(132, 1296, 120, 120),
	])
	_setup_hover(history_button, [
		Rect2(258, 414, 120, 120),
		Rect2(258, 666, 120, 120),
		Rect2(258, 792, 120, 120),
		Rect2(258, 918, 120, 120),
		Rect2(258, 1044, 120, 120),
		Rect2(258, 1170, 120, 120),
		Rect2(258, 1296, 120, 120),
	])
	_setup_hover(instruction_button, [
		Rect2(384, 414, 120, 120),
		Rect2(384, 666, 120, 120),
		Rect2(384, 792, 120, 120),
		Rect2(384, 918, 120, 120),
		Rect2(384, 1044, 120, 120),
		Rect2(384, 1170, 120, 120),
		Rect2(384, 1296, 120, 120),
	])


## Creates AtlasTexture frames from the spritesheet regions, wires up
## mouse_entered / mouse_exited signals, and adds a Timer to cycle frames.
func _setup_hover(button: TextureButton, regions: Array) -> void:
	var frames: Array[AtlasTexture] = []
	for region in regions:
		var tex := AtlasTexture.new()
		tex.atlas = _spritesheet
		tex.region = region
		frames.append(tex)

	var timer := Timer.new()
	timer.wait_time = HOVER_FRAME_DURATION
	add_child(timer)

	_hover_data[button] = {"frames": frames, "timer": timer, "index": 0}

	button.texture_hover = frames[0]
	button.mouse_entered.connect(_on_hover_start.bind(button))
	button.mouse_exited.connect(_on_hover_end.bind(button))
	timer.timeout.connect(_on_hover_tick.bind(button))


func _on_hover_start(button: TextureButton) -> void:
	var data: Dictionary = _hover_data[button]
	data["index"] = 0
	button.texture_hover = data["frames"][0]
	data["timer"].start()


func _on_hover_end(button: TextureButton) -> void:
	var data: Dictionary = _hover_data[button]
	data["timer"].stop()
	data["index"] = 0
	button.texture_hover = data["frames"][0]


func _on_hover_tick(button: TextureButton) -> void:
	var data: Dictionary = _hover_data[button]
	data["index"] = (data["index"] + 1) % data["frames"].size()
	button.texture_hover = data["frames"][data["index"]]


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
