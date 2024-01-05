extends CharacterBody2D
class_name Player

@export var speed = 60

@export_category("Animation")
@export var tilt = 15

@onready var sprite := $Sprite

func _enter_tree() -> void:
	Globals.player = self

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	sprite.rotation_degrees = input.x * tilt

	velocity = input * speed

	move_and_slide()
