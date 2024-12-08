
class_name CirclePlayer
extends RigidBody2D

signal dies

@export var to_shape : PackedScene

var velocity := Vector2.ZERO

var _min_speed := Vector2.ZERO

@onready var _anim := $AnimationPlayer
@onready var _lose := $LoseSfx


func _ready() -> void:
	linear_velocity = velocity
	dies.connect(get_parent()._on_death)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shape_shift"):
		_anim.play(&"start_shape_shift")


func _shape_shift():
		var parent := get_parent()
		var next_form : PhysicsBody2D = to_shape.instantiate()
		next_form.position = position
		next_form.velocity = linear_velocity
		next_form.to_shape = load(&"res://player/circle_player/circle_player.tscn")
		parent.add_child(next_form)
		queue_free()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Prevent slowing down (yes, this is a bit hacky)
	if absf(state.linear_velocity.x) < _min_speed.x:
		state.linear_velocity.x = signf(state.linear_velocity.x) * _min_speed.x
	_min_speed.x = absf(state.linear_velocity.x)
	if absf(state.linear_velocity.y) < _min_speed.y:
		state.linear_velocity.y = signf(state.linear_velocity.y) * _min_speed.y


func _on_hurt() -> void:
	_lose.play()
	await _lose.finished
	dies.emit()
