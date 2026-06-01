extends Control

@onready var item_list: VBoxContainer = $VBoxContainer/ItemList
@onready var coin_label: Label = $VBoxContainer/CoinLabel
@onready var back_btn: Button = $VBoxContainer/BackBtn

var gm: Node = null
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
    gm = get_node_or_null("/root/GameManager")
    back_btn.pressed.connect(_on_back)
    _populate()

func _populate():
    var coins = gm.get("ori_coin") if gm else 0
    coin_label.text = "Ori Coin: " + str(coins)
    for child in item_list.get_children():
        child.queue_free()
    for i in range(items.size()):
        var item = items[i]
        var hbox = HBoxContainer.new()
        var label = Label.new()
        label.text = item.name + " - " + str(item.price) + " OC"
        label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        label.add_theme_font_size_override("font_size", 18)
        hbox.add_child(label)
        var btn = Button.new()
        btn.text = "Buy"
        btn.pressed.connect(_on_buy.bind(i))
        hbox.add_child(btn)
        item_list.add_child(hbox)

func _on_buy(index: int):
    var item = items[index]
    var coins = gm.get("ori_coin") if gm else 0
    if coins >= item.price:
        if gm:
            gm.set("ori_coin", coins - item.price)
        coin_label.text = "Ori Coin: " + str(gm.get("ori_coin") if gm else 0)
    else:
        coin_label.text = "Not enough!"

func _on_back():
    get_tree().change_scene_to_file("res://scenes/town.tscn")