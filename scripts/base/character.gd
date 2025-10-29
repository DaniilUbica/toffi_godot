@abstract class_name BaseCharacter2D
extends CharacterBody2D

@export var speed: float = 500.0
@export var max_health: int = 20
@export var attack_range: int = 100

@onready var animated_sprite := $AnimatedSprite2D

var current_health: int

func _ready():
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	queue_free()
