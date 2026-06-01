extends Control

@onready var quest_list: VBoxContainer = $VBoxContainer/QuestList
@onready var back_btn: Button = $VBoxContainer/BackBtn

func _ready():
  back_btn.pressed.connect(_on_back)
  _populate()

func _populate():
  for child in quest_list.get_children():
    child.queue_free()
  var quests = [
    {"name": "First Blood", "desc": "Defeat 1 enemy", "status": "Active"},
    {"name": "Hyena Hunter", "desc": "Defeat 5 hyenas", "status": "Available"},
    {"name": "Savanna Clear", "desc": "Clear Savanna level", "status": "Available"}
  ]
  for quest in quests:
    var hbox = HBoxContainer.new()
    var label = Label.new()
    label.text = quest.name + " [" + quest.status + "]"
    label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hbox.add_child(label)
    quest_list.add_child(hbox)

func _on_back():
  get_tree().change_scene_to_file("res://scenes/town.tscn")