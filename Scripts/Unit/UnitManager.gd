extends Node
# Global script.


#@ Constants
const CLERK_REF: PackedScene = preload("res://Scenes/Unit/Clerk.tscn")
const AGENT_REF: PackedScene = preload("res://Scenes/Unit/Agent.tscn")


#@ Public Variables
var units: Array[Unit] = []  # All of the units the Player owns.
	# ALERT: BUG - EVERYTIME THE SCENE MOVES TO main.gd, UNITS ARE CREATED.
	# 	THESE UNITS ARE THEN MOVED INTO THIS ARRAY, AND THE PREVIOUS ONES ARE DELETED.
	# 	THIS RESULTS IN THE ARRAY EXPANDING EVERYTIME SCENE CHANGES.


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
func spawn_clerk(designated_room: InteriorRoom) -> ClerkUnit:
	if !designated_room.clerks:
		designated_room.clerks = []
	
	var number_of_clerks_in_room: int = designated_room.clerks.size()
	if number_of_clerks_in_room < designated_room.MAX_CLERKS:
		var new_clerk: ClerkUnit = CLERK_REF.instantiate()
		new_clerk.name = "Clerk" + str(number_of_clerks_in_room + 1)
		new_clerk.unit_name = ["John Doe", "Jane Doe", "Doephus", "John Smith"].pick_random()  # TODO: Make random names more elaborate.
		new_clerk._designated_room = designated_room
		units.append(new_clerk)
		return new_clerk
	return null


## Returns a Agent unit associated with a designated_room, or null if the designated_room is full.
func spawn_agent(designated_room: InteriorRoom) -> AgentUnit:
	if !designated_room.agents:
		designated_room.agents = []
	
	var number_of_agents_in_room: int = designated_room.agents.size()
	if number_of_agents_in_room < designated_room.MAX_AGENTS:
		var new_agent: AgentUnit = AGENT_REF.instantiate()
		new_agent.name = "Agent" + str(number_of_agents_in_room + 1)
		new_agent._designated_room = designated_room
		units.append(new_agent)
		return new_agent
	return null


func save_data() -> void:
	return


func load_data(dict) -> void:
	return
