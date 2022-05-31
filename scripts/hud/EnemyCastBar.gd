extends TextureProgress

var casting = false
var paused = false
onready var text = get_node("Text")

func _ready():
	hide()
	text.hide()
	
func _process(delta):
	if casting and not paused:
		value += delta
		if value == max_value:
			reset()

func _on_ScriptManager_boss_cast(ability, length):
	casting = true
	paused = false
	max_value = length
	show()
	text.text = ability
	text.show()


func _on_StartButton_pressed():
	if casting:
		paused = not paused

func _on_ResetButton_pressed():
	reset()

func reset():
	casting = false
	paused = false
	hide()
	value = 0
