class_name BattleRewards
extends RefCounted

static func calculate_xp(enemy_level: int, num_enemies: int) -> int:
  return enemy_level * 20 * num_enemies

static func calculate_gold(enemy_level: int, num_enemies: int) -> int:
  return enemy_level * 10 * num_enemies

static func roll_item_drop(enemy_level: int):
  var drop_chance = randf()
  if drop_chance < 0.1:
    return "rare"
  elif drop_chance < 0.3:
    return "common"
  return null