extends Node
class_name Upgrades

enum UPGRADES {
	LIFE,
	SPEED,
	DAMAGE
}

@export var upgrades: Array[UpgradeResource] = []

var current_upgrades: Array[UpgradeResource] = []

func get_random_upgrades(amount: int) -> Array[UpgradeResource]:
	var result: Array[UpgradeResource] = []
	for i in range(amount):
		result.append(upgrades.pick_random())
	return result

func activate_upgrade(upgrade: UPGRADES):
	var method = UPGRADES.keys()[upgrade].to_lower() + "_upgrade"
	if has_method(method): call(method)

func life_upgrade():
	pass

func speed_upgrade():
	pass

func damage_upgrade():
	pass
