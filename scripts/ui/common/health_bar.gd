class_name HealthBar
extends Control

@onready var bar: ProgressBar = 
@onready var label: Label = 

var max_value: int = 100
var current_value: int = 100

func _ready():
  bar.max_value = max_value
  bar.value = current_value

func setup(p_max: int, p_current: int) -> void:
  max_value = p_max
  current_value = p_current
  if bar:
    bar.max_value = max_value
    bar.value = current_value

func update(new_value: int) -> void:
  current_value = clamp(new_value, 0, max_value)
  if bar:
    bar.value = current_value