class_name EshuScout
extends GameCharacter

func _init(p_name: String):
  super(p_name, CharacterClass.ClassType.ESHU_SCOUT)
  skills = [
    {"name": "Quick Strike", "mp_cost": 8, "multiplier": 1.3, "is_magic": false, "is_heal": false},
    {"name": "Tricksters Mock", "mp_cost": 12, "multiplier": 0, "is_magic": false, "is_heal": false},
    {"name": "Shadow Step", "mp_cost": 15, "multiplier": 0, "is_magic": false, "is_heal": false},
    {"name": "Eshus Mischief", "mp_cost": 35, "multiplier": 2.0, "is_magic": false, "is_heal": false}
  ]