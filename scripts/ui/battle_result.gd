extends Control

signal result_closed()

@onready var title_label: Label = /TitleLabel
@onready var xp_label: Label = /XpLabel
@onready var gold_label: Label = /GoldLabel
@onready var item_label: Label = /ItemLabel
@onready var level_up_label: Label = /LevelUpLabel
@onready var continue_btn: Button = /ContinueBtn

func _ready():
  continue_btn.pressed.connect(_on_continue)
  level_up_label.visible = false

func setup_victory(xp: int, gold: int, item_drop = null, did_level_up: bool = false) -> void:
  title_label.text = "VICTORY!"
  title_label.modulate = Color.GOLD
  xp_label.text = "EXP Gained: +" + str(xp)
  gold_label.text = "Gold Gained: +" + str(gold)
  if item_drop:
    item_label.text = "Item Dropped: " + item_drop
  else:
    item_label.text = "No item dropped"
  if did_level_up:
    level_up_label.visible = true
    level_up_label.text = "LEVEL UP!"

func setup_defeat() -> void:
  title_label.text = "DEFEAT"
  title_label.modulate = Color.RED
  xp_label.text = "No rewards"
  gold_label.text = ""
  item_label.text = ""

func _on_continue() -> void:
  result_closed.emit()
  get_tree().change_scene_to_file("res://scenes/town.tscn")