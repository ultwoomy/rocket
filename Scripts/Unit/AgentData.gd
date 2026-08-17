extends UnitData
class_name AgentData


#@ Public Variables
var max_health: int
var current_health: int
var max_mana: int
var current_mana: int
var max_sanity: int
var current_sanity: int

var equipped_gear: Gear


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# ALERT: Testing purposes!
	var new_gear: GearData = load("res://Resources/GearData/Exclusive/FanOfKnives.tres")
	equipped_gear = Gear.new(new_gear)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
func rename(new_name: String) -> void:
	self.unit_name = new_name
