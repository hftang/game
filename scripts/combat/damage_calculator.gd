class_name DamageCalculator
extends RefCounted

enum Element { PHYSICAL, FIRE, WATER, LIGHTNING, EARTH }

static func calculate_damage(attacker: GameCharacter, defender: GameCharacter, skill = null) -> int:
  var base_damage: int
  if skill and skill.is_magic:
    base_damage = int(attacker.get_total_mag() * skill.multiplier) - defender.get_total_def() / 2
  else:
    base_damage = attacker.get_total_atk() - defender.get_total_def()
  base_damage = max(1, base_damage)
  var variance = randf_range(0.9, 1.1)
  base_damage = int(base_damage * variance)
  return max(1, base_damage)

static func get_elemental_multiplier(attack_element: Element, defender_element: Element) -> float:
  if attack_element == Element.LIGHTNING and defender_element == Element.WATER:
    return 1.5
  if attack_element == Element.WATER and defender_element == Element.FIRE:
    return 1.5
  if attack_element == Element.FIRE and defender_element == Element.LIGHTNING:
    return 1.5
  return 1.0