class_name CharacterClass
extends RefCounted

enum ClassType {
  OGUN_WARRIOR,
  SHANGO_MAGE,
  OSHUN_HEALER,
  ESHU_SCOUT
}

static func get_class_name(type: ClassType) -> String:
  match type:
    ClassType.OGUN_WARRIOR: return "Ogun Warrior"
    ClassType.SHANGO_MAGE: return "Shango Mage"
    ClassType.OSHUN_HEALER: return "Oshun Healer"
    ClassType.ESHU_SCOUT: return "Eshu Scout"
  return "Unknown"

static func get_base_stats(type: ClassType) -> Dictionary:
  match type:
    ClassType.OGUN_WARRIOR:
      return {"hp": 150, "mp": 50, "atk": 25, "def": 20, "spd": 10, "mag": 5}
    ClassType.SHANGO_MAGE:
      return {"hp": 80, "mp": 120, "atk": 8, "def": 10, "spd": 12, "mag": 25}
    ClassType.OSHUN_HEALER:
      return {"hp": 100, "mp": 100, "atk": 10, "def": 15, "spd": 11, "mag": 20}
    ClassType.ESHU_SCOUT:
      return {"hp": 90, "mp": 70, "atk": 18, "def": 12, "spd": 25, "mag": 10}
  return {}