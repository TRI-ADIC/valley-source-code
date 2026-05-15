extends Node3D

@onready var viewmodel = $"."
@onready var player = $"../../.."

#Sway variables
const SENSITIVITY = 0.5
var mouse_movement = Vector3.ZERO
const SWAY_THESHOLD = 5
const SWAY_SPEED = 5
const SWAY_AMOUNT = 0.2
var default_rotation

#Hand bob variables
const BOB_FREQUENCY = 1.1
const BOB_AMPLITUDE = 0.03
var handbob_time = 0.0
var default_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_rotation = viewmodel.rotation
	default_position = viewmodel.position
	print(default_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_hand_move(delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement = Vector3(-event.relative.y * SENSITIVITY, -event.relative.x * SENSITIVITY, 0)
		
func _hand_move(delta: float):
	# Hand sway
	var mouse_movement_length = mouse_movement.length()
	if (mouse_movement_length > SWAY_THESHOLD):
		viewmodel.rotation = viewmodel.rotation.lerp(mouse_movement.normalized() * SWAY_AMOUNT, SWAY_SPEED * delta)
	else:
		viewmodel.rotation = viewmodel.rotation.lerp(default_rotation, SWAY_SPEED * delta)
		
	#Hand bob
	if player.is_on_floor():
		handbob_time += delta * player.velocity.length()
		viewmodel.transform.origin = _handbob(handbob_time)
		
func _handbob(time) -> Vector3:
	var position = default_position
	position.y = (sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE) + default_position.y
	position.x = (cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE) + default_position.x
	return position
	
