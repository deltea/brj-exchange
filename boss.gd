extends Area2D
class_name Boss

@export var max_health = 100

var health = max_health

func _on_area_entered(area: Area2D) -> void:
	if area is PlayerBullet:
		(area as PlayerBullet).queue_free()
		take_damage()

func take_damage():
	flash()

	health -= Globals.player.bullet_damage
	if health < 0:
		die()

func die():
	queue_free()
	SceneManager.change_scene(SceneManager.exchange_scene)

func flash():
	if $Sprite:
		$Sprite.material.set_shader_parameter("enabled", true)
		await Globals.wait(0.2)
		$Sprite.material.set_shader_parameter("enabled", false)
