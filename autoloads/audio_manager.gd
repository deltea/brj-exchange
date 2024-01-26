extends Node

@export var shoot: AudioStream
@export var hurt: AudioStream
@export var enemy_hit: AudioStream

@onready var sfx_player := $SFXStreamPlayer
@onready var music_player := $MusicPlayer

func play_sound(sound: AudioStream):
	sfx_player.stream = sound
	sfx_player.play()
