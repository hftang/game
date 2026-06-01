extends Control

@onready var item_list: VBoxContainer = $VBoxContainer/ItemList
@onready var back_btn: Button = $VBoxContainer/BackBtn

func _ready():
  back_btn.pressed.connect(_on_back)
  _populate()

func _populate():
  for child in item_list.get_children():
    child.queue_free()
  var label = Label.new()
  label.text = "Inventory is empty"
  item_list.add_child(label)

func _on_back():
  get_tree().change_scene_to_file("res://scenes/town.tscn")