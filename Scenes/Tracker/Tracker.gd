extends Control


@onready var v_box_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer
@onready var popup: Control = $Popup

const INVESTMENT_CARD = preload("uid://bmhpiel1ax4rp")

func _ready() -> void:
	popup.investment_submitted.connect(_on_investment_submitted)
	var saved_investments: Array[Investment] = DataManager.load_investments()
	for investment in saved_investments:
		v_box_container.add_child(_create_card(investment))
	_sort_cards()

func _create_card(investment: Investment) -> InvestmentCard:
	var card: InvestmentCard = INVESTMENT_CARD.instantiate()
	card.start_date = investment.start_date
	card.end_date = investment.get_end_date()
	card.type = investment.type
	card.rate = investment.rate
	card.amount = investment.amount
	card.actual_value = investment.actual_cost
	card.interest_earned = investment.get_interest_earned()
	card.matured_value = investment.get_matured_value()
	card.is_active = investment.get_status()
	card.id = investment.id
	card.remove_requested.connect(_on_remove_requested)
	return card

func _sort_cards() -> void:
	var cards = v_box_container.get_children()
	cards.sort_custom(func(a, b): return a.start_date > b.start_date)
	for i in cards.size():
		v_box_container.move_child(cards[i], i)

func _on_investment_submitted(investment: Investment) -> void:
	v_box_container.add_child(_create_card(investment))
	_sort_cards()
	var current_exp = DataManager.load_exp()
	DataManager.save_exp(current_exp + 50)	
	var current_goal = DataManager.load_current_goal()
	if current_goal == null:
		return
	var all_investments = DataManager.load_investments()
	var all_goals = DataManager.load_goals()
	var progress = InvestmentStats.calculate_goal_progress(all_investments, current_goal)
	if progress >= 100:
		var goal = Goal.new()
		goal.id = str(all_goals.size() + 1)
		goal.target_amount = current_goal
		goal.completed_date = Time.get_date_string_from_system(false)
		all_goals.append(goal)
		DataManager.save_goals(all_goals)
		DataManager.save_current_goal(null)
		DataManager.save_exp(current_exp + 250)

func _on_remove_requested(id: String, is_active: bool) -> void:
	if is_active:
		var investments = DataManager.load_investments()
		investments = investments.filter(func(inv): return inv.id != id)
		DataManager.save_investments(investments)

	for card in v_box_container.get_children():
		if card.id == id:
			card.queue_free()
			break

func _on_add_button_pressed() -> void:
	popup.show()
