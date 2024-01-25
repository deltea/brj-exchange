extends Control
class_name WobbleUI

@export var speed = 2.0
@export var magnitude = 20.0

func _process(delta: float) -> void:
	rotation = sin(speed * Globals.time) * magnitude * delta
