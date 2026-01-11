@tool
extends Panel
class_name Background
## Simple background transitions.

#region Variables ------------------------------------------------------------------------
## All script variables that are not local to a method should be placed here.

#region signals
# place all signals here
#endregion

#region enum
# place all enums here
#endregion

#region  constants
# place all constants variables here
const MY_BOX: String = "panel"

#endregion

#region static-variables
# export all static variables here
#endregion

#region export-variables
## The images to cycle through
@export var images: Array[CompressedTexture2D] = []
## how long to stay on one image
@export var background_duration: float = 5.0: set = set_duration

#endregion

#region variables
# place all regular variables here
var background_timer: Timer
var _bg_flat_box: StyleBoxFlat = preload("uid://j7w5jto8euh4")
var _bg_img_box: StyleBoxTexture

#endregion

#region on-ready
# place all on ready variables here
#endregion

#endregion -------------------------------------------------------------------------------

#region Builtin Functions ----------------------------------------------------------------

func _init(imgs: Array[CompressedTexture2D] = [], duration: float = background_duration) -> void:
	images = imgs
	background_duration = duration
	


func _ready() -> void:
	if not _bg_img_box:
		_bg_img_box = StyleBoxTexture.new()
	
	_setup_timer()
	_pick_image()
	
	

#endregion -------------------------------------------------------------------------------

#region API Calls ------------------------------------------------------------------------
func init(imgs: Array[CompressedTexture2D], dur: float) -> void:
	background_duration = dur
	images = imgs

func set_duration(v: float) -> void:
	background_timer.wait_time = v
	background_duration = v

func change_image(img: CompressedTexture2D = null) -> void:
	if not _bg_img_box:
		_bg_img_box = StyleBoxTexture.new()
	if not img:
		if not get_theme_stylebox(MY_BOX) == _bg_flat_box:
			_load_default_bg()
			return
	if not images.has(img):
		if not get_theme_stylebox(MY_BOX) == _bg_flat_box:
			_load_default_bg()
			return
	
	_bg_img_box.texture = img
	if not get_theme_stylebox(MY_BOX) == _bg_img_box:
		add_theme_stylebox_override(MY_BOX, _bg_img_box)



#endregion -------------------------------------------------------------------------------

#region Signal Handlers ------------------------------------------------------------------
func _on_timer_timeout() -> void:
	if images.is_empty():
		_load_default_bg()
		background_timer.start()
		return
	change_image(images.pick_random())
	background_timer.start()
	pass


func _load_default_bg() -> void:
	add_theme_stylebox_override(MY_BOX, _bg_flat_box)
	pass


func _pick_image() -> void:
	if images.is_empty():
		change_image()
		return
	change_image(images.pick_random())


func _setup_timer() -> void:
	if not background_timer:
		background_timer = Timer.new()
		add_child(background_timer)
	
	background_timer.one_shot = true
	background_timer.wait_time = background_duration
	if not background_timer.timeout.is_connected(_on_timer_timeout):
		background_timer.timeout.connect(_on_timer_timeout)
	background_timer.start()

#endregion -------------------------------------------------------------------------------
