extends SceneTree

var frame_count: int = 0
var active_scene: Node = null
var test_phase: int = 0
var errors: Array = []
var passed: Array = []

func _init():
    print("===== ORISHAS PATH - AUTOMATED TEST =====")
    print("")
    
    # Test 1: Load all scenes
    print("[TEST 1] Loading all scenes...")
    var scenes = {
        "MainMenu": "res://scenes/main_menu.tscn",
        "CharacterSelect": "res://scenes/character_select.tscn",
        "Town": "res://scenes/town.tscn",
        "Battle": "res://scenes/battle.tscn",
        "LevelSelect": "res://scenes/ui/level_select.tscn",
        "Shop": "res://scenes/ui/shop.tscn",
        "Inventory": "res://scenes/ui/inventory.tscn",
        "QuestLog": "res://scenes/ui/quest_log.tscn",
        "Profile": "res://scenes/ui/profile.tscn",
        "Chat": "res://scenes/ui/chat.tscn",
        "BattleResult": "res://scenes/ui/battle_result.tscn",
    }
    for name in scenes:
        var res = ResourceLoader.load(scenes[name])
        if res != null:
            passed.append("  PASS: " + name + " loaded")
        else:
            errors.append("  FAIL: " + name + " failed to load")
    
    # Test 2: Instantiate scenes and check nodes
    print("[TEST 2] Instantiating scenes and checking node structure...")
    
    # Main Menu
    var main_menu = ResourceLoader.load("res://scenes/main_menu.tscn").instantiate()
    _check_node(main_menu, "VBoxContainer", "MainMenu")
    _check_node(main_menu, "VBoxContainer/StartButton", "MainMenu")
    _check_node(main_menu, "VBoxContainer/SettingsButton", "MainMenu")
    _check_node(main_menu, "VBoxContainer/QuitButton", "MainMenu")
    _check_node(main_menu, "Background", "MainMenu")
    main_menu.free()
    
    # Character Select
    var char_sel = ResourceLoader.load("res://scenes/character_select.tscn").instantiate()
    _check_node(char_sel, "VBoxContainer/NameInput", "CharSelect")
    _check_node(char_sel, "VBoxContainer/ClassButtons", "CharSelect")
    _check_node(char_sel, "VBoxContainer/CreateButton", "CharSelect")
    _check_node(char_sel, "VBoxContainer/ClassDescription", "CharSelect")
    _check_node(char_sel, "Background", "CharSelect")
    _check_node(char_sel, "VBoxContainer/PortraitRow", "CharSelect")
    char_sel.free()
    
    # Town
    var town = ResourceLoader.load("res://scenes/town.tscn").instantiate()
    _check_node(town, "VBoxContainer/AdventureBtn", "Town")
    _check_node(town, "VBoxContainer/ShopBtn", "Town")
    _check_node(town, "VBoxContainer/InventoryBtn", "Town")
    _check_node(town, "VBoxContainer/QuestsBtn", "Town")
    _check_node(town, "VBoxContainer/ProfileBtn", "Town")
    _check_node(town, "VBoxContainer/ChatBtn", "Town")
    _check_node(town, "VBoxContainer/RechargeBtn", "Town")
    _check_node(town, "CoinLabel", "Town")
    _check_node(town, "LevelLabel", "Town")
    _check_node(town, "Background", "Town")
    town.free()
    
    # Battle - check animation nodes
    var battle = ResourceLoader.load("res://scenes/battle.tscn").instantiate()
    _check_node(battle, "Background", "Battle")
    _check_node(battle, "EnemySprite", "Battle")
    _check_node(battle, "PlayerHPBars", "Battle")
    _check_node(battle, "EnemyHPBars", "Battle")
    _check_node(battle, "BattleLog", "Battle")
    _check_node(battle, "ActionPanel/AttackBtn", "Battle")
    _check_node(battle, "ActionPanel/SkillBtn", "Battle")
    _check_node(battle, "ActionPanel/DefendBtn", "Battle")
    _check_node(battle, "ActionPanel/ItemBtn", "Battle")
    _check_node(battle, "BackBtn", "Battle")
    _check_node(battle, "FlashOverlay", "Battle")
    _check_node(battle, "SlashEffect", "Battle")
    _check_node(battle, "DamageLabel", "Battle")
    _check_node(battle, "HealEffect", "Battle")
    _check_node(battle, "EnemyFlash", "Battle")
    _check_node(battle, "VictoryPanel", "Battle")
    _check_node(battle, "VictoryPanel/VictoryLabel", "Battle")
    battle.free()
    
    # Shop
    var shop = ResourceLoader.load("res://scenes/ui/shop.tscn").instantiate()
    _check_node(shop, "VBoxContainer/CoinLabel", "Shop")
    _check_node(shop, "VBoxContainer/ItemList", "Shop")
    _check_node(shop, "VBoxContainer/BackBtn", "Shop")
    shop.free()
    
    # Level Select
    var lvl = ResourceLoader.load("res://scenes/ui/level_select.tscn").instantiate()
    _check_node(lvl, "VBoxContainer/LevelList", "LevelSelect")
    _check_node(lvl, "VBoxContainer/EnterBtn", "LevelSelect")
    _check_node(lvl, "VBoxContainer/BackBtn", "LevelSelect")
    lvl.free()
    
    # Inventory
    var inv = ResourceLoader.load("res://scenes/ui/inventory.tscn").instantiate()
    _check_node(inv, "VBoxContainer/ItemList", "Inventory")
    _check_node(inv, "VBoxContainer/BackBtn", "Inventory")
    inv.free()
    
    # Quest Log
    var quest = ResourceLoader.load("res://scenes/ui/quest_log.tscn").instantiate()
    _check_node(quest, "VBoxContainer/QuestList", "QuestLog")
    _check_node(quest, "VBoxContainer/BackBtn", "QuestLog")
    quest.free()
    
    # Profile
    var prof = ResourceLoader.load("res://scenes/ui/profile.tscn").instantiate()
    _check_node(prof, "VBoxContainer/NameLabel", "Profile")
    _check_node(prof, "VBoxContainer/LevelLabel", "Profile")
    _check_node(prof, "VBoxContainer/ExpLabel", "Profile")
    _check_node(prof, "VBoxContainer/CoinLabel", "Profile")
    _check_node(prof, "VBoxContainer/BackBtn", "Profile")
    prof.free()
    
    # Chat
    var chat = ResourceLoader.load("res://scenes/ui/chat.tscn").instantiate()
    _check_node(chat, "VBoxContainer/MessageList", "Chat")
    _check_node(chat, "VBoxContainer/HBoxContainer/InputField", "Chat")
    _check_node(chat, "VBoxContainer/HBoxContainer/SendButton", "Chat")
    _check_node(chat, "VBoxContainer/BackBtn", "Chat")
    chat.free()
    
    # Battle Result
    var br = ResourceLoader.load("res://scenes/ui/battle_result.tscn").instantiate()
    _check_node(br, "VBoxContainer/TitleLabel", "BattleResult")
    _check_node(br, "VBoxContainer/XpLabel", "BattleResult")
    _check_node(br, "VBoxContainer/GoldLabel", "BattleResult")
    _check_node(br, "VBoxContainer/ContinueBtn", "BattleResult")
    br.free()
    
    # Test 3: GameManager autoload
    print("[TEST 3] Checking GameManager autoload...")
    var gm_script = load("res://scripts/autoload/game_manager.gd")
    if gm_script:
        var gm = Node.new()
        gm.set_script(gm_script)
        gm.name = "GameManager"
        root.add_child(gm)
        
        gm.player_name = "TestHero"
        gm.level = 1
        gm.ori_coin = 100
        gm.exp = 0
        
        if gm.player_name == "TestHero":
            passed.append("  PASS: GameManager player_name works")
        else:
            errors.append("  FAIL: GameManager player_name broken")
        
        if gm.ori_coin == 100:
            passed.append("  PASS: GameManager ori_coin works")
        else:
            errors.append("  FAIL: GameManager ori_coin broken")
        
        gm.add_ori_coin(50)
        if gm.ori_coin == 150:
            passed.append("  PASS: GameManager add_ori_coin works")
        else:
            errors.append("  FAIL: GameManager add_ori_coin broken")
        
        var spent = gm.spend_ori_coin(80)
        if spent and gm.ori_coin == 70:
            passed.append("  PASS: GameManager spend_ori_coin works")
        else:
            errors.append("  FAIL: GameManager spend_ori_coin broken")
        
        gm.add_exp(150)
        if gm.level >= 2:
            passed.append("  PASS: GameManager level up works (level=" + str(gm.level) + ")")
        else:
            errors.append("  FAIL: GameManager level up broken")
        
        gm.queue_free()
    else:
        errors.append("  FAIL: Could not load game_manager.gd")
    
    # Test 4: Check battle script source has animation methods
    print("[TEST 4] Checking battle animation methods...")
    var battle_file = FileAccess.open("res://scripts/ui/battle_ui.gd", FileAccess.READ)
    if battle_file:
        var src = battle_file.get_as_text()
        battle_file.close()
        var methods = ["func _on_attack", "func _on_skill", "func _on_defend", "func _on_item", "func _show_slash", "func _flash_enemy", "func _show_damage", "func _screen_flash", "func _screen_shake", "func _show_heal"]
        for m in methods:
            if src.contains(m):
                passed.append("  PASS: Battle has method: " + m.substr(5))
            else:
                errors.append("  FAIL: Battle missing method: " + m.substr(5))
        # Check tween usage
        if src.contains("create_tween"):
            passed.append("  PASS: Battle uses Tween animations")
        else:
            errors.append("  FAIL: Battle does not use Tween animations")
        # Check effect count
        var tween_count = src.count("create_tween")
        passed.append("  PASS: Battle has " + str(tween_count) + " tween animations")
    else:
        errors.append("  FAIL: Could not open battle_ui.gd")
    
    # Test 5: Verify image assets exist
    print("[TEST 5] Checking image assets...")
    var assets = [
        "res://assets/backgrounds/main_menu_bg.png",
        "res://assets/backgrounds/char_select_bg.png",
        "res://assets/backgrounds/town_bg.png",
        "res://assets/backgrounds/battle_bg.png",
        "res://assets/backgrounds/shop_bg.png",
        "res://assets/characters/ogun_warrior.png",
        "res://assets/characters/shango_mage.png",
        "res://assets/characters/oshun_healer.png",
        "res://assets/characters/eshu_scout.png",
        "res://assets/enemies/hyena.png",
        "res://assets/ui/game_theme.tres",
    ]
    for a in assets:
        if FileAccess.file_exists(a):
            passed.append("  PASS: Asset exists: " + a)
        else:
            errors.append("  FAIL: Asset missing: " + a)
    
    # Test 6: Verify theme loads
    print("[TEST 6] Checking theme...")
    var theme_res = ResourceLoader.load("res://assets/ui/game_theme.tres")
    if theme_res:
        passed.append("  PASS: Theme loaded successfully")
    else:
        errors.append("  FAIL: Theme failed to load")
    
    # Print results
    print("")
    print("===== TEST RESULTS =====")
    for p in passed:
        print(p)
    if errors.size() > 0:
        print("")
        print("ERRORS:")
        for e in errors:
            print(e)
    print("")
    print("PASSED: " + str(passed.size()) + " / " + str(passed.size() + errors.size()))
    if errors.size() == 0:
        print("ALL TESTS PASSED!")
    else:
        print("SOME TESTS FAILED!")
    print("========================")
    
    quit()

func _check_node(parent: Node, path: String, scene_name: String):
    var node = parent.get_node_or_null(path)
    if node:
        passed.append("  PASS: " + scene_name + " has node: " + path)
    else:
        errors.append("  FAIL: " + scene_name + " missing node: " + path)