extends Control

@onready var level_list: VBoxContainer = $VBoxContainer/LevelList
@onready var level_desc: Label = $VBoxContainer/LevelDesc
@onready var level_req: Label = $VBoxContainer/LevelReq
@onready var enter_btn: Button = $VBoxContainer/EnterBtn
@onready var back_btn: Button = $VBoxContainer/BackBtn

var selected_level: Dictionary = {}

func _ready():
  back_btn.pressed.connect(_on_back_pressed)
  enter_btn.pressed.connect(_on_enter_pressed)
  enter_btn.visible = false
  _populate_levels()

func _populate_levels() -> void:
  for child in level_list.get_children():
    child.queue_free()
  var levels = [
    {"id": "lv1", "name": "Savanna Outskirts", "desc": "Hyenas and scorpions.", "req": 1},
    {"id": "lv2", "name": "Sahara Crossing", "desc": "Bandits in the desert.", "req": 3},
    {"id": "lv3", "name": "Sacred Forest", "desc": "Spirits and witches.", "req": 5},
    {"id": "lv4", "name": "Olokuns Lair", "desc": "The final boss.", "req": 7}
  ]
  for level in levels:
    var btn = Button.new()
    var locked = level.req > GameManager.level
    if locked:
      btn.text = level.name + " [LOCKED Lv." + str(level.req) + "]"
      btn.disabled = true
    else:
      btn.text = level.name
      btn.pressed.connect(_on_level_pressed.bind(level))
    level_list.add_child(btn)

func _on_level_pressed(level: Dictionary) -> void:
  selected_level = level
  level_desc.text = level.desc
  enter_btn.visible = true

func _on_enter_pressed() -> void:
  if not selected_level.is_empty():
    get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_back_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/town.tscn")