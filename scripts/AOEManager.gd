extends Node
class_name AOEManager

enum Type {
	AOE,
	DEBUFF,
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
var DebuffAOEScene = preload("res://scenes/DebuffAOE.tscn")
var DonutScene = preload("res://scenes/Donut.tscn")
var TowerScene = preload("res://scenes/Tower.tscn")
onready var boss: Boss = get_node("/root/Game/Boss")

func create_aoe(source: String, type: int, damage_type: String, min_soak: int, scale: float, translation: Vector3, target_name: String, damage: float, kb_distance: float, kb_duration: float, statuses: Dictionary = {}):
	var aoe: AOEBase
	match type:
		Type.AOE:
			aoe = AOEScene.instance()
		Type.DEBUFF:
			aoe = DebuffAOEScene.instance() #AOEScene but with hidden texture
		Type.DONUT:
			aoe = DonutScene.instance()
		Type.TOWER:
			aoe = TowerScene.instance()
			aoe.connect("tower_soaked", self, "_on_tower_soaked")
		
	aoe.damage_type = damage_type
	aoe.min_soak = min_soak
	aoe.source = source
	aoe.target_name = target_name
	aoe.scale = Vector3(scale, 1, scale)
	aoe.damage = damage
	aoe.kb_distance = kb_distance
	aoe.kb_duration = kb_duration
	aoe.translation = translation
	aoe.statuses = statuses
	
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
			create_aoe("Dark Spineshatter Dive", Type.AOE, "phys", 0, DIVE_SCALE, dest, p, 2, 40, 0.5, {"vuln_fire": 12, "vuln_phys": 2})
			towers.append(dest)
		"highjump":
			var dest = f.transform.origin
			create_aoe("Dark High Jump", Type.AOE, "phys", 0, DIVE_SCALE, dest, p, 2, 40, 0.5, {"vuln_fire": 12, "vuln_phys": 2})
			towers.append(dest)
		"elusive":
			var dest = f.transform.origin + Vector3(0,0,1).rotated(Vector3(0,1,0), f.rotation.y + f.facing) * TOWER_DISTANCE
			create_aoe("Dark Elusive Dive", Type.AOE, "phys", 0, DIVE_SCALE, dest, p, 2, 40, 0.5, {"vuln_fire": 12, "vuln_phys": 2})
			towers.append(dest)
			
func mech_eye():
	# Goes on a random player in front of the boss - assuming a 90' cone
	var f: Array = boss.friendlies_in_los()
	if f.size() == 0:
		f = friendlies
	var i = randi() % f.size()
	create_aoe("Eye of the Tyrant", Type.AOE, "magic", 5, DIVE_SCALE, f[i].transform.origin, "", 1, 0, 0, {"vuln_fire": 12, "vuln_phys": 2})

func mech_gnashlash(is_lash: bool):
	if is_lash:
		create_aoe("Lash", Type.DONUT, "magic", 0, BOSS_SCALE, boss.transform.origin, "", 5, 10, 0.5)
	else:
		create_aoe("Gnash", Type.AOE, "magic", 0, BOSS_SCALE, boss.transform.origin, "", 5, 10, 0.5)

func mech_towers():
	for t in towers:
		#TODO: Damage type (i.e. fire + vuln handling) + tower aoe type & model
		create_aoe("Tower", Type.TOWER, "fire", 1, DIVE_SCALE, t, "", 1, 0, 0, {"vuln_fire": 12, "vuln_phys": 7})
	towers.clear()
