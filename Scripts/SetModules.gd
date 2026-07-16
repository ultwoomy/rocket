extends Panel
class_name SetModules


#@ Signals


#@ Enums
enum ShipLayers {
	INTERIOR,
	EXTERIOR,
}


#@ Public Variables
var current_layer: ShipLayers = ShipLayers.EXTERIOR


#@ Onready Variables
@onready var layer0: Panel = $Layer0
@onready var layer1: Panel = $Layer1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## ALERT: TESTING!
	if !layer0 or !layer1:
		return
	
	self.spawn_interior_rooms()
	
	var i = 0
	for m in ModuleManager.active_modules:
		var add_mod = m.instant()
		add_mod.name = "ID" + str(m.ID)
		layer1.add_child(add_mod)
		
		add_mod.position = BaseData.slotCoords[i]
		BaseData.buildAdjList(i, m.ID)
		i += 1
	if i < 5:
		var empty_mod = ModuleContainer.new()
		empty_mod.mod_scene = load("res://Scenes/Modules/EMPTYSLOT.tscn")
		var add_mod = empty_mod.instant()
		add_mod.save_position.connect(record_position)
		layer1.add_child(add_mod)
		add_mod.position = BaseData.slotCoords[i]
		# change this to cost when i figure out how to make it not crash
		add_mod.init(BaseData.default_cost[i])
	
	self._update_rocket_view()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("switch_rocket_view"):
		current_layer = ShipLayers.INTERIOR if current_layer == ShipLayers.EXTERIOR else ShipLayers.EXTERIOR
		self._update_rocket_view()


#@ Public Methods
# FIXME - TODO: add_interior_room should be renamed(?)
# 	adding adds to an Array/something that is keeping reference
# 	spawn puts it into the scene
func add_interior_room(new_interior_room: InteriorRoom, index: int) -> void:
	new_interior_room.name = "InteriorRoom" + str(index)
	layer0.add_child(new_interior_room)
	new_interior_room.global_position = layer1.global_position + BaseData.slotCoords[index]  # NOTE: layer1 has a different position compared to layer0!
	
	# HACK/FIXME: Follow BaseData.buildAdjList to know what direction for interior room connectors.
	# TODO: This has a pattern, so maybe it can be shortened(?).
	# WARNING: Creates duplicates due to nothing keeping track of already created connectors! How do I make this cleaner???
	if BaseData.adj[index].top != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		layer0.add_child(connector)
		connector.global_position = layer1.global_position + BaseData.slotCoords[index] - offset
		connector.start(Connector.RoomSide.TOP)
	if BaseData.adj[index].left != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		layer0.add_child(connector)
		connector.global_position = layer1.global_position + BaseData.slotCoords[index] - offset
		connector.start(Connector.RoomSide.LEFT)
	if BaseData.adj[index].right != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		layer0.add_child(connector)
		connector.global_position = layer1.global_position + BaseData.slotCoords[index] - offset
		connector.start(Connector.RoomSide.RIGHT)
	if BaseData.adj[index].bottom != -1:
		var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
		var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
		connector.name = "Connector" + str(index)
		layer0.add_child(connector)
		connector.global_position = layer1.global_position + BaseData.slotCoords[index] - offset
		connector.start(Connector.RoomSide.BOTTOM)


## Spawns InteriorRooms in the scene based on the data given by InteriorRoomManager.
func spawn_interior_rooms() -> void:
	var interior_rooms: Array[InteriorRoom] = InteriorRoomManager.create_interior_rooms()
	for interior_rooms_index in range(interior_rooms.size()):
		var interior_room: InteriorRoom = interior_rooms[interior_rooms_index]
		self.add_interior_room(interior_room, interior_rooms_index)
	self._update_rocket_view()


func record_position():
	BaseData.current_position = self.position


#@ Private Methods
## Hides and shows the layers depending on what layer the Player is in.
func _update_rocket_view() -> void:
	var isInteriorVisible: bool = true if current_layer == ShipLayers.INTERIOR else false
	var isExteriorVisible: bool = true if current_layer == ShipLayers.EXTERIOR else false
	get_tree().call_group("Interior", "set_visible", isInteriorVisible)
	get_tree().call_group("Exterior", "set_visible", isExteriorVisible)
