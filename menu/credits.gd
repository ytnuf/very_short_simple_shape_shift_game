
extends Control

func _ready() -> void:
	var input_str := FileAccess.get_file_as_string(&"res://CREDITS.json")
	assert(!input_str.is_empty() )
	var credits := JSON.parse_string(input_str) as Dictionary
	assert(credits != null)

	var asset_credits = credits["assets"] as Array[Dictionary]
	if asset_credits.is_empty():
		return

	var credit_lst := $CreditList
	var asset_title := Label.new()
	asset_title.text = "\nAssets Used: \n"
	asset_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credit_lst.add_child(asset_title)
	var space_label := Label.new()
	space_label.text = "\n"
	credit_lst.add_child(space_label.duplicate() )
		
	for asset in asset_credits:
		var title := asset["source name"] as String
		var author := asset["creator name"] as String
		var source := asset["source page"] as String
		var license := asset["license name"] as String
		var asset_label := Label.new()
		asset_label.add_theme_font_size_override("font_size", 24)
		asset_label.text = "%s by %s [%s]\n %s\n" % [title, author, license, source]
		asset_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		credit_lst.add_child(asset_label)
		credit_lst.add_child(space_label.duplicate() )


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
