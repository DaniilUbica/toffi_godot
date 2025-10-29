extends Node2D

@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 2.0
@export var weapon_collision_layers: Array[int] = [1]
@export var weapon_attack_range: int = 100

@onready var timer = $ReloadTimer
@onready var enemies_spawner = $"/root/main/EnemiesSpawner"

var shoot_sheduled: bool = false

func _ready() -> void:
	timer.wait_time = shoot_cooldown
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _process(_delta: float) -> void:
	if shoot_sheduled:
		var nearest_enemy = find_nearest_enemy()
		if (
			bullet_scene && 
			nearest_enemy && 
			nearest_enemy.global_position.distance_to(global_position) <= weapon_attack_range
			):
			shoot(global_position.direction_to(nearest_enemy.global_position))
			shoot_sheduled = false
			timer.start()

func _on_timer_timeout() -> void:
	var nearest_enemy = find_nearest_enemy()
	if (
		bullet_scene && 
		nearest_enemy && 
		nearest_enemy.global_position.distance_to(global_position) <= weapon_attack_range
		):
		shoot(global_position.direction_to(nearest_enemy.global_position))
	elif !bullet_scene:
		assert(false)
	else:
		shoot_sheduled = true
		timer.stop()

func shoot(direction: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.setup(direction.normalized(), position, weapon_collision_layers)
	
	add_child(bullet)
	
func find_nearest_enemy() -> BaseCharacter2D:
	if !enemies_spawner || (enemies_spawner && enemies_spawner.spawned_enemies.size() == 0):
		return null
	
	var enemies: Array = enemies_spawner.spawned_enemies
	if enemies.size() == 1:
		return enemies.front()
	
	var nearest_enemy = enemies.front()
	var nearest_distance = INF
	for enemy in enemies:
		if is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if nearest_distance > distance:
				nearest_distance = distance
				nearest_enemy = enemy
	
	return nearest_enemy
