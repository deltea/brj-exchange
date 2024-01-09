extends Node

@export var upgrades: Array[UpgradeResource] = []

var current_upgrades: Array[UpgradeResource] = []

func get_random_upgrades(amount: int) -> Array[UpgradeResource]:
	var result: Array[UpgradeResource] = []
	for i in range(amount):
		result.append(upgrades.pick_random())
	return result
