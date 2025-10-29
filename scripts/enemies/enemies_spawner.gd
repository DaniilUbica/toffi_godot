extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_rate: float = 2.0
@export var spawn_radius: float = 100.0

@onready var timer = $Timer
@onready var player = $"/root/main/Player"

var spawned_enemies = []

func _ready() -> void:
	timer.wait_time = spawn_rate
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
func _process(_delta: float) -> void:
	var i = 0
	while i < spawned_enemies.size():
		var enemy = spawned_enemies[i]
		if !is_instance_valid(enemy) || enemy.current_health <= 0:
			spawned_enemies.remove_at(i)
		else:
			i += 1

func _on_timer_timeout() -> void:
	if enemy_scene and player:
		spawn_enemy()

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	
	var random_angle = randf() * 2 * PI
	var random_distance = randf() * spawn_radius
	var spawn_position = Vector2(
		cos(random_angle) * random_distance, 
		sin(random_angle) * random_distance
	)
	
	enemy.global_position = global_position + spawn_position
	get_parent().add_child(enemy)
	spawned_enemies.push_back(enemy)
