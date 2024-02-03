extends Node
class_name StartMenu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		SceneManager.change_scene(SceneManager.exchange_scene)
		UpgradeManager.current_upgrades = UpgradeManager.get_random_upgrades(1)
		UpgradeManager.activate_all_upgrades()
		Scoring.boss_times = []
		Scoring.total_health_lost = 0
