@tool
extends Background




func _enter_tree() -> void:
	_bg_flat_box = load("uid://b0eamf0gphbpy")


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_bg_flat_box = load("uid://b0eamf0gphbpy")
	pass # Replace with function body.
