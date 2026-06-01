extends Control

@onready var player_hp_bars: VBoxContainer = $PlayerHPBars
@onready var enemy_hp_bars: VBoxContainer = $EnemyHPBars
@onready var battle_log: RichTextLabel = $BattleLog
@onready var attack_btn: Button = $ActionPanel/AttackBtn
@onready var skill_btn: Button = $ActionPanel/SkillBtn
@onready var defend_btn: Button = $ActionPanel/DefendBtn
@onready var item_btn: Button = $ActionPanel/ItemBtn
@onready var back_btn: Button = $BackBtn
@onready var enemy_sprite: TextureRect = $EnemySprite
@onready var flash_overlay: ColorRect = $FlashOverlay
@onready var slash_effect: ColorRect = $SlashEffect
@onready var damage_label: Label = $DamageLabel
@onready var heal_effect: ColorRect = $HealEffect
@onready var enemy_flash: ColorRect = $EnemyFlash
@onready var victory_panel: Panel = $VictoryPanel
@onready var victory_label: Label = $VictoryPanel/VictoryLabel

var gm: Node = null
var player_name: String = "Hero"
var player_hp: int = 100
var player_max_hp: int = 100
var player_mp: int = 50
var player_max_mp: int = 50
var enemy_hp: int = 80
var enemy_max_hp: int = 80
var enemy_name_str: String = "Wild Hyena"
var battle_active: bool = true
var is_animating: bool = false

func _ready():
    gm = get_node_or_null("/root/GameManager")
    if gm:
        player_name = str(gm.get("player_name")) if gm.get("player_name") else "Hero"
    attack_btn.pressed.connect(_on_attack)
    skill_btn.pressed.connect(_on_skill)
    defend_btn.pressed.connect(_on_defend)
    item_btn.pressed.connect(_on_item)
    back_btn.pressed.connect(_on_back)
    back_btn.visible = false
    victory_panel.visible = false
    battle_log.text = ""
    flash_overlay.visible = true
    slash_effect.visible = true
    damage_label.visible = true
    heal_effect.visible = true
    enemy_flash.visible = true
    _update_display()
    _play_intro()

func _play_intro():
    is_animating = true
    enemy_sprite.modulate.a = 0.0
    var tween = create_tween()
    tween.tween_property(enemy_sprite, "modulate:a", 1.0, 0.8).set_ease(Tween.EASE_OUT)
    tween.tween_property(enemy_sprite, "scale", Vector2(1.05, 1.05), 0.15)
    tween.tween_property(enemy_sprite, "scale", Vector2(1.0, 1.0), 0.15)
    tween.tween_callback(func(): is_animating = false)

func _update_display():
    for child in player_hp_bars.get_children():
        child.queue_free()
    var p_label = Label.new()
    p_label.text = player_name + ": " + str(player_hp) + "/" + str(player_max_hp)
    p_label.add_theme_font_size_override("font_size", 20)
    var hp_ratio = float(player_hp) / float(player_max_hp)
    p_label.add_theme_color_override("font_color", Color(0.2, 1.0, 0.3) if hp_ratio > 0.3 else Color(1.0, 0.3, 0.2))
    player_hp_bars.add_child(p_label)
    for child in enemy_hp_bars.get_children():
        child.queue_free()
    var e_label = Label.new()
    e_label.text = enemy_name_str + ": " + str(enemy_hp) + "/" + str(enemy_max_hp)
    e_label.add_theme_font_size_override("font_size", 20)
    e_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.2))
    e_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    enemy_hp_bars.add_child(e_label)

func _disable_actions():
    attack_btn.disabled = true
    skill_btn.disabled = true
    defend_btn.disabled = true
    item_btn.disabled = true

func _enable_actions():
    attack_btn.disabled = false
    skill_btn.disabled = false
    defend_btn.disabled = false
    item_btn.disabled = false

func _on_attack():
    if not battle_active or is_animating: return
    is_animating = true
    _disable_actions()
    var damage = randi() % 10 + 5
    var tween = create_tween()
    tween.tween_property(enemy_sprite, "position:x", enemy_sprite.position.x + 30, 0.1)
    tween.tween_property(enemy_sprite, "position:x", enemy_sprite.position.x, 0.1)
    tween.tween_callback(func(): _show_slash(enemy_sprite.position + Vector2(0, 100)))
    tween.tween_interval(0.15)
    tween.tween_callback(func(): _flash_enemy())
    tween.tween_interval(0.1)
    tween.tween_callback(func(): _show_damage(enemy_sprite.position + Vector2(randf_range(-30, 30), 80), damage, false))
    tween.tween_property(enemy_sprite, "position:x", enemy_sprite.position.x - 15, 0.05)
    tween.tween_property(enemy_sprite, "position:x", enemy_sprite.position.x + 15, 0.05)
    tween.tween_property(enemy_sprite, "position:x", enemy_sprite.position.x - 10, 0.05)
    tween.tween_property(enemy_sprite, "position:x", enemy_sprite.position.x, 0.05)
    tween.tween_interval(0.3)
    tween.tween_callback(func():
        enemy_hp = max(0, enemy_hp - damage)
        battle_log.text += "You attack for " + str(damage) + " damage!\n"
        _update_display()
        if enemy_hp <= 0:
            _victory()
        else:
            _enemy_turn_attack()
    )

func _on_skill():
    if not battle_active or is_animating: return
    if player_mp < 10:
        battle_log.text += "Not enough MP!\n"
        return
    is_animating = true
    _disable_actions()
    player_mp -= 10
    var damage = randi() % 15 + 10
    var tween = create_tween()
    tween.tween_callback(func(): _screen_flash(Color(0.3, 0.4, 1.0, 0.5), 0.3))
    tween.tween_interval(0.15)
    tween.tween_callback(func(): _show_slash(enemy_sprite.position + Vector2(0, 50)))
    tween.tween_callback(func(): _show_slash(enemy_sprite.position + Vector2(-40, 120)))
    tween.tween_callback(func(): _show_slash(enemy_sprite.position + Vector2(40, 80)))
    tween.tween_interval(0.2)
    tween.tween_callback(func(): _flash_enemy())
    tween.tween_interval(0.1)
    tween.tween_callback(func(): _flash_enemy())
    tween.tween_interval(0.1)
    tween.tween_callback(func(): _show_damage(enemy_sprite.position + Vector2(0, 60), damage, true))
    for i in range(4):
        tween.tween_property(enemy_sprite, "position:x", enemy_sprite.position.x + randf_range(-20, 20), 0.04)
    tween.tween_property(enemy_sprite, "position:x", enemy_sprite.position.x, 0.04)
    tween.tween_interval(0.3)
    tween.tween_callback(func():
        enemy_hp = max(0, enemy_hp - damage)
        battle_log.text += "Skill attack for " + str(damage) + " damage!\n"
        _update_display()
        if enemy_hp <= 0:
            _victory()
        else:
            _enemy_turn_attack()
    )

func _on_defend():
    if not battle_active or is_animating: return
    is_animating = true
    _disable_actions()
    var tween = create_tween()
    tween.tween_callback(func(): _screen_flash(Color(0.5, 0.8, 1.0, 0.4), 0.4))
    tween.tween_interval(0.3)
    tween.tween_callback(func():
        battle_log.text += "You raise your shield!\n"
        _enemy_turn_defend()
    )

func _on_item():
    if not battle_active or is_animating: return
    is_animating = true
    _disable_actions()
    var heal = 20
    var tween = create_tween()
    tween.tween_callback(func(): _show_heal())
    tween.tween_interval(0.2)
    tween.tween_callback(func(): _show_damage(Vector2(100, 800), heal, false, true))
    tween.tween_interval(0.4)
    tween.tween_callback(func():
        player_hp = min(player_max_hp, player_hp + heal)
        battle_log.text += "Potion used! +" + str(heal) + " HP\n"
        _update_display()
        _enemy_turn_attack()
    )

func _enemy_turn_attack():
    var damage = randi() % 8 + 3
    var tween = create_tween()
    tween.tween_interval(0.3)
    tween.tween_property(enemy_sprite, "position:y", enemy_sprite.position.y + 40, 0.12).set_ease(Tween.EASE_IN)
    tween.tween_property(enemy_sprite, "position:y", enemy_sprite.position.y, 0.08).set_ease(Tween.EASE_OUT)
    tween.tween_callback(func(): _screen_shake(0.2))
    tween.tween_callback(func(): _screen_flash(Color(1.0, 0.2, 0.1, 0.4), 0.2))
    tween.tween_interval(0.1)
    tween.tween_callback(func(): _show_damage(Vector2(randf_range(80, 200), randf_range(700, 800)), damage, false))
    tween.tween_interval(0.3)
    tween.tween_callback(func():
        player_hp = max(0, player_hp - damage)
        battle_log.text += enemy_name_str + " attacks for " + str(damage) + "!\n"
        _update_display()
        if player_hp <= 0:
            _defeat()
        else:
            is_animating = false
            _enable_actions()
    )

func _enemy_turn_defend():
    var damage = max(1, randi() % 5 + 1)
    var tween = create_tween()
    tween.tween_interval(0.3)
    tween.tween_property(enemy_sprite, "position:y", enemy_sprite.position.y + 40, 0.12)
    tween.tween_property(enemy_sprite, "position:y", enemy_sprite.position.y, 0.08)
    tween.tween_callback(func(): _show_damage(Vector2(100, 800), damage, false))
    tween.tween_interval(0.3)
    tween.tween_callback(func():
        player_hp = max(0, player_hp - damage)
        battle_log.text += "Blocked! Only " + str(damage) + " damage!\n"
        _update_display()
        if player_hp <= 0:
            _defeat()
        else:
            is_animating = false
            _enable_actions()
    )

func _victory():
    battle_active = false
    var tween = create_tween()
    tween.tween_property(enemy_sprite, "modulate:a", 0.0, 0.5)
    tween.tween_property(enemy_sprite, "scale", Vector2(0.5, 0.5), 0.5)
    tween.tween_interval(0.3)
    tween.tween_callback(func(): _screen_flash(Color(1.0, 0.9, 0.3, 0.6), 0.5))
    tween.tween_interval(0.3)
    tween.tween_callback(func():
        if gm:
            gm.call("add_exp", 20)
            gm.set("ori_coin", gm.get("ori_coin") + 10)
        battle_log.text += "VICTORY! +20 EXP, +10 Ori Coin\n"
        victory_panel.visible = true
        victory_label.text = "VICTORY!"
        victory_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
        victory_panel.modulate.a = 0.0
    )
    tween.tween_property(victory_panel, "modulate:a", 1.0, 0.5)
    tween.tween_property(victory_label, "scale", Vector2(1.1, 1.1), 0.3)
    tween.tween_property(victory_label, "scale", Vector2(1.0, 1.0), 0.3)
    tween.tween_callback(func(): back_btn.visible = true)

func _defeat():
    battle_active = false
    var tween = create_tween()
    tween.tween_property(flash_overlay, "color", Color(0.1, 0.0, 0.0, 0.7), 0.8)
    tween.tween_interval(0.3)
    tween.tween_callback(func():
        battle_log.text += "DEFEAT...\n"
        victory_panel.visible = true
        victory_label.text = "DEFEAT"
        victory_label.add_theme_color_override("font_color", Color(0.8, 0.1, 0.1))
        victory_panel.modulate.a = 0.0
    )
    tween.tween_property(victory_panel, "modulate:a", 1.0, 0.5)
    tween.tween_callback(func(): back_btn.visible = true)

func _show_slash(pos: Vector2):
    slash_effect.visible = true
    slash_effect.position = pos - Vector2(60, 10)
    slash_effect.size = Vector2(120, 20)
    slash_effect.rotation = randf_range(-0.5, 0.5)
    slash_effect.modulate = Color(1, 0.9, 0.2, 0.9)
    var tween = create_tween()
    tween.tween_property(slash_effect, "modulate:a", 0.0, 0.25)
    tween.tween_property(slash_effect, "size:x", 180.0, 0.25)
    tween.tween_callback(func(): slash_effect.visible = false)

func _flash_enemy():
    enemy_flash.visible = true
    enemy_flash.modulate.a = 0.8
    var tween = create_tween()
    tween.tween_property(enemy_flash, "modulate:a", 0.0, 0.15)
    tween.tween_callback(func(): enemy_flash.visible = false)

func _show_damage(pos: Vector2, amount: int, is_critical: bool, is_heal: bool = false):
    var lbl = Label.new()
    lbl.text = str(amount)
    lbl.position = pos
    lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    lbl.z_index = 100
    if is_heal:
        lbl.add_theme_color_override("font_color", Color(0.2, 1.0, 0.3))
        lbl.text = "+" + str(amount)
    elif is_critical:
        lbl.add_theme_color_override("font_color", Color(1.0, 0.8, 0.0))
        lbl.text = str(amount) + "!"
        lbl.add_theme_font_size_override("font_size", 64)
    else:
        lbl.add_theme_color_override("font_color", Color(1.0, 0.3, 0.2))
    lbl.add_theme_font_size_override("font_size", 48 if not is_critical else 64)
    add_child(lbl)
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(lbl, "position:y", pos.y - 100, 0.8).set_ease(Tween.EASE_OUT)
    tween.tween_property(lbl, "modulate:a", 0.0, 0.8).set_delay(0.3)
    if is_critical:
        tween.tween_property(lbl, "scale", Vector2(1.3, 1.3), 0.2).set_ease(Tween.EASE_OUT)
        tween.tween_property(lbl, "scale", Vector2(1.0, 1.0), 0.3).set_delay(0.2)
    tween.set_parallel(false)
    tween.tween_callback(func(): lbl.queue_free())

func _screen_flash(color: Color, duration: float):
    flash_overlay.visible = true
    flash_overlay.color = color
    flash_overlay.modulate.a = 1.0
    var tween = create_tween()
    tween.tween_property(flash_overlay, "modulate:a", 0.0, duration)

func _screen_shake(duration: float):
    var original_pos = position
    var tween = create_tween()
    var shake_count = 6
    for i in range(shake_count):
        var offset = Vector2(randf_range(-8, 8), randf_range(-8, 8))
        tween.tween_property(self, "position", original_pos + offset, duration / shake_count)
    tween.tween_property(self, "position", original_pos, 0.05)

func _show_heal():
    heal_effect.visible = true
    heal_effect.modulate.a = 0.6
    var tween = create_tween()
    tween.tween_property(heal_effect, "modulate:a", 0.0, 0.6)
    tween.tween_callback(func(): heal_effect.visible = false)

func _on_back():
    get_tree().change_scene_to_file("res://scenes/town.tscn")