extends Node

func _ready() -> void:
	var dir = DirAccess.open("user://")
	#dir.remove("savegame.save")  # ALERT: Testing purposes only!
	load_game()

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var fuel_exists : bool = false
	var mod_exists : bool = false
	var ohzero_exists : bool = false
	var basedata_exists : bool = false
	if not FileAccess.file_exists("user://savegame.save"):
		var empt : Dictionary
		if not fuel_exists:
			FuelManager.load_data(empt)
		if not mod_exists:
			ModuleManager.load_data(empt)
		if not ohzero_exists:
			OhzeroData.load_data(empt)
		if not basedata_exists:
			BaseData.load_data(empt)
		return

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		if(node_data["name"] == "FuelManager"):
			FuelManager.load_data(node_data)
			fuel_exists = true
		if(node_data["name"] == "ModuleManager"):
			ModuleManager.load_data(node_data)
			mod_exists = true
		if(node_data["name"] == "OhzeroData"):
			OhzeroData.load_data(node_data)
			ohzero_exists = true
		if(node_data["name"] == "BaseData"):
			BaseData.load_data(node_data)
			basedata_exists = true
	var empt : Dictionary
	if not fuel_exists:
		FuelManager.load_data(empt)
	if not mod_exists:
		ModuleManager.load_data(empt)
	if not ohzero_exists:
		OhzeroData.load_data(empt)
	if not basedata_exists:
		BaseData.load_data(empt)

	
# Note: This can be called from anywhere inside the tree. This function is
# path independent.
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Savables")
	for node in save_nodes:

		# Check the node has a save function.
		if !node.has_method("save_data"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save_data")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
