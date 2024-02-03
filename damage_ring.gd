extends Area2D
class_name DamageRing

@export var damage = 1

@onready var sprite := $Sprite

func _ready() -> void:
	sprite.self_modulate = Globals.world.shadow_color
	scale = Stats.damage_ring_size * Vector2.ONE

func _on_damage_timer_timeout() -> void:
	var collisions = get_overlapping_areas()
	for collision in collisions:
		if collision is Boss or collision is CloudPuff or collision is Rock:
			collision.take_damage(damage)
