extends Node

@onready var animation_player := $AnimationPlayer

var exchange_scene = preload("res://levels/exchange.tscn")
var win_scene = preload("res://levels/win.tscn")
var prev_scene_name: String

func change_scene(scene: PackedScene):
	prev_scene_name = get_tree().current_scene.name

	animation_player.play_backwards("transition")
	await Globals.wait(0.5)
	get_tree().change_scene_to_packed(scene)
	Events.change_scene.emit(scene)
	await Globals.wait(0.5)
	animation_player.play("transition")

func next_level():
	var level_num = prev_scene_name.erase(0, 6).to_int()
	var next_level_path = "res://levels/level_%s.tscn" % str(level_num + 1)
	if ResourceLoader.exists(next_level_path):
		var level = load(next_level_path)
		change_scene(level)
