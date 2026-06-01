extends Control

@onready var message_list: RichTextLabel = /MessageList
@onready var input_field: LineEdit = /HBoxContainer/InputField
@onready var send_button: Button = /HBoxContainer/SendButton

var chat: ChatManager
var current_channel: String = "WORLD"

func _ready():
  send_button.pressed.connect(_on_send_pressed)
  input_field.text_submitted.connect(_on_text_submitted)

func setup(chat_manager: ChatManager) -> void:
  chat = chat_manager
  chat.message_received.connect(_on_message_received)

func _on_send_pressed() -> void:
  _send_message()

func _on_text_submitted(text: String) -> void:
  _send_message()

func _send_message() -> void:
  var message = input_field.text.strip_edges()
  if message.is_empty():
    return
  if current_channel == "WORLD":
    chat.send_world_message(message)
  input_field.text = ""

func _on_message_received(sender: String, message: String, channel: String) -> void:
  if channel == current_channel:
    message_list.append_text("[" + sender + "]: " + message)