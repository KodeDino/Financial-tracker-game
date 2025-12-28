extends NinePatchRect

const CARD_INACTIVE = preload("uid://8p36o5buxeaw")
const CARD_ACTIVE = preload("uid://dne8c8kj7rawq")

@export var isActive: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if isActive:
		texture = CARD_ACTIVE
	else:
		texture = CARD_INACTIVE
