extends GutTest

func test_create_ogun_warrior():
  var char = GameCharacter.new("TestWarrior", CharacterClass.ClassType.OGUN_WARRIOR)
  assert_eq(char.character_name, "TestWarrior")
  assert_eq(char.max_hp, 150)
  assert_eq(char.base_atk, 25)
  assert_true(char.is_alive)

func test_create_shango_mage():
  var char = GameCharacter.new("TestMage", CharacterClass.ClassType.SHANGO_MAGE)
  assert_eq(char.max_hp, 80)
  assert_eq(char.max_mp, 120)
  assert_eq(char.base_mag, 25)

func test_take_damage():
  var char = GameCharacter.new("Test", CharacterClass.ClassType.OGUN_WARRIOR)
  char.take_damage(50)
  assert_eq(char.current_hp, 100)
  assert_true(char.is_alive)

func test_take_lethal_damage():
  var char = GameCharacter.new("Test", CharacterClass.ClassType.OGUN_WARRIOR)
  char.take_damage(200)
  assert_eq(char.current_hp, 0)
  assert_false(char.is_alive)

func test_heal():
  var char = GameCharacter.new("Test", CharacterClass.ClassType.OGUN_WARRIOR)
  char.take_damage(100)
  char.heal(30)
  assert_eq(char.current_hp, 80)

func test_heal_cannot_exceed_max():
  var char = GameCharacter.new("Test", CharacterClass.ClassType.OGUN_WARRIOR)
  char.take_damage(50)
  char.heal(100)
  assert_eq(char.current_hp, 150)

func test_use_mp():
  var char = GameCharacter.new("Test", CharacterClass.ClassType.SHANGO_MAGE)
  assert_true(char.use_mp(50))
  assert_eq(char.current_mp, 70)

func test_use_mp_insufficient():
  var char = GameCharacter.new("Test", CharacterClass.ClassType.OGUN_WARRIOR)
  assert_false(char.use_mp(100))
  assert_eq(char.current_mp, 50)

func test_get_class_name():
  assert_eq(CharacterClass.get_class_name(CharacterClass.ClassType.OGUN_WARRIOR), "Ogun Warrior")
  assert_eq(CharacterClass.get_class_name(CharacterClass.ClassType.SHANGO_MAGE), "Shango Mage")