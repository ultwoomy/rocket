extends Control
class_name InteriorContainer


#@ Signals
signal spawned_interior


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Figure out what to do with this variable. Is this the best thing to do with this variable?
	
	" TESTING: ADDING A NEW UNIT DATA, SO IT CAN BE SPAWNED BY ANOTHER SCRIPT - DELETE LATER WHEN ABLE TO ADD UNITS TO ROOMS"
	#var interior_rooms: Array[InteriorRoom] = self.spawn_interior_rooms()
	#interior_rooms[0].interior_room_data.clerks.append(UnitManager.add_new_clerk(interior_rooms[0].interior_room_data))
	#var new_clerk_data: UnitData = UnitManager.add_new_clerk(interior_rooms[0].interior_room_data)
	" TESTING ENDS "


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
# FIXME - TODO: add_interior_room should be renamed(?)
# 	adding adds to an Array/something that is keeping reference
# 	spawn puts it into the scene
func add_interior_room(new_interior_room: InteriorRoom, index: int) -> void:
	new_interior_room.name = "InteriorRoom" + str(index)
	self.add_child(new_interior_room)
	new_interior_room.global_position = BaseData.slotCoords[index]
	
	# HACK/FIXME: Follow BaseData.buildAdjList to know what direction for interior room connectors.
	# TODO: This has a pattern, so maybe it can be shortened(?).
	# WARNING: Creates duplicates due to nothing keeping track of already created connectors! How do I make this cleaner???
	if BaseData.adj[index].top != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		self.add_child(connector)
		connector.global_position = BaseData.slotCoords[index] - offset
		connector.start(Connector.RoomSide.TOP)
	if BaseData.adj[index].left != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		self.add_child(connector)
		connector.global_position = BaseData.slotCoords[index] - offset
		connector.start(Connector.RoomSide.LEFT)
	if BaseData.adj[index].right != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		self.add_child(connector)
		connector.global_position = BaseData.slotCoords[index] - offset
		connector.start(Connector.RoomSide.RIGHT)
	if BaseData.adj[index].bottom != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		self.add_child(connector)
		connector.global_position = BaseData.slotCoords[index] - offset
		connector.start(Connector.RoomSide.BOTTOM)


## Spawns InteriorRooms in the scene based on the data given by InteriorRoomManager.
## InteriorRoomManager stores and saves InteriorRooms that the Player has unlocked. This function loads in the interior rooms and spawns them in the scene.
## TODO: NOTE - There is a lot of redundancy(?) IF this function should return a value. Maybe the function returning a value is not the issue here...
func spawn_interior_rooms() -> Array[InteriorRoom]:
	var interior_rooms: Array[InteriorRoom] = InteriorRoomManager.create_interior_rooms()  # TODO: Should this function take in an Array[InteriorRoom] instead? Possibly yes.
	for interior_rooms_index in range(interior_rooms.size()):
		var interior_room: InteriorRoom = interior_rooms[interior_rooms_index]
		self.add_interior_room(interior_room, interior_rooms_index)
	self.spawned_interior.emit()
	return interior_rooms
