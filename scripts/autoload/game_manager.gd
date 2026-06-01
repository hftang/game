extends Node

signal scene_changed(scene_name: String)
signal player_data_loaded()

enum GameState {
  MAIN_MENU,
  CHARACTER_SELECT,
  TOWN,
  BATTLE,
  SHOP,
  INVENTORY
}

var current_state: GameState = GameState.MAIN_MENU
var player_id: String = ""
var player_name: String = ""
var ori_coin: int = 0
var level: int = 1
var exp: int = 0
var exp_to_next: int = 100

func change_state(new_state: GameState) -> void:
  current_state = new_state
  scene_changed.emit(GameState.keys()[new_state])

func add_ori_coin(amount: int) -> void:
  ori_coin += amount

func spend_ori_coin(amount: int) -> bool:
  if ori_coin >= amount:
    ori_coin -= amount
    return true
  return false

func add_exp(amount: int) -> void:
  exp += amount
  while exp >= exp_to_next:
    level_up()

func level_up() -> void:
  exp -= exp_to_next
  level += 1
  exp_to_next = int(exp_to_next * 1.5)