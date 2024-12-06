extends CharacterBody2D


const BLOCK_LENGTH : float = Constants.BLOCK_LENGTH


func _physics_process(_delta: float) -> void:
	const HORIZONTAL_SPEED := 0.25 * BLOCK_LENGTH
	const VERTICAL_SPEED := 4.0 * BLOCK_LENGTH
	
	var in_dir := signf(Input.get_axis(&"move_left", &"move_right") )
	velocity.x = in_dir * HORIZONTAL_SPEED
	velocity.y = -VERTICAL_SPEED

	move_and_slide()
