extends Node

signal data_saved()
signal data_loaded(data: Dictionary)

const SAVE_PATH = "user://save_data.json"

var player_data: Dictionary = {
  "player_id": "",
  "username": "",
  "ori_coin": 0,
  "level": 1,
  "exp": 0,
  "characters": [],
  "inventory": [],
  "pets": []
}

func _ready():
  load_local()

func save_local() -> void:
  var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
  if file:
    file.store_string(JSON.stringify(player_data))
    file.close()
    data_saved.emit()

func load_local() -> void:
  if not FileAccess.file_exists(SAVE_PATH):
    return
  var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
  if file:
    var json = JSON.new()
    var error = json.parse(file.get_as_text())
    file.close()
    if error == OK:
      player_data = json.data
      data_loaded.emit(player_data)

func update_player_id(id: String) -> void:
  player_data.player_id = id
  save_local()

func add_character(character_data: Dictionary) -> void:
  player_data.characters.append(character_data)
  save_local()

func sync_from_server(server_data: Dictionary) -> void:
  player_data = server_data
  save_local()