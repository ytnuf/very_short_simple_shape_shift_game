
extends Control


func _ready() -> void:
	if OS.get_name() == &"Web":
		$VBoxContainer/QuitButton.visible = false

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file(&"res://menu/credits.tscn")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(&"res://level/level_1/level_1.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
