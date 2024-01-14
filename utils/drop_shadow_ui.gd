extends TextureRect
class_name DropShadowUI

@export var shadow_offset = Vector2(0, 8)
@export var shadow_color: Color = Color.DARK_GRAY
@export var scale_multiplier = Vector2.ONE
@export var ordering = -20

var parent: TextureButton

func _ready():
	if not get_parent() is TextureButton: return

	parent = get_parent() as TextureButton
	texture = parent.texture_normal
	z_index = ordering
	material.set_shader_parameter("color", shadow_color)

func _process(_delta: float) -> void:
	if not get_parent(): return

	position = parent.position + shadow_offset
	rotation = parent.rotation
	scale = parent.scale * scale_multiplier
