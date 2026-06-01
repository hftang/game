class_name QuestManager
extends RefCounted

signal quest_accepted(quest: Quest)
signal quest_completed(quest: Quest)
signal quest_claimed(quest: Quest, rewards: Dictionary)

func accept_quest(quest: Quest) -> void:
  if quest.status == Quest.QuestStatus.AVAILABLE:
    quest.status = Quest.QuestStatus.ACTIVE
    quest_accepted.emit(quest)

func on_enemy_killed(enemy_id: String) -> void:
  for quest in QuestDatabase.get_active_quests():
    if quest.quest_type == Quest.QuestType.KILL_ENEMIES:
      if quest.target_id == "any" or quest.target_id == enemy_id:
        quest.add_progress(1)
        if quest.is_complete():
          quest_completed.emit(quest)

func on_level_completed(level_id: String) -> void:
  for quest in QuestDatabase.get_active_quests():
    if quest.quest_type == Quest.QuestType.COMPLETE_LEVEL and quest.target_id == level_id:
      quest.add_progress(1)
      if quest.is_complete():
        quest_completed.emit(quest)

func claim_quest(quest: Quest) -> Dictionary:
  var rewards = quest.claim()
  if not rewards.is_empty():
    quest_claimed.emit(quest, rewards)
  return rewards