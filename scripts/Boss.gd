extends Position3D
class_name Boss

var friendlies
# Right-angled triangle outwards from the boss in +Z direction
# Adjust mul as needed
const _mul = 5
# Points must be counterclockwise
const _p1 = _mul * Vector2(0,0)
const _p2 = _mul * Vector2(-sqrt(2), sqrt(2))
const _p3 = _mul * Vector2(sqrt(2), sqrt(2))
# For in-bounds check
const _v1 = Vector2(_p2.y - _p1.y, -_p2.x + _p1.x)
const _v2 = Vector2(_p3.y - _p2.y, -_p3.x + _p2.x)
const _v3 = Vector2(_p1.y - _p3.y, -_p1.x + _p3.x)

func _ready():
	pass

func _on_Friendlies_loaded(f):
	friendlies = f.duplicate()

func friendlies_in_los():
	var p = []
	for f in friendlies:
		var pos = Vector2(f.global_transform.origin.x, f.global_transform.origin.z)
		var v1 = pos - _p1
		var v2 = pos - _p2
		var v3 = pos - _p3
		
		var d1 = _v1.dot(v1)
		var d2 = _v2.dot(v2)
		var d3 = _v3.dot(v3)
		
		if (d1 >= 0 and d2 >= 0 and d3 >= 0):
			p.append(f)
	return p
