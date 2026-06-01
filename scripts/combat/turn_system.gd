class_name TurnSystem
extends RefCounted

var combatants: Array = []
var current_index: int = 0

func setup(battle_combatants: Array) -> void:
  combatants = battle_combatants.duplicate()
  combatants.sort_custom(func(a, b): return a.get_total_spd() > b.get_total_spd())
  current_index = 0

func get_current() -> GameCharacter:
  if combatants.is_empty():
    return null
  return combatants[current_index]

func advance() -> GameCharacter:
  current_index = (current_index + 1) % combatants.size()
  return get_current()

func remove_dead() -> void:
  combatants = combatants.filter(func(c): return c.is_alive)