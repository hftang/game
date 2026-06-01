extends Control

signal level_selected(level_id: String)

@onready var level_list: VBoxContainer = $VBoxContainer/LevelList
@onready var level_desc: Label = $VBoxContainer/LevelDesc
@onready var level_req: Label = $VBoxContainer/LevelReq
@onready var enter_btn: Button = $VBoxContainer/EnterBtn
@onready var back_btn: Button = $VBoxContainer/BackBtn

var selected_level: Dictionary = {}
var player_level: int = 1

func _ready():
  enter_btn.pressed.connect(_on_enter_pressed)
  back_btn.pressed.connect(_on_back_pressed)
  enter_btn.visible = false
  player_level = GameManager.level
  _populate_levels()

func _populate_levels() -> void:
  for child in level_list.get_children():
    child.queue_free()
  for level in LevelDatabase.all_levels:
    var btn = Button.new()
    var locked = level.required_level > player_level
    if locked:
      btn.text = level.name + " [LOCKED Lv." + str(level.required_level) + "]"
      btn.disabled = true
    else:
      btn.text = level.name + " (Lv." + str(level.required_level) + ")"
      btn.pressed.connect(_on_level_pressed.bind(level))
    level_list.add_child(btn)

func _on_level_pressed(level: Dictionary) -> void:
  selected_level = level
  level_desc.text = level.description
  level_req.text = "Enemies: " + str(level.enemy_count)
  enter_btn.visible = true

func _on_enter_pressed() -> void:
  if not selected_level.is_empty():
    GameManager.change_state(GameManager.GameState.BATTLE)
    get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_back_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/town.tscn")