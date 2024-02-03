extends Node
class_name Upgrades

enum UPGRADES {
	LIFE,
	SPEED,
	SIZE,
	REGEN,
	RICOCHET,
	STRENGTH,
	SHIELD,
	HELPER,
	RING,
}

@export var upgrades: Array[UpgradeResource] = []

var current_upgrades: Array[UpgradeResource] = []

func _enter_tree() -> void:
	current_upgrades = get_random_upgrades(1)
	activate_all_upgrades()

func get_random_upgrades(amount: int) -> Array[UpgradeResource]:
	var result: Array[UpgradeResource] = []
	for i in range(amount):
		result.append(upgrades.pick_random())
	return result

func activate_upgrade(upgrade: UPGRADES):
	var method = UPGRADES.keys()[upgrade].to_lower() + "_upgrade"
	if has_method(method):
		call(method, 1)
		print("activated ", method)

func deactivate_upgrade(upgrade: UPGRADES):
	var method = UPGRADES.keys()[upgrade].to_lower() + "_upgrade"
	if has_method(method):
		call(method, -1)
		print("deactivated ", method)

func activate_all_upgrades():
	for upgrade in current_upgrades:
		activate_upgrade(upgrade.method)

# ---------- Upgrades ----------

func life_upgrade(value: int):
	Stats.max_health += 15 * value
	Stats.enemy_damage -= 1 * value

func speed_upgrade(value: int):
	Stats.run_speed += 20 * value
	Stats.dash_duration += 0.04 * value
	Stats.dash_speed += 50 * value
	Stats.bullet_speed += 100 * value

func size_upgrade(value: int):
	Stats.player_size -= 0.1 * value
	Stats.bullet_size += 0.2 * value

func regen_upgrade(value: int):
	Stats.regen += 0.4 * value

func ricochet_upgrade(value: int):
	Stats.bullet_bounce += 1 * value

func strength_upgrade(value: int):
	Stats.run_speed -= 30 * value
	Stats.bullet_speed += 50 * value
	Stats.bullet_spread += 5.0 * value
	Stats.fire_rate += 4.0 * value

func shield_upgrade(value: int):
	Stats.shield_size += (0.5 if Stats.shield_size > 0 else 1.0) * value

func helper_upgrade(value: int):
	pass

func ring_upgrade(value: int):
	Stats.damage_ring_size += (0.5 if Stats.damage_ring_size > 0 else 1.0) * value
