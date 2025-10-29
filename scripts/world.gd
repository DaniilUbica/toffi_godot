extends TileMapLayer

@export var world_size: Vector2i = Vector2i(200, 120)

const wall_tile_coords: Vector2i = Vector2i(0, 0)

func _ready() -> void:
	create_border_walls()

func create_border_walls() -> void:
	clear()
	
	for x in range(world_size.x):
		set_cell(Vector2i(x, 0), 0, wall_tile_coords)
		set_cell(Vector2i(x, world_size.y - 1), 0, wall_tile_coords)
	
	for y in range(1, world_size.y - 1):
		set_cell(Vector2i(0, y), 0, wall_tile_coords)
		set_cell(Vector2i(world_size.x - 1, y), 0, wall_tile_coords)
