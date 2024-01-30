extends TextureRect
class_name Mouse

enum MODE {
	CROSSHAIR,
	DEFAULT,
}

@export var animation_speed = 10
@export var crosshair_texture: Texture2D
@export var default_texture: Texture2D

var target_rotation = 0

func _enter_tree() -> void:
	Globals.mouse = self

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Events.change_scene.connect(_on_change_scene)

func _process(delta: float) -> void:
	var target = get_global_mouse_position()
	position = target - size / 2

	scale = scale.lerp(Vector2.ONE, (animation_speed if texture == crosshair_texture else 25) * delta)
	rotation_degrees = move_toward(rotation_degrees, target_rotation, 800 * delta)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and texture == default_texture:
		scale = Vector2.ONE * 0.8

func impact():
	scale = Vector2.ONE * 1.8

func impact_rotation():
	impact()
	target_rotation += 90

func change_texture(mode: MODE):
	if mode == MODE.CROSSHAIR:
		texture = crosshair_texture
	elif mode == MODE.DEFAULT:
		texture = default_texture

func _on_change_scene(_scene: PackedScene):
	texture = default_texture
	target_rotation = 0
	rotation = 0
