extends Camera2D
class_name Camera

@export var follow_speed = 10.0
@export var zoom_speed = 3
@export var mouse_strength = 0.1
@export var rotation_speed = 20.0
@export var impact_rotation = 5.0
@export var shake_damping_speed = 1.0

var shake_duration = 0;
var shake_magnitude = 0;
var original_pos = Vector2.ZERO;
var target_zoom = Vector2.ONE

func _enter_tree() -> void:
	Globals.camera = self

func _ready() -> void:
	original_pos = position

func _process(delta: float) -> void:
	offset = (get_global_mouse_position() - global_position) * mouse_strength
	rotation_degrees = move_toward(rotation_degrees, 0, rotation_speed * delta)
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)

	if shake_duration > 0:
		position = original_pos + random_direction() * shake_magnitude
		shake_duration -= delta * shake_damping_speed
	else:
		shake_duration = 0
		position = original_pos

func random_direction():
	return Vector2.from_angle(deg_to_rad(randf_range(0, 360)))

func shake(duration: float, magnitude: float):
	shake_duration = duration
	shake_magnitude = magnitude

func impact():
	rotation_degrees = (1 if randf() > 0.5 else -1) * impact_rotation
