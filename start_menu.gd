extends Node
class_name StartMenu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		SceneManager.change_scene(SceneManager.exchange_scene)
