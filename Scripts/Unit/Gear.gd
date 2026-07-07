extends Resource
class_name GearData


#@ Enumerators
enum GearType {
	GENERIC,
	EXCLUSIVE,
}


#@ Export Variables
@export var gear_name: String
@export var gear_type: GearType
@export var unit_requirement: String  # ALERT: Type String for now since it isn't certain what the requirement is.
@export var has_levelling: bool = false
@export var functionalities: Array  # TODO
	# INFO: GearData will have an Array[SomeSortOfGearClass],
	#	The SomeSortOfGearClass is a Base class with an execute() method.
	#	It's derived classes will provide functional behaviors that the Gear will do and provide.
	#	
	#	The Steps go like this:
	#		1. Something triggers Gear
	#		2. The trigger looks into Gear's GearData's Array
	#		3. Going through the Array, we call each element of type SomeSortOfGearClass' execute method
	#		4. Thus, we get Gear to function how we want it to
	#	
	#	This is one of the design patterns that I forget. 
	#	- L.B.
