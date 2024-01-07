extends Camera2D
class_name Camera

@export var follow_speed = 10.0
@export var mouse_influence = 0.1

func _process(_delta: float) -> void:
	offset = (get_global_mouse_position() - global_position) * mouse_influence
