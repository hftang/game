extends Control

@onready var quest_list: VBoxContainer = $VBoxContainer/QuestList
@onready var quest_desc: Label = $VBoxContainer/QuestDesc
@onready var quest_progress: Label = $VBoxContainer/QuestProgress
@onready var claim_btn: Button = $VBoxContainer/ClaimBtn
@onready var accept_btn: Button = $VBoxContainer/AcceptBtn
@onready var back_btn: Button = $VBoxContainer/BackBtn

var selected_quest: Quest

func _ready():
  claim_btn.pressed.connect(_on_claim_pressed)
  accept_btn.pressed.connect(_on_accept_pressed)
  back_btn.pressed.connect(_on_back_pressed)
  claim_btn.visible = false
  accept_btn.visible = false
  _populate_quests()

func _populate_quests() -> void:
  for child in quest_list.get_children():
    child.queue_free()
  for quest in QuestDatabase.all_quests:
    var btn = Button.new()
    match quest.status:
      Quest.QuestStatus.AVAILABLE: btn.text = "[NEW] " + quest.quest_name
      Quest.QuestStatus.ACTIVE: btn.text = quest.quest_name + " (" + str(quest.current_count) + "/" + str(quest.target_count) + ")"
      Quest.QuestStatus.COMPLETED: btn.text = "[DONE] " + quest.quest_name
      Quest.QuestStatus.CLAIMED: btn.text = "[CLAIMED] " + quest.quest_name
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
    selected_quest.status = Quest.QuestStatus.ACTIVE
    _populate_quests()

func _on_claim_pressed() -> void:
  if selected_quest:
    selected_quest.status = Quest.QuestStatus.CLAIMED
    GameManager.add_exp(selected_quest.xp_reward)
    GameManager.ori_coin += selected_quest.ori_coin_reward
    quest_desc.text = "Claimed! +" + str(selected_quest.xp_reward) + " XP"
    _populate_quests()

func _on_back_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/town.tscn")