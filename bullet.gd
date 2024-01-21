extends Area2D
class_name Bullet

var speed = 0
var wall_hit_scene = preload("res://particles/wall_hit.tscn")

func _physics_process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta

func _on_visible_on_screen_notifier_screen_exited() -> void:
	# queue_free()
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Wall: destroy()

func destroy():
	var wall_hit = wall_hit_scene.instantiate() as GPUParticles2D
	wall_hit.global_position = global_position
	wall_hit.emitting = true
	Globals.world.add_child(wall_hit)
	get_tree().create_timer(wall_hit.lifetime).timeout.connect(wall_hit.queue_free)
	queue_free()
