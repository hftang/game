extends Control

@onready var message_list: RichTextLabel = $VBoxContainer/MessageList
@onready var input_field: LineEdit = $VBoxContainer/HBoxContainer/InputField
@onready var send_button: Button = $VBoxContainer/HBoxContainer/SendButton
@onready var back_btn: Button = $VBoxContainer/BackBtn

func _ready():
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
    message_list.append_text("[" + GameManager.player_name + "]: " + message + "\n")
    input_field.text = ""

func _on_back():
    get_tree().change_scene_to_file("res://scenes/town.tscn")