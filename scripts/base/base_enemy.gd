@abstract class_name BaseEnemy2D
extends BaseCharacter2D

@onready var player := $"/root/main/Player" as BaseCharacter2D

@export var enemy_attack_cooldown := 2.0

var enemy_attack_timer: Timer
var enemy_attack_range := 100
var enemy_speed := 300.0

var _can_attack := false
var _is_attacking := false

@abstract func attack() -> void

func _ready() -> void:
	await get_tree().process_frame
	animated_sprite.play("run")
	speed = enemy_speed
	attack_range = enemy_attack_range
	
	init_attack_timer()

func _physics_process(_delta) -> void:
	if current_health <= 0:
		enemy_attack_timer.stop()
		_can_attack = false
		return
	
	if _is_attacking:
		var direction = (player.global_position - global_position).normalized()
		animated_sprite.flip_h = direction.x < 0
		return

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

func init_attack_timer() -> void:
	enemy_attack_timer = Timer.new()
	enemy_attack_timer.wait_time = enemy_attack_cooldown
	enemy_attack_timer.timeout.connect(_on_ready_to_attack)
	
	add_child(enemy_attack_timer)
	enemy_attack_timer.start()
