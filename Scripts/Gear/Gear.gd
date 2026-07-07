extends RefCounted
class_name Gear


#@ Public Variables
var levels: int


#@ Private Variables
var _gear_data: GearData


#@ Virtual Methods
func _init(gear_data: GearData) -> void:
	_gear_data = gear_data


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
