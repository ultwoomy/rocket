extends Panel


#@ Signals
signal save_position


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
	var i = 0
	for m in ModuleManager.active_modules:
		var add_mod = m.instant()
		var interior_room: InteriorRoom = load("res://Scenes/Interior/InteriorRoom.tscn").instantiate()
		interior_room.name = "InteriorRoom" + str(i)
		add_mod.name = "ID" + str(i)
		layer0.add_child(interior_room)
		layer1.add_child(add_mod)
		interior_room.global_position = layer1.global_position + BaseData.slotCoords[i]  # NOTE: layer1 has a different position compared to layer0!
		add_mod.position = BaseData.slotCoords[i]
		BaseData.buildAdjList(i,m.ID)
		
		# HACK/FIXME: Follow BaseData.buildAdjList to know what direction for interior room connectors.
		# TODO: This has a pattern, so maybe it can be shortened(?).
		# WARNING: Creates duplicates due to nothing keeping track of already created connectors! How do I make this cleaner???
		if BaseData.adj[i].top != -1:
			var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
			var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
			connector.name = "Connector" + str(i)
			layer0.add_child(connector)
			connector.global_position = layer1.global_position + BaseData.slotCoords[i] - offset
			connector.start(Connector.RoomSide.TOP)
			print("TOP! - m.ID: ", m.ID)
		if BaseData.adj[i].left != -1:
			var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
			var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
			connector.name = "Connector" + str(i)
			layer0.add_child(connector)
			connector.global_position = layer1.global_position + BaseData.slotCoords[i] - offset
			connector.start(Connector.RoomSide.LEFT)
			print("LEFT! - m.ID: ", m.ID)
		if BaseData.adj[i].right != -1:
			var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
			var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
			connector.name = "Connector" + str(i)
			layer0.add_child(connector)
			connector.global_position = layer1.global_position + BaseData.slotCoords[i] - offset
			connector.start(Connector.RoomSide.RIGHT)
			print("RIGHT! - m.ID: ", m.ID)
		if BaseData.adj[i].bottom != -1:
			var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
			var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
			connector.name = "Connector" + str(i)
			layer0.add_child(connector)
			connector.global_position = layer1.global_position + BaseData.slotCoords[i] - offset
			connector.start(Connector.RoomSide.BOTTOM)
			print("BOTTOM! - m.ID: ", m.ID)
		
		
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
	
	_update_rocket_view()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("switch_rocket_view"):
		current_layer = ShipLayers.INTERIOR if current_layer == ShipLayers.EXTERIOR else ShipLayers.EXTERIOR
		_update_rocket_view()


#@ Public Methods
func record_position():
	save_position.emit()


#@ Private Methods
# Hides and shows the layers that should be present to the Player.
func _update_rocket_view() -> void:
	var isInteriorVisible: bool = true if current_layer == ShipLayers.INTERIOR else false
	var isExteriorVisible: bool = true if current_layer == ShipLayers.EXTERIOR else false
	get_tree().call_group("Interior", "set_visible", isInteriorVisible)
	get_tree().call_group("Exterior", "set_visible", isExteriorVisible)
