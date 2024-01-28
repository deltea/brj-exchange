extends Area2D
class_name Rock

@export var smaller_rock_scene: PackedScene
@export var smaller_rock_num = 5
@export var rotation_speed = 100
@export var movement_speed = 100
@export var animation_speed = 2
@export var max_health = 30
@export var explosion_scene: PackedScene
@export var damage = 10

@onready var sprite := $Sprite

var velocity = Vector2.ZERO
var health: float

func _enter_tree() -> void:
	health = max_health

func _ready() -> void:
	velocity = Vector2.from_angle(randf_range(0, PI * 2)) * movement_speed

func _process(delta: float) -> void:
	sprite.scale = sprite.scale.move_toward(Vector2.ONE, animation_speed * delta)

func _physics_process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	position += velocity * delta

func take_damage():
	flash()

	health -= Globals.player.bullet_damage
	if health < 0: die()

func die():
	if explosion_scene:
		var explosion = explosion_scene.instantiate() as CPUParticles2D
		explosion.position = position
		explosion.emitting = true
		Globals.world.add_child(explosion)

	if smaller_rock_scene:
		for i in smaller_rock_num:
			var smaller_rock = smaller_rock_scene.instantiate() as Rock
			smaller_rock.position = position
			Globals.world.add_child(smaller_rock)

	queue_free()

func flash():
	sprite.scale = Vector2.ONE * 1.2
	sprite.material.set_shader_parameter("enabled", true)
	await Globals.wait(0.2)
	sprite.material.set_shader_parameter("enabled", false)

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		var wall = body as Wall
		velocity = velocity.bounce(Vector2.from_angle(wall.rotation + PI / 2))

func _on_area_entered(area: Area2D) -> void:
	if area is PlayerBullet:
		(area as PlayerBullet).queue_free()
		take_damage()
