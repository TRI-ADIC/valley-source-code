extends Node3D

@onready var cat_animation = $"Starting Area/Cat/AnimatedSprite3D"
@onready var spirit_animation = $"Starting Area/Spirit/AnimatedSprite3D"
@onready var title_animation = $Control/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cat_animation.play("default")
	spirit_animation.play("default")
	title_animation.play("default")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World/World.tscn")


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
