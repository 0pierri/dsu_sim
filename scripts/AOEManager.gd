extends Node
class_name AOEManager

enum Type {
	AOE,
	DONUT,
	TOWER
}

const DIVE_SCALE = 5
const TOWER_DISTANCE = 15
const BOSS_SCALE = 8.2

var towers = []
var geirskoguls = []
var friendlies = []
var AOEScene = preload("res://scenes/AOE.tscn")
var DonutScene = preload("res://scenes/Donut.tscn")
var TowerScene = preload("res://scenes/Tower.tscn")
onready var TextureLoader = get_node("/root/Game/TextureLoader")
onready var player: Player = get_node("/root/Game/Friendlies/0")
onready var boss: Boss = get_node("/root/Game/Boss")

func create_aoe(source: String, type, min_soak, scale, translation, target_name: String, damage: float, kb_distance: float, kb_duration: float):
	var aoe: AOEBase
	match type:
		Type.AOE:
			aoe = AOEScene.instance()
		Type.DONUT:
			aoe = DonutScene.instance()
		Type.TOWER:
			aoe = TowerScene.instance() as Tower
			aoe.connect("tower_soaked", self, "_on_tower_soaked")
		
	aoe.friendlies = friendlies
	aoe.min_soak = min_soak
	aoe.source = source
	aoe.target_name = target_name
	aoe.scale = Vector3(scale, 1, scale)
	aoe.damage = damage
	aoe.kb_distance = kb_distance
	aoe.kb_duration = kb_duration
	aoe.translation = translation
	
	add_child(aoe)
	aoe.check()
	aoe.hit()
	aoe.release()
	
func _on_Friendlies_loaded(f):
	friendlies = f

func _on_reset():
	for t in towers:
		t.reset()
	towers.clear()
	
func _on_tower_soaked(translation):
	geirskoguls.append(translation)

func mech_dark_dive(type, p):
	var f: Friendly = friendlies[int(p)]
	match type:
		"spineshatter":
			var dest = f.transform.origin + Vector3(0,0,-1).rotated(Vector3(0,1,0), f.rotation.y + f.facing) * TOWER_DISTANCE
			create_aoe("Dark Spineshatter Dive", Type.AOE, 0, DIVE_SCALE, dest, p, 10, 40, 0.5)
			towers.append(dest)
		"highjump":
			var dest = f.transform.origin
			create_aoe("Dark High Jump", Type.AOE, 0, DIVE_SCALE, dest, p, 10, 40, 0.5)
			towers.append(dest)
		"elusive":
			var dest = f.transform.origin + Vector3(0,0,1).rotated(Vector3(0,1,0), f.rotation.y + f.facing) * TOWER_DISTANCE
			create_aoe("Dark Elusive Dive", Type.AOE, 0, DIVE_SCALE, dest, p, 10, 40, 0.5)
			towers.append(dest)
			
func mech_eye():
	# Goes on a random player in front of the boss - assuming a 90' cone
	var f: Array = boss.friendlies_in_los()
	if f.size() == 0:
		f = friendlies
	var i = randi() % f.size()
	create_aoe("Eye of the Tyrant", Type.AOE, 5, DIVE_SCALE, f[i].transform.origin, "", 1, 0, 0)

func mech_gnashlash(is_lash: bool):
	if is_lash:
		create_aoe("Lash", Type.DONUT, 0, BOSS_SCALE, boss.transform.origin, "", 5, 10, 0.5)
	else:
		create_aoe("Gnash", Type.AOE, 0, BOSS_SCALE, boss.transform.origin, "", 5, 10, 0.5)

func mech_towers():
	for t in towers:
		#TODO: Damage type (i.e. fire + vuln handling) + tower aoe type & model
		create_aoe("Tower", Type.TOWER, 1, DIVE_SCALE, t, "", 1, 0, 0)
	towers.clear()
