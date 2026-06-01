class_name Pet
extends RefCounted

var pet_id: String
var pet_name: String
var species: String
var level: int = 1
var max_hp: int
var current_hp: int
var atk: int
var def_stat: int
var spd: int
var skill_name: String
var skill_desc: String

func _init(p_id: String, p_name: String, p_species: String, stats: Dictionary, p_skill_name: String, p_skill_desc: String):
  pet_id = p_id
  pet_name = p_name
  species = p_species
  max_hp = stats.get("hp", 100)
  current_hp = max_hp
  atk = stats.get("atk", 10)
  def_stat = stats.get("def", 10)
  spd = stats.get("spd", 10)
  skill_name = p_skill_name
  skill_desc = p_skill_desc

func take_damage(amount: int) -> void:
  current_hp = max(0, current_hp - amount)

func is_alive() -> bool:
  return current_hp > 0