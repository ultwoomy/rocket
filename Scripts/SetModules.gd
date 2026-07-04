extends Panel


#@ Signals
signal save_position


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
		# TODO: Have the layers display separately- only one layer may be visible at a time!
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
		if BaseData.adj[i].left != -1:
			var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
			var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
			connector.name = "Connector" + str(i)
			layer0.add_child(connector)
			connector.global_position = layer1.global_position + BaseData.slotCoords[i] - offset
			connector.start(Connector.RoomSide.LEFT)
		if BaseData.adj[i].right != -1:
			var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0, InteriorRoom.PIXEL_SIZE_DIFFERENCE)
			var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
			connector.name = "Connector" + str(i)
			layer0.add_child(connector)
			connector.global_position = layer1.global_position + BaseData.slotCoords[i] - offset
			connector.start(Connector.RoomSide.RIGHT)
		if BaseData.adj[i].bottom != -1:
			var offset: Vector2 = Vector2(InteriorRoom.PIXEL_SIZE_DIFFERENCE, InteriorRoom.PIXEL_SIZE_DIFFERENCE/2.0)
			var connector = load("res://Scenes/Interior/Connector.tscn").instantiate()
			connector.name = "Connector" + str(i)
			layer0.add_child(connector)
			connector.global_position = layer1.global_position + BaseData.slotCoords[i] - offset
			connector.start(Connector.RoomSide.BOTTOM)
		
		
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func record_position():
	save_position.emit()
