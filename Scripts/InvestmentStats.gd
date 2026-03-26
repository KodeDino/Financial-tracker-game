class_name InvestmentStats

static func calculate(investments: Array[Investment]) -> Dictionary:
	var total_principal := 0.0
	var total_interest := 0.0
	var total_value := 0.0
	var upcoming: Array[Investment] = []

	for inv in investments:
		total_principal += inv.get_fresh_principal()
		if inv.get_status():  # active
			total_value += inv.amount
			upcoming.append(inv)
		else:  # matured
			total_interest += inv.get_interest_earned()
			total_value += inv.get_matured_value()

	upcoming.sort_custom(func(a, b): return a.get_end_date() < b.get_end_date())

	return {
		"tpv": total_value,
		"tpc": total_principal,
		"tie": total_interest,
		"upcoming": upcoming
	}

static func calculate_goal_progress(investments: Array[Investment], target_amount: float) -> float:
	if target_amount <= 0.0:
		return 0.0
	var total_value := 0.0
	for inv in investments:
		if inv.get_status():
			total_value += inv.amount
		else:
			total_value += inv.get_matured_value()
	return minf((total_value / target_amount) * 100.0, 100.0)
