extends CanvasLayer

@export var card_tilt = 10
@export var card_separation = 45.0
@export var card_y_offset = 10.0
@export var tween_speed = 0.2
@export var exchange_row_y = 72
@export var current_row_y = 200

var card_scene = preload("res://ui/card.tscn")

func _ready() -> void:
	var upgrade_num = 5
	var random_upgrades = UpgradeManager.get_random_upgrades(upgrade_num)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_parallel()
	for i in range(upgrade_num):
		var card = card_scene.instantiate() as Card
		card.position = Vector2(480.0 / 2.0 - (52.0 / 2), 0 - 68 * 2)
		card.upgrade = random_upgrades[i]
		card.animation_offset = i

		#! Add the card tilting and y offset DYNAMICALLY
		var card_x = 240 + i * card_separation - (upgrade_num - 1) * card_separation / 2.0 - 26
		var card_y = exchange_row_y - abs(i - 2) * card_y_offset - 34
		card.tilted_rotation = -i * card_tilt + 2 * card_tilt
		card.target_position = Vector2(card_x, card_y)
		tween.chain().tween_property(card, "position", Vector2(card_x, card_y), tween_speed)

		add_child(card)

	var current_num = UpgradeManager.current_upgrades.size()
	for i in range(current_num):
		var card = card_scene.instantiate() as Card
		card.position = Vector2(480.0 / 2.0 - (52.0 / 2), 0 - 68 * 2)
		card.upgrade = UpgradeManager.current_upgrades[i]
		card.animation_offset = i

		var card_x = 240 + i * card_separation - (current_num - 1) * card_separation / 2.0 - 26
		var card_y = current_row_y + abs(i - 2) * card_y_offset - 34
		card.tilted_rotation = i * card_tilt - 2 * card_tilt
		card.target_position = Vector2(card_x, card_y)
		tween.chain().tween_property(card, "position", Vector2(card_x, card_y), tween_speed)

		add_child(card)
