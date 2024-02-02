extends CanvasLayer
class_name GameOver

@export var animation_duration = 3.0
@export var background_color = Color.BLACK

@onready var progress := $Progress
@onready var cards := $Cards

var card_scene = preload("res://ui/card.tscn")

func _ready() -> void:
	RenderingServer.set_default_clear_color(background_color)
	var level_num = SceneManager.prev_scene_name.erase(0, 6).to_float()
	var target_value = (level_num - 1) * 100 + (100 - Globals.prev_boss_health)

	progress.value = 0
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(progress, "value", target_value, animation_duration)

	for upgrade in UpgradeManager.current_upgrades:
		await Globals.wait(animation_duration / len(UpgradeManager.current_upgrades) / 2)
		var card = card_scene.instantiate() as Card
		card.upgrade = upgrade
		cards.add_child(card)

func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene(SceneManager.main_menu_scene)
