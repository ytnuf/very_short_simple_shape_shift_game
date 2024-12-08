
class_name BasePlayer
extends CharacterBody2D

signal dies

const BLOCK_LENGTH : float = Constants.BLOCK_LENGTH

@export var to_shape : PackedScene

var _p_meter : float = 0.0

@onready var _anim := $AnimationPlayer
@onready var _lose := $LoseSfx


func _ready() -> void:
	dies.connect(get_parent()._on_death)


func _physics_process(dt: float) -> void:
	const RUN_SPEED := 8.4375 * BLOCK_LENGTH
	const SPRINT_SPEED := 11.25 * BLOCK_LENGTH
	const ACCELERATION := 21.09375 * BLOCK_LENGTH
	const STOPPING_DECELERATION := 14.0625 * BLOCK_LENGTH
	const SKID_RUN_DECELERATION := 70.3125 * BLOCK_LENGTH
	const P_METER_INC := 30.0
	const P_METER_DEC := 15.0
	const P_METER_MAX := 28.0
	const FALL_GRAVITY := 42.1875 * BLOCK_LENGTH
	const MAX_FALL_SPEED := 15.0 * BLOCK_LENGTH
	
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
	
	velocity.y += FALL_GRAVITY * dt
	velocity.y = min(MAX_FALL_SPEED, velocity.y)
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shape_shift"):
		_anim.play(&"start_shape_shift")


func _shape_shift():
		var parent := get_parent()
		var next_form : PhysicsBody2D = to_shape.instantiate()
		next_form.position = position
		next_form.velocity = velocity
		next_form.to_shape = load(&"res://player/base_player/base_player.tscn")
		parent.add_child(next_form)
		queue_free()


func _on_hurt() -> void:
	_lose.play()
	await _lose.finished
	dies.emit()
