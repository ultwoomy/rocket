extends Panel


#@ Signals
signal save_position


#@ Onready Variables
@onready var layer1 : Panel = $Layer1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for m in ModuleManager.active_modules:
		var add_mod = m.instant()
		var interior_room = load("res://Scenes/InteriorRoom.tscn").instantiate()
		# TODO: Have the layers display separately- only one layer may be visible at a time!
		layer1.add_child(interior_room)  # NOTE: layer1 has a different position compared to layer0!
		layer1.add_child(add_mod)
		interior_room.position = BaseData.slotCoords[i]
		add_mod.position = BaseData.slotCoords[i]
		BaseData.buildAdjList(i,m.ID)
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
