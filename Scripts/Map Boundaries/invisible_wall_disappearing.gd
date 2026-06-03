extends Node3D

@export var open_with_flames:Dictionary[Cauldron, bool] = {}

var disappear = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for flame in open_with_flames:
		flame.lit.connect(_check_if_lit)


# Check if all cauldrons are lit
func _check_if_lit():
	for flame in open_with_flames:
		var is_lit = flame.is_lit
		
		# If all are lit, entrance opens
		if is_lit:
			disappear = true
		else:
			disappear = false
			break
			
	if disappear:
		%Wall.use_collision = false
