extends BaseCharacter2D

@export var acceleration: float = 1500.0
@export var friction: float = 2000.0

const player_attack_range: int = 500

func _ready() -> void:
	animated_sprite.play("idle")
	attack_range = player_attack_range

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if direction.length() > 0:
		direction = direction.normalized()
		animated_sprite.play("run")
		
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		animated_sprite.flip_h = direction.x < 0
	else:
		animated_sprite.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
