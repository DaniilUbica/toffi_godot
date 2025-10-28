extends CharacterBody2D

@export var speed: int = 500
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("idle")

func _physics_process(_delta) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if direction.length() > 0:
		animated_sprite.play("run")
		
		direction = direction.normalized() * speed
		if direction.x != 0:
			animated_sprite.flip_h = direction.x < 0
	else:
		animated_sprite.play("idle")

	velocity = direction

	move_and_slide()
	
