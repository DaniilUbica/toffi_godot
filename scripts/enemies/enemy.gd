extends CharacterBody2D

@export var speed: int = 500
var target: Node2D
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	await get_tree().process_frame
	target = get_node("/root/main/Player")
	animated_sprite.play("run")

func _physics_process(_delta):
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
