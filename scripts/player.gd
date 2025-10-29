extends BaseCharacter2D

@export var acceleration: float = 1500.0
@export var friction: float = 2000.0

const range_weapon_scene = preload("res://range_weapon.tscn")
const player_attack_range: int = 500
const player_weapon_collision_layers: Array[int] = [2]

var range_weapon: Node2D

func _ready() -> void:
	animated_sprite.play("idle")
	attack_range = player_attack_range
	
	init_range_weapon()

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

func init_range_weapon() -> void:
	range_weapon = range_weapon_scene.instantiate()
	range_weapon.bullet_scene = preload("res://bullet.tscn")
	range_weapon.weapon_collision_layers = player_weapon_collision_layers
	range_weapon.weapon_attack_range = player_attack_range
	
	add_child(range_weapon)
