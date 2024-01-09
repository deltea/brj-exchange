extends Area2D
class_name Card

@export var hover_y = -10
@export var animation_speed = 100

@onready var sprite := $Sprite

var upgrade: UpgradeResource
var animation_offset = 0
var hovering = false

func _ready() -> void:
	sprite.texture = upgrade.texture

func _process(delta: float) -> void:
	sprite.position.y = move_toward(sprite.position.y, hover_y if hovering else 0, animation_speed * delta)
	if not hovering:
		sprite.offset = Vector2(0, sin(Globals.time * 2 + (animation_offset * 7)) * 1.4)

func _on_mouse_entered() -> void:
	hovering = true

func _on_mouse_exited() -> void:
	hovering = false
