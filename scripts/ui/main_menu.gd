extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready():
  start_button.pressed.connect(_on_start_pressed)
  settings_button.pressed.connect(_on_settings_pressed)
  quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
  get_tree().change_scene_to_file("res://scenes/character_select.tscn")

func _on_settings_pressed():
  pass

func _on_quit_pressed():
  get_tree().quit()