extends Control
class_name InteriorRoom


#@ Constants
const PIXEL_SIZE_DIFFERENCE: float = 60  #  The size of an interior room is 60 pixels smaller for both x & y than the size of a module.
const TOP_MIDDLE_SIDE: Vector2 = Vector2(180.0, 0.0)
const BOTTOM_MIDDLE_SIDE: Vector2 = Vector2(180.0, 300.0)
const LEFT_MIDDLE_SIDE: Vector2 = Vector2(0.0, 150.0)
const RIGHT_MIDDLE_SIDE: Vector2 = Vector2(360.0, 150.0)

const CLERK_REF: PackedScene = preload("res://Scenes/Unit/Clerk.tscn")
const AGENT_REF: PackedScene = preload("res://Scenes/Unit/Agent.tscn")
const MAX_CLERKS: int = 3
const MAX_AGENTS: int = 1


#@ Public Variables
var clerks: Array[ClerkUnit]
var agents: Array[AgentUnit]


#@ Onready Variables
@onready var room_panel: Panel = $RoomPanel


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# ALERT: Testing purposes only!
	spawn_clerk()
	spawn_clerk()
	spawn_clerk()
	spawn_clerk()
	
	spawn_agent()
	spawn_agent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Private Methods
# NOTICE: Doesn't make sense for this function to be in this script, should move it somewhere more suitable when able.
func spawn_clerk() -> void:
	if !clerks:
		clerks = []
	
	var number_of_clerks: int = clerks.size()
	if number_of_clerks < MAX_CLERKS:
		var new_clerk: ClerkUnit = CLERK_REF.instantiate()
		new_clerk.name = "Clerk" + str(number_of_clerks + 1)
		new_clerk.unit_name = ["John Doe", "Jane Doe", "Doephus", "John Smith"].pick_random()  # TODO: Make random names more elaborate.
		room_panel.add_child(new_clerk)
		new_clerk.position = Vector2(randf_range(0, room_panel.size.x), randf_range(0, room_panel.size.y))
		clerks.append(new_clerk)
		UnitManager.units.append(new_clerk)


func spawn_agent() -> void:
	if !agents:
		agents = []
	
	var number_of_agents: int = agents.size()
	if number_of_agents < MAX_AGENTS:
		var new_agent: AgentUnit = AGENT_REF.instantiate()
		new_agent.name = "Agent" + str(number_of_agents + 1)
		room_panel.add_child(new_agent)
		new_agent.position = Vector2(randf_range(0, room_panel.size.x), randf_range(0, room_panel.size.y))
		agents.append(new_agent)
		UnitManager.units.append(new_agent)
