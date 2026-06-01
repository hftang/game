extends GutTest

func test_item_price():
  var item = Item.new("test", "Test Item", "weapon", Item.Quality.COMMON, "Test", 100)
  assert_eq(item.price, 100)

func test_quality_enum():
  assert_eq(Item.Quality.COMMON, 0)
  assert_eq(Item.Quality.RARE, 1)
  assert_eq(Item.Quality.EPIC, 2)
  assert_eq(Item.Quality.LEGENDARY, 3)

func test_buy_item_insufficient_coin():
  var shop = ShopManager.new(null)
  var item = Item.new("test", "Test", "weapon", Item.Quality.COMMON, "", 100)
  assert_false(shop.buy_item(item, 50))

func test_buy_item_sufficient_coin():
  var shop = ShopManager.new(null)
  var item = Item.new("test", "Test", "weapon", Item.Quality.COMMON, "", 100)
  assert_true(shop.buy_item(item, 150))