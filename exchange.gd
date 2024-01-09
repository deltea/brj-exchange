extends Node2D

@export var card_tilt = 10
@export var card_separation = 45.0
@export var card_y_offset = 10.0
@export var tween_speed = 0.2

var card_scene = preload("res://ui/card.tscn")

func _ready() -> void:
	var upgrade_num = 5
	var random_upgrades = UpgradeManager.get_random_upgrades(upgrade_num)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	for i in range(upgrade_num):
		var card = card_scene.instantiate() as Card
		card.position = Vector2(480.0 / 2.0 - (52.0 / 2), 0 - 68)
		card.upgrade = random_upgrades[i]
		card.animation_offset = i

		#! Add the card tilting and y offset DYNAMICALLY
		var card_x = 240 + i * card_separation - (upgrade_num - 1) * card_separation / 2.0
		var card_y = 64 + abs(i - 2) * card_y_offset
		var target_rotation = i * card_tilt - 2 * card_tilt
		tween.chain().tween_property(card, "position", Vector2(card_x, card_y), tween_speed)
		tween.tween_property(card, "rotation_degrees", target_rotation, tween_speed)

		add_child(card)
