extends BaseModule
class_name ID4
@onready var up_arrow : TextureButton = $Panel/UpArrow
@onready var down_arrow : TextureButton = $Panel/DownArrow
@onready var left_arrow : TextureButton = $Panel/LeftArrow
@onready var right_arrow : TextureButton = $Panel/RightArrow
@onready var desc : Label = $Panel/Label
var index : int
var current_focus : int

# ID0 effect: Multiply fuel per click by number of clicks made (softcap : 1000) Post 1000 formula : (x+1000)^0.9 + 65
# ID1 effect: Raise fuel line gain from bar fill to the exponent of 1 + (log base 100 (fuel)/5)
# ID2 effect: Critical fuel gain is now affected by a reduced crit multiplier
# ID3 effect: Passive fuel and fuel line gain happens more often based on number of times it has triggered
# ID5 effect: Rush effect is constantly applied. Rushing again will square this effect.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FuelManager.fuel_changed.connect(self.update_ID4_description)
	FuelManager.fuel_crits_changed.connect(self.update_ID4_description)
	FuelManager.fuel_lines_changed.connect(self.update_ID4_description)
	FuelManager.tick_completed.connect(self.update_ID4_description)
	index = BaseData.findIndexByID(4)
	if index < 0:
		enabled = false
		return
	if BaseData.adj[index].top < 0:
		up_arrow.hide()
	if BaseData.adj[index].left < 0:
		left_arrow.hide()
	if BaseData.adj[index].right < 0:
		right_arrow.hide()
	if BaseData.adj[index].bottom < 0:
		down_arrow.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_up_arrow_pressed() -> void:
	var x = BaseData.adj[index].top
	if enabled and x >= 0:
		current_focus = x
		update_ID4_description()
		pick_buff(x)


func _on_left_arrow_pressed() -> void:
	var x = BaseData.adj[index].left
	if enabled and x >= 0:
		current_focus = x
		update_ID4_description()
		pick_buff(x)


func _on_right_arrow_pressed() -> void:
	var x = BaseData.adj[index].right
	if enabled and x >= 0:
		current_focus = x
		update_ID4_description()
		pick_buff(x)


func _on_down_arrow_pressed() -> void:
	var x = BaseData.adj[index].bottom
	if enabled and x >= 0:
		current_focus = x
		update_ID4_description()
		pick_buff(x)

func pick_buff(x : int):
	if x == 0:
		FuelManager.ID4_enable_click_multiplier()
	elif x == 1:
		FuelManager.ID4_enable_fuel_line_exponent()
	elif x == 2:
		FuelManager.ID4_enable_critical_fuel_gain_multiplier()
	elif x == 3:
		FuelManager.ID4_enable_passive_fuel_multiplier()
	elif x == 5:
		FuelManager.ID4_enable_global_rush_multiplier()

func update_ID4_description():
	ModuleManager.update_ID4_description()
	desc.text = ModuleManager.ID4_description[current_focus]
