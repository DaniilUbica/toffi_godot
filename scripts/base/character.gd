@abstract class_name BaseCharacter2D
extends CharacterBody2D

@export var speed: float = 500.0
@export var max_health: int = 20
@export var attack_range: int = 100

@onready var animated_sprite := $AnimatedSprite2D as AnimatedSprite2D

var current_health: int

signal health_changed(new_health)

func _ready():
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()
	
	health_changed.emit(current_health)

func die():
	queue_free()

func get_texture_size() -> Vector2:
	var texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)
	return texture.get_size() * animated_sprite.scale
