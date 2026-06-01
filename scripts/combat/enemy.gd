class_name Enemy
extends GameCharacter

var enemy_id: String
var xp_reward: int
var gold_reward: int
var drop_table: Array

func _init(p_id: String, p_name: String, p_class: CharacterClass.ClassType, p_level: int, p_xp: int, p_gold: int, p_drops: Array = []):
  super(p_name, p_class)
  enemy_id = p_id
  level = p_level
  xp_reward = p_xp
  gold_reward = p_gold
  drop_table = p_drops
  _scale_stats()

func _scale_stats() -> void:
  var mult = 1.0 + (level - 1) * 0.15
  max_hp = int(max_hp * mult)
  current_hp = max_hp
  max_mp = int(max_mp * mult)
  current_mp = max_mp
  base_atk = int(base_atk * mult)
  base_def = int(base_def * mult)
  base_mag = int(base_mag * mult)