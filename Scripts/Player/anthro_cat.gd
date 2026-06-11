extends CharacterBody3D

const SENSITIVITY = 0.003
var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 12
var gravity = 45.0
var head_position = Vector3.ZERO
var moving = false
var is_in_air = false

#Head bob variables
const BOB_FREQUENCY = 1.5
const BOB_AMPLITUDE = 0.08
var headbob_time = 0.0
var last_bob_position_x = 0.0 # Track previous horizontal headbob position
var last_bob_direction = 0 # Track the previous movement direction. -1 = left, 1 = right

#FOV variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var footsteps_sound_effect: AudioStreamPlayer3D = %Footsteps

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
func _headbob(time) -> Vector3:
	head_position.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	head_position.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return head_position
	
func _fov_change(delta: float) -> float:
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	return camera.fov

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if is_in_air: # If true, this is the first frame since the player has landed
			is_in_air = false
			footsteps_sound_effect.play()
		if direction:
			moving = true
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			moving = false
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 15.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 15.0)
	else:
		# Mid-air inertia
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
		is_in_air = true
		
	#Head bob
	headbob_time += delta * velocity.length() * float (is_on_floor())
	camera.transform.origin = _headbob(headbob_time)
	
	play_footsteps()
	
	#FOV change
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 2.0)

	move_and_slide()
	
func play_footsteps() -> void:
	if moving and is_on_floor():
		var bob_position_x = head_position.x
		var bob_direction = sign(bob_position_x - last_bob_position_x)
		
		if bob_direction != 0 and bob_direction != last_bob_direction and last_bob_direction != 0:
			#Play sound effect
			footsteps_sound_effect.play()
			
		last_bob_direction = bob_direction
		last_bob_position_x = bob_position_x
	else:
		last_bob_direction = 0
		last_bob_position_x = head_position.x
