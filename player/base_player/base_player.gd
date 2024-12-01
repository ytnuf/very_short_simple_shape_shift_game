
extends CharacterBody2D

const BLOCK_LENGTH : float = 16.0

var _is_jumping : bool = false
var _jump_buffer : float = 0.0
var _p_meter : float = 0.0


func _physics_process(dt: float) -> void:
	const RUN_SPEED := 8.4375 * BLOCK_LENGTH
	const SPRINT_SPEED := 11.25 * BLOCK_LENGTH
	const ACCELERATION := 21.09375 * BLOCK_LENGTH
	const STOPPING_DECELERATION := 14.0625 * BLOCK_LENGTH
	const SKID_RUN_DECELERATION := 70.3125 * BLOCK_LENGTH
	const P_METER_INC := 30.0
	const P_METER_DEC := 15.0
	const P_METER_MAX := 28.0
	const JUMP_GRAVITY := 42.1875 * BLOCK_LENGTH
	const FALL_GRAVITY := 84.375 * BLOCK_LENGTH
	const MAX_JUMP_BUFFER := 0.0625
	
	if absf(velocity.x) >= RUN_SPEED and is_on_floor():
		_p_meter += P_METER_INC * dt
	elif absf(velocity.x) < RUN_SPEED:
		_p_meter -= P_METER_DEC * dt
	_p_meter = clampf(_p_meter, 0.0, P_METER_MAX)
	
	var in_dir := signf(Input.get_axis(&"move_left", &"move_right") )
	var cur_dir := signf(velocity.x)
	if in_dir == 0.0:
		velocity.x = move_toward(velocity.x, 0.0, STOPPING_DECELERATION * dt)
	elif in_dir == cur_dir or cur_dir == 0.0:
		velocity.x += in_dir * ACCELERATION * dt
		var max_speed := SPRINT_SPEED if _p_meter >= P_METER_MAX else RUN_SPEED
		velocity.x = min(absf(velocity.x), max_speed) * in_dir
	else:
		velocity.x -= cur_dir * SKID_RUN_DECELERATION * dt
	
	_jump_buffer -= dt
	if Input.is_action_just_pressed(&"jump"):
		_jump_buffer = MAX_JUMP_BUFFER
	if is_on_floor() and _jump_buffer >= 0.0:
		_is_jumping = true
		_jump_buffer = 0.0
		velocity.y = -_initial_jump_speed(absf(velocity.x) )
	elif is_on_floor() or Input.is_action_just_released(&"jump"):
		_is_jumping = false
	var gravity := JUMP_GRAVITY if _is_jumping else FALL_GRAVITY
	velocity.y += gravity * dt
	
	move_and_slide()


static func _initial_jump_speed(x_speed: float) -> float:
	# Jump height range is [3.84, 6] blocks
	return (0.4 * x_speed) + (18.0 * BLOCK_LENGTH)
