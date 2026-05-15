extends Node3D

@onready var viewmodel = $"."

# Delay variables
const SENSITIVITY = 0.5
const DELAY_THESHOLD = 1
const DELAY_SPEED = 0.6
const DELAY_AMOUNT = 1
var mouse_movement = Vector3.ZERO
var default_rotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_float_object_up()
	default_rotation = viewmodel.rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_spirit_move_delay(delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement = Vector3(-event.relative.y * SENSITIVITY, -event.relative.x * SENSITIVITY, 0)
	
func _float_object_up():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(0, 0.25, 0), 2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_float_object_down)
	
func _float_object_down():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector3(0, -0.25, 0), 2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_float_object_up)
	
func _spirit_move_delay(delta: float):
	var mouse_movement_length = mouse_movement.length()
	if (mouse_movement_length > DELAY_THESHOLD):
		viewmodel.rotation = viewmodel.rotation.lerp(mouse_movement.normalized() * -DELAY_AMOUNT, DELAY_SPEED * delta)
	else:
		viewmodel.rotation = viewmodel.rotation.lerp(default_rotation, DELAY_SPEED * delta)
	
