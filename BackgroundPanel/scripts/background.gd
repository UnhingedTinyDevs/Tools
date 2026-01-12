#@tool
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
@export_group("Images")
## Determines if the images cycle.
@export var slide_show: bool = true
## The images to cycle through.
@export var images: Array[CompressedTexture2D] = []: set = set_images
## how long to stay on one image.
@export var duration: float = 5.0: set = set_duration
@export_group("Transitions")
## Determines if the slideshow uses transitions
@export var transitions: bool = true
## The transitions that can be used on the slideshow
@export_enum("FADE", "SLIDE_RIGHT", "SLIDE_LEFT") var transition_type: int

#endregion

#region variables
# place all regular variables here
var _timer: Timer
var _bg_flat_box: StyleBoxFlat = preload("uid://j7w5jto8euh4")
var _bg_img_box: StyleBoxTexture

#endregion

#region on-ready
# place all on ready variables here
@onready var background_transitions: BackgroundTransitions = %BackgroundTransitions
#endregion

#endregion -------------------------------------------------------------------------------

#region Builtin Functions ----------------------------------------------------------------

func _init(imgs: Array[CompressedTexture2D] = [], _duration: float = 5.0) -> void:
	images = imgs
	duration = _duration

func _ready() -> void:
	if not _bg_img_box:
		_bg_img_box = StyleBoxTexture.new()

	_ensure_timer()
	_apply_duration_if_ready(true) # true = restart now that we're ready
	_pick_image()
	

#endregion -------------------------------------------------------------------------------

#region API Calls ------------------------------------------------------------------------
func init(imgs: Array[CompressedTexture2D], dur: float) -> void:
	duration = dur
	images = imgs


func set_duration(v: float) -> void:
	duration = v
	_ensure_timer()
	if is_inside_tree():
		_timer.stop()
		_timer.wait_time = duration
		_timer.start()


func set_images(v: Array[CompressedTexture2D]) -> void:
	if v == images: return
	images = v
	pass


func random_image_change() -> void:
	background_transitions.play("fade_out")
	await background_transitions.animation_finished
	change_image(images.pick_random())
	background_transitions.play("fade_in")
	_timer.start()


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
		_timer.stop()
		return
	random_image_change()


func _load_default_bg() -> void:
	add_theme_stylebox_override(MY_BOX, _bg_flat_box)
	pass


func _pick_image() -> void:
	if images.is_empty():
		change_image()
		return
	change_image(images.pick_random())


func _ensure_timer() -> void:
	if _timer:
		return
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.wait_time = duration
	add_child(_timer)

	if not _timer.timeout.is_connected(_on_timer_timeout):
		_timer.timeout.connect(_on_timer_timeout)


func _apply_duration_if_ready(restart: bool = false) -> void:
	if not is_inside_tree():
		# Wait until we enter the tree; then _ready() will call this again.
		return

	_ensure_timer()
	_timer.wait_time = duration

	if restart:
		_timer.start() # safe: timer is now in the tree :contentReference[oaicite:1]{index=1}

#endregion -------------------------------------------------------------------------------
