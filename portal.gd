extends Area2D
class_name Portal

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.go_in_portal.emit(self)
