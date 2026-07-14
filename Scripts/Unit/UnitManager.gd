extends Node
# Global script.


#@ Constants
const UNIT_REF: PackedScene = preload("res://Scenes/Unit/Unit.tscn")


#@ Public Variables
var units: Array[UnitData]
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
## Returns a Clerk unit associated with a designated_room, or null if the designated_room is full.
# (!?) FIXME - TODO: This function should ONLY spawn a clerk from an Array of UnitData.
# 	Whereas "spawning" a NEW clerk should add to the Array. This is really just "add".
func spawn_clerk(designated_room: InteriorRoom) -> Unit:
	# Check to see if we should spawn a clerk unit.
	var clerks_in_room: Array[UnitData]
	var number_of_clerks_in_room: int = designated_room.clerks.size()
	for unit_data in units:
		if !(unit_data is AgentData) and (unit_data._designated_room == designated_room):
			clerks_in_room.append(unit_data)
	var fail_condition: bool = (clerks_in_room.size() >= designated_room.MAX_CLERKS) or (number_of_clerks_in_room >= designated_room.MAX_CLERKS)
	if fail_condition:
		return null
	
	# Create a clerk unit.
	if !units:
		units = []
	var new_clerk_data: UnitData = UnitData.new()
	var new_clerk: Unit = UNIT_REF.instantiate()
	new_clerk.name = "Clerk" + str(number_of_clerks_in_room + 1)
	new_clerk_data.unit_name = ["John Doe", "Jane Doe", "Doephus", "John Smith"].pick_random()  # TODO: Make random names more elaborate.
	new_clerk_data._designated_room = designated_room
	
	
	# Keep a non-object reference.
	new_clerk.unit_data = new_clerk_data
	units.append(new_clerk_data)
	
	return new_clerk


## Returns a Agent unit associated with a designated_room, or null if the designated_room is full.
func spawn_agent(designated_room: InteriorRoom) -> Unit:
	# Check to see if we should spawn an agent unit.
	var agents_in_room: Array[UnitData]
	var number_of_agents_in_room: int = designated_room.agents.size()
	for unit_data in units:
		if (unit_data is AgentData) and (unit_data._designated_room == designated_room):
			agents_in_room.append(unit_data)
	var fail_condition: bool = (agents_in_room.size() >= designated_room.MAX_AGENTS) or (number_of_agents_in_room >= designated_room.MAX_AGENTS)
	if fail_condition:
		return null
	
	# Create an agent unit.
	if !units:
		units = []
	var new_agent_data: AgentData = AgentData.new()
	var new_agent: Unit = UNIT_REF.instantiate()
	new_agent.name = "Agent" + str(number_of_agents_in_room + 1)
	new_agent.modulate = Color.html("#646464")
	new_agent_data._designated_room = designated_room
	
	# Keep a non-object reference.
	new_agent.unit_data = new_agent_data
	units.append(new_agent_data)
	
	return new_agent


func save_data() -> void:
	return


func load_data(dict) -> void:
	return
