tool
extends Viewport

#TODO: Move this into its own scene and give all Friendly entities one
func _process(_delta):
	set_size($PlayerNameLabel.rect_size)
