extends Area2D
class_name Boss

@export var max_health = 300
@export var start_delay = 2.5

var health: float
var explosion_scene = preload("res://particles/explosion.tscn")

func _enter_tree() -> void:
	health = max_health

func _on_area_entered(area: Area2D) -> void:
	if area is PlayerBullet:
		(area as PlayerBullet).queue_free()
		take_damage()

func take_damage(damage: float = 0):
	AudioManager.play_sound(AudioManager.hit)
	flash()

	var prev_health = health
	health -= damage if damage > 0 else Stats.current.bullet_damage
	Globals.canvas.boss_health.value = 100.0 / max_health * health
	Globals.prev_boss_health = 100.0 / max_health * health
	if health < 0: die()

	var half_health = max_health / 2.0
	if prev_health > half_health and health <= half_health:
		Globals.canvas.set_boss_name("Phase 2")

func die():
	AudioManager.play_sound(AudioManager.explosion)
	Events.boss_defeated.emit()
	Globals.camera.shake(0.5, 2)
	var explosion = explosion_scene.instantiate() as CPUParticles2D
	explosion.position = position
	explosion.emitting = true
	Globals.world.add_child(explosion)
	AudioManager.beat_target_volume = 0
	Scoring.add_time()

	queue_free()

func flash():
	if $Sprite:
		$Sprite.material.set_shader_parameter("enabled", true)
		await Globals.wait(0.2)
		$Sprite.material.set_shader_parameter("enabled", false)

func is_second_phase():
	return health < max_health / 2.0
