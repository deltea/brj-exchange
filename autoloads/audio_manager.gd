extends Node

@export var music_fade_speed = 0.5

@export var shoot: AudioStream
@export var hurt: AudioStream
@export var hit: AudioStream
@export var boing: AudioStream
@export var explosion: AudioStream
@export var fireball: AudioStream
@export var fireball_small: AudioStream
@export var shield: AudioStream
@export var dash: AudioStream
@export var helper: AudioStream
@export var wind: AudioStream
@export var win: AudioStream
@export var select: AudioStream
@export var card_hover: AudioStream
@export var score: AudioStream

@onready var melody_player := $MelodyStreamPlayer
@onready var beat_player := $BeatStreamPlayer

var beat_target_volume = 0

func _ready() -> void:
	beat_target_volume = 0
	Events.change_scene.connect(_on_change_scene)

func _process(delta: float) -> void:
	beat_player.volume_db = linear_to_db(move_toward(db_to_linear(beat_player.volume_db), beat_target_volume, music_fade_speed * delta))

func play_sound(sound: AudioStream):
	var sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.bus = "SFX"
	sfx_player.stream = sound
	sfx_player.play()
	sfx_player.connect("finished", sfx_player.queue_free)

func _on_change_scene(_scene: PackedScene):
	beat_target_volume = 0
