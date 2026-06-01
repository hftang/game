extends Control

signal level_selected(level_id: String)

@onready var level_list: VBoxContainer = /LevelList
@onready var level_desc: Label = /LevelDesc
@onready var level_req: Label = /LevelReq
@onready var enter_btn: Button = /EnterBtn
@onready var back_btn: Button = /BackBtn

var selected_level: Dictionary = {}
var player_level: int = 1

func _ready():
  enter_btn.pressed.connect(_on_enter_pressed)
  back_btn.pressed.connect(_on_back_pressed)
  enter_btn.visible = false

func setup(p_level: int) -> void:
  player_level = p_level
  _populate_levels()

func _populate_levels() -> void:
  for child in level_list.get_children():
    child.queue_free()
  var levels = LevelDatabase.get_available_levels(player_level)
  for level in levels:
    var btn = Button.new()
    btn.text = level.name + " (Lv." + str(level.required_level) + ")"
    btn.pressed.connect(_on_level_pressed.bind(level))
    level_list.add_child(btn)
  # Show locked levels too
  for level in LevelDatabase.all_levels:
    if level.required_level > player_level:
      var btn = Button.new()
      btn.text = level.name + " [LOCKED - Lv." + str(level.required_level) + "]"
      btn.disabled = true
      level_list.add_child(btn)

func _on_level_pressed(level: Dictionary) -> void:
  selected_level = level
  level_desc.text = level.description
  level_req.text = "Enemies: " + str(level.enemy_count) + " | Bonus XP: +" + str(level.xp_bonus)
  enter_btn.visible = true

func _on_enter_pressed() -> void:
  if not selected_level.is_empty():
    level_selected.emit(selected_level.id)

func _on_back_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/town.tscn")