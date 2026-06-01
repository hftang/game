extends GutTest

var battle: BattleManager

func before_each():
  battle = BattleManager.new()

func test_battle_setup():
  var player = GameCharacter.new("Player", CharacterClass.ClassType.OGUN_WARRIOR)
  var enemy = GameCharacter.new("Enemy", CharacterClass.ClassType.OGUN_WARRIOR)
  battle.setup_battle([player], [enemy])
  assert_eq(battle.all_combatants.size(), 2)

func test_turn_order_by_speed():
  var fast_char = GameCharacter.new("Fast", CharacterClass.ClassType.ESHU_SCOUT)
  var slow_char = GameCharacter.new("Slow", CharacterClass.ClassType.OGUN_WARRIOR)
  battle.setup_battle([fast_char], [slow_char])
  var first = battle.start_turn()
  assert_eq(first.character_name, "Fast")

func test_attack_deals_damage():
  var attacker = GameCharacter.new("Atk", CharacterClass.ClassType.OGUN_WARRIOR)
  var defender = GameCharacter.new("Def", CharacterClass.ClassType.OGUN_WARRIOR)
  battle.setup_battle([attacker], [defender])
  var damage = battle.perform_attack(attacker, defender)
  assert_gt(damage, 0)
  assert_lt(defender.current_hp, defender.max_hp)