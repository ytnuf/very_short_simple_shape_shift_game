extends Node2D


func _on_goal_end_level() -> void:
	$EndLevelTimer.start()


func _on_end_level_timer_timeout() -> void:
	get_tree().change_scene_to_file(&"res://level/level_2/level_2.tscn")
