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

func get_random_upgrades(amount: int, cost: int = 0) -> Array[UpgradeResource]:
	var result: Array[UpgradeResource] = []
	if cost > 0:
		while len(result) < amount:
			var random_upgrade = upgrades.pick_random()
			if random_upgrade.cost == cost: result.push_back(random_upgrade)
	else:
		for i in range(amount):
			result.push_back(upgrades.pick_random())
	return result

func activate_upgrade(upgrade: UPGRADES):
	var method = UPGRADES.keys()[upgrade].to_lower() + "_upgrade"
	if has_method(method):
		call(method)
		print("activated ", method)

func activate_all_upgrades():
	Stats.reset_stats()
	for upgrade in current_upgrades:
		activate_upgrade(upgrade.method)

# ---------- Upgrades ----------

func life_upgrade():
	Stats.current.max_health += 15
	Stats.current.enemy_damage -= 1

func speed_upgrade():
	Stats.current.run_speed += 20
	Stats.current.dash_duration += 0.04
	Stats.current.dash_speed += 50
	Stats.current.bullet_speed += 100

func size_upgrade():
	Stats.current.player_size -= 0.1
	Stats.current.bullet_size += 0.2

func regen_upgrade():
	Stats.current.regen += 0.4

func ricochet_upgrade():
	Stats.current.bullet_bounce += 1

func strength_upgrade():
	Stats.current.run_speed -= 30
	Stats.current.bullet_speed += 50
	Stats.current.bullet_spread += 5.0
	Stats.current.fire_rate += 4.0

func shield_upgrade():
	Stats.current.shield_size += (0.5 if Stats.current.shield_size > 0 else 1.0)

func helper_upgrade():
	Stats.current.helper_amount += 1

func ring_upgrade():
	Stats.current.damage_ring_size += (0.5 if Stats.current.damage_ring_size > 0 else 1.0)
