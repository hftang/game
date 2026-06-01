extends Control

@onready var adventure_btn: Button = $VBoxContainer/AdventureBtn
@onready var shop_btn: Button = $VBoxContainer/ShopBtn
@onready var inventory_btn: Button = $VBoxContainer/InventoryBtn
@onready var quests_btn: Button = $VBoxContainer/QuestsBtn
@onready var profile_btn: Button = $VBoxContainer/ProfileBtn
@onready var chat_btn: Button = $VBoxContainer/ChatBtn
@onready var recharge_btn: Button = $VBoxContainer/RechargeBtn
@onready var coin_label: Label = $CoinLabel
@onready var level_label: Label = $LevelLabel

var gm: Node = null

func _ready():
    gm = get_node_or_null("/root/GameManager")
    adventure_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn"))
    shop_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/shop.tscn"))
    inventory_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/inventory.tscn"))
    quests_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/quest_log.tscn"))
    profile_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/profile.tscn"))
    chat_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/chat.tscn"))
    recharge_btn.pressed.connect(_on_recharge)
    _update_display()

func _update_display() -> void:
    var coins = gm.get("ori_coin") if gm else 0
    var lvl = gm.get("level") if gm else 1
    var pname = gm.get("player_name") if gm else "Hero"
    coin_label.text = "Ori Coin: " + str(coins)
    level_label.text = "Lv." + str(lvl) + " " + str(pname)

func _on_recharge() -> void:
    if gm:
        gm.set("ori_coin", gm.get("ori_coin") + 500)
    _update_display()