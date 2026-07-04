extends Panel
@onready var layer1 : Panel = $Layer1
signal save_position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for m in ModuleManager.active_modules:
		var add_mod = m.instant()
		layer1.add_child(add_mod)
		add_mod.position = BaseData.slotCoords[i]
		BaseData.buildAdjList(i,m.ID)
		i += 1
	if i < 5:
		var empty_mod = ModuleContainer.new()
		empty_mod.mod_scene = load("res://Scenes/Modules/EMPTYSLOT.tscn")
		var add_mod = empty_mod.instant()
		add_mod.save_position.connect(record_position)
		if i < 5:
			layer1.add_child(add_mod)
			add_mod.position = BaseData.slotCoords[i]
			add_mod.init(BaseData.cost[i])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func record_position():
	save_position.emit()
