extends Node3D

@onready var cat_animation = $"Starting Area/Cat/AnimatedSprite3D"
@onready var spirit_animation = $"Starting Area/Spirit/AnimatedSprite3D"
@onready var title_animation = $Control/AnimatedSprite2D

var button_type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cat_animation.play("default")
	spirit_animation.play("default")
	title_animation.play("default")

func _on_start_button_pressed() -> void:
	button_type = "start"
	%ScreenTransition.show()
	%ScreenTransition/FadeTimer.start()
	%ScreenTransition/AnimationPlayer.play("fade_in")


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	button_type = "quit"
	%ScreenTransition.show()
	%ScreenTransition/FadeTimer.start()
	%ScreenTransition/AnimationPlayer.play("fade_in")


func _on_fade_timer_timeout() -> void:
	match button_type:
		"start":
			get_tree().change_scene_to_file("res://Scenes/World/World.tscn")
		"quit":
			get_tree().quit()
