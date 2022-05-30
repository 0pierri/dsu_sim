extends Label

onready var Player = get_node("/root/Game/Friendlies/0")

func _physics_process(_delta):
	var x = stepify(Player.translation.x, 0.01)
	var z = stepify(Player.translation.z, 0.01)
	text = "Pos: (" + str(x).pad_decimals(2) + ", " + str(z).pad_decimals(2) + "); " \
		 + "Rot: " + str(stepify(Player.rotation.y + Player.facing, 0.01)).pad_decimals(2)
