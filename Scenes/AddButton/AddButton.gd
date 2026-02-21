extends TextureButton

const HOVER_FRAME_DURATION := 0.15
var _spritesheet: Texture2D = preload("res://Assets/Sprites/FT_sprites_6x.png")
var _hover_frames: Array[AtlasTexture] = []
var _hover_timer: Timer
var _hover_index: int = 0


func _ready() -> void:
	_setup_hover([
		Rect2(312, 102, 54, 54),
		Rect2(372, 102, 54, 54),
		Rect2(432, 102, 54, 54),
		Rect2(312, 162, 54, 54),
		Rect2(372, 162, 54, 54),
		Rect2(432, 162, 54, 54),
		Rect2(312, 222, 54, 54),
		Rect2(372, 222, 54, 54),
	])


func _setup_hover(regions: Array) -> void:
	for region in regions:
		var tex := AtlasTexture.new()
		tex.atlas = _spritesheet
		tex.region = region
		_hover_frames.append(tex)

	_hover_timer = Timer.new()
	_hover_timer.wait_time = HOVER_FRAME_DURATION
	add_child(_hover_timer)

	texture_hover = _hover_frames[0]
	mouse_entered.connect(_on_hover_start)
	mouse_exited.connect(_on_hover_end)
	_hover_timer.timeout.connect(_on_hover_tick)


func _on_hover_start() -> void:
	_hover_index = 0
	texture_hover = _hover_frames[0]
	_hover_timer.start()


func _on_hover_end() -> void:
	_hover_timer.stop()
	_hover_index = 0
	texture_hover = _hover_frames[0]


func _on_hover_tick() -> void:
	_hover_index = (_hover_index + 1) % _hover_frames.size()
	texture_hover = _hover_frames[_hover_index]
