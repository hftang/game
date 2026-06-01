class_name OgunWarrior
extends GameCharacter

func _init(p_name: String):
  super(p_name, CharacterClass.ClassType.OGUN_WARRIOR)
  skills = [
    {"name": "Iron Strike", "mp_cost": 10, "multiplier": 1.5, "is_magic": false, "is_heal": false},
    {"name": "War Cry", "mp_cost": 15, "multiplier": 0, "is_magic": false, "is_heal": false},
    {"name": "Shield Wall", "mp_cost": 20, "multiplier": 0, "is_magic": false, "is_heal": false},
    {"name": "Oguns Wrath", "mp_cost": 40, "multiplier": 2.5, "is_magic": false, "is_heal": false}
  ]