extends TextureButton
class_name Card

@export var hover_y = -5
@export var animation_speed = 100

var upgrade: UpgradeResource
var animation_offset = 0
var target_rotation = 0
var tilted_rotation: float
var hovering = false
var target_position: Vector2

func _ready() -> void:
	texture_normal = upgrade.texture
	target_rotation = tilted_rotation

func _process(delta: float) -> void:
	position.y = move_toward(position.y, target_position.y + hover_y if hovering else target_position.y, animation_speed * delta) + (sin(Globals.time * 2 + (animation_offset * 7)) * 1.4)
	rotation_degrees = move_toward(rotation_degrees, target_rotation, 150 * delta)

func _on_mouse_entered():
	print('ye')
	hovering = true

func _on_mouse_exited():
	hovering = false
