extends Area2D
class_name Bullet

var speed = 0

func _physics_process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
