extends Area
class_name AOE

var is_donut = false
var target = null
var min_soak = 1
var damage = 1
var kb_distance
var kb_duration
var friendlies

func set_texture(texture: Texture):
	$Texture.texture = texture
	
func check():
	var targets = []
	for f in friendlies:
		var dist = f.global_transform.origin.distance_to(global_transform.origin)
		if (is_donut and dist > scale.x) or (not is_donut and dist < scale.x):
			targets.append(f)
	if targets.size() < min_soak: # if not enough players stacking
		damage = 10
			
	for t in targets:
		_hit(t)

func _hit(f: Friendly):
	if f.name != target:
		f.take_damage(damage)
	if f.name == "0" and is_donut:
		print("Knockback from " + str(global_transform.origin) + " to " + str(f.global_transform.origin))
	f.knockback(kb_distance, kb_duration, f.global_transform.origin - global_transform.origin)

func _on_area_entered(area: Area):
	pass
