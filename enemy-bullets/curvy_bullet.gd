extends EnemyBullet
class_name CurvyBullet

@export var curve_magnitude = 3
@export var curve_speed = 3

var time = 0

func _ready() -> void:
	time = Globals.time

func _physics_process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta + (sin(curve_speed * Globals.time + time) * curve_magnitude * Vector2.DOWN)
