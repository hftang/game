extends Control

@onready var player_hp_bars: VBoxContainer = $PlayerHPBars
@onready var enemy_hp_bars: VBoxContainer = $EnemyHPBars
@onready var battle_log: RichTextLabel = $BattleLog
@onready var attack_btn: Button = $ActionPanel/AttackBtn
@onready var skill_btn: Button = $ActionPanel/SkillBtn
@onready var defend_btn: Button = $ActionPanel/DefendBtn
@onready var item_btn: Button = $ActionPanel/ItemBtn

var player_hp: int = 100
var player_max_hp: int = 100
var player_mp: int = 50
var player_max_mp: int = 50
var enemy_hp: int = 80
var enemy_max_hp: int = 80
var enemy_name_str: String = "Enemy"
var battle_active: bool = true

func _ready():
  attack_btn.pressed.connect(_on_attack)
  skill_btn.pressed.connect(_on_skill)
  defend_btn.pressed.connect(_on_defend)
  item_btn.pressed.connect(_on_item)
  _update_display()

func _update_display():
  for child in player_hp_bars.get_children():
    child.queue_free()
  var p_label = Label.new()
  p_label.text = GameManager.player_name + ": " + str(player_hp) + "/" + str(player_max_hp)
  player_hp_bars.add_child(p_label)
  for child in enemy_hp_bars.get_children():
    child.queue_free()
  var e_label = Label.new()
  e_label.text = enemy_name_str + ": " + str(enemy_hp) + "/" + str(enemy_max_hp)
  enemy_hp_bars.add_child(e_label)

func _on_attack():
  if not battle_active: return
  var damage = randi() % 10 + 5
  enemy_hp = max(0, enemy_hp - damage)
  battle_log.text += "You attack for " + str(damage) + " damage!"

  if enemy_hp <= 0:
    battle_active = false
    battle_log.text += "VICTORY!"

    GameManager.add_exp(20)
    GameManager.ori_coin += 10
  else:
    _enemy_turn()
  _update_display()

func _on_skill():
  if not battle_active: return
  if player_mp < 10:
    battle_log.text += "Not enough MP!"

    return
  player_mp -= 10
  var damage = randi() % 15 + 10
  enemy_hp = max(0, enemy_hp - damage)
  battle_log.text += "You use skill for " + str(damage) + " damage!"

  if enemy_hp <= 0:
    battle_active = false
    battle_log.text += "VICTORY!"

    GameManager.add_exp(20)
    GameManager.ori_coin += 10
  else:
    _enemy_turn()
  _update_display()

func _on_defend():
  if not battle_active: return
  battle_log.text += "You defend!"

  _enemy_turn()
  _update_display()

func _on_item():
  if not battle_active: return
  player_hp = min(player_max_hp, player_hp + 20)
  battle_log.text += "You use potion! +20 HP"

  _enemy_turn()
  _update_display()

func _enemy_turn():
  var damage = randi() % 8 + 3
  player_hp = max(0, player_hp - damage)
  battle_log.text += enemy_name_str + " attacks for " + str(damage) + " damage!"

  if player_hp <= 0:
    battle_active = false
    battle_log.text += "DEFEAT!"
