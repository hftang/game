extends Node

signal game_initialized()

var quest_mgr: QuestManager

func _ready():
  quest_mgr = QuestManager.new()
  _auto_accept_quests()
  game_initialized.emit()

func _auto_accept_quests() -> void:
  # Auto-accept first quest
  var first_quest = QuestDatabase.get_quest("q_first_blood")
  if first_quest and first_quest.status == Quest.QuestStatus.AVAILABLE:
    quest_mgr.accept_quest(first_quest)

func on_battle_victory(enemy_ids: Array, level_id: String) -> Dictionary:
  var total_xp = 0
  var total_gold = 0
  var drops = []
  for enemy_id in enemy_ids:
    var enemy = EnemyDatabase.create_enemy(enemy_id)
    if enemy:
      total_xp += enemy.xp_reward
      total_gold += enemy.gold_reward
      var drop = BattleRewards.roll_item_drop(enemy.level)
      if drop:
        drops.append(drop)
      quest_mgr.on_enemy_killed(enemy_id)
  quest_mgr.on_level_completed(level_id)
  var old_level = GameManager.level
  GameManager.add_exp(total_xp)
  GameManager.ori_coin += total_gold
  var did_level_up = GameManager.level > old_level
  if did_level_up:
    quest_mgr.on_player_level_up(GameManager.level)
  return {
    "xp": total_xp,
    "gold": total_gold,
    "drops": drops,
    "level_up": did_level_up
  }