extends Node

const DIVE_SCALE = 5
const TOWER_DISTANCE = 15

var friendlies = []
var AOEScene = preload("res://scenes/AOE.tscn")
onready var player = get_node("/root/Game/Friendlies/0")
onready var boss = get_node("/root/Game/Boss")

func create_aoe(scale, translation, target: String, damage: float, kb_distance: float, kb_duration: float):
	var aoe = AOEScene.instance()
	aoe.target = target
	aoe.scale = Vector3(scale, 1, scale)
	aoe.damage = damage
	aoe.kb_distance = kb_distance
	aoe.kb_duration = kb_duration
	aoe.translation = translation
	add_child(aoe)
	yield(get_tree().create_timer(0.3), "timeout")
	remove_child(aoe)
	aoe.queue_free()
	
func _on_Friendlies_loaded():
	for i in range(0,8):
		friendlies.append(get_node("/root/Game/Friendlies/" + str(i)))

func _on_mech_divefromgrace():
	pass

func _on_mech_dark_dive(type, p):
	var f: Friendly = friendlies[int(p)]
	match type:
		"spineshatter":
			var dest = f.transform.origin + Vector3(0,0,-1).rotated(Vector3(0,1,0), f.rotation.y + f.facing) * TOWER_DISTANCE
			create_aoe(DIVE_SCALE, dest, p, 10, 40, 0.5)
		"highjump":
			create_aoe(DIVE_SCALE, f.transform.origin, p, 10, 40, 0.5)
		"elusive":
			var dest = f.transform.origin + Vector3(0,0,1).rotated(Vector3(0,1,0), f.rotation.y + f.facing) * TOWER_DISTANCE
			create_aoe(DIVE_SCALE, dest, p, 10, 40, 0.5)
