extends Control

@onready var item_grid: GridContainer = /ItemGrid
@onready var equip_button: Button = /EquipButton
@onready var use_button: Button = /UseButton

var inventory: Array = []
var selected_item: Item

func _ready():
  equip_button.pressed.connect(_on_equip_pressed)
  use_button.pressed.connect(_on_use_pressed)

func setup(items: Array) -> void:
  inventory = items
  _populate_grid()

func _populate_grid():
  for child in item_grid.get_children():
    child.queue_free()
  for item_data in inventory:
    var btn = Button.new()
    btn.text = item_data.item_name
    btn.custom_minimum_size = Vector2(80, 80)
    btn.pressed.connect(_on_item_click.bind(item_data))
    item_grid.add_child(btn)

func _on_item_click(item: Item) -> void:
  selected_item = item
  equip_button.visible = item is Equipment
  use_button.visible = item.item_type == "consumable"

func _on_equip_pressed() -> void:
  pass

func _on_use_pressed() -> void:
  pass