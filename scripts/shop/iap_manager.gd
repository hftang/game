class_name IAPManager
extends RefCounted

signal card_redeemed(amount: int)
signal card_redeem_failed(error: String)
signal monthly_card_activated()
signal daily_reward_claimed(amount: int)

var network: Node

func _init(network_manager: Node):
  network = network_manager

func redeem_card(code: String) -> void:
  network.redeem_card(code)

func buy_monthly_card(ori_coin: int) -> bool:
  if ori_coin < 500:
    return false
  return true