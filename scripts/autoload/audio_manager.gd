extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var music_volume: float = 0.8
var sfx_volume: float = 1.0

func _ready():
  music_player = AudioStreamPlayer.new()
  music_player.bus = "Music"
  add_child(music_player)
  sfx_player = AudioStreamPlayer.new()
  sfx_player.bus = "SFX"
  add_child(sfx_player)

func play_music(stream: AudioStream) -> void:
  music_player.stream = stream
  music_player.volume_db = linear_to_db(music_volume)
  music_player.play()

func stop_music() -> void:
  music_player.stop()

func play_sfx(stream: AudioStream) -> void:
  sfx_player.stream = stream
  sfx_player.volume_db = linear_to_db(sfx_volume)
  sfx_player.play()

func set_music_volume(volume: float) -> void:
  music_volume = clamp(volume, 0.0, 1.0)
  music_player.volume_db = linear_to_db(music_volume)

func set_sfx_volume(volume: float) -> void:
  sfx_volume = clamp(volume, 0.0, 1.0)
  sfx_player.volume_db = linear_to_db(sfx_volume)