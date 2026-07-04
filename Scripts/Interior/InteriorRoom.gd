extends Control
class_name InteriorRoom


#@ Constants
const PIXEL_SIZE_DIFFERENCE: float = 60  #  The size of an interior room is 60 pixels smaller for both x & y than the size of a module.
const TOP_MIDDLE_SIDE: Vector2 = Vector2(180.0, 0.0)
const BOTTOM_MIDDLE_SIDE: Vector2 = Vector2(180.0, 300.0)
const LEFT_MIDDLE_SIDE: Vector2 = Vector2(0.0, 150.0)
const RIGHT_MIDDLE_SIDE: Vector2 = Vector2(360.0, 150.0)


#@ Onready Variables
@onready var room_panel: Panel = $RoomPanel


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
