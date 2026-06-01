extends Control

@onready var adventure_btn: Button = /AdventureBtn
@onready var shop_btn: Button = /ShopBtn
@onready var inventory_btn: Button = /InventoryBtn
@onready var quests_btn: Button = /QuestsBtn
@onready var profile_btn: Button = /ProfileBtn
@onready var chat_btn: Button = /ChatBtn
@onready var recharge_btn: Button = /RechargeBtn
@onready var coin_label: Label = 
@onready var level_label: Label = 

func _ready():
  adventure_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn"))
  shop_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/shop.tscn"))
  inventory_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/inventory.tscn"))
  quests_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/quest_log.tscn"))
  profile_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/profile.tscn"))
  chat_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/chat.tscn"))
  recharge_btn.pressed.connect(_on_recharge)
  _update_display()

func _update_display() -> void:
  coin_label.text = "Ori Coin: " + str(GameManager.ori_coin)
  level_label.text = "Lv." + str(GameManager.level) + " " + GameManager.player_name

func _on_recharge() -> void:
  # TODO: Open recharge dialog
  pass