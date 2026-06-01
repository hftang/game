extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var vbox: VBoxContainer = $VBoxContainer

func _ready():
    start_button.pressed.connect(_on_start_pressed)
    settings_button.pressed.connect(_on_settings_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    _play_intro()

func _play_intro():
    vbox.modulate.a = 0.0
    vbox.position.y += 50
    var tween = create_tween()
    tween.tween_interval(0.3)
    tween.tween_property(vbox, "modulate:a", 1.0, 0.6)
    tween.parallel().tween_property(vbox, "position:y", vbox.position.y - 50, 0.6).set_ease(Tween.EASE_OUT)
    # Pulse the start button
    tween.tween_property(start_button, "scale", Vector2(1.05, 1.05), 0.4).set_delay(0.2)
    tween.tween_property(start_button, "scale", Vector2(1.0, 1.0), 0.4)

func _on_start_pressed():
    # Press animation then transition
    var tween = create_tween()
    tween.tween_property(vbox, "modulate:a", 0.0, 0.3)
    tween.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/character_select.tscn"))

func _on_settings_pressed():
    pass

func _on_quit_pressed():
    get_tree().quit()