extends Node

const DIVE_SCALE = 5
const TOWER_DISTANCE = 15
const BOSS_SCALE = 8.2

var towers = []
var friendlies = []
var AOEScene = preload("res://scenes/AOE.tscn")
onready var TextureLoader = get_node("/root/Game/TextureLoader")
onready var player: Player = get_node("/root/Game/Friendlies/0")
onready var boss: Boss = get_node("/root/Game/Boss")

func create_aoe(is_donut, min_soak, scale, translation, target: String, damage: float, kb_distance: float, kb_duration: float):
	var aoe = AOEScene.instance()
	if is_donut:
		aoe.set_texture(TextureLoader.get("tex_donut"))
		aoe.is_donut = true
	else:
		aoe.set_texture(TextureLoader.get("tex_aoe"))
		
	aoe.friendlies = friendlies
	aoe.min_soak = min_soak
	aoe.target = target
	aoe.scale = Vector3(scale, 1, scale)
	aoe.damage = damage
	aoe.kb_distance = kb_distance
	aoe.kb_duration = kb_duration
	aoe.translation = translation
	
	add_child(aoe)
	aoe.check()
	yield(get_tree().create_timer(0.3), "timeout")
	remove_child(aoe)
	aoe.queue_free()
	
func _on_Friendlies_loaded(f):
	friendlies = f

func _on_mech_divefromgrace():
	pass

func _on_mech_dark_dive(type, p):
	var f: Friendly = friendlies[int(p)]
	match type:
		"spineshatter":
			var dest = f.transform.origin + Vector3(0,0,-1).rotated(Vector3(0,1,0), f.rotation.y + f.facing) * TOWER_DISTANCE
			create_aoe(false, 1, DIVE_SCALE, dest, p, 10, 40, 0.5)
			towers.append(dest)
		"highjump":
			var dest = f.transform.origin
			create_aoe(false, 1, DIVE_SCALE, dest, p, 10, 40, 0.5)
			towers.append(dest)
		"elusive":
			var dest = f.transform.origin + Vector3(0,0,1).rotated(Vector3(0,1,0), f.rotation.y + f.facing) * TOWER_DISTANCE
			create_aoe(false, 1, DIVE_SCALE, dest, p, 10, 40, 0.5)
			towers.append(dest)
			
func _on_mech_eye():
	# Goes on a random player in front of the boss - assuming a 90' cone
	var f: Array = boss.friendlies_in_los()
	var i = randi() % f.size()
	create_aoe(false, 5, DIVE_SCALE, f[i].transform.origin, "", 1, 0, 0)

func _on_mech_gnashlash(is_lash: bool):
	if is_lash:
		create_aoe(true, 0, BOSS_SCALE, boss.transform.origin, "", 5, 10, 0.5)
	else:
		create_aoe(false, 0, BOSS_SCALE, boss.transform.origin, "", 5, 10, 0.5)

func _on_mech_towers():
	for t in towers:
		#TODO: Damage type (i.e. fire + vuln handling) + tower aoe type & model
		create_aoe(false, 1, DIVE_SCALE, t, "", 10, 0, 0)
