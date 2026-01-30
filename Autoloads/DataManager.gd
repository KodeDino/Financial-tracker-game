extends Node

const SAVE_FILE_PATH = "user://investments.json"

func save_investments(investments: Array[Investment]) -> void:
	# 1. Convert investments array to array of dictionaries
	var dict_array: Array[Dictionary] = []
	for investment in investments:
		dict_array.append(investment.to_dict())
	# 2. Open file for writing
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		print("Error opening save file: ", FileAccess.get_open_error())
		return
	# 3. Convert to JSON string and write
	var json_string = JSON.stringify(dict_array, "\t")  # "\t" for pretty print
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
	var data_array = json.data
	# 5. Convert array of dictionaries back to Investment objects
	var investments: Array[Investment] = []
	for data in data_array:
		investments.append(Investment.from_dict(data))
		
	return investments
