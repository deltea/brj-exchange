extends CanvasLayer
class_name Canvas

@onready var boss_health := $BossHealth as TextureProgressBar
@onready var player_health := $PlayerHealth as TextureProgressBar
@onready var boss_name_label := $BossName

func _enter_tree() -> void:
	Globals.canvas = self
	Events.boss_defeated.connect(_on_boss_defeated)

func _ready() -> void:
	boss_health.tint_progress = Globals.world.boss_health_color

func _on_boss_defeated():
	boss_health.visible = false
	player_health.visible = false

func set_boss_name(boss_name: String):
	boss_name_label.position.x = get_window()
	boss_name_label.text = boss_name
	var tween = get_tree().create_tween()
	# tween.tween_property(boss_name_label, "position", Vector2())
