class_name Cauldron extends Node3D

signal lit()

var is_lit = false

# If spirit comes near cauldron, light it and signal the entrance connected to cauldron
func _on_area_3d_area_entered(area: Area3D) -> void:
	if !%Flame.visible:
		%Flame.visible = true
		%Flame.play("default")
		%FlameWoosh.play()
	
	if is_lit == false:
		is_lit = true
		lit.emit()
