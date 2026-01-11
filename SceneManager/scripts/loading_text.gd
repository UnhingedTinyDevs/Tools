@tool
extends Control
class_name LoadingText

const DEFAULT_TEXT: String = "LOADING"

@onready var loading_text: RichTextLabel = %Loading
@onready var ellipsis: RichTextLabel = %Ellipsis
@onready var loading_text_animations: LoadingTextAnimations = $HBoxContainer/Ellipsis/LoadingTextAnimations


#region Builtins
func _ready() -> void:
	set_text(DEFAULT_TEXT)

#endregion Builtins

#region API
## Call to set up the loading text
func init(_text: String, elipse: bool) -> void:
	set_text(_text)
	if not elipse:
		set_elipse(false)


## Call to toggle the elipse animation
func set_elipse(v: bool) -> void:
	if v:
		ellipsis.text = "..."
		loading_text_animations.play("EllipsisLoad")
	else:
		ellipsis.text = ""
		loading_text_animations.play("none")


## Set the text of the loading label
func set_text(t: String) -> void:
	loading_text.text = t + " "

#endregion API
