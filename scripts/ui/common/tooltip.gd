class_name Tooltip
extends PanelContainer

@onready var title_label: Label = /Title
@onready var desc_label: Label = /Description
@onready var stats_label: Label = /Stats

func show_item(item: Item) -> void:
  title_label.text = item.item_name
  title_label.modulate = item.get_quality_color()
  desc_label.text = item.description
  if item is Equipment:
    var equip = item as Equipment
    var stats_text = ""
    if equip.atk_bonus > 0: stats_text += "ATK +" + str(equip.atk_bonus)
    if equip.def_bonus > 0: stats_text += "DEF +" + str(equip.def_bonus)
    stats_label.text = stats_text
  else:
    stats_label.text = ""
  visible = true

func hide_tooltip() -> void:
  visible = false