class_name OshunHealer
extends GameCharacter

func _init(p_name: String):
  super(p_name, CharacterClass.ClassType.OSHUN_HEALER)
  skills = [
    {"name": "Healing Spring", "mp_cost": 15, "multiplier": 1.5, "is_magic": true, "is_heal": true},
    {"name": "Purify", "mp_cost": 20, "multiplier": 0, "is_magic": false, "is_heal": false},
    {"name": "Blessing of Oshun", "mp_cost": 30, "multiplier": 1.0, "is_magic": true, "is_heal": true},
    {"name": "River Shield", "mp_cost": 25, "multiplier": 0, "is_magic": false, "is_heal": false}
  ]