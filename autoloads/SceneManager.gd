extends Node

var exchange_scene = preload("res://levels/exchange.tscn")

func change_scene(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
