extends GutTest

func test_basic_damage_calculation():
  var attacker = GameCharacter.new("Atk", CharacterClass.ClassType.OGUN_WARRIOR)
  var defender = GameCharacter.new("Def", CharacterClass.ClassType.OGUN_WARRIOR)
  var damage = DamageCalculator.calculate_damage(attacker, defender)
  assert_gt(damage, 0)

func test_elemental_multiplier():
  var mult = DamageCalculator.get_elemental_multiplier(DamageCalculator.Element.LIGHTNING, DamageCalculator.Element.WATER)
  assert_eq(mult, 1.5)

func test_no_elemental_advantage():
  var mult = DamageCalculator.get_elemental_multiplier(DamageCalculator.Element.FIRE, DamageCalculator.Element.WATER)
  assert_eq(mult, 1.0)