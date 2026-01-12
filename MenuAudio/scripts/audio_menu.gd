@tool
extends CanvasLayer
class_name AudioMenu
## A simple Audio Menu that allows the setting of audio volumes
##
## We must somehow agree up names for busses so I will say we are just
## going with the classic [Master, Music, Dialog, SFX]

@export var theme: Theme = Theme.new(): set = set_theme
@export_category("Background")
@export var backgrounds: Array[CompressedTexture2D]: set = set_bg_images
@export var background_duration: float = 4.0: set = set_bg_duration

@onready var background: Background = %Background
@onready var main_control: Control = %MainControl

#region Builtins
func _enter_tree() -> void:
	pass


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	elif not Engine.is_editor_hint():
		assert(background, "Why is it noll it should get set on ready??")
		pass
	_setup_theme()
	if background:
		#background.init(backgrounds, background_duration)
		pass

#endregion

#region Setters
func set_theme(t: Theme) -> void:
	if t == theme: return
	if main_control:
		main_control.theme = t
	theme = t

func set_bg_images(v: Array[CompressedTexture2D]) -> void:
	if v == backgrounds: return
	backgrounds = v
	if background:
		background.images = v

func set_bg_duration(v: float) -> void:
	if v == background_duration: return
	background_duration = v
	background.background_duration = background_duration

#endregion Setters

#region Private Methods
func _setup_theme() -> void:
	if theme and not theme.changed.is_connected(_on_theme_changed):
		theme.changed.connect(_on_theme_changed)


func _on_theme_changed() -> void:
	main_control.theme = theme


#endregion Private Methods
