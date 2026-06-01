extends Control

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var class_label: Label = $VBoxContainer/ClassLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var exp_label: Label = $VBoxContainer/ExpLabel
@onready var coin_label: Label = $VBoxContainer/CoinLabel
@onready var stats_label: Label = $VBoxContainer/StatsLabel
@onready var back_btn: Button = $VBoxContainer/BackBtn

func _ready():
  back_btn.pressed.connect(_on_back_pressed)
  _update_display()

func _update_display() -> void:
  name_label.text = "Name: " + GameManager.player_name
  class_label.text = "Level: " + str(GameManager.level)
  level_label.text = "EXP: " + str(GameManager.exp) + "/" + str(GameManager.exp_to_next)
  exp_label.text = "Ori Coin: " + str(GameManager.ori_coin)
  coin_label.text = "HP: " + str(GameManager.level * 10 + 90)
  stats_label.text = "ATK: " + str(GameManager.level * 2 + 13) + " | DEF: " + str(GameManager.level * 2 + 8)

func _on_back_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/town.tscn")