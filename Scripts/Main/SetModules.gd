extends Control
class_name SetModules


#@ Signals
signal spawned_modules


#@ Constants


#@ Export Variables


#@ Public Variables


#@ Private Variables


#@ Onready Variables


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for m in ModuleManager.active_modules:
		var add_mod = m.instant()
		add_mod.name = "ID" + str(m.ID)
		self.add_child(add_mod)
		
		add_mod.position = BaseData.slotCoords[i]
		BaseData.buildAdjList(i, m.ID)
		i += 1
	if i < 5:
		var empty_mod = ModuleContainer.new()
		empty_mod.mod_scene = load("res://Scenes/Modules/EMPTYSLOT.tscn")
		var add_mod = empty_mod.instant()
		add_mod.save_position.connect(record_position)
		self.add_child(add_mod)
		add_mod.position = BaseData.slotCoords[i]
		# change this to cost when i figure out how to make it not crash
		add_mod.init(BaseData.default_cost[i])
	
	self.spawned_modules.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
func record_position():
	BaseData.current_position = self.position


#@ Private Methods
