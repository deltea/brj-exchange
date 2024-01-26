extends Area2D
class_name Whirlpool

@export var animation_speed = 2

var target_scale = Vector2.ZERO

func _ready() -> void:
	scale = Vector2.ZERO
	pass

func _process(delta: float) -> void:
	scale = scale.move_toward(target_scale, animation_speed * delta)
