extends Control

@onready var item_list: ItemList = /ItemList
@onready var buy_button: Button = /BuyButton
@onready var coin_label: Label = /CoinLabel

var shop: ShopManager
var selected_item: Item

func _ready():
  buy_button.pressed.connect(_on_buy_pressed)
  item_list.item_selected.connect(_on_item_selected)

func setup(shop_manager: ShopManager) -> void:
  shop = shop_manager
  _populate_items()

func _populate_items():
  item_list.clear()
  var items = shop.get_shop_items()
  for item in items:
    var index = item_list.add_item(item.item_name + " - " + str(item.price) + " Ori Coin")
    item_list.set_item_metadata(index, item)

func _on_item_selected(index: int) -> void:
  selected_item = item_list.get_item_metadata(index)

func _on_buy_pressed() -> void:
  if selected_item:
    pass

func update_coin_display(amount: int) -> void:
  coin_label.text = "Ori Coin: " + str(amount)