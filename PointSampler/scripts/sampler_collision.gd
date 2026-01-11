@tool
extends CollisionShape2D
class_name SamplerShape

const DEFAULT_NODE_NAME: String = "SamplerShape"


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		name = DEFAULT_NODE_NAME


func _ready() -> void:
	name = DEFAULT_NODE_NAME
