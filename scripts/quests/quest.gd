class_name Quest
extends RefCounted

enum QuestType { KILL_ENEMIES, COMPLETE_LEVEL, COLLECT_ITEMS, REACH_LEVEL }
enum QuestStatus { AVAILABLE, ACTIVE, COMPLETED, CLAIMED }

var quest_id: String
var quest_name: String
var description: String
var quest_type: QuestType
var target_id: String
var target_count: int
var current_count: int = 0
var status: QuestStatus = QuestStatus.AVAILABLE
var xp_reward: int
var gold_reward: int
var ori_coin_reward: int

func _init(p_id: String, p_name: String, p_desc: String, p_type: QuestType, p_target: String, p_count: int, p_xp: int, p_gold: int, p_ori: int = 0):
  quest_id = p_id
  quest_name = p_name
  description = p_desc
  quest_type = p_type
  target_id = p_target
  target_count = p_count
  xp_reward = p_xp
  gold_reward = p_gold
  ori_coin_reward = p_ori

func add_progress(amount: int = 1) -> void:
  if status == QuestStatus.ACTIVE:
    current_count = min(target_count, current_count + amount)
    if current_count >= target_count:
      status = QuestStatus.COMPLETED

func is_complete() -> bool:
  return status == QuestStatus.COMPLETED

func claim() -> Dictionary:
  if status != QuestStatus.COMPLETED:
    return {}
  status = QuestStatus.CLAIMED
  return {"xp": xp_reward, "gold": gold_reward, "ori_coin": ori_coin_reward}