class_name Skill
extends RefCounted

var skill_id: String
var skill_name: String
var mp_cost: int
var multiplier: float
var is_magic: bool
var is_heal: bool
var description: String
var required_class: CharacterClass.ClassType
var required_level: int

func _init(p_id: String, p_name: String, p_mp: int, p_mult: float, p_magic: bool, p_heal: bool, p_desc: String, p_class: CharacterClass.ClassType, p_level: int = 1):
  skill_id = p_id
  skill_name = p_name
  mp_cost = p_mp
  multiplier = p_mult
  is_magic = p_magic
  is_heal = p_heal
  description = p_desc
  required_class = p_class
  required_level = p_level