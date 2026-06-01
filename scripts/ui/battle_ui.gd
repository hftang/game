extends Control

@onready var player_hp_bars: VBoxContainer = 
@onready var enemy_hp_bars: VBoxContainer = 
@onready var action_panel: HBoxContainer = 
@onready var attack_btn: Button = /AttackBtn
@onready var skill_btn: Button = /SkillBtn
@onready var defend_btn: Button = /DefendBtn
@onready var item_btn: Button = /ItemBtn
@onready var battle_log: RichTextLabel = 

var battle: BattleManager
var current_character: GameCharacter

func _ready():
  attack_btn.pressed.connect(_on_attack)
  skill_btn.pressed.connect(_on_skill)
  defend_btn.pressed.connect(_on_defend)
  item_btn.pressed.connect(_on_item)

func setup_battle(players: Array, enemies: Array) -> void:
  battle = BattleManager.new()
  battle.setup_battle(players, enemies)
  battle.battle_started.connect(_on_battle_started)
  battle.turn_started.connect(_on_turn_started)
  battle.action_performed.connect(_on_action_performed)
  battle.battle_ended.connect(_on_battle_ended)

func _on_battle_started():
  battle_log.text = "Battle Start!"

func _on_turn_started(combatant: GameCharacter):
  current_character = combatant
  var is_player = battle.player_team.has(combatant)
  action_panel.visible = is_player

func _on_action_performed(action: String, damage: int):
  battle_log.text += current_character.character_name + " used " + action + " for " + str(damage) + " damage!"

func _on_battle_ended(victory: bool):
  if victory:
    battle_log.text += "VICTORY!"
  else:
    battle_log.text += "DEFEAT"
  action_panel.visible = false

func _on_attack():
  var enemy = _get_first_alive_enemy()
  if enemy:
    battle.perform_attack(current_character, enemy)
    battle.start_turn()

func _on_skill():
  if current_character.skills.size() > 0:
    var skill = current_character.skills[0]
    var enemy = _get_first_alive_enemy()
    if enemy:
      battle.perform_skill(current_character, enemy, skill)
      battle.start_turn()

func _on_defend():
  battle.start_turn()

func _on_item():
  battle.start_turn()

func _get_first_alive_enemy() -> GameCharacter:
  for enemy in battle.enemy_team:
    if enemy.is_alive:
      return enemy
  return null