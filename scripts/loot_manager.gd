extends Node

class LootItem:
	var item_scene: PackedScene
	var drop_chance: float
	
	func _init(scene: PackedScene, chance: float):
		item_scene = scene
		drop_chance = chance

var enemy_loot_tables := {}

func _ready():
	var melee_enemy_loot = [
		LootItem.new(preload("res://heal_loot.tscn"), 1.0),
	]
	
	enemy_loot_tables[BaseEnemy2D.EnemyType.MELEE] = melee_enemy_loot

func spawn_loot(enemy_type: BaseEnemy2D.EnemyType, position: Vector2):
	if not enemy_loot_tables.has(enemy_type):
		push_error("Loot table not found for enemy type: " + String.num(enemy_type))
		return
	
	var loot_table = enemy_loot_tables[enemy_type]
	
	for loot_item in loot_table:
		if randf() <= loot_item.drop_chance:
			var item_instance = loot_item.item_scene.instantiate()
			if item_instance:
				call_deferred("add_child", item_instance)
				item_instance.global_position = position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
