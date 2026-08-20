extends Node
# Global script.


#@ Signals


#@ Constants
const UNIT_REF: PackedScene = preload("res://Scenes/Unit/Unit.tscn")  # NOTE: Originally was supposed to be for both Clerk/Agent, and then changed dynamically during runtime to match.


#@ Public Variables
var active_units: Array[UnitData]
	# ALERT: BUG - EVERYTIME THE SCENE CHANGES FROM main.gd, THE UNITS ARE DELETED.
	# 	THESE UNITS SHOULD BE KEPT IN THE ARRAY.
	# 	BUT BECAUSE THESE UNITS ARE NODES/OBJECTS, THEY ARE DELETED WHEN SCENE CHANGES.
	# 	THUS, THE UNITS ARE REMOVED FROM THE ARRAY.
	# 	THIS ALSO RESULTS IN THE ARRAY EXPANDING EVERYTIME SCENE CHANGES.


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Make this savable.
	#add_to_group("Savables")
	
	print("UnitManager is running!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
## Returns UnitData of the newly added unit, or null if it was not added.
## The new unit must be given a room to spawn in and to be kept track of.
func add_new_clerk(current_room_data: InteriorRoomData) -> UnitData:
	var new_clerk: UnitData = UnitData.new()
	
	# Check if room is already full.
	var has_available_space: bool = current_room_data.clerks.size() < current_room_data.MAX_CLERKS
	if !has_available_space:
		print("UNABLE TO ADD NEW CLERK: No available space!")  # TODO(?): Actually have a way for the Player to know. Not sure if needed here.
		return null
	
	# Double check using the units array.
	var clerks_in_current_room: int = 0
	for unit_data in active_units:
		if !(unit_data is AgentData) and (unit_data.current_room == current_room_data):
			clerks_in_current_room += 1
	if clerks_in_current_room >= current_room_data.MAX_CLERKS:
		print("UNABLE TO ADD NEW CLERK: No available space!")
		return null
	
	# TODO: Name
	
	
	return new_clerk


## Returns UnitData of the newly added unit, or null if it was not added.
## The new unit must be given a room to spawn in and to be kept track of.
func add_new_agent(current_room_data: InteriorRoomData) -> AgentData:
	var new_agent: AgentData = AgentData.new()
	
	# Check if room is already full.
	var has_available_space: bool = current_room_data.agents.size() < current_room_data.MAX_AGENTS
	if !has_available_space:
		print("UNABLE TO ADD NEW AGENT: No available space!")  # TODO(?): Actually have a way for the Player to know. Not sure if needed here.
		return null
	
	# Double check using the units array.
	var agents_in_current_room: int = 0
	for unit_data in active_units:
		if (unit_data is AgentData) and (unit_data.current_room == current_room_data):
			agents_in_current_room += 1
	if agents_in_current_room >= current_room_data.MAX_AGENTS:
		print("UNABLE TO ADD NEW CLERK: No available space!")
		return null
	
	# TODO: Name
	
	
	return new_agent


## Returns a Clerk unit instance using the given UnitData, or null if there was an error.
## Normally, you would want to get the unit_data from an InteriorRoomData.
func get_clerk_unit(unit_data: UnitData) -> Unit:
	if !unit_data:
		print("UNABLE TO SPAWN NEW CLERK: Invalid unit data!")
		return null
	
	# Create a unit instance to be used for a clerk.
	var new_clerk_unit: Unit = UNIT_REF.instantiate()
	new_clerk_unit.unit_data = unit_data
	new_clerk_unit.name = "Clerk"  # NOTICE: If multiple clerks are created in a scene, the script calling this method should handle naming.
	
	# Modify unit_data properties.
	unit_data.unit_name = ["John Doe", "Jane Doe", "Doephus", "John Smith"].pick_random()  # TODO: Make random names more elaborate.
	
	
	return new_clerk_unit


## Returns a Clerk unit instance using the given AgentData, or null if there was an error.
## Normally, you would want to get the unit_data from an InteriorRoomData.
func get_agent_unit(agent_data: AgentData) -> Unit:
	if !agent_data:
		print("UNABLE TO SPAWN NEW AGENT: Invalid unit data!")
		return null
	
	# Create a unit instance to be used for an agent.
	var new_agent_unit: Unit = UNIT_REF.instantiate()
	new_agent_unit.unit_data = agent_data
	new_agent_unit.name = "Agent"  # NOTICE: If multiple clerks are created in a scene, the script calling this method should handle naming.
	new_agent_unit.modulate = Color.html("#646464")
	
	# Modify unit_data properties.
	agent_data.unit_name = "<AGENT NAME HERE>"
	
	
	return new_agent_unit


func save_data() -> void:
	return


func load_data(dict) -> void:
	return
