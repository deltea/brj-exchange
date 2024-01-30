extends Node2D
class_name World

@export var background_color: Color = Color.BLACK
@export var shadow_color: Color = Color.BLACK
@export var portal_color: Color = Color.WHITE
@export var boss_health_color: Color = Color.PALE_VIOLET_RED

var portal_scene = preload("res://portal.tscn")

func _enter_tree() -> void:
	Globals.world = self

func _ready() -> void:
	RenderingServer.set_default_clear_color(background_color)
	Events.boss_defeated.connect(_on_boss_defeated)
	Globals.mouse.change_texture(Mouse.MODE.CROSSHAIR)

func _on_boss_defeated():
	await Globals.wait(1.0)
	var portal = portal_scene.instantiate()
	portal.position = Vector2.ZERO
	add_child(portal)
