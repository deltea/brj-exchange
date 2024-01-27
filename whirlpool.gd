extends Area2D
class_name Whirlpool

@export var animation_speed = 2

@onready var collider := $CollisionShape

var target_scale = Vector2.ZERO

func _ready() -> void:
	scale = Vector2.ZERO
	toggle_collider(false)

func _process(delta: float) -> void:
	scale = scale.move_toward(target_scale, animation_speed * delta)

func toggle_collider(value: bool):
	collider.disabled = not value
