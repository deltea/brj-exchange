extends CanvasLayer
class_name Canvas

@onready var boss_health := $BossHealth as TextureProgressBar
@onready var player_health := $PlayerHealth as TextureProgressBar

func _enter_tree() -> void:
	Globals.canvas = self
