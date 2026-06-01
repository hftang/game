extends Control

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var xp_label: Label = $VBoxContainer/XpLabel
@onready var gold_label: Label = $VBoxContainer/GoldLabel
@onready var continue_btn: Button = $VBoxContainer/ContinueBtn

func _ready():
  continue_btn.pressed.connect(_on_continue)

func setup_victory(xp: int, gold: int) -> void:
  title_label.text = "VICTORY!"
  title_label.modulate = Color.GOLD
  xp_label.text = "EXP Gained: +" + str(xp)
  gold_label.text = "Gold Gained: +" + str(gold)

func setup_defeat() -> void:
  title_label.text = "DEFEAT"
  title_label.modulate = Color.RED
  xp_label.text = "No rewards"
  gold_label.text = ""

func _on_continue() -> void:
  get_tree().change_scene_to_file("res://scenes/town.tscn")