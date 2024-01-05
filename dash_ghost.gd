extends Sprite2D
class_name DashGhost

var duration: float

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), duration)
	await tween.finished
	queue_free()
