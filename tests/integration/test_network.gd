extends GutTest

func test_character_creation():
  var char = GameCharacter.new("TestChar", CharacterClass.ClassType.OGUN_WARRIOR)
  assert_not_null(char)
  assert_eq(char.character_name, "TestChar")

func test_battle_flow():
  var player = GameCharacter.new("Player", CharacterClass.ClassType.OGUN_WARRIOR)
  var enemy = GameCharacter.new("Enemy", CharacterClass.ClassType.OGUN_WARRIOR)
  var battle = BattleManager.new()
  battle.setup_battle([player], [enemy])
  var first_turn = battle.start_turn()
  assert_not_null(first_turn)
  var damage = battle.perform_attack(player, enemy)
  assert_gt(damage, 0)

func test_shop_purchase():
  var item = Item.new("test", "Test", "weapon", Item.Quality.COMMON, "", 100)
  var shop = ShopManager.new(null)
  assert_true(shop.buy_item(item, 200))
  assert_false(shop.buy_item(item, 50))