class_name ShangoMage
extends GameCharacter

func _init(p_name: String):
  super(p_name, CharacterClass.ClassType.SHANGO_MAGE)
  skills = [
    {"name": "Thunder Bolt", "mp_cost": 15, "multiplier": 1.8, "is_magic": true, "is_heal": false},
    {"name": "Flame Wave", "mp_cost": 20, "multiplier": 1.5, "is_magic": true, "is_heal": false},
    {"name": "Mana Surge", "mp_cost": 0, "multiplier": 0, "is_magic": false, "is_heal": false},
    {"name": "Shango Judgment", "mp_cost": 50, "multiplier": 3.0, "is_magic": true, "is_heal": false}
  ]