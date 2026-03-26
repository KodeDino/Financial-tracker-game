class_name ExpSystem

static func get_threshold(level: int) -> int:
	return 100 + (level - 1) * 150

static func get_level_from_exp(total_exp: int) -> int:
	var level = 1
	var cumulative = 0
	while cumulative < total_exp:
		cumulative += get_threshold(level)
		if total_exp < cumulative:
			return level
		level += 1
	return level

static func get_progress(total_exp: int) -> Dictionary:
	var current_level = get_level_from_exp(total_exp)
	var threshold = get_threshold(current_level)
	var cumulative_at_start = 0
	for i in range(1, current_level):
		cumulative_at_start += get_threshold(i)
	return {
		"current_level": current_level,
		"exp_into_level": total_exp - cumulative_at_start,
		"exp_needed": threshold
	}
