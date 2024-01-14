extends Node2D
class_name World

@export var background_color: Color = Color.BLACK
@export var shadow_color: Color = Color.BLACK

func _enter_tree() -> void:
	Globals.world = self

func _ready() -> void:
	RenderingServer.set_default_clear_color(background_color)
