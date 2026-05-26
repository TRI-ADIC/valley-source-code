extends Node3D

@export var open_with_flames:Dictionary[Cauldron, bool] = {}

var lift = false

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
			lift = true
		else:
			lift = false
			break
			
	if lift:
		var tween = create_tween()
		tween.tween_property(%BridgeMesh, "position", %RaisedPoint.position, 3).set_trans(Tween.TRANS_SINE)
