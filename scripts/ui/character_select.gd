extends Control

@onready var name_input: LineEdit = $VBoxContainer/NameInput
@onready var class_buttons: VBoxContainer = $VBoxContainer/ClassButtons
@onready var create_button: Button = $VBoxContainer/CreateButton
@onready var class_desc: Label = $VBoxContainer/ClassDescription

var gm: Node = null
var selected_class_index: int = 0
var class_names = ["Ogun Warrior", "Shango Mage", "Oshun Healer", "Eshu Scout"]
var class_descs = ["High HP, strong physical attacks. Tank.", "Powerful magic. Glass cannon.", "Healing and support.", "Fast and tricky. Debuff."]

func _ready():
    gm = get_node_or_null("/root/GameManager")
    create_button.pressed.connect(_on_create_pressed)
    _setup_class_buttons()

func _setup_class_buttons():
    for i in range(class_names.size()):
        var btn = Button.new()
        btn.text = class_names[i]
        btn.custom_minimum_size = Vector2(0, 45)
        btn.pressed.connect(_on_class_selected.bind(i))
        class_buttons.add_child(btn)

func _on_class_selected(index: int):
    selected_class_index = index
    class_desc.text = class_descs[index]

func _on_create_pressed():
    var char_name = name_input.text.strip_edges()
    if char_name.is_empty():
        class_desc.text = "Please enter a name!"
        return
    if gm:
        gm.set("player_name", char_name)
        gm.set("level", 1)
        gm.set("exp", 0)
        gm.set("ori_coin", 100)
    get_tree().change_scene_to_file("res://scenes/town.tscn")