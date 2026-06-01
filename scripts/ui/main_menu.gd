extends Control

@onready var start_button: Button = /StartButton
@onready var settings_button: Button = /SettingsButton
@onready var quit_button: Button = /QuitButton

func _ready():
  start_button.pressed.connect(_on_start_pressed)
  quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
  get_tree().change_scene_to_file("res://scenes/character_select.tscn")

func _on_quit_pressed():
  get_tree().quit()