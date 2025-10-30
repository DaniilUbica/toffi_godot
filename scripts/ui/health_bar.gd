extends ProgressBar

var hb_width := 100
var hb_height := 20

func _ready() -> void:
	value = max_value
	
func setup_health_bar(max_health: int, current_health: int, a_show_percentage: bool) -> void:
	max_value = max_health
	value = current_health
	show_percentage = a_show_percentage
