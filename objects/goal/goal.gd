
extends Area2D

signal end_level

@onready var sfx := $AudioStreamPlayer

func _on_collected(_body: Node2D) -> void:
	end_level.emit()
	sfx.play()
	await sfx.finished
	queue_free()
