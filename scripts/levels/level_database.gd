class_name LevelDatabase
extends RefCounted

static var all_levels: Array = [
  {"id": "lv_savanna", "name": "Savanna Outskirts", "description": "Grasslands beyond Ile-Ife. Hyenas and scorpions patrol.", "required_level": 1, "enemy_count": 3, "xp_bonus": 0, "gold_bonus": 0},
  {"id": "lv_desert", "name": "Sahara Crossing", "description": "The harsh desert. Bandits lurk behind every dune.", "required_level": 3, "enemy_count": 3, "xp_bonus": 10, "gold_bonus": 5},
  {"id": "lv_forest", "name": "Sacred Forest", "description": "Ancient forest where spirits dwell. Dark magic corrupts the trees.", "required_level": 5, "enemy_count": 3, "xp_bonus": 20, "gold_bonus": 10},
  {"id": "lv_boss", "name": "Olokuns Lair", "description": "The corrupted sea god awaits. Prove your worth to the Orishas.", "required_level": 7, "enemy_count": 1, "xp_bonus": 50, "gold_bonus": 30}
]

static func get_level(level_id: String) -> Dictionary:
  for level in all_levels:
    if level.id == level_id:
      return level
  return {}

static func get_available_levels(player_level: int) -> Array:
  return all_levels.filter(func(l): return l.required_level <= player_level)