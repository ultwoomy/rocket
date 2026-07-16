extends Control
class_name ShipLayers


#@ Enums
enum Containers {
	INTERIOR,
	EXTERIOR,
}


#@ Export Variables
## Assign node_offset a node that inherits or is a Control node to use that node's position in calculating module/room position.
@export var node_offset: Control:
	get:
		return node_offset
	set(value):
		node_offset = value
		_node_offset_position = node_offset.position


#@ Public Variables
var current_layer: Containers = Containers.EXTERIOR


#@ Private Variables
var _node_offset_position: Vector2


#@ Onready Variables
@onready var interior_container: Control = $InteriorContainer
@onready var exterior_container: SetModules = $ExteriorContainer


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exterior_container.position += _node_offset_position
	
	self.spawn_interior_rooms()
	
	exterior_container.spawned_modules.connect(_update_rocket_view)  # TODO: Give exterior the correct type!


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	## Switch view from interior to exterior or vice versa.
	if Input.is_action_just_pressed("switch_rocket_view"):
		current_layer = Containers.INTERIOR if current_layer == Containers.EXTERIOR else Containers.EXTERIOR
		self._update_rocket_view()


#@ Public Methods
# FIXME - TODO: add_interior_room should be renamed(?)
# 	adding adds to an Array/something that is keeping reference
# 	spawn puts it into the scene
func add_interior_room(new_interior_room: InteriorRoom, index: int) -> void:
	new_interior_room.name = "InteriorRoom" + str(index)
	interior_container.add_child(new_interior_room)
	new_interior_room.global_position = BaseData.slotCoords[index] + _node_offset_position
	
	# HACK/FIXME: Follow BaseData.buildAdjList to know what direction for interior room connectors.
	# TODO: This has a pattern, so maybe it can be shortened(?).
	# WARNING: Creates duplicates due to nothing keeping track of already created connectors! How do I make this cleaner???
	if BaseData.adj[index].top != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		interior_container.add_child(connector)
		connector.global_position = BaseData.slotCoords[index] - offset + _node_offset_position
		connector.start(Connector.RoomSide.TOP)
	if BaseData.adj[index].left != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		interior_container.add_child(connector)
		connector.global_position = BaseData.slotCoords[index] - offset + _node_offset_position
		connector.start(Connector.RoomSide.LEFT)
	if BaseData.adj[index].right != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		interior_container.add_child(connector)
		connector.global_position = BaseData.slotCoords[index] - offset + _node_offset_position
		connector.start(Connector.RoomSide.RIGHT)
	if BaseData.adj[index].bottom != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		interior_container.add_child(connector)
		connector.global_position = BaseData.slotCoords[index] - offset + _node_offset_position
		connector.start(Connector.RoomSide.BOTTOM)


## Spawns InteriorRooms in the scene based on the data given by InteriorRoomManager.
func spawn_interior_rooms() -> void:
	var interior_rooms: Array[InteriorRoom] = InteriorRoomManager.create_interior_rooms()
	for interior_rooms_index in range(interior_rooms.size()):
		var interior_room: InteriorRoom = interior_rooms[interior_rooms_index]
		self.add_interior_room(interior_room, interior_rooms_index)
	self._update_rocket_view()


#@ Private Methods
## Hides and shows the layers depending on what layer the Player is in.
func _update_rocket_view() -> void:
	var isInteriorVisible: bool = true if current_layer == Containers.INTERIOR else false
	var isExteriorVisible: bool = true if current_layer == Containers.EXTERIOR else false
	get_tree().call_group("Interior", "set_visible", isInteriorVisible)
	get_tree().call_group("Exterior", "set_visible", isExteriorVisible)
