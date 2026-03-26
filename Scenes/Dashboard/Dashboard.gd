extends Control

@onready var goal_popup: Control = $GoalPopup
@onready var progress_card: NinePatchRect = $ProgressCard
@onready var tpv: NinePatchRect = $TPV
@onready var tpc: NinePatchRect = $TPC
@onready var tie: NinePatchRect = $TIE
@onready var progress_bar: ProgressBar = $ExpContainer/ProgressBar
@onready var left_lvl: Label = $ExpContainer/LeftLvl
@onready var right_lvl: Label = $ExpContainer/RightLvl
@onready var exp_label: Label = $ExpContainer/ExpLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var investments = DataManager.load_investments()
	var stats = InvestmentStats.calculate(investments)
	tpv.set_value(stats["tpv"])
	tpc.set_value(stats["tpc"])
	tie.set_value(stats["tie"])
	_setup_exp_labels()

	

func _on_progress_card_on_create_goal_pressed() -> void:
	goal_popup.show()


func _on_goal_popup_goal_created() -> void:
	progress_card.refresh()


func _setup_exp_labels() -> void:
	var total_exp = DataManager.load_exp()
	var progress = ExpSystem.get_progress(total_exp)
	left_lvl.text = "lvl. " + str(progress["current_level"])
	right_lvl.text = "lvl. " + str(progress["current_level"] + 1)
	exp_label.text = str(progress["exp_into_level"]) + "/" + str(progress["exp_needed"])
	progress_bar.max_value = progress["exp_needed"]
	progress_bar.value = progress["exp_into_level"]
