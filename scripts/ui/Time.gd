extends Label

onready var T = get_node("/root/Game/Timer")

func _process(_delta):
	text = "Time: " + str(stepify(T.timer, 0.01)).pad_decimals(2)
