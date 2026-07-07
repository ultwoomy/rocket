extends Node
var module_list : Array[ModuleContainer]
var active_modules : Array[ModuleContainer]

var LEVEL1DESC = ["Every flight starts with a small click",
				  "A line is a series of points",
				  "More all at once",
				  "The embers stoke their own flames",
				  "Lifetime Support",
				  "Row Row Fight the power"]

var ID4_description
var ID4_focus = 0

# MODULE DESCRIPTOR
# Every module adds a mechanic to the game. You can buy modules with fuel, but you don't get to choose which one you get. You'll be presented with 3 choices
# and the player will pick 1 initially based on vibes, later unlocked more info and knowing which one is which. There are 3 phases of ids.
# The first module is given free and does not have alternate choices. The next 4 modules are chosen from the Upper pool. Then 3 modules are chosen from the
# Middle pool. Then 2 modules are chosen from the Lower pool, and 1 is given at the bottom. 
# ID: 0:
# Starting module. Press a button. Gain fuel
#
# ID: 1:
# Upper module. Creates a fuel bar that adds a small multiplier to fuel gain every time the bar fills. Can spend fuel or bars to increase speed of bar fill/soft cap.
# 
# ID: 2:
# Upper module. Gives fuel gain a small chance to critical strike, gaining significantly more fuel on click. Chance or multiplier can be increased but levelling one
# will weaken the other.
# 
# ID: 3:
# Upper module. Passively produces fuel over time. Affected by a reduced amount by other fuel multipliers. Can sacrifice fuel to gain extra passive fuel.
# Works for fuel lines
# 
# ID: 4:
# Upper module. Increases the strength of a selected phase 1 module.
# 
# ID: 5:
# Upper module. Overdrive module. Increases fuel multiplier by a large amount for a short period of time with a cooldown. Upgrade to increase that multiplier.
# 
# ID: 6:
# Upper module. Occasionally spawn stars. When clicked, stars give a random buff or amount of a random accesible resource. This includes fuel bars.
#
func _ready() -> void:
	add_to_group("Savables")

func save_data():
	var dict : Dictionary = {}
	dict["name"] = "ModuleManager"
	dict["mod_max_size"] = module_list.size()
	dict["mod_active_size"] = active_modules.size()

	for n in module_list:
		var id := str(n.ID)
		dict[id + "LEVEL1DESC"] = n.LEVEL1DESC
		dict[id + "xp"] = n.xp
		dict[id + "ID"] = n.ID

	var mod_order = []
	for n in active_modules:
		var id := str(n.ID)
		dict["A" + id + "LEVEL1DESC"] = n.LEVEL1DESC
		dict["A" + id + "xp"] = n.xp
		dict["A" + id + "ID"] = n.ID
		mod_order.append(int(id))
	
	dict["ID4_focus"] = ID4_focus
	dict["mod_order"] = mod_order
	return dict
	
func load_data(dict):
	var temp_cont
	for i in range(dict.get("mod_max_size",LEVEL1DESC.size())):
		temp_cont = ModuleContainer.new()
		temp_cont.mod_scene = load("res://Scenes/Modules/ID" + str(i) + ".tscn")
		var id := str(i)
		temp_cont.LEVEL1DESC = dict.get(id + "LEVEL1DESC", LEVEL1DESC[i])
		temp_cont.xp = dict.get(id + "xp",0)
		temp_cont.ID = dict.get(id + "ID", i)
		module_list.append(temp_cont)
		
	var mod_order = dict.get("mod_order",[])
	for i in mod_order:
		print(i)
		temp_cont = ModuleContainer.new()
		temp_cont.mod_scene = load("res://Scenes/Modules/ID" + str(int(i)) + ".tscn")
		var id := str(int(i))
		temp_cont.LEVEL1DESC = dict.get("A" + id + "LEVEL1DESC", LEVEL1DESC[i])
		temp_cont.xp = dict.get("A" + id + "xp", 0)
		temp_cont.ID = dict.get("A" + id + "ID", i)
		active_modules.append(temp_cont)
	
	ID4_focus = dict.get("ID4_focus", 0)
	update_ID4_description()
		

func update_ID4_description():
	ID4_description = ["Multiply fuel per click based on number of clicks made Currently: " + str(NumberManager.get_scientific(FuelManager.ID4_data.click_multiplier)),
						"Raise fuel line gain from bar fill by an exponent based on fuel. Currently: " + str(NumberManager.get_scientific(FuelManager.ID4_data.fuel_line_exponent)),
						"Critical fuel gain is now affected by a reduced crit multiplier. Currently: " + str(NumberManager.get_scientific(FuelManager.ID4_data.critical_fuel_gain_multiplier)),
						"Passive fuel gain triigers more often based on number of times it has triggered. Fuel line gain does not increase. Currently " + str(NumberManager.get_scientific(1/FuelManager.ID4_data.passive_fuel_multiplier)) + " times faster",
						"This is pointing at a copy of ID4. How did this happen?",
						"Rush becomes stronger based on time spent fully charged. Currently: " + str(NumberManager.get_scientific(FuelManager.ID5_data.overcharge_multiplier))]
