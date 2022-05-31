extends Friendly
class_name Player

const MOVE_SPEED = 8

var velocity = Vector3(0,0,0)
var standard_controls = true

func _ready():
	var playerHealthbar = get_node("/root/Game/UI/Margin/Container/Center/PlayerHealth")
	playerHealthbar.setup(max_health, self)
	rotation.x = 0
	rotation.z = 0
	rotate_y(deg2rad(180))

func _physics_process(delta):
	# Finish any knockbacks first
	if kb_duration > 0:
		._physics_process(delta)
		return
	if health == 0 and not ignore_death:
		return
		
	velocity = Vector3(0,0,0)
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if is_moving_foward():
		velocity.z -= 1
	if Input.is_action_pressed("move_down"):
		velocity.z += 1
		
	set_facing(PI/4 * velocity.z * velocity.x)
		
	velocity = velocity.normalized() * MOVE_SPEED
	if Input.is_action_pressed("move_down"):
		# If moving backwards in standard or diagonally backwards in legacy
		if standard_controls or (not standard_controls and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"))):
			velocity.x *= 0.5
			velocity.z *= 0.5
		# If moving directly backwards in legacy
		elif not standard_controls and not is_moving_foward() and not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			set_facing(PI)
	
	velocity = velocity.rotated(Vector3(0,1,0), rotation.y)
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func is_moving_foward():
	return Input.is_action_pressed("move_up") or (Input.is_mouse_button_pressed(BUTTON_LEFT) and Input.is_mouse_button_pressed(BUTTON_MASK_RIGHT))

func _on_ControlButton_pressed():
	standard_controls = not standard_controls
