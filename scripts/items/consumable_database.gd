class_name ConsumableDatabase
extends RefCounted

static var all_consumables: Array = [
  Consumable.new("c_hp_potion_s", "Small Health Potion", "Restores 50 HP", 30, 50, 0),
  Consumable.new("c_hp_potion_m", "Medium Health Potion", "Restores 150 HP", 80, 150, 0),
  Consumable.new("c_hp_potion_l", "Large Health Potion", "Restores 300 HP", 200, 300, 0),
  Consumable.new("c_mp_potion_s", "Small Mana Potion", "Restores 30 MP", 25, 0, 30),
  Consumable.new("c_mp_potion_m", "Medium Mana Potion", "Restores 80 MP", 60, 0, 80),
  Consumable.new("c_mp_potion_l", "Large Mana Potion", "Restores 150 MP", 150, 0, 150),
  Consumable.new("c_full_restore", "Orisha Blessing", "Fully restores HP and MP", 500, 9999, 9999),
  Consumable.new("c_atk_elixir", "Warriors Elixir", "Boosts ATK by 10 for next battle", 100),
  Consumable.new("c_def_elixir", "Guardians Elixir", "Boosts DEF by 10 for next battle", 100),
]

static func get_by_id(id: String):
  for item in all_consumables:
    if item.item_id == id:
      return item
  return null

static func get_all() -> Array:
  return all_consumables