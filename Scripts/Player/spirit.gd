extends Node3D

@onready var viewmodel = $"."
@onready var viewmodel_mesh = $MeshInstance3D
@onready var raycast = $"../RayCast3D"

# Delay variables
const SENSITIVITY = 0.5
const DELAY_THESHOLD = 1
const DELAY_SPEED = 0.6
const DELAY_AMOUNT = 1
var mouse_movement = Vector3.ZERO
var default_rotation

# Send and retrieve variables
var default_position
var send_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_float_object_up()
	default_rotation = viewmodel.rotation
	default_position = viewmodel_mesh.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	_spirit_move_delay(delta)
	
	# Bug: Sending and retrieving spirit in quick succession causes spirit to come from... somewhere in the ground idk.
	
	# Sending out spirit
	if Input.is_action_pressed("send"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		if raycast.is_colliding():
			var raycast_point = raycast.get_collision_point()
			tween.tween_property(viewmodel_mesh, "global_position", raycast_point, 0.5)
		else:
			var raycast_endpoint = $"../RayCastEndPoint".global_position
			tween.tween_property(viewmodel_mesh, "global_position", raycast_endpoint, 0.5)
		# Disable inheriting of parent (so spirit doesn't rotate with camera)
		viewmodel_mesh.top_level = true
		
	# Retrieving spirit
	if Input.is_action_just_pressed("retrieve"):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(viewmodel_mesh, "position", default_position, 0.5)
		# Enable inheriting of parent (so spirit rotates with camera again)
		viewmodel_mesh.top_level = false
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement = Vector3(-event.relative.y * SENSITIVITY, -event.relative.x * SENSITIVITY, 0)
	
func _float_object_up():
	var tween = create_tween()
	tween.tween_property(viewmodel, "position", position + Vector3(0, 0.25, 0), 2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_float_object_down)
	
func _float_object_down():
	var tween = create_tween()
	tween.tween_property(viewmodel, "position", position + Vector3(0, -0.25, 0), 2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_float_object_up)
	
func _spirit_move_delay(delta: float):
	var mouse_movement_length = mouse_movement.length()
	if (mouse_movement_length > DELAY_THESHOLD):
		viewmodel.rotation = viewmodel.rotation.lerp(mouse_movement.normalized() * -DELAY_AMOUNT, DELAY_SPEED * delta)
	else:
		viewmodel.rotation = viewmodel.rotation.lerp(default_rotation, DELAY_SPEED * delta)
		
