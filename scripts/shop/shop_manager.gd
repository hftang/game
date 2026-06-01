class_name ShopManager
extends RefCounted

signal purchase_success(item_id: String)
signal purchase_failed(error: String)

var network: Node

func _init(network_manager: Node):
  network = network_manager

func get_shop_items() -> Array:
  var items = []
  items.append_array(EquipmentDatabase.weapons)
  items.append_array(EquipmentDatabase.armors)
  items.append_array(EquipmentDatabase.accessories)
  return items

func buy_item(item: Item, player_coin: int) -> bool:
  if player_coin < item.price:
    purchase_failed.emit("Not enough Ori Coin")
    return false
  return true