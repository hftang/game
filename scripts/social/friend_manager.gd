class_name FriendManager
extends RefCounted

signal friend_request_sent(friend_name: String)
signal friend_request_accepted(friend_name: String)
signal friend_removed(friend_name: String)

var network: Node

func _init(network_manager: Node):
  network = network_manager

func send_friend_request(player_id: String) -> void:
  pass

func accept_friend_request(request_id: String) -> void:
  pass

func remove_friend(friend_id: String) -> void:
  pass

func get_friends_list() -> Array:
  return []