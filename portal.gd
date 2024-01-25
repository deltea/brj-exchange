extends Area2D
class_name Portal

@onready var sprite := $Sprite
@onready var particles := $Particles

func _ready() -> void:
	particles.self_modulate = Globals.world.portal_color
	sprite.self_modulate = Globals.world.portal_color

	global_scale = Vector2.ZERO
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_scale", Vector2.ONE, 1.0)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.go_in_portal.emit(self)
