class_name Consumable
extends Item

var hp_restore: int = 0
var mp_restore: int = 0

func _init(p_id: String, p_name: String, p_desc: String, p_price: int, p_hp: int = 0, p_mp: int = 0):
  super(p_id, p_name, "consumable", Item.Quality.COMMON, p_desc, p_price)
  hp_restore = p_hp
  mp_restore = p_mp

func use(target: GameCharacter) -> void:
  if hp_restore > 0:
    target.heal(hp_restore)
  if mp_restore > 0:
    target.current_mp = min(target.max_mp, target.current_mp + mp_restore)