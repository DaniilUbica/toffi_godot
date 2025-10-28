extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_rate: float = 2.0
@export var spawn_radius: float = 100.0

@onready var timer = $Timer
@onready var player = get_node("/root/main/Player")

func _ready():
	timer.wait_time = spawn_rate
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	if enemy_scene and player:
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	var random_angle = randf() * 2 * PI
	var random_distance = randf() * spawn_radius
	var spawn_position = Vector2(
		cos(random_angle) * random_distance, 
		sin(random_angle) * random_distance
	)
	
	enemy.global_position = global_position + spawn_position
	get_parent().add_child(enemy)
