class_name QuestDatabase
extends RefCounted

static var all_quests: Array = [
  Quest.new("q_first_blood", "First Blood", "Defeat your first enemy.", Quest.QuestType.KILL_ENEMIES, "any", 1, 50, 20),
  Quest.new("q_hyena_hunter", "Hyena Hunter", "Defeat 5 hyenas.", Quest.QuestType.KILL_ENEMIES, "e_hyena", 5, 100, 50),
  Quest.new("q_clear_savanna", "Savanna Clear", "Complete Savanna Outskirts.", Quest.QuestType.COMPLETE_LEVEL, "lv_savanna", 1, 150, 80, 10),
  Quest.new("q_desert_explorer", "Desert Explorer", "Complete Sahara Crossing.", Quest.QuestType.COMPLETE_LEVEL, "lv_desert", 1, 200, 100, 15),
  Quest.new("q_boss_hunter", "Orishas Chosen", "Defeat Corrupted Olokun.", Quest.QuestType.COMPLETE_LEVEL, "lv_boss", 1, 500, 300, 50),
  Quest.new("q_reach_lv5", "Rising Warrior", "Reach level 5.", Quest.QuestType.REACH_LEVEL, "player", 5, 200, 100, 20),
]

static func get_quest(quest_id: String):
  for quest in all_quests:
    if quest.quest_id == quest_id:
      return quest
  return null