class_name BattleManager
extends RefCounted

signal battle_started()
signal turn_started(combatant: GameCharacter)
signal action_performed(action: String, damage: int)
signal combatant_defeated(combatant: GameCharacter)
signal battle_ended(victory: bool)

enum BattleState { WAITING, PLAYER_TURN, ENEMY_TURN, ANIMATING, ENDED }

var state: BattleState = BattleState.WAITING
var turn_system: TurnSystem = TurnSystem.new()
var player_team: Array = []
var enemy_team: Array = []
var all_combatants: Array = []

func setup_battle(p_players: Array, p_enemies: Array) -> void:
  player_team = p_players
  enemy_team = p_enemies
  all_combatants = player_team + enemy_team
  turn_system.setup(all_combatants)
  state = BattleState.WAITING
  battle_started.emit()

func start_turn() -> GameCharacter:
  var current = turn_system.get_current()
  turn_system.remove_dead()
  if check_battle_end():
    return null
  if current == null or not current.is_alive:
    current = turn_system.advance()
  if player_team.has(current):
    state = BattleState.PLAYER_TURN
  else:
    state = BattleState.ENEMY_TURN
  turn_started.emit(current)
  return current

func perform_attack(attacker: GameCharacter, defender: GameCharacter) -> int:
  var damage = DamageCalculator.calculate_damage(attacker, defender)
  defender.take_damage(damage)
  action_performed.emit("attack", damage)
  if not defender.is_alive:
    combatant_defeated.emit(defender)
  return damage

func perform_skill(attacker: GameCharacter, defender: GameCharacter, skill) -> int:
  if not attacker.use_mp(skill.mp_cost):
    return 0
  var damage = DamageCalculator.calculate_damage(attacker, defender, skill)
  if skill.is_heal:
    defender.heal(damage)
    action_performed.emit("heal", damage)
  else:
    defender.take_damage(damage)
    action_performed.emit("skill", damage)
    if not defender.is_alive:
      combatant_defeated.emit(defender)
  return damage

func check_battle_end() -> bool:
  var players_alive = player_team.filter(func(c): return c.is_alive)
  var enemies_alive = enemy_team.filter(func(c): return c.is_alive)
  if players_alive.is_empty():
    state = BattleState.ENDED
    battle_ended.emit(false)
    return true
  elif enemies_alive.is_empty():
    state = BattleState.ENDED
    battle_ended.emit(true)
    return true
  return false

func get_enemy_ai_action(enemy: GameCharacter) -> Dictionary:
  var alive_players = player_team.filter(func(c): return c.is_alive)
  if alive_players.is_empty():
    return {}
  var target = alive_players[randi() % alive_players.size()]
  return {"type": "attack", "target": target}