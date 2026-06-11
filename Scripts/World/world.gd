extends Node3D

var scream_triggered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ScreenTransition/AnimationPlayer.play("fade_out")
	%ScreenTransition/FadeTimer.start()
	
	GlobalAudio.fade_out()


func _on_fade_timer_timeout() -> void:
	%ScreenTransition.hide()


func _on_level_2_trigger_area_entered(area: Area3D) -> void:
	if !GlobalAudio.has_stream_playback():
		GlobalAudio.play_valley_ambience()
		var tween = create_tween()
		tween.tween_property(GlobalAudio, "volume_db", 0, 10).set_trans(Tween.TRANS_LINEAR)


func _on_level_3_trigger_area_entered(area: Area3D) -> void:
	if !scream_triggered:
		scream_triggered = true
		GlobalAudio.stop()
		%Scream.play()
		var tween = create_tween()
		tween.tween_property(%Scream, "volume_db", 20.935, 1).set_trans(Tween.TRANS_SINE)
