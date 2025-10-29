extends BaseCharacter2D

@onready var player := $"/root/main/Player"

const melee_enemy_max_health: int = 15

func _ready() -> void:
	await get_tree().process_frame
	animated_sprite.play("run")
	current_health = melee_enemy_max_health
	speed = 300

func _physics_process(_delta) -> void:
	if player && global_position.distance_to(player.global_position) > attack_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		animated_sprite.flip_h = direction.x < 0
		
		move_and_slide()
	elif !player:
		assert(false)
