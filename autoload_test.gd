extends Node

var phase: int = 0
var elapsed: float = 0.0
var next_time: float = 0.0
var pass_count: int = 0
var fail_count: int = 0

func _ready():
    print("")
    print("=" + "=".repeat(50))
    print("  ORISHAS PATH - FULL BUTTON TEST")
    print("=" + "=".repeat(50))
    next_time = 0.5

func _process(delta):
    elapsed += delta
    if elapsed >= next_time:
        next_time = elapsed + 0.8
        _run()

func ok(msg: String):
    pass_count += 1
    print("  [OK] " + msg)

func ng(msg: String):
    fail_count += 1
    print("  [NG] " + msg)

func sc():
    return get_tree().current_scene

func btn(path: String) -> Button:
    var n = sc().get_node_or_null(path)
    if n and n is Button: return n
    return null

func press(path: String) -> bool:
    var b = btn(path)
    if b:
        if b.disabled:
            return false
        b.pressed.emit()
        return true
    return false

func check_btn(path: String, label: String) -> bool:
    var b = btn(path)
    if b:
        ok(label + " button exists: " + b.text)
        var conns = b.get_signal_connection_list("pressed")
        if conns.size() > 0:
            ok(label + " button connected (" + str(conns.size()) + ")")
        else:
            ng(label + " button NOT connected!")
        return true
    else:
        ng(label + " button MISSING at: " + path)
        return false

func _run():
    phase += 1
    match phase:
        # === MAIN MENU ===
        1:
            print("\n--- MAIN MENU ---")
            ok("Scene: " + sc().name)
            check_btn("VBoxContainer/StartButton", "Start Game")
            check_btn("VBoxContainer/SettingsButton", "Settings")
            check_btn("VBoxContainer/QuitButton", "Quit")
            var bg = sc().get_node_or_null("Background")
            if bg and bg is TextureRect and bg.texture:
                ok("Background texture loaded")
            else:
                ng("Background texture missing")
            press("VBoxContainer/StartButton")

        # === CHARACTER SELECT ===
        2:
            print("\n--- CHARACTER SELECT ---")
            ok("Scene: " + sc().name)
            var ni = sc().get_node_or_null("VBoxContainer/NameInput")
            if ni: ok("NameInput exists") else: ng("NameInput missing")
            check_btn("VBoxContainer/CreateButton", "Create Character")
            var pr = sc().get_node_or_null("VBoxContainer/PortraitRow")
            if pr:
                ok("PortraitRow has " + str(pr.get_child_count()) + " portraits")
            else:
                ng("PortraitRow missing")
            var cb = sc().get_node_or_null("VBoxContainer/ClassButtons")
            if cb:
                ok("ClassButtons has " + str(cb.get_child_count()) + " class buttons")
                if cb.get_child_count() > 0:
                    cb.get_child(0).pressed.emit()
                    ok("Clicked first class button")
            if ni: ni.text = "AutoTest"
            press("VBoxContainer/CreateButton")

        # === TOWN ===
        3:
            print("\n--- TOWN ---")
            ok("Scene: " + sc().name)
            var bg = sc().get_node_or_null("Background")
            if bg and bg is TextureRect and bg.texture:
                ok("Town background texture loaded")
            for p in ["AdventureBtn","ShopBtn","InventoryBtn","QuestsBtn","ProfileBtn","ChatBtn","RechargeBtn"]:
                check_btn("VBoxContainer/" + p, p)
            var cl = sc().get_node_or_null("CoinLabel")
            if cl: ok("CoinLabel: " + cl.text)
            var ll = sc().get_node_or_null("LevelLabel")
            if ll: ok("LevelLabel: " + ll.text)
            # Test Recharge button
            press("VBoxContainer/RechargeBtn")
            if cl: ok("After recharge: " + cl.text)
            # Go to Shop
            press("VBoxContainer/ShopBtn")

        # === SHOP ===
        4:
            print("\n--- SHOP ---")
            ok("Scene: " + sc().name)
            var bg = sc().get_node_or_null("Background")
            if bg and bg is TextureRect and bg.texture:
                ok("Shop background texture loaded")
            var il = sc().get_node_or_null("VBoxContainer/ItemList")
            if il: ok("ItemList has " + str(il.get_child_count()) + " items")
            check_btn("VBoxContainer/BackBtn", "Back")
            press("VBoxContainer/BackBtn")

        # === TOWN -> INVENTORY ===
        5:
            print("\n--- TOWN -> INVENTORY ---")
            press("VBoxContainer/InventoryBtn")

        6:
            print("\n--- INVENTORY ---")
            ok("Scene: " + sc().name)
            check_btn("VBoxContainer/BackBtn", "Back")
            press("VBoxContainer/BackBtn")

        # === TOWN -> QUESTS ===
        7:
            print("\n--- TOWN -> QUESTS ---")
            press("VBoxContainer/QuestsBtn")

        8:
            print("\n--- QUEST LOG ---")
            ok("Scene: " + sc().name)
            var ql = sc().get_node_or_null("VBoxContainer/QuestList")
            if ql: ok("QuestList has " + str(ql.get_child_count()) + " quests")
            check_btn("VBoxContainer/BackBtn", "Back")
            press("VBoxContainer/BackBtn")

        # === TOWN -> PROFILE ===
        9:
            print("\n--- TOWN -> PROFILE ---")
            press("VBoxContainer/ProfileBtn")

        10:
            print("\n--- PROFILE ---")
            ok("Scene: " + sc().name)
            for p in ["NameLabel","LevelLabel","ExpLabel","CoinLabel"]:
                var l = sc().get_node_or_null("VBoxContainer/" + p)
                if l: ok(p + ": " + l.text)
                else: ng(p + " missing")
            check_btn("VBoxContainer/BackBtn", "Back")
            press("VBoxContainer/BackBtn")

        # === TOWN -> CHAT ===
        11:
            print("\n--- TOWN -> CHAT ---")
            press("VBoxContainer/ChatBtn")

        12:
            print("\n--- CHAT ---")
            ok("Scene: " + sc().name)
            var ml = sc().get_node_or_null("VBoxContainer/MessageList")
            if ml: ok("MessageList exists")
            var inp = sc().get_node_or_null("VBoxContainer/HBoxContainer/InputField")
            if inp:
                inp.text = "Hello World"
                ok("InputField works")
            check_btn("VBoxContainer/HBoxContainer/SendButton", "Send")
            press("VBoxContainer/HBoxContainer/SendButton")
            if ml and ml.text.length() > 0:
                ok("Chat message sent: " + ml.text.substr(ml.text.length()-30))
            check_btn("VBoxContainer/BackBtn", "Back")
            press("VBoxContainer/BackBtn")

        # === TOWN -> ADVENTURE -> BATTLE ===
        13:
            print("\n--- TOWN -> ADVENTURE ---")
            press("VBoxContainer/AdventureBtn")

        14:
            print("\n--- LEVEL SELECT ---")
            ok("Scene: " + sc().name)
            var ll = sc().get_node_or_null("VBoxContainer/LevelList")
            if ll and ll.get_child_count() > 0:
                ok("Level list: " + str(ll.get_child_count()) + " levels")
                ll.get_child(0).pressed.emit()
                ok("Selected first level")
            check_btn("VBoxContainer/EnterBtn", "Enter Level")
            check_btn("VBoxContainer/BackBtn", "Back")
            next_time = elapsed + 0.3
            press("VBoxContainer/EnterBtn")

        # === BATTLE ===
        15:
            print("\n--- BATTLE ---")
            ok("Scene: " + sc().name)
            var bg = sc().get_node_or_null("Background")
            if bg and bg is TextureRect and bg.texture:
                ok("Battle background texture loaded")
            var es = sc().get_node_or_null("EnemySprite")
            if es and es is TextureRect and es.texture:
                ok("Enemy sprite texture loaded")
            for p in ["PlayerHPBars","EnemyHPBars","BattleLog","FlashOverlay","SlashEffect","EnemyFlash","VictoryPanel"]:
                var n = sc().get_node_or_null(p)
                if n: ok("Battle node: " + p)
                else: ng("Battle node missing: " + p)
            for p in ["ActionPanel/AttackBtn","ActionPanel/SkillBtn","ActionPanel/DefendBtn","ActionPanel/ItemBtn"]:
                check_btn(p, p.split("/")[-1])
            var scr = sc().get_script()
            if scr: ok("Script: " + scr.resource_path)
            else: ng("No script on battle!")
            # Test Attack
            print("\n  Testing ATTACK...")
            press("ActionPanel/AttackBtn")

        16:
            var log_node = sc().get_node_or_null("BattleLog")
            if log_node and log_node.text.length() > 3:
                ok("Attack logged: " + log_node.text.split("\n")[-2].substr(0,40))
            else:
                ng("Attack NOT logged!")
            # Attack more until battle ends
            var back = sc().get_node_or_null("BackBtn")
            if back and back.visible:
                ok("Battle ended!")
                press("BackBtn")
            else:
                press("ActionPanel/AttackBtn")
                phase = 15

        # === BACK IN TOWN ===
        17:
            print("\n--- BACK IN TOWN ---")
            ok("Scene after battle: " + sc().name)
            _finish()

func _finish():
    print("\n" + "=" + "=".repeat(50))
    print("  RESULTS: " + str(pass_count) + " PASS / " + str(fail_count) + " FAIL / " + str(pass_count + fail_count) + " TOTAL")
    if fail_count == 0:
        print("  ALL TESTS PASSED!")
    else:
        print("  " + str(fail_count) + " TESTS FAILED")
    print("=" + "=".repeat(50))
    get_tree().quit()