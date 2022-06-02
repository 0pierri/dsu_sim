extends Node
class_name TextureLoader

var tex_spineshatter: Texture = preload("res://textures/status/spineshatter.png")
var tex_highjump: Texture = preload("res://textures/status/highjump.png")
var tex_elusive: Texture = preload("res://textures/status/elusive.png")
var tex_first: Texture = preload("res://textures/status/first.png")
var tex_second: Texture = preload("res://textures/status/second.png")
var tex_third: Texture = preload("res://textures/status/third.png")
var tex_limitcut1: Texture = preload("res://textures/effect/limitcut1.png")
var tex_limitcut2_r: Texture = preload("res://textures/effect/limitcut2_r.png")
var tex_limitcut3: Texture = preload("res://textures/effect/limitcut3.png")
var tex_vuln_fire: Texture = preload("res://textures/status/vuln_fire.png")
var tex_vuln_phys: Texture = preload("res://textures/status/vuln_phys.png")

func _ready():
	for p in get_property_list():
		if p.name.begins_with("tex_"):
			var res: Texture = .get(p.name)
			res.resource_name = p.name.right(4)

func get(tex: String):
	var t = .get("tex_" + tex)
	assert(t != null)
	return t
