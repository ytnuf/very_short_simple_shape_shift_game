
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
	asset_title.text = "Assets Used: "
	asset_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credit_lst.add_child(asset_title)
	for asset in asset_credits:
		var title := asset["source name"] as String
		var author := asset["creator name"] as String
		var _source := asset["source page"] as String
		var license := asset["license name"] as String
		var asset_label := Label.new()
		asset_label.text = "%s by %s [%s]" % [title, author, license]
		asset_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		credit_lst.add_child(asset_label)


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
