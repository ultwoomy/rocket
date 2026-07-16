extends Node
# Global script.


#@ Constants
const INTERIOR_ROOM_REF: PackedScene = preload("res://Scenes/Interior/InteriorRoom.tscn")


#@ Public Variables
var interior_layout: Array[InteriorRoomData]  # Keeps track of the entire interior.
# TODO: Append to interior_layout when an interior room is unlocked.


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Make this savable.
	#add_to_group("Savables")
	
	print("InteriorRoomManager is running!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
func add_room() -> void:
	if !interior_layout:
		interior_layout = []
	
	var new_room_data: InteriorRoomData = InteriorRoomData.new()
	interior_layout.append(new_room_data)


## Returns InteriorRooms made from the InteriorRoomData elements in interior_layout.
func create_interior_rooms() -> Array[InteriorRoom]:
	# The number of interior rooms should match the modules unlocked on the exterior.
	var modules_and_room_difference: int = ModuleManager.active_modules.size() - InteriorRoomManager.interior_layout.size()
	for index in range(modules_and_room_difference):
		self.add_room()
	
	var interior_rooms: Array[InteriorRoom] = []
	for interior_room_data in interior_layout:
		var interior_room: InteriorRoom = INTERIOR_ROOM_REF.instantiate()
		interior_room.interior_room_data = interior_room_data
		
		var interior_room_clerks: Array[Unit] = _create_clerks_in_interior_room(interior_room_data, interior_room)
		var interior_room_agents: Array[Unit] = _create_agents_in_interior_room(interior_room_data, interior_room)
		for clerks in interior_room_clerks:
			interior_room.add_child(clerks)
		for agents in interior_room_agents:
			interior_room.add_child(agents)
		
		interior_rooms.append(interior_room)
	return interior_rooms


func save_data() -> void:
	return


func load_data(dict) -> void:
	return


#@ Private Methods
func _create_clerks_in_interior_room(interior_room_data: InteriorRoomData, interior_room: InteriorRoom) -> Array[Unit]:
	var clerks: Array[Unit] = []
	if interior_room_data.clerks:
		for clerk_data in interior_room_data.clerks:
			var clerk: Unit = UnitManager.spawn_clerk(interior_room)  # FIXME - TODO: Function should instead just handle spawning a Unit and assigning the proper Unit type!
			clerks.append(clerk)
	else:
		interior_room_data.clerks = []
	return clerks


func _create_agents_in_interior_room(interior_room_data: InteriorRoomData, interior_room: InteriorRoom) -> Array[Unit]:
	var agents: Array[Unit] = []
	if interior_room_data.agents:
		for agent_data in interior_room_data.agents:
			var agent: Unit = UnitManager.spawn_agent(interior_room)  # FIXME - TODO: Function should instead just handle spawning a Unit and assigning the proper Unit type!
			agents.append(agent)
	else:
		interior_room_data.agents = []
	return agents
