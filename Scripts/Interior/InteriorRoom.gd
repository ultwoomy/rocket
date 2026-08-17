extends Control
class_name InteriorRoom


#@ Constants
const PIXEL_SIZE_DIFFERENCE: float = 60  #  The size of an interior room is 60 pixels smaller for both x & y than the size of a module.
const TOP_MIDDLE_SIDE: Vector2 = Vector2(180.0, 0.0)
const BOTTOM_MIDDLE_SIDE: Vector2 = Vector2(180.0, 300.0)
const LEFT_MIDDLE_SIDE: Vector2 = Vector2(0.0, 150.0)
const RIGHT_MIDDLE_SIDE: Vector2 = Vector2(360.0, 150.0)


#@ Public Variables
var interior_room_data: InteriorRoomData
var occupying_units: Array[Unit] = []


#@ Onready Variables
@onready var room_panel: Panel = $RoomPanel


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	respawn_units()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
## Removes any units that are already in the room and spawns new units using interior_room_data.
func respawn_units() -> void:
	if !interior_room_data:
		printerr("ERROR: No data given to interior room!")
		return
	
	# Remove any previous units.
	if occupying_units:
		for unit in occupying_units:
			unit.queue_free()
	occupying_units = []
	
	# Spawn in new units.
	const UNIT_REFERENCE: PackedScene = preload("res://Scenes/Unit/Unit.tscn")
	for clerk_data in interior_room_data.clerks:
		var clerk: Unit = UnitManager.get_clerk(clerk_data)
		occupying_units.append(clerk)
		self.add_child(clerk)
	for agent_data in interior_room_data.agents:
		var agent: Unit = UnitManager.get_agent(agent_data)
		occupying_units.append(agent)
		self.add_child(agent)
