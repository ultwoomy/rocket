extends Dialogue
class_name ohzero_dialogue

enum faces {HAPPY, NEUTRAL, NERVOUS, PEEVED}

func setup():
	super()
	dialogue_sections["intro_a"] = ["Looks like another crash! Don't worry, this time for sure we'll make it.",
									"Is your memory intact or should I run the tutorial?"]
	dialogue_sections["tutorial"] = ["Hooray! This parts my favorite!",
									"Starting tutorial diagnostics, press that exit button to continue"]
	dialogue_sections["intro_c"] = ["Well business as usual then, right?"]
	dialogue_sections["default_a"] = ["I am Ohzero~. I am the operations manager of this rocket.",
									  "Everything runs itself though, so I just explain things to the manager"]
	dialogue_sections["default_b"] = ["Well what don't you do, manager?",
									  "You acquire and spend fuel where necessary",
									  "Upgrade the rocket and fend off nosy intruders",
									  "Salvage them and improve our fuel gathering technology",
									  "All to make one big launch and land upon the stars!"]
	dialogue_sections["default_c"] = ["We are stationed at the Fourth Rocket",
									 "This is flight attempt number #%@&^",
									 "Uhm. That's really it. The land we're on isn't named right now.",
									 "It doesn't matter at all. All we need to do is go up, then we will all find our real homes."]
	dialogue_sections["explain_module"] = ["So here's how this part works",
											"So you know the modules you installed into the ship?",
											"Those don't come with instruction manules, so I'm here to help!",
											"I will bring up a menu of the 6 modules related to this part of the ship",
											"If you have that module unlocked, I'll be able to tell you how it works",
											"I will also pull up various stats and mods if you've unlocked them"]
	dialogue_sections["explain_module_0"] = ["This one's real simple! Just click on the fuel button and gain fuel",
											 "A lot of different factors affect fuel gain, including settings on other modules",
											 "You can spend fuel in a lot of modules to upgrade their effects",
											 "The better your fuel gain efficiency, the longer you can launch for, and the closer we get to the stars"]
	dialogue_sections["explain_module_1"] = ["This module consolidates fuel lines every time you gain or lose fuel",
											 "Each line multiples your fuel gain",
											 "You can make each line stronger, gain more faster, and increase the amount you get by spending resources",
											 "This is a great first module to get as it gets strong pretty fast"]
	dialogue_sections["explain_module_2"] = ["This module has a chance to grant a huge fuel multiplier on gain fuel",
											 "You can use the slider at the bottom to lower or raise your chance to get a crit",
											 "The lower the chance, the stronger the crit, but the less critical fuel you'll get",
											 "Critical fuel can be used to upgrade the crit multiplier or some other modules",
											 "Try not to pick this one first as its inconsistent"]
	dialogue_sections["explain_module_3"] = ["This module will passively make fuel and fuel lines for you based on how many resources you burn on it",
											 "The fuel gain per second is multiplied by the fuel line gain, so be sure to burn both",
											 "It's great early on but gets weak as you gain a lot of fuel",
											 "Still, its great when you just want to relax instead of clicking away",
											 "It can crit too, though the crit multiplier on fuel lines is much weaker",
											 "This is a great early pick to make the early game smoother"]
	dialogue_sections["explain_module_4"] = ["You'll notice this module's got big arrows pointing to neighboring modules",
											 "Press the arrow to give a buff to the module its pointing at",
											 "If you press any other arrow, the buff to that module will be removed and it will buff the other module instead",
											 "You want this module to be in the center so you can pick any surrounding module to buff",
											 "Though of course, if you only want to buff one module you can stick this one off to the side",
											 "All of its buffs are really good, so feel free to pick this module whenever you want"]
	dialogue_sections["explain_module_5"] = ["This module charges up over time then blows up your production for a short period",
											 "Also gives a truckload of critical fuel while being able to crit, so try to get module 2 as well"]
	
	dialogue_sections["intro_a_face"] = [faces.HAPPY, faces.NEUTRAL]
	dialogue_sections["tutorial_face"] = [faces.HAPPY, faces.NEUTRAL]
	dialogue_sections["intro_c_face"] = [faces.HAPPY]
	dialogue_sections["default_a_face"] = [faces.HAPPY, faces.NERVOUS]
	dialogue_sections["default_b_face"] = [faces.HAPPY,faces.NEUTRAL,faces.NEUTRAL,faces.PEEVED,faces.HAPPY]
	dialogue_sections["default_c_face"] = [faces.NEUTRAL,faces.NEUTRAL,faces.NERVOUS,faces.HAPPY]
	dialogue_sections["explain_module_face"] = [faces.HAPPY,faces.NEUTRAL,faces.NEUTRAL,faces.NEUTRAL,faces.HAPPY,faces.NEUTRAL]
	
	dialogue_sections["intro_a_options"] = [["","Huh?",""],
											["Tutorial", "", "No need"]]
	# Right now I'm doing the actions as strings 

											
	dialogue_sections["tutorial_options"] = [["","Next",""],
											["", "", ""]]

											
	dialogue_sections["default_a_options"] = [["","Next",""],
											["","Understood",""]]

											
	dialogue_sections["default_b_options"] = [["","A lot",""],
											  ["","Next",""],
											  ["","Next",""],
											  ["","Next",""],
											  ["","Understood",""]]

											
	dialogue_sections["default_c_options"] = [["","Next",""],
											  ["","Next",""],
											  ["","Next",""],
											  ["","Understood",""]]

											
	dialogue_sections["explain_module_options"] = [["","Next",""],
												   ["","Next",""],
												   ["","Next",""],
												   ["","Next",""],
												   ["","Next",""],
												   ["","Understood",""]]

											
	dialogue_sections["default_options"] = ["Who are you?","What is my purpose?","Where is this?","RUN: Explain Module"]
	dialogue_sections["default_options_active"] = [true,true,true,true]
	
func parse_selection(x : String):
	var ret = "next"
	if x == "Who are you?":
		ret = "default_a"
	if x == "What is my purpose?":
		ret = "default_b"
	if x == "Where is this?":
		ret = "default_c"
	if x == "Understood":
		return "next";
	if x == "Tutorial":
		return "tutorial";
	if x == "No need":
		return "no need"
	if x == "RUN: Explain Module":
		if not OhzeroData.module_explanation_explained:
			OhzeroData.module_explanation_explained = true
			return "explain_module"
		else:
			return "open_explain_module_menu"

	disable_default_option(dialogue_sections["default_options"].find(x))
	return ret
