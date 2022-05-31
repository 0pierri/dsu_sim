extends Node

var started = false
var timer = 0

signal timer_changed(timer)

func _process(delta):
	if !started:
		return
	timer += delta

func _on_StartButton_pressed():
	started = not started

func _on_ResetButton_pressed():
	started = false
	timer = 0
	emit_signal("timer_changed", timer)
