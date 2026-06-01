class_name Equipment
extends Item

var atk_bonus: int = 0
var def_bonus: int = 0
var spd_bonus: int = 0
var mag_bonus: int = 0
var hp_bonus: int = 0
var mp_bonus: int = 0

func _init(p_id: String, p_name: String, p_type: String, p_quality: Quality, p_desc: String, p_price: int, stats: Dictionary):
  super(p_id, p_name, p_type, p_quality, p_desc, p_price)
  atk_bonus = stats.get("atk", 0)
  def_bonus = stats.get("def", 0)
  spd_bonus = stats.get("spd", 0)
  mag_bonus = stats.get("mag", 0)
  hp_bonus = stats.get("hp", 0)
  mp_bonus = stats.get("mp", 0)