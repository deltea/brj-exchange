extends Sprite2D
class_name DropShadow

@export var shadow_offset = Vector2(0, 8)
@export var shadow_color: Color = Color.DARK_GRAY
@export var scale_multiplier = Vector2.ONE
@export var ordering = -20

var parent_sprite: Sprite2D

func _ready():
	if not get_parent() is Sprite2D: return

	parent_sprite = get_parent() as Sprite2D
	texture = parent_sprite.texture
	z_index = ordering
	material.set_shader_parameter("color", shadow_color)

func _process(_delta: float) -> void:
	if not get_parent(): return

	global_position = parent_sprite.global_position + shadow_offset
	global_rotation = parent_sprite.global_rotation
	global_scale = parent_sprite.global_scale * scale_multiplier
