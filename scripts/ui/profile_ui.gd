extends Control

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var exp_label: Label = $VBoxContainer/ExpLabel
@onready var coin_label: Label = $VBoxContainer/CoinLabel
@onready var back_btn: Button = $VBoxContainer/BackBtn

func _ready():
  back_btn.pressed.connect(_on_back)
  name_label.text = "Name: " + GameManager.player_name
  level_label.text = "Level: " + str(GameManager.level)
  exp_label.text = "EXP: " + str(GameManager.exp) + "/" + str(GameManager.exp_to_next)
  coin_label.text = "Ori Coin: " + str(GameManager.ori_coin)

func _on_back():
  get_tree().change_scene_to_file("res://scenes/town.tscn")