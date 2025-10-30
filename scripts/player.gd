extends BaseCharacter2D

@export var acceleration: float = 1500.0
@export var friction: float = 2000.0

@onready var hud_layer := $"/root/main/HUDLayer" as CanvasLayer

const range_weapon_scene = preload("res://range_weapon.tscn")
const player_attack_range: int = 350
const player_weapon_collision_layers: Array[int] = [2]

const health_bar_scene = preload("res://health_bar.tscn")

var range_weapon: Node2D
var health_bar: ProgressBar

var health_bar_offset := 50

func _ready() -> void:
	super._ready()
	animated_sprite.play("idle")
	attack_range = player_attack_range
	
	init_range_weapon()
	init_health_bar()

func _process(_delta: float) -> void:
	update_health_bar_position()

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
	
func init_health_bar() -> void:
	health_bar = health_bar_scene.instantiate()
	health_bar.setup_health_bar(max_health, max_health, false)

	update_health_bar_position()

	health_changed.connect(func(new_health):
		health_bar.value = new_health
	)
	
	hud_layer.add_child(health_bar)

func update_health_bar_position() -> void:
	var screen_pos = get_global_transform_with_canvas().origin
	health_bar.position = screen_pos + Vector2(-health_bar.custom_minimum_size.x / 2, -get_texture_size().y / 2 - health_bar_offset)
