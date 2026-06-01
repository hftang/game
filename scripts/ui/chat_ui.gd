extends Control

@onready var message_list: RichTextLabel = $VBoxContainer/MessageList
@onready var input_field: LineEdit = $VBoxContainer/HBoxContainer/InputField
@onready var send_button: Button = $VBoxContainer/HBoxContainer/SendButton
@onready var back_btn: Button = $VBoxContainer/BackBtn

var gm: Node = null

func _ready():
    gm = get_node_or_null("/root/GameManager")
    send_button.pressed.connect(_on_send_pressed)
    input_field.text_submitted.connect(_on_text_submitted)
    back_btn.pressed.connect(_on_back)
    message_list.append_text("Welcome to World Chat!\n")

func _on_send_pressed() -> void:
    _send_message()

func _on_text_submitted(text: String) -> void:
    _send_message()

func _send_message() -> void:
    var message = input_field.text.strip_edges()
    if message.is_empty():
        return
    var pname = gm.get("player_name") if gm else "Hero"
    message_list.append_text("[" + str(pname) + "]: " + message + "\n")
    input_field.text = ""

func _on_back():
    get_tree().change_scene_to_file("res://scenes/town.tscn")