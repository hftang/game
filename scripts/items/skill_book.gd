class_name SkillBook
extends Item

var skill_id: String
var target_class: CharacterClass.ClassType

func _init(p_id: String, p_name: String, p_desc: String, p_price: int, p_skill_id: String, p_class: CharacterClass.ClassType):
  super(p_id, p_name, "skill_book", Item.Quality.RARE, p_desc, p_price)
  skill_id = p_skill_id
  target_class = p_class