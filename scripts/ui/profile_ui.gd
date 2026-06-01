extends Control

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var exp_label: Label = $VBoxContainer/ExpLabel
@onready var coin_label: Label = $VBoxContainer/CoinLabel
@onready var back_btn: Button = $VBoxContainer/BackBtn

var gm: Node = null

func _ready():
    gm = get_node_or_null("/root/GameManager")
    back_btn.pressed.connect(_on_back)
    var pname = gm.get("player_name") if gm else "Hero"
    var lvl = gm.get("level") if gm else 1
    var exp = gm.get("exp") if gm else 0
    var exp_next = gm.get("exp_to_next") if gm else 100
    var coins = gm.get("ori_coin") if gm else 0
    name_label.text = "Name: " + str(pname)
    level_label.text = "Level: " + str(lvl)
    exp_label.text = "EXP: " + str(exp) + "/" + str(exp_next)
    coin_label.text = "Ori Coin: " + str(coins)

func _on_back():
    get_tree().change_scene_to_file("res://scenes/town.tscn")