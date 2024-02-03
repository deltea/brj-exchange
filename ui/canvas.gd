extends CanvasLayer
class_name Canvas

@onready var boss_health := $BossHealth as TextureProgressBar
@onready var player_health := $PlayerHealth as TextureProgressBar
@onready var boss_name_label := $BossName
@onready var animation_player := $AnimationPlayer
@onready var time_label := $Time

func _enter_tree() -> void:
	Globals.canvas = self
	Events.boss_defeated.connect(_on_boss_defeated)

func _ready() -> void:
	boss_health.tint_progress = Globals.world.boss_health_color
	Events.player_die.connect(_on_player_die)

func set_boss_name(boss_name: String):
	boss_name_label.text = boss_name
	animation_player.play("show_boss_name")

func set_time(time: float):
	time_label.text = str(snapped(time, 0.01)) + "s"

func hide_hud():
	boss_health.visible = false
	player_health.visible = false
	time_label.visible = false

func _on_boss_defeated():
	hide_hud()

func _on_player_die():
	hide_hud()
