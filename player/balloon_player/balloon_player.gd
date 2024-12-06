extends CharacterBody2D


const BLOCK_LENGTH : float = Constants.BLOCK_LENGTH

@export var to_shape : PackedScene

@onready var _anim := $AnimationPlayer


func _physics_process(_delta: float) -> void:
	const HORIZONTAL_SPEED := BLOCK_LENGTH
	const VERTICAL_SPEED := 4.0 * BLOCK_LENGTH
	
	var in_dir := signf(Input.get_axis(&"move_left", &"move_right") )
	velocity.x = in_dir * HORIZONTAL_SPEED
	velocity.y = -VERTICAL_SPEED

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"shape_shift"):
		_anim.play(&"start_shape_shift")


func _shape_shift():
		var parent := get_parent()
		var next_form : PhysicsBody2D = to_shape.instantiate()
		next_form.position = position
		next_form.velocity = velocity
		next_form.to_shape = load(&"res://player/balloon_player/balloon_player.tscn")
		parent.add_child(next_form)
		queue_free()


func _on_hurt() -> void:
	#TODO: implement death
	print("DIE")
