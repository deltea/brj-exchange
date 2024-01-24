extends Area2D
class_name EnemyTile

@export var damage = 10.0
@export var telegraph_duration = 1.5
@export var damage_color = Color.WHITE

@onready var collider := $CollisionShape

var tween: Tween

func _ready() -> void:
	scale = Vector2.ZERO
	collider.disabled = true
	tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2.ONE, telegraph_duration)
	tween.tween_property(collider, "disabled", false, 0)
	tween.tween_property($Sprite, "self_modulate", damage_color, 0)
	tween.tween_property(collider, "disabled", true, 0.5)
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0)
	tween.tween_callback(queue_free)
