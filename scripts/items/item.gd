class_name Item
extends RefCounted

enum Quality { COMMON, RARE, EPIC, LEGENDARY }

var item_id: String
var item_name: String
var item_type: String
var quality: Quality
var description: String
var price: int

func _init(p_id: String, p_name: String, p_type: String, p_quality: Quality, p_desc: String, p_price: int):
  item_id = p_id
  item_name = p_name
  item_type = p_type
  quality = p_quality
  description = p_desc
  price = p_price

func get_quality_color() -> Color:
  match quality:
    Quality.COMMON: return Color.WHITE
    Quality.RARE: return Color.CYAN
    Quality.EPIC: return Color.PURPLE
    Quality.LEGENDARY: return Color.GOLD
  return Color.WHITE