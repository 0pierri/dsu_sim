extends KinematicBody
class_name Friendly

var max_health = 10
var flash_timer
var health
var facing = 0

var kb_duration: float = 0
var kb_vector: Vector3

var HealthBar
var HealthBarScene = preload("res://scenes/PartyHealthBar.tscn")
onready var TextureLoader = get_node("/root/Game/TextureLoader")
onready var Model = get_node("Model")
onready var Target = get_node("Target")
onready var Effect = get_node("Effect")
onready var PartyHealth = get_node("/root/Game/UI/Margin/Container/Left/PartyHealth")
onready var ScriptManager = get_node("/root/Game/ScriptManager")

signal health_changed(health)
signal loaded(f)

func _ready():
	get_node("CollisionArea").name = name
	health = max_health
	
	ScriptManager.connect("reset", self, "_on_reset")
	ScriptManager.connect("damage", self, "_on_damage")
	ScriptManager.connect("apply_effect", self, "_on_apply_effect")
	ScriptManager.connect("remove_effect", self, "_on_remove_effect")
	ScriptManager.connect("apply_status", self, "_on_apply_status")
	ScriptManager.connect("remove_status", self, "_on_remove_status")
		
	var hb = HealthBarScene.instance()
	hb.setup(max_health, self)
	PartyHealth.add_child(hb)
	emit_signal("loaded", self)
	
func _physics_process(delta):
	if kb_duration > 0:
		kb_duration -= delta
# warning-ignore:return_value_discarded
		move_and_slide(kb_vector)
		
func get_rotation():
	return rotation.y + facing
	
func set_facing(rad: float):
	facing = rad
	Model.rotation.y = rad
	Target.rotation.y = rad
	
func take_damage(amount: float):
	health = clamp(health - amount, 0, max_health)
	emit_signal("health_changed", health)
	Model.modulate = Color(1, 0.42, 0.42, 1)
	if health <= 0:
		return
	yield(get_tree().create_timer(0.3), "timeout")
	Model.modulate = Color(1, 1, 1, 1)
	
func knockback(distance: float, duration: float, direction: Vector3):
	# If new knockback, overwrite any existing ones
	if duration != 0:
		kb_duration = duration
		kb_vector = direction.normalized() * distance/duration
	
func _on_damage(players: Array, _name, amount: float):
	if players.has(name):
		health = clamp(health - amount, 0, max_health)
		emit_signal("health_changed", health)
		Model.modulate = Color(1, 0.42, 0.42, 1)
		if health <= 0:
			return
		yield(get_tree().create_timer(0.3), "timeout")
		Model.modulate = Color(1, 1, 1, 1)
		
func _on_apply_effect(effect: String, player: String, duration: float):
	if player == name:
		Effect.texture = TextureLoader.get("tex_" + effect)
		Effect.show()
		yield(get_tree().create_timer(duration), "timeout")
		Effect.hide()
		
func _on_remove_effect(player: String):
	if player == name:
		Effect.hide()
		
func _on_apply_status(_status: Texture, player: String, duration: float, show_timer: bool):
	if player == name:
		pass

func _on_remove_status(_status: Texture, player: String):
	if player == name:
		pass

func _on_reset():
	health = max_health
	kb_duration = 0
	Model.modulate = Color(1, 1, 1, 1)
