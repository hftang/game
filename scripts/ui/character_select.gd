extends Control

signal character_created(char_name: String, class_type: CharacterClass.ClassType)

@onready var name_input: LineEdit = /NameInput
@onready var class_buttons: VBoxContainer = /ClassButtons
@onready var create_button: Button = /CreateButton
@onready var class_desc: Label = /ClassDescription

var selected_class: CharacterClass.ClassType = CharacterClass.ClassType.OGUN_WARRIOR

func _ready():
  create_button.pressed.connect(_on_create_pressed)
  _setup_class_buttons()

func _setup_class_buttons():
  var classes = [
    {"type": CharacterClass.ClassType.OGUN_WARRIOR, "name": "Ogun Warrior", "desc": "High HP, strong physical attacks. Tank/Melee DPS."},
    {"type": CharacterClass.ClassType.SHANGO_MAGE, "name": "Shango Mage", "desc": "Powerful lightning/fire magic. Glass cannon."},
    {"type": CharacterClass.ClassType.OSHUN_HEALER, "name": "Oshun Healer", "desc": "Healing and support. Keeps team alive."},
    {"type": CharacterClass.ClassType.ESHU_SCOUT, "name": "Eshu Scout", "desc": "Fast and tricky. Debuff specialist."}
  ]
  for cls in classes:
    var btn = Button.new()
    btn.text = cls.name
    btn.pressed.connect(_on_class_selected.bind(cls.type, cls.desc))
    class_buttons.add_child(btn)

func _on_class_selected(type: CharacterClass.ClassType, desc: String):
  selected_class = type
  class_desc.text = desc

func _on_create_pressed():
  var char_name = name_input.text.strip_edges()
  if char_name.is_empty():
    class_desc.text = "Please enter a character name!"
    return
  character_created.emit(char_name, selected_class)