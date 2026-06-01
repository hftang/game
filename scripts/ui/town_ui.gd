extends Control

@onready var adventure_btn: Button = $VBoxContainer/AdventureBtn
@onready var shop_btn: Button = $VBoxContainer/ShopBtn
@onready var inventory_btn: Button = $VBoxContainer/InventoryBtn
@onready var quests_btn: Button = $VBoxContainer/QuestsBtn
@onready var profile_btn: Button = $VBoxContainer/ProfileBtn
@onready var recharge_btn: Button = $VBoxContainer/RechargeBtn
@onready var coin_label: Label = $CoinLabel
@onready var level_label: Label = $LevelLabel

func _ready():
  adventure_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn"))
  shop_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/shop.tscn"))
  inventory_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/inventory.tscn"))
  quests_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/quest_log.tscn"))
  profile_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/profile.tscn"))
  recharge_btn.pressed.connect(_on_recharge)
  _update_display()

func _update_display() -> void:
  coin_label.text = "Ori Coin: " + str(GameManager.ori_coin)
  level_label.text = "Lv." + str(GameManager.level) + " " + GameManager.player_name

func _on_recharge() -> void:
  get_tree().change_scene_to_file("res://scenes/ui/recharge.tscn")