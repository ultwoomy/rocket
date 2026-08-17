## InteriorRoomData keeps a reference to an InteriorRoom object and its props.
extends RefCounted
class_name InteriorRoomData


#@ Constants
const MAX_CLERKS: int = 3
const MAX_AGENTS: int = 1


#@ Public Variables
var clerks: Array[UnitData]
var agents: Array[AgentData]


#@ 
