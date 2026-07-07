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
