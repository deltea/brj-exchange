extends Camera2D
class_name Camera

@export var follow_speed = 10.0
@export var mouse_influence = 0.1
@export var rotation_speed = 20.0
@export var impact_rotation = 5.0
@export var zoom_speed = 10.0
@export var impact_zoom = 1.1

func _enter_tree() -> void:
	Globals.camera = self

func _process(delta: float) -> void:
	offset = (get_global_mouse_position() - global_position) * mouse_influence
	rotation_degrees = move_toward(rotation_degrees, 0, rotation_speed * delta)
	zoom = zoom.move_toward(Vector2.ONE, zoom_speed * delta)

func impact():
	rotation_degrees = (1 if randf() > 0.5 else -1) * impact_rotation
	# zoom = impact_zoom * Vector2.ONE
