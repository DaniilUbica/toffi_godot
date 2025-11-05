extends Area2D

@export var speed: float = 1500.0
@export var damage: int = 10

var direction: Vector2 = Vector2.LEFT

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta) -> void:
	var movement = direction * speed * delta
	position += movement

func _on_body_entered(body) -> void:
	if body is BaseCharacter2D:
		body.take_damage(damage)
		
	queue_free()

func setup(
	bullet_direction: Vector2, 
	start_position: Vector2, 
	bullet_collision_mask: Array[int]
	) -> void:
	direction = bullet_direction.normalized()
	global_position = start_position
	
	collision_mask = 0
	for mask_value in bullet_collision_mask:
		set_collision_mask_value(mask_value, true)
