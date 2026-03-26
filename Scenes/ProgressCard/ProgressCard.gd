extends NinePatchRect

signal on_create_goal_pressed

@onready var percent_label: Label = $PercentLabel
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var add_button: TextureButton = $AddButton
@onready var cancel_button: TextureButton = $CancelButton
@onready var goal_label: Label = $GoalLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	percent_label.text = str(texture_progress_bar.value) + '%'
	var current_goal = DataManager.load_current_goal()
	_setup_goal_label(current_goal)
	_button_switch(current_goal)


func _on_add_button_pressed() -> void:
	on_create_goal_pressed.emit()


func _setup_goal_label(current_goal: Variant) -> void:
	_load_progress(current_goal)
	if current_goal != null:
		goal_label.text = "Goal: " + str(current_goal)
	else:
		goal_label.text = "No current goal"


func refresh() -> void:
	var current_goal = DataManager.load_current_goal()
	_setup_goal_label(current_goal)
	_button_switch(current_goal)
		
func _load_progress(current_goal: Variant) -> void:
	var investments = DataManager.load_investments()
	var progress = 0.0
	if current_goal != null:
		progress = InvestmentStats.calculate_goal_progress(investments, current_goal)
	texture_progress_bar.value = progress
	percent_label.text = str(snapped(progress, 0.01)) + "%"
		
	
func _button_switch(current_goal: Variant) -> void:	
	if current_goal != null:
		cancel_button.show()
		add_button.hide()
	else:
		cancel_button.hide()
		add_button.show()


func _on_cancel_button_pressed() -> void:
	DataManager.save_current_goal(null)
	refresh()
