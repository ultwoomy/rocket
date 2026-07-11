extends Control
class_name InteriorRoom


#@ Constants
const PIXEL_SIZE_DIFFERENCE: float = 60  #  The size of an interior room is 60 pixels smaller for both x & y than the size of a module.
const TOP_MIDDLE_SIDE: Vector2 = Vector2(180.0, 0.0)
const BOTTOM_MIDDLE_SIDE: Vector2 = Vector2(180.0, 300.0)
const LEFT_MIDDLE_SIDE: Vector2 = Vector2(0.0, 150.0)
const RIGHT_MIDDLE_SIDE: Vector2 = Vector2(360.0, 150.0)

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
	##### ALERT: Testing purposes only!
	const NUMBER_OF_UNIT_SPAWNS: int = 4
	for num in range(NUMBER_OF_UNIT_SPAWNS):
		var new_clerk: ClerkUnit = UnitManager.spawn_clerk(self)
		if new_clerk:
			if !clerks:
				clerks = []
			room_panel.add_child(new_clerk)
			new_clerk.position = Vector2(randf_range(0, room_panel.size.x), randf_range(0, room_panel.size.y))
			clerks.append(new_clerk)

	for num in range(NUMBER_OF_UNIT_SPAWNS):
		var new_agent: AgentUnit = UnitManager.spawn_agent(self)
		if new_agent:
			if !agents:
				agents = []
			room_panel.add_child(new_agent)
			new_agent.position = Vector2(randf_range(0, room_panel.size.x), randf_range(0, room_panel.size.y))
			agents.append(new_agent)
	#####
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Private Methods
