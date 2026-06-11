extends Node3D

@onready var cat_animation = $Cat/AnimatedSprite3D
@onready var spirit_animation = $Spirit/AnimatedSprite3D
@onready var tbc_animation = $Control/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cat_animation.play("default")
	spirit_animation.play("default")
	tbc_animation.play("default")
	%ScreenTransition/AnimationPlayer.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	%ScreenTransition.hide()


func _on_quit_button_pressed() -> void:
	%ScreenTransition.show()
	%ScreenTransition/FadeTimer.start()
	%ScreenTransition/AnimationPlayer.play("fade_in")


func _on_fade_timer_timeout() -> void:
	get_tree().quit()
