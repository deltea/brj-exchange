extends Bullet
class_name EnemyBullet

@export var texture_1: Texture2D
@export var texture_2: Texture2D

@onready var sprite := $Sprite

func _on_animation_timer_timeout() -> void:
	sprite.texture = texture_2 if sprite.texture == texture_1 else texture_1

func _on_visible_on_screen_notifier_screen_exited() -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area is Shield and Stats.shield_size > 0:
		destroy()
