
class_name CirclePlayer
extends RigidBody2D

@export var to_shape : PackedScene

@onready var _anim := $AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shape_shift"):
		_anim.play(&"start_shape_shift")


func _shape_shift():
		var parent := get_parent()
		var next_form : PhysicsBody2D = to_shape.instantiate()
		next_form.position = position
		next_form.to_shape = load(&"res://player/circle_player/circle_player.tscn")
		parent.add_child(next_form)
		queue_free()
