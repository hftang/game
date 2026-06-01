class_name PetDatabase
extends RefCounted

static var all_pets: Array = [
  Pet.new("pet_lion", "Aslan", "Lion", {"hp": 120, "atk": 18, "def": 12, "spd": 14}, "Lions Roar", "AOE damage and chance to fear enemies"),
  Pet.new("pet_cheetah", "Fleet", "Cheetah", {"hp": 80, "atk": 14, "def": 8, "spd": 25}, "Swift Pounce", "Fast attack that always goes first"),
  Pet.new("pet_crocodile", "Sobek", "Crocodile", {"hp": 150, "atk": 15, "def": 18, "spd": 8}, "Death Roll", "High damage single target with bleed")
]

static func get_by_id(id: String):
  for pet in all_pets:
    if pet.pet_id == id:
      return pet
  return null