extends MarginContainer

onready var PlayerHealthbar = get_node("/root/Game/UI/Margin/Container/Center/PlayerHealth/Bar")

func _process(_delta):
# warning-ignore:narrowing_conversion
	add_constant_override("margin_left", get_viewport_rect().size.x/2 + 150)
	add_constant_override("margin_top", PlayerHealthbar.rect_global_position.y - 50)
