extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_float_object_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _float_object_up():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(0, 0.25, 0), 2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_float_object_down)
	
func _float_object_down():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(0, -0.25, 0), 2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_float_object_up)
