extends Node

@onready var animation_player := $AnimationPlayer

var exchange_scene = preload("res://levels/exchange.tscn")

func change_scene(scene: PackedScene):
	animation_player.play_backwards("transition")
	await Globals.wait(1.0)
	get_tree().change_scene_to_packed(scene)
	await Globals.wait(1.0)
	animation_player.play("transition")
