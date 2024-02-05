extends Node
class_name StartMenu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		AudioManager.play_sound(AudioManager.select)
		SceneManager.change_scene(SceneManager.exchange_scene)
		Stats.reset_stats()
		UpgradeManager.current_upgrades = UpgradeManager.get_random_upgrades(2)
		Scoring.boss_times = []
		Scoring.total_health_lost = 0
