extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ScreenTransition/AnimationPlayer.play("fade_out")
	%ScreenTransition/FadeTimer.start()


func _on_fade_timer_timeout() -> void:
	%ScreenTransition.hide()
