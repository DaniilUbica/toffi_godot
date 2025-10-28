extends Camera2D

@onready var tilemap = $"../../WallsLayer"
var player: Node2D

func _ready():
	player = get_parent()
	update_limits()
	
func _process(_delta: float) -> void:
	update_limits()

func update_limits():
	var used_rect = tilemap.get_used_rect()
	var cell_size = tilemap.tile_set.tile_size
	
	limit_left = used_rect.position.x * cell_size.x
	limit_right = (used_rect.position.x + used_rect.size.x) * cell_size.x
	limit_top = used_rect.position.y * cell_size.y
	limit_bottom = (used_rect.position.y + used_rect.size.y) * cell_size.y
