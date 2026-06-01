class_name EnemyDatabase
extends RefCounted

static func create_enemy(enemy_id: String, level_override: int = -1) -> Enemy:
  var template = _get_template(enemy_id)
  if template.is_empty():
    return null
  var lvl = level_override if level_override > 0 else template.level
  return Enemy.new(template.id, template.name, template.cls, lvl, template.xp, template.gold, template.drops)

static func _get_template(id: String) -> Dictionary:
  var templates = {
    "e_hyena": {"id": "e_hyena", "name": "Hyena", "cls": CharacterClass.ClassType.OGUN_WARRIOR, "level": 1, "xp": 20, "gold": 10, "drops": []},
    "e_scorpion": {"id": "e_scorpion", "name": "Giant Scorpion", "cls": CharacterClass.ClassType.ESHU_SCOUT, "level": 2, "xp": 35, "gold": 15, "drops": ["a_leather_vest"]},
    "e_cobra": {"id": "e_cobra", "name": "Spitting Cobra", "cls": CharacterClass.ClassType.ESHU_SCOUT, "level": 2, "xp": 30, "gold": 12, "drops": []},
    "e_bandit": {"id": "e_bandit", "name": "Desert Bandit", "cls": CharacterClass.ClassType.OGUN_WARRIOR, "level": 3, "xp": 50, "gold": 25, "drops": ["w_iron_sword"]},
    "e_witch": {"id": "e_witch", "name": "Forest Witch", "cls": CharacterClass.ClassType.SHANGO_MAGE, "level": 3, "xp": 55, "gold": 20, "drops": ["w_thunder_staff"]},
    "e_spirit": {"id": "e_spirit", "name": "Ancestral Spirit", "cls": CharacterClass.ClassType.OSHUN_HEALER, "level": 4, "xp": 70, "gold": 30, "drops": ["a_river_robe"]},
    "e_boss_oshun": {"id": "e_boss_oshun", "name": "Corrupted Olokun", "cls": CharacterClass.ClassType.SHANGO_MAGE, "level": 5, "xp": 200, "gold": 100, "drops": ["w_oguns_hammer", "a_shango_vestment"]}
  }
  return templates.get(id, {})

static func get_enemies_for_level(level_id: String) -> Array:
  match level_id:
    "lv_savanna": return ["e_hyena", "e_scorpion", "e_cobra"]
    "lv_desert": return ["e_bandit", "e_scorpion", "e_cobra"]
    "lv_forest": return ["e_witch", "e_spirit", "e_hyena"]
    "lv_boss": return ["e_boss_oshun"]
  return []