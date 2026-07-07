extends Resource
class_name Gear


#@ Enumerators
enum GearType {
	GENERIC,
	EXCLUSIVE,
}


#@ Export Variables
@export var gear_name: String
@export var gear_type: GearType
@export var unit_requirement: String  # ALERT: Type String for now since it isn't certain what the requirement is.
@export var level: int = -1  # NOTE: Negative number means the gear does NOT level up.


#@ Public Methods
func level_up() -> void:
	if level >= 0:
		level += 1
