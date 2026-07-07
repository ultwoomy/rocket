extends Unit
class_name AgentUnit


#@ Export Variables
@export var max_health: int
@export var current_health: int
@export var max_mana: int
@export var current_mana: int
@export var max_sanity: int
@export var current_sanity: int


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
func rename(new_name: String) -> void:
	self.unit_name = new_name
