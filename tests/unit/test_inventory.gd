extends GutTest

func test_equipment_creation():
  var sword = Equipment.new("w_test", "Test Sword", "weapon", Item.Quality.COMMON, "Test", 100, {"atk": 10})
  assert_eq(sword.item_name, "Test Sword")
  assert_eq(sword.atk_bonus, 10)
  assert_eq(sword.item_type, "weapon")

func test_equip_weapon():
  var char = GameCharacter.new("Test", CharacterClass.ClassType.OGUN_WARRIOR)
  var sword = Equipment.new("w_test", "Test Sword", "weapon", Item.Quality.COMMON, "Test", 100, {"atk": 10})
  char.equip(sword)
  assert_eq(char.get_total_atk(), 35)

func test_quality_colors():
  var common = Item.new("test", "Test", "weapon", Item.Quality.COMMON, "", 0)
  assert_eq(common.get_quality_color(), Color.WHITE)

func test_equipment_database():
  var all_items = EquipmentDatabase.get_all_equipment()
  assert_eq(all_items.size(), 14)
  var sword = EquipmentDatabase.get_by_id("w_iron_sword")
  assert_not_null(sword)
  assert_eq(sword.item_name, "Iron Sword")