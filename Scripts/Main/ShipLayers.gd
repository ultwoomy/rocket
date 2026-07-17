extends Control
class_name ShipLayers


#@ Enums
enum Containers {
	INTERIOR,
	EXTERIOR,
}


#@ Export Variables
## Assign node_offset a node that inherits or is a Control node to use that node's position in calculating module/room position.
@export var node_offset: Control:
	get:
		return node_offset
	set(value):
		node_offset = value
		_node_offset_position = node_offset.position


#@ Public Variables
var current_layer: Containers = Containers.EXTERIOR


#@ Private Variables
var _node_offset_position: Vector2


#@ Onready Variables
@onready var interior_container: Control = $InteriorContainer
@onready var exterior_container: SetModules = $ExteriorContainer


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interior_container.position += _node_offset_position
	exterior_container.position += _node_offset_position
	
	interior_container.spawned_interior.connect(_update_rocket_view)
	exterior_container.spawned_modules.connect(_update_rocket_view)
	
	self._update_rocket_view()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	## Switch view from interior to exterior or vice versa.
	if Input.is_action_just_pressed("switch_rocket_view"):
		current_layer = Containers.INTERIOR if current_layer == Containers.EXTERIOR else Containers.EXTERIOR
		self._update_rocket_view()


#@ Public Methods


#@ Private Methods
## Hides and shows the layers depending on what layer the Player is in.
func _update_rocket_view() -> void:
	var isInteriorVisible: bool = true if current_layer == Containers.INTERIOR else false
	var isExteriorVisible: bool = true if current_layer == Containers.EXTERIOR else false
	get_tree().call_group("Interior", "set_visible", isInteriorVisible)
	get_tree().call_group("Exterior", "set_visible", isExteriorVisible)
