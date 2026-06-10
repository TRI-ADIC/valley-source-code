extends Node3D

@onready var cat_animation = $Cat/AnimatedSprite3D
@onready var spirit_animation = $Spirit/AnimatedSprite3D
@onready var tbc_animation = $Control/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cat_animation.play("default")
	spirit_animation.play("default")
	tbc_animation.play("default")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
