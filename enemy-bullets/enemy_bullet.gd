extends Bullet
class_name EnemyBullet

@export var texture_1: Texture2D
@export var texture_2: Texture2D
@export var damage = 20.0

@onready var sprite := $Sprite

func _on_animation_timer_timeout() -> void:
	sprite.texture = texture_2 if sprite.texture == texture_1 else texture_1
