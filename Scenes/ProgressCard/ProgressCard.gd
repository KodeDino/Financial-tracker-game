extends NinePatchRect

@onready var percent_label: Label = $PercentLabel
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	percent_label.text = str(texture_progress_bar.value) + '%'
