@abstract class_name BaseEnemy2D
extends BaseCharacter2D

enum EnemyType {
	MELEE = 0,
	UNKNOWN = -1
}

const max_health_data_key := "max_health"
const damage_data_key := "damage"

var enemy_initial_data = {
	EnemyType.MELEE: { "max_health": 15, "damage": 3 }
}

@onready var player := $"/root/main/Player" as BaseCharacter2D
@onready var loot_manager := $"/root/main/LootManager"

@export var enemy_attack_cooldown := 2.0

var enemy_attack_timer: Timer
var enemy_attack_range := 100
var enemy_speed := 300.0
var enemy_type := EnemyType.UNKNOWN
var enemy_damage := 0

var _can_attack := false

@abstract func attack() -> void

func _ready() -> void:
	await get_tree().process_frame
	animated_sprite.play("run")
	speed = enemy_speed
	attack_range = enemy_attack_range
	
	init_attack_timer()

func _physics_process(_delta) -> void:
	if player && global_position.distance_to(player.global_position) > attack_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		animated_sprite.flip_h = direction.x < 0
		
		move_and_slide()
	elif !player:
		assert(false)
		
func _process(_delta: float) -> void:
	if _can_attack && player && global_position.distance_to(player.global_position) <= attack_range:
		attack()
		_can_attack = false
	elif !player:
		assert(false)

func _on_ready_to_attack() -> void:
	_can_attack = true
	
func die():
	if loot_manager:
		loot_manager.spawn_loot(enemy_type, global_position)
	queue_free()
	
func init_enemy():
	var initial_data = enemy_initial_data.get(enemy_type)
	if initial_data:
		current_health = initial_data.get(max_health_data_key, max_health)
		enemy_damage = initial_data.get(damage_data_key, enemy_damage)
	else:
		push_error("Enemy's initial data is null")

func init_attack_timer() -> void:
	enemy_attack_timer = Timer.new()
	enemy_attack_timer.wait_time = enemy_attack_cooldown
	enemy_attack_timer.timeout.connect(_on_ready_to_attack)
	
	add_child(enemy_attack_timer)
	enemy_attack_timer.start()
