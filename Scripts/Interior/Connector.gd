extends Control
class_name Connector


#@ Enumerator
enum RoomSide {
	TOP,
	LEFT,
	RIGHT,
	BOTTOM,
}


#@ Constants
const ELEVATOR_SIZE: Vector2 = Vector2(120.0, 60.0)
const HALLWAY_SIZE: Vector2 = Vector2(60.0, 120.0)


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
func start(side: RoomSide) -> void:
	var panel: Panel = $Panel
	
	match side:
		RoomSide.TOP:
			self.position += InteriorRoom.TOP_MIDDLE_SIDE
			panel.size = ELEVATOR_SIZE
		RoomSide.LEFT:
			self.position += InteriorRoom.LEFT_MIDDLE_SIDE
			panel.size = HALLWAY_SIZE
		RoomSide.RIGHT:
			self.position += InteriorRoom.RIGHT_MIDDLE_SIDE
			panel.size = HALLWAY_SIZE
		RoomSide.BOTTOM:
			self.position += InteriorRoom.BOTTOM_MIDDLE_SIDE
			panel.size = ELEVATOR_SIZE
		_:
			return
