class_name EquipmentDatabase
extends RefCounted

static var weapons: Array = [
  Equipment.new("w_iron_sword", "Iron Sword", "weapon", Item.Quality.COMMON, "A basic iron sword", 100, {"atk": 5}),
  Equipment.new("w_bronze_axe", "Bronze Axe", "weapon", Item.Quality.COMMON, "Heavy bronze axe", 150, {"atk": 8, "spd": -2}),
  Equipment.new("w_thunder_staff", "Thunder Staff", "weapon", Item.Quality.RARE, "Staff crackling with lightning", 300, {"mag": 12}),
  Equipment.new("w_sacred_bow", "Sacred Bow", "weapon", Item.Quality.RARE, "Blessed by Oshun", 280, {"atk": 10, "spd": 3}),
  Equipment.new("w_oguns_hammer", "Oguns Hammer", "weapon", Item.Quality.EPIC, "Legendary weapon of the forge god", 800, {"atk": 20, "hp": 50})
]

static var armors: Array = [
  Equipment.new("a_leather_vest", "Leather Vest", "armor", Item.Quality.COMMON, "Basic leather protection", 80, {"def": 3}),
  Equipment.new("a_iron_plate", "Iron Plate", "armor", Item.Quality.COMMON, "Heavy iron armor", 200, {"def": 8, "spd": -3}),
  Equipment.new("a_river_robe", "River Robe", "armor", Item.Quality.RARE, "Robe blessed by Oshun", 350, {"def": 5, "mp": 30}),
  Equipment.new("a_shadow_cloak", "Shadow Cloak", "armor", Item.Quality.RARE, "Increases evasion", 320, {"def": 4, "spd": 8}),
  Equipment.new("a_shango_vestment", "Shangos Vestment", "armor", Item.Quality.EPIC, "Armor of the thunder god", 900, {"def": 15, "mag": 10, "hp": 30})
]

static var accessories: Array = [
  Equipment.new("ac_speed_ring", "Speed Ring", "accessory", Item.Quality.COMMON, "Increases speed", 120, {"spd": 5}),
  Equipment.new("ac_hp_amulet", "HP Amulet", "accessory", Item.Quality.COMMON, "Increases max HP", 100, {"hp": 30}),
  Equipment.new("ac_mp_crystal", "MP Crystal", "accessory", Item.Quality.RARE, "Increases max MP", 250, {"mp": 50}),
  Equipment.new("ac_orisha_pendant", "Orisha Pendant", "accessory", Item.Quality.EPIC, "Balanced stat boost", 600, {"atk": 5, "def": 5, "spd": 5, "mag": 5})
]

static func get_all_equipment() -> Array:
  return weapons + armors + accessories

static func get_by_id(id: String):
  for item in get_all_equipment():
    if item.item_id == id:
      return item
  return null