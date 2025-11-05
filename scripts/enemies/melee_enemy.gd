extends BaseEnemy2D

func _ready() -> void:
	super._ready()
	enemy_type = EnemyType.MELEE

	init_enemy()
	
func attack() -> void:
	player.take_damage(enemy_damage)
