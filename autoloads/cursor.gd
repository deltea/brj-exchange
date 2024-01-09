extends TextureRect
class_name Mouse

@export var animation_speed = 10

var target_rotation = 0

func _enter_tree() -> void:
	Globals.mouse = self

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	var target = get_global_mouse_position()
	position = target - Vector2(5, 5)

	scale = scale.lerp(Vector2.ONE, animation_speed * delta)
	rotation_degrees = move_toward(rotation_degrees, target_rotation, 800 * delta)

func impact():
	scale = Vector2.ONE * 1.8

func impact_rotation():
	impact()
	target_rotation += 90
