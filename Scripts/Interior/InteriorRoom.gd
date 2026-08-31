extends Control
class_name InteriorRoom


#@ Constants
const PIXEL_SIZE_DIFFERENCE: float = 60  #  The size of an interior room is 60 pixels smaller for both x & y than the size of a module.
const TOP_MIDDLE_SIDE: Vector2 = Vector2(180.0, 0.0)
const BOTTOM_MIDDLE_SIDE: Vector2 = Vector2(180.0, 300.0)
const LEFT_MIDDLE_SIDE: Vector2 = Vector2(0.0, 150.0)
const RIGHT_MIDDLE_SIDE: Vector2 = Vector2(360.0, 150.0)


#@ Public Variables
var interior_room_data: InteriorRoomData
var occupying_units: Array[Unit] = []


#@ Onready Variables
@onready var room_panel: Panel = $RoomPanel
# NOTE - TEMPORARY
@onready var clerk_button: Button = $ClerkButton
@onready var agent_button: Button = $AgentButton


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.respawn_units()
	self.set_button_visibility(false)  # Hides buttons by default.
	
	# Signals.
	# NOTE - TEMPORARY
	clerk_button.pressed.connect(buy_unit.bind(Purchasable.CLERK))
	agent_button.pressed.connect(buy_unit.bind(Purchasable.AGENT))
	CameraManager.unfocused.connect(set_button_visibility.bind(false))  # Hides button when unfocused.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and CameraManager.state is UnfocusCS:
			# Zoom in on this Control node.
			var half_size: Vector2 = self.size / 2.0
			CameraManager.focus_on_control_node(self, half_size)
			
			# Show buttons.
			var is_focused: bool = CameraManager.state is FocusCS
			self.set_button_visibility(is_focused)  # NOTE: This only triggers when clicked on! 


#@ Public Methods
## Removes any units that are already in the room and spawns new units using interior_room_data.
func respawn_units() -> void:
	if !interior_room_data:
		printerr("ERROR: No data given to interior room!")
		return
	
	# Remove any previous units.
	if occupying_units:
		for unit in occupying_units:
			unit.queue_free()
	occupying_units = []
	
	# Get units and spawn them into the scene.
	occupying_units = self._get_units()
	for unit in occupying_units:
		self._set_random_position_of_unit(unit)
		self.add_child(unit)


# TODO: Move these temporary functions elsewhere!
enum Purchasable {
	CLERK,
	AGENT,
}
func buy_unit(unit: Purchasable) -> void:
	match unit:
		Purchasable.CLERK:
			if interior_room_data.clerks.size() < interior_room_data.MAX_CLERKS:
				var new_clerk: UnitData = UnitManager.add_new_clerk(interior_room_data)
				interior_room_data.clerks.append(new_clerk)
				respawn_units()
		Purchasable.AGENT:
			if interior_room_data.agents.size() < interior_room_data.MAX_AGENTS:
				var new_agent: AgentData = UnitManager.add_new_agent(interior_room_data)
				interior_room_data.agents.append(new_agent)
				respawn_units()
		_:
			printerr("ERROR: Unable to buy an item! Is the call method correct?")
			return


func set_button_visibility(boolean: bool) -> void:
	clerk_button.visible = boolean
	agent_button.visible = boolean


#@ Private Methods
func _get_units() -> Array[Unit]:
	if !interior_room_data:
		printerr("ERROR: Unable to get data for interior room! Can't get any units!")
		return []
	
	const UNIT_REFERENCE: PackedScene = preload("res://Scenes/Unit/Unit.tscn")
	var units: Array[Unit] = []
	for clerk_data in interior_room_data.clerks:
		units.append(UnitManager.get_clerk_unit(clerk_data))
	for agent_data in interior_room_data.agents:
		units.append(UnitManager.get_agent_unit(agent_data))
	return units


func _set_random_position_of_unit(unit: Unit) -> void:
	var min_x: float = room_panel.position.x
	var min_y: float = room_panel.position.y
	var max_x: float = room_panel.size.x
	var max_y: float = room_panel.size.y
	var random_x: float = randf_range(min_x, max_x)
	var random_y: float = randf_range(min_y, max_y)
	
	unit.position = Vector2(random_x, random_y)
