extends Node

@export var shoot: AudioStream
@export var hurt: AudioStream
@export var enemy_hit: AudioStream
@export var music_fade_speed = 0.5

@onready var sfx_player := $SFXStreamPlayer
@onready var melody_player := $MelodyStreamPlayer
@onready var beat_player := $BeatStreamPlayer

var beat_target_volume = 0

func _ready() -> void:
	beat_target_volume = 0
	Events.change_scene.connect(_on_change_scene)

func _process(delta: float) -> void:
	beat_player.volume_db = linear_to_db(move_toward(db_to_linear(beat_player.volume_db), beat_target_volume, music_fade_speed * delta))

func play_sound(sound: AudioStream):
	sfx_player.stream = sound
	sfx_player.play()

func _on_change_scene(scene: PackedScene):
	beat_target_volume = 0
