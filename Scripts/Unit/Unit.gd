extends Control
class_name Unit


#@ Constants
const CLERK_REFERENCE: PackedScene = preload("res://Scenes/Unit/Clerk.tscn")
const AGENT_REFERENCE: PackedScene = preload("res://Scenes/Unit/Agent.tscn")


#@ Enumerators


#@ Export Variables


#@ Public Variables
var unit_data: UnitData  # NOTE: Should be assigned after instantiating. (Can't use .new() since it is an instance)


#@ Private Variables


#@ Public Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if unit_data:
		if (unit_data is UnitData) and (not unit_data is AgentData):
			var clerk_instance: Control = CLERK_REFERENCE.instantiate()
			self.add_child(clerk_instance)
		if unit_data is AgentData:
			var agent_instance: Control = AGENT_REFERENCE.instantiate()
			self.add_child(agent_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
