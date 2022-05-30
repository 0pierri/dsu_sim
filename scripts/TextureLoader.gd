extends Node
class_name TextureLoader

var tex_spineshatter: Texture = preload("res://textures/status/spineshatter.png")
var tex_highjump: Texture = preload("res://textures/status/highjump.png")
var tex_elusive: Texture = preload("res://textures/status/elusive.png")
var tex_first: Texture = preload("res://textures/status/first.png")
var tex_second: Texture = preload("res://textures/status/second.png")
var tex_third: Texture = preload("res://textures/status/third.png")
var tex_fireresdown: Texture = preload("res://textures/status/fireresdown.png")
var tex_physvulnup: Texture = preload("res://textures/status/physvulnup.png")
var tex_limitcut1: Texture = preload("res://textures/effect/limitcut1.png")
var tex_limitcut2_r: Texture = preload("res://textures/effect/limitcut2_r.png")
var tex_limitcut3: Texture = preload("res://textures/effect/limitcut3.png")
var tex_aoe: Texture = preload("res://textures/environment/aoe.png")
var tex_donut: Texture = preload("res://textures/environment/donut.png")

func _ready():
	for p in get_property_list():
		if p.name.begins_with("tex_"):
			var res: Texture = get(p.name)
			res.resource_name = p.name.right(4)
