extends Control

@onready var item_list: VBoxContainer = $VBoxContainer/ItemList
@onready var coin_label: Label = $VBoxContainer/CoinLabel
@onready var back_btn: Button = $VBoxContainer/BackBtn

var items = [
  {"name": "Iron Sword", "price": 100, "atk": 5},
  {"name": "Bronze Axe", "price": 150, "atk": 8},
  {"name": "Thunder Staff", "price": 300, "atk": 12},
  {"name": "Leather Vest", "price": 80, "def": 3},
  {"name": "Iron Plate", "price": 200, "def": 8},
  {"name": "HP Potion", "price": 30, "heal": 50},
  {"name": "MP Potion", "price": 25, "mp": 30}
]

func _ready():
  back_btn.pressed.connect(_on_back)
  _populate()

func _populate():
  coin_label.text = "Ori Coin: " + str(GameManager.ori_coin)
  for child in item_list.get_children():
    child.queue_free()
  for i in range(items.size()):
    var item = items[i]
    var hbox = HBoxContainer.new()
    var label = Label.new()
    label.text = item.name + " - " + str(item.price) + " OC"
    label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(label)
    var btn = Button.new()
    btn.text = "Buy"
    btn.pressed.connect(_on_buy.bind(i))
    hbox.add_child(btn)
    item_list.add_child(hbox)

func _on_buy(index: int):
  var item = items[index]
  if GameManager.ori_coin >= item.price:
    GameManager.ori_coin -= item.price
    coin_label.text = "Ori Coin: " + str(GameManager.ori_coin)
  else:
    coin_label.text = "Not enough!"

func _on_back():
  get_tree().change_scene_to_file("res://scenes/town.tscn")