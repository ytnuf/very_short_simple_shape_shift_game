extends Control


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(&"res://menu/main_menu.tscn")
