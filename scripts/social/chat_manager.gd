class_name ChatManager
extends RefCounted

signal message_received(sender: String, message: String, channel: String)

var network: Node

func _init(network_manager: Node):
  network = network_manager

func send_world_message(message: String) -> void:
  pass

func send_private_message(recipient_id: String, message: String) -> void:
  pass

func load_chat_history(channel: String) -> void:
  pass