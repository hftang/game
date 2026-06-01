extends Control

@onready var quest_list: VBoxContainer = /QuestList
@onready var quest_desc: Label = /QuestDesc
@onready var quest_progress: Label = /QuestProgress
@onready var claim_btn: Button = /ClaimBtn
@onready var accept_btn: Button = /AcceptBtn
@onready var back_btn: Button = /BackBtn

var quest_mgr: QuestManager
var selected_quest: Quest

func _ready():
  claim_btn.pressed.connect(_on_claim_pressed)
  accept_btn.pressed.connect(_on_accept_pressed)
  back_btn.pressed.connect(_on_back_pressed)
  claim_btn.visible = false
  accept_btn.visible = false
  quest_mgr = QuestManager.new()
  _populate_quests()

func _populate_quests() -> void:
  for child in quest_list.get_children():
    child.queue_free()
  # Available quests
  for quest in QuestDatabase.get_available_quests():
    var btn = Button.new()
    btn.text = "[NEW] " + quest.quest_name
    btn.pressed.connect(_on_quest_pressed.bind(quest))
    quest_list.add_child(btn)
  # Active quests
  for quest in QuestDatabase.get_active_quests():
    var btn = Button.new()
    btn.text = quest.quest_name + " (" + str(quest.current_count) + "/" + str(quest.target_count) + ")"
    btn.pressed.connect(_on_quest_pressed.bind(quest))
    quest_list.add_child(btn)
  # Completed quests
  for quest in QuestDatabase.get_completed_quests():
    var btn = Button.new()
    btn.text = "[DONE] " + quest.quest_name
    btn.pressed.connect(_on_quest_pressed.bind(quest))
    quest_list.add_child(btn)

func _on_quest_pressed(quest: Quest) -> void:
  selected_quest = quest
  quest_desc.text = quest.description
  quest_progress.text = "Progress: " + str(quest.current_count) + "/" + str(quest.target_count)
  accept_btn.visible = quest.status == Quest.QuestStatus.AVAILABLE
  claim_btn.visible = quest.status == Quest.QuestStatus.COMPLETED

func _on_accept_pressed() -> void:
  if selected_quest:
    quest_mgr.accept_quest(selected_quest)
    _populate_quests()

func _on_claim_pressed() -> void:
  if selected_quest:
    var rewards = quest_mgr.claim_quest(selected_quest)
    if not rewards.is_empty():
      quest_desc.text = "Claimed! XP: " + str(rewards.xp) + " Gold: " + str(rewards.gold) + " Ori Coin: " + str(rewards.ori_coin)
    _populate_quests()

func _on_back_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/town.tscn")