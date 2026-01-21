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
@export_group("Images")
## Determines if the images cycle.
@export var slide_show: bool = true:
	set(v):
		if slide_show == v: return
		slide_show = v
		start_slide_show()
## The images to cycle through.
@export var images: Array[CompressedTexture2D] = []: set = set_images
## how long to stay on one image.
@export var duration: float = 5.0: set = set_duration
@export_group("Transitions")
## Determines if the slideshow uses transitions
@export var transitions: bool = true
## The transitions that can be used on the slideshow
@export_enum("FADE", "SLIDE_RIGHT", "SLIDE_LEFT") var transition_type: int:
	set(v):
		if v == transition_type: return
		transition_type = v


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
	if slide_show:
		start_slide_show()
	else:
		set_static_img()

#endregion -------------------------------------------------------------------------------

#region API Calls ------------------------------------------------------------------------
func init(imgs: Array[CompressedTexture2D], dur: float) -> void:
	duration = dur
	images = imgs


## Set the duration for how long to display a background
func set_duration(v: float) -> void:
	duration = v
	if is_inside_tree():
		_timer.stop()
		_timer.wait_time = duration
		_timer.start()


## Sets the array of images to be used as backgrounds
func set_images(v: Array[CompressedTexture2D]) -> void:
	if v == images: return
	images = v
	if slide_show and images.size() > 1:
		start_slide_show()
	elif images.size() == 1:
		set_static_img(images[0])
	pass


## Selects a random image to display.
func random_image() -> void:
	if images.is_empty(): # if no images black bg
		set_static_img()
	if not images.size() == 1: # if one image load that image.
		set_static_img(images[0])
	
	change_image(images.pick_random())
	if slide_show: # restart slideshow if need be.
		_ensure_timer()
		_timer.start()


## Changes the image and plays a transition if needed.
func change_image(img: CompressedTexture2D = null) -> void:
	if not img:
		if not get_theme_stylebox(MY_BOX) == _bg_flat_box:
			_load_default_bg()
			return
	if not images.has(img):
		if not get_theme_stylebox(MY_BOX) == _bg_flat_box:
			_load_default_bg()
			return
	
	await _play_transition(transition_start_name())
	_set_image(img)
	await _play_transition(transition_end_name())


## Set an image with out starting a timer
func set_static_img(img: CompressedTexture2D = null) -> void:
	if not img:
		_load_default_bg()
		
	# for now pick random
	if images.has(img):
		change_image(img)
	_load_default_bg()


func start_slide_show() -> void:
	if not slide_show:
		return
	_ensure_timer()
	random_image()
	pass


func transition_start_name() -> String:
	match transition_type:
		0: return "fade_out"
		1: return "slide_to_right"
		2: return "slide_to_left"
		_: return "fade_out"


func transition_end_name() -> String:
	match transition_type:
		0: return "fade_in"
		1: return "slide_from_right"
		2: return "slide_from_left"
		_: return "fade_in"


#endregion -------------------------------------------------------------------------------

#region Signal Handlers ------------------------------------------------------------------
func _on_timer_timeout() -> void:
	if not slide_show: # if there is no slide show stop the timer
		_timer.stop()
		return
	
	if _timer.wait_time != duration:
		_timer.wait_time = duration
	
	if images.is_empty():
		set_static_img()
		return
	
	random_image()


# Loads a basic black background
func _load_default_bg() -> void:
	if not images.is_empty():
		return
	add_theme_stylebox_override(MY_BOX, _bg_flat_box)
	if _timer and not _timer.is_stopped():
		_timer.stop()


# plays a transition animation
# will always wait for the animation it played to finish playing
# use as an await function
func _play_transition(n: String) -> void:
	if not transitions:
		return
	if not background_transitions:
		return
	background_transitions.play(n)
	await background_transitions.animation_finished



# Simply places the compressed texture in the image box
func _set_image(img: CompressedTexture2D) -> void:
	if not _bg_img_box:
		_bg_img_box = StyleBoxTexture.new()
	
	_bg_img_box.texture = img
	if not get_theme_stylebox(MY_BOX) == _bg_img_box:
		add_theme_stylebox_override(MY_BOX, _bg_img_box)


func _ensure_timer():
	if _timer:
		return
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.wait_time = duration
	if not _timer.timeout.is_connected(_on_timer_timeout):
		_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	print("timer had to be initalized")

#endregion -------------------------------------------------------------------------------
