class_name GameCharacter
extends RefCounted

var character_name: String
var class_type: CharacterClass.ClassType
var level: int = 1
var exp: int = 0
var max_hp: int
var current_hp: int
var max_mp: int
var current_mp: int
var base_atk: int
var base_def: int
var base_spd: int
var base_mag: int
var equipment: Dictionary = {"weapon": null, "armor": null, "accessory": null}
var skills: Array = []
var is_alive: bool = true

func _init(p_name: String, p_class: CharacterClass.ClassType):
  character_name = p_name
  class_type = p_class
  var stats = CharacterClass.get_base_stats(p_class)
  max_hp = stats.hp
  current_hp = max_hp
  max_mp = stats.mp
  current_mp = max_mp
  base_atk = stats.atk
  base_def = stats.def
  base_spd = stats.spd
  base_mag = stats.mag

func get_total_atk() -> int:
  var bonus = 0
  if equipment.weapon:
    bonus += equipment.weapon.atk_bonus
  return base_atk + bonus

func get_total_def() -> int:
  var bonus = 0
  if equipment.armor:
    bonus += equipment.armor.def_bonus
  return base_def + bonus

func get_total_spd() -> int:
  return base_spd

func get_total_mag() -> int:
  return base_mag

func take_damage(amount: int) -> void:
  current_hp = max(0, current_hp - amount)
  if current_hp <= 0:
    is_alive = false

func heal(amount: int) -> void:
  current_hp = min(max_hp, current_hp + amount)

func use_mp(amount: int) -> bool:
  if current_mp >= amount:
    current_mp -= amount
    return true
  return false

func equip(item) -> void:
  if item.item_type == "weapon":
    equipment.weapon = item
  elif item.item_type == "armor":
    equipment.armor = item
  elif item.item_type == "accessory":
    equipment.accessory = item

func add_skill(skill) -> void:
  skills.append(skill)