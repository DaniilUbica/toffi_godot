extends BaseEnemy2D

const melee_enemy_max_health: int = 15
const melee_enemy_attack_damage: int = 3

func _ready() -> void:
	super._ready()
	current_health = melee_enemy_max_health
	
func attack() -> void:
	player.take_damage(melee_enemy_attack_damage)
