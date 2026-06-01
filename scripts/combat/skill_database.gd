class_name SkillDatabase
extends RefCounted

static var all_skills: Array = [
  Skill.new("s_iron_strike", "Iron Strike", 10, 1.5, false, false, "Powerful physical strike", CharacterClass.ClassType.OGUN_WARRIOR, 1),
  Skill.new("s_war_cry", "War Cry", 15, 0, false, false, "Boost team ATK", CharacterClass.ClassType.OGUN_WARRIOR, 3),
  Skill.new("s_shield_wall", "Shield Wall", 20, 0, false, false, "Reduce damage by 50%", CharacterClass.ClassType.OGUN_WARRIOR, 5),
  Skill.new("s_oguns_wrath", "Oguns Wrath", 40, 2.5, false, false, "Devastating attack", CharacterClass.ClassType.OGUN_WARRIOR, 8),
  Skill.new("s_thunder_bolt", "Thunder Bolt", 15, 1.8, true, false, "Lightning magic attack", CharacterClass.ClassType.SHANGO_MAGE, 1),
  Skill.new("s_flame_wave", "Flame Wave", 20, 1.5, true, false, "Fire AOE damage", CharacterClass.ClassType.SHANGO_MAGE, 3),
  Skill.new("s_mana_surge", "Mana Surge", 0, 0, false, false, "Restore 30 MP", CharacterClass.ClassType.SHANGO_MAGE, 5),
  Skill.new("s_shango_judgment", "Shango Judgment", 50, 3.0, true, false, "Massive lightning damage", CharacterClass.ClassType.SHANGO_MAGE, 8),
  Skill.new("s_healing_spring", "Healing Spring", 15, 1.5, true, true, "Heal single ally", CharacterClass.ClassType.OSHUN_HEALER, 1),
  Skill.new("s_purify", "Purify", 20, 0, false, false, "Remove debuffs", CharacterClass.ClassType.OSHUN_HEALER, 3),
  Skill.new("s_blessing_of_oshun", "Blessing of Oshun", 30, 1.0, true, true, "Heal all allies", CharacterClass.ClassType.OSHUN_HEALER, 5),
  Skill.new("s_river_shield", "River Shield", 25, 0, false, false, "Absorb 100 damage", CharacterClass.ClassType.OSHUN_HEALER, 8),
  Skill.new("s_quick_strike", "Quick Strike", 8, 1.3, false, false, "Fast attack, always first", CharacterClass.ClassType.ESHU_SCOUT, 1),
  Skill.new("s_tricksters_mock", "Tricksters Mock", 12, 0, false, false, "Reduce target DEF 30%", CharacterClass.ClassType.ESHU_SCOUT, 3),
  Skill.new("s_shadow_step", "Shadow Step", 15, 0, false, false, "Increase SPD 50%", CharacterClass.ClassType.ESHU_SCOUT, 5),
  Skill.new("s_eshus_mischief", "Eshus Mischief", 35, 2.0, false, false, "Attack all enemies", CharacterClass.ClassType.ESHU_SCOUT, 8)
]

static func get_skills_for_class(class_type: CharacterClass.ClassType) -> Array:
  return all_skills.filter(func(s): return s.required_class == class_type)

static func get_by_id(id: String):
  for skill in all_skills:
    if skill.skill_id == id:
      return skill
  return null

static func get_available_skills(class_type: CharacterClass.ClassType, level: int) -> Array:
  return all_skills.filter(func(s): return s.required_class == class_type and s.required_level <= level)