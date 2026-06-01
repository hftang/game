extends Control

@onready var name_label: Label = /NameLabel
@onready var class_label: Label = /ClassLabel
@onready var level_label: Label = /LevelLabel
@onready var exp_label: Label = /ExpLabel
@onready var coin_label: Label = /CoinLabel
@onready var stats_label: Label = /StatsLabel
@onready var equip_label: Label = /EquipLabel
@onready var back_btn: Button = /BackBtn

var character: GameCharacter

func _ready():
  back_btn.pressed.connect(_on_back_pressed)

func setup(char: GameCharacter, p_level: int, p_exp: int, p_coin: int) -> void:
  character = char
  name_label.text = "Name: " + char.character_name
  class_label.text = "Class: " + CharacterClass.get_class_name(char.class_type)
  level_label.text = "Level: " + str(p_level)
  exp_label.text = "EXP: " + str(p_exp)
  coin_label.text = "Ori Coin: " + str(p_coin)
  stats_label.text = "HP: " + str(char.max_hp) + " | MP: " + str(char.max_mp) + " | ATK: " + str(char.base_atk) + " | DEF: " + str(char.base_def) + " | SPD: " + str(char.base_spd) + " | MAG: " + str(char.base_mag)
  var weapon = char.equipment.weapon
  var armor = char.equipment.armor
  equip_label.text = "Weapon: " + (weapon.item_name if weapon else "None") + " | Armor: " + (armor.item_name if armor else "None")

func _on_back_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/town.tscn")