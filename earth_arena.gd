extends Node2D

@export var rotation_speed = 10

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
