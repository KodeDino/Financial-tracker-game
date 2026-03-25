extends Node

const SAVE_FILE_PATH = "user://investments.json"

func save_investments(investments: Array[Investment]) -> void:
	var loaded_goals = load_goals()
	var goals_array: Array[Dictionary] = []
	for goal in loaded_goals:
		goals_array.append(goal.to_dict())
	# 1. Convert investments array to array of dictionaries
	var dict_array: Array[Dictionary] = []
	for investment in investments:
		dict_array.append(investment.to_dict())
	var dict = { "investments": dict_array, "goals": goals_array }
	# 2. Open file for writing
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		print("Error opening save file: ", FileAccess.get_open_error())
		return
	# 3. Convert to JSON string and write
	var json_string = JSON.stringify(dict, "\t")  # "\t" for pretty print
	file.store_string(json_string)
	file.close()
	

func load_investments() -> Array[Investment]:
	# 1. Check if file exists
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("No such file")
		return []
	# 2. Open file for reading
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		print('Error opening save file: ', FileAccess.get_open_error())
		return []
	# 3. Read JSON string
	var json_string = file.get_as_text()
	file.close()
	# 4. Parse JSON to Array
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("Error parsing JSON: ", json.get_error_message())
		return []
	var data_array = json.data["investments"]
	# 5. Convert array of dictionaries back to Investment objects
	var investments: Array[Investment] = []
	for data in data_array:
		investments.append(Investment.from_dict(data))
		
	return investments


func save_goals(goals: Array[Goal]) -> void:
	var loaded_investments = load_investments()
	var investments_array: Array[Dictionary] = []
	for investment in loaded_investments:
		investments_array.append(investment.to_dict())
	var dict_array: Array[Dictionary] = []
	for goal in goals:
		dict_array.append(goal.to_dict())
	var dict = { "investments": investments_array, "goals": dict_array }
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		print("Error opening save file: ", FileAccess.get_open_error())
		return
	var json_string = JSON.stringify(dict, "\t")  # "\t" for pretty print
	file.store_string(json_string)
	file.close()
	

func load_goals() -> Array[Goal]:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("No such file")
		return []
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		print('Error opening save file: ', FileAccess.get_open_error())
		return []
	var json_string = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("Error parsing JSON: ", json.get_error_message())
		return []
	var data_array = json.data["goals"]
	var goals: Array[Goal] = []
	for data in data_array:
		goals.append(Goal.from_dict(data))
		
	return goals
