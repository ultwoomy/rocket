extends Control
class_name InteriorRoom


#@ Constants
const PIXEL_SIZE_DIFFERENCE: float = 60  #  The size of an interior room is 60 pixels smaller for both x & y than the size of a module.


#@ Onready Variables
@onready var room_panel: Panel = $RoomPanel


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
