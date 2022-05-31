extends AOEBase
class_name Tower

var _reset = false

func _ready():
	$Model.material_override.set("shader_param/color", Color(1, 0.55, 0.15))
	
func check():
	pass
	
func hit():
	pass

func release():
	yield(get_tree().create_timer(1.8), "timeout")	
	if _reset:
		queue_free()
		return
	
	$Model.material_override.set("shader_param/color", Color(1, 0.11, 0.11))
	.check()
	.hit()
	
	yield(get_tree().create_timer(0.2), "timeout")
	.hide()
	yield(get_tree().create_timer(1), "timeout")
	if _reset:
		queue_free()
		return
		
	if _targets.size() < min_soak:
		show()
		for f in friendlies:
			f.take_damage(f.max_health, source + " not soaked")
			
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()

func reset():
	hide()
	_reset = true
	
