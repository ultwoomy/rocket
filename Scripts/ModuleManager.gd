extends Node
var module_list : Array[ModuleContainer]
var active_modules : Array[ModuleContainer]

var LEVEL1DESC = ["Every flight starts with a small click",
				  "A line is a series of points",
				  "More all at once",
				  "The embers stoke their own flames",
				  "Lifetime Support"]
var LEVEL2DESC = ["ID: 0. The basic fuel generator",
				  "ID: 1. Creates a bar that gives you 1 fuel line every time it fills",
				  "ID: 2. Grants a small chance to gain more fuel per click",
				  "ID: 3. Burn fuel and fuel lines to get some of each each second",
				  "ID: 4. Select a bordering module to buff"]
var LEVEL3DESC = ["ID: 0. Gives 1 fuel per click",
				  "ID: 1. Multiplies ID 0 gain with fuel lines",
				  "ID: 2. Gives ID 0 gain a critical chance",
				  "ID: 3. Burn fuel and fuel lines to get some of each each second",
				  "ID: 4. Select a bordering module to buff (put this in the middle)"]
var thresh2 = [2,2,2,2,2]
var thresh3 = [5,5,5,5,5]

var ID4_description

# MODULE DESCRIPTOR
# Every module adds a mechanic to the game. You can buy modules with fuel, but you don't get to choose which one you get. You'll be presented with 3 choices
# and the player will pick 1 initially based on vibes, later unlocked more info and knowing which one is which. There are 3 phases of ids.
# The first module is given free and does not have alternate choices. The next 3 modules are chosen from the Phase 1 pool. Then 4 modules are chosen from the
# Phase 2 pool. Then 2 modules are chosen from the Phase 3 pool. 
# ID: 0:
# Starting module. Press a button. Gain fuel
#
# ID: 1:
# Phase 1 module. Creates a fuel bar that adds a small multiplier to fuel gain every time the bar fills. Can spend fuel or bars to increase speed of bar fill/soft cap.
# 
# ID: 2:
# Phase 1 module. Gives fuel gain a small chance to critical strike, gaining significantly more fuel on click. Chance or multiplier can be increased but levelling one
# will weaken the other.
# 
# ID: 3:
# Phase 1 module. Passively produces fuel over time. Affected by a reduced amount by other fuel multipliers. Can sacrifice fuel to gain extra passive fuel.
# Works for fuel lines
# 
# ID: 4:
# Phase 1 module. Increases the strength of a selected phase 1 module.
# 
# ID: 5:
# Phase 1 module. Overdrive module. Increases fuel multiplier by a large amount for a short period of time with a cooldown. Upgrade to increase that multiplier.
# 
# ID: 6:
# Phase 1 module. Occasionally spawn stars. When clicked, stars give a random buff or amount of a random accesible resource. This includes fuel bars.
#
# ORDEALS DESCRIPTOR
# Every 3 modules an ordeal (challenge) will be added to a list. On launching the rocket, the player will have to face the ordeals one after the other, and will recieve 
# stardust based on how much fuel is left after completing them. If no fuel is left, the rocket crashes, and the player gets nothing. Fuel consumption is exponential.
# All modules can continue producing fuel
# 
# PHASE 1 ORDEALS: 
# Golden Dawn: A bunch of silver stars will appear on the rocekt somewhere and one golden star. The player has to click the golden star while more silver stars appear
# and sap fuel production. Challenge ends upon gold star click
# 
# Silver Dawn: All phase 2 and 3 modules are disabled. The player must produce a certain amount of fuel with only phase 1 modules to complete the ordeal
# 
# Steel Dawn: 2 random modules have swapped places. The player must figure out which 2 modules they are and select them to complete the ordeal.
# 
# Amber Dawn: Player must click on several munchers siphoning fuel until the pop and return the eaten fuel alongside a bonus. Ordeal ends when all munchers are dead.

# Called when the node enters the scene tree for the first time.
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
		dict[id + "LEVEL2DESC"] = n.LEVEL2DESC
		dict[id + "LEVEL3DESC"] = n.LEVEL3DESC
		dict[id + "thresh2"] = n.thresh2
		dict[id + "thresh3"] = n.thresh3
		dict[id + "xp"] = n.xp
		dict[id + "ID"] = n.ID

	var mod_order = []
	for n in active_modules:
		var id := str(n.ID)
		dict["A" + id + "LEVEL1DESC"] = n.LEVEL1DESC
		dict["A" + id + "LEVEL2DESC"] = n.LEVEL2DESC
		dict["A" + id + "LEVEL3DESC"] = n.LEVEL3DESC
		dict["A" + id + "thresh2"] = n.thresh2
		dict["A" + id + "thresh3"] = n.thresh3
		dict["A" + id + "xp"] = n.xp
		dict["A" + id + "ID"] = n.ID
		mod_order.append(int(id))
	
	dict["mod_order"] = mod_order
	return dict
	
func load_data(dict):
	var temp_cont
	for i in range(dict.get("mod_max_size",LEVEL1DESC.size())):
		temp_cont = ModuleContainer.new()
		temp_cont.mod_scene = load("res://Scenes/Modules/ID" + str(i) + ".tscn")
		var id := str(i)
		temp_cont.LEVEL1DESC = dict.get(id + "LEVEL1DESC", LEVEL1DESC[i])
		temp_cont.LEVEL2DESC = dict.get(id + "LEVEL2DESC", LEVEL2DESC[i])
		temp_cont.LEVEL3DESC = dict.get(id + "LEVEL3DESC", LEVEL3DESC[i])
		temp_cont.thresh2 = dict.get(id + "thresh2", thresh2[i])
		temp_cont.thresh2 = dict.get(id + "thresh3", thresh3[i])
		temp_cont.xp = dict.get(id + "xp",0)
		temp_cont.ID = dict.get(id + "ID", i)
		module_list.append(temp_cont)
		
	var mod_order = dict.get("mod_order",[])
	for i in mod_order:
		temp_cont = ModuleContainer.new()
		temp_cont.mod_scene = load("res://Scenes/Modules/ID" + str(i) + ".tscn")
		var id := str(i)
		temp_cont.LEVEL1DESC = dict.get("A" + id + "LEVEL1DESC", LEVEL1DESC[i])
		temp_cont.LEVEL2DESC = dict.get("A" + id + "LEVEL2DESC", LEVEL2DESC[i])
		temp_cont.LEVEL3DESC = dict.get("A" + id + "LEVEL3DESC", LEVEL3DESC[i])
		temp_cont.thresh2 = dict.get("A" + id + "thresh2", thresh2[i])
		temp_cont.thresh2 = dict.get("A" + id + "thresh3", thresh3[i])
		temp_cont.xp = dict.get("A" + id + "xp", 0)
		temp_cont.ID = dict.get("A" + id + "ID", i)
		active_modules.append(temp_cont)
		
	update_ID4_description()
		

func update_ID4_description():
	ID4_description = ["Multiply fuel per click based on number of clicks made Currently: " + str(NumberManager.get_scientific(FuelManager.ID4_data.click_multiplier)),
						"Raise fuel line gain from bar fill by an exponent based on fuel. Currently: " + str(NumberManager.get_scientific(FuelManager.ID4_data.fuel_line_exponent)),
						"Critical fuel gain is now affected by a reduced crit multiplier. Currently: " + str(NumberManager.get_scientific(FuelManager.ID4_data.critical_fuel_gain_multiplier)),
						"Passive fuel and fuel line gain happens more often based on number of times it has triggered. Currently " + str(NumberManager.get_scientific(1/FuelManager.ID4_data.passive_fuel_multiplier)) + " times faster",
						"This is pointing at a copy of ID4. How did this happen?",
						"Rush multiplier is constantly applied. Rushing again will square this bonus."]
