# Authors: Jachin Minyard
@tool
extends CanvasLayer
class_name LoadingScreen 
## Simple loading screen class that can be used to hide loading.

#region Signals --------------------------------------------------------------------------
signal transition_complete ## emitted when a transition ends.

#endregion Signals -----------------------------------------------------------------------

#region Exports ---------------------------------------------------------------------------
## The theme that governs the style of the Loading screen
@export var theme: Theme: set = set_theme

#region Gameplay Tips
@export_category("Gameplay Tips")
## Add gameplay tips here that will be displayed on loading.
@export var tips: Array[String] = []: set = set_tips
## The length a tip is displayed
@export var tip_duration: float = 3.0: set = set_tip_duration
## The animation transition of the text change
@export var tip_in_transition: String = "fade_in": set = set_tip_in_transition

#endregion Gameplay Tips

#region Background Exports
@export_category("Background")
## Place Images here that will be displayed on loading.
@export var background_img: Array[CompressedTexture2D] = []: set = set_background_img
## The duration you stay on a background
@export var background_duration: float = 5.0: set = set_background_duration
@export_category("Loading")
## What text is displayed in the title
@export var text: String = "Loading": set = set_loading_text
## Should the animated elipises be displayed
@export var elispse: bool = true: set = set_elispse
#endregion Background Exports

#endregion Exports ------------------------------------------------------------------------

#region Variables ------------------------------------------------------------------------
var starting_animation: String

#endregion Variables ---------------------------------------------------------------------

#region OnReadys -------------------------------------------------------------------------
## Animations for the loading screen as a whole
@onready var animations: AnimationPlayer = %Transitions
## the progress bar to display on longer load times
@onready var progress_bar: ProgressBar = %Progress
## The timer that manages the transitions for loading
@onready var timer: Timer = $Timer
## Gameplay tips to display on the loading screem
@onready var gameplay_tips: GameplayTips = %GameplayTips
## the background component that will be used to cycle through Images
@onready var background: Background = %Background
## The Loading Text module used to display a loading title
@onready var loading_text: LoadingText = %LoadingText
## The main controll node it gives the theme to all other nodes
@onready var main_control: Control = %MainControl

#endregion OnReadys ----------------------------------------------------------------------

#region Builtins -------------------------------------------------------------------------
func _ready() -> void:
	if not Engine.is_editor_hint():
		progress_bar.visible = false
		timer.timeout.connect(_on_timer_timeout)
	
	# initalize the sub parts 
	gameplay_tips.init(tips, tip_duration, tip_in_transition)
	background.init(background_img, background_duration)
	loading_text.init(text, false)
	
	# set up the themes.
	main_control.theme = theme
	if not theme.changed.is_connected(_on_theme_changed):
		theme.changed.connect(_on_theme_changed)


#endregion Builtins ----------------------------------------------------------------------

#region Setters
## Sets the theme resource used by the loading screne
func set_theme(v: Theme) -> void:
	main_control.theme = v
	theme = v


## Sets an array of gameplay tips that can be displayed on loading.
func set_tips(v: Array[String]) -> void:
	if tips == v: return
	tips = v
	if gameplay_tips:
		gameplay_tips._tips = v


## Sets the durration each gameplay tip will be displayed for.
func set_tip_duration(v: float) -> void:
	if tip_duration == v: return
	tip_duration = v
	if gameplay_tips:
		gameplay_tips.tip_duration = v


## Sets the in transition when loading the gameplay tips
func set_tip_in_transition(v: String) -> void:
	if v == tip_in_transition: return
	tip_in_transition = v
	if gameplay_tips:
		gameplay_tips.transition_in_name = tip_in_transition


## Sets an array of background images that can be transitioned too
func set_background_img(v: Array[CompressedTexture2D]) -> void:
	if v == background_img: return
	background_img = v
	if background:
		background.images = v


## Sets the duration the background is dispalyed for before transitoning
func set_background_duration(v: float) -> void:
	if background_duration == v: return
	background_duration = v
	if background:
		background.background_duration = background_duration


## Sets the text to display in the title of the screen. 
## Set to "" if you want to no display toxt
func set_loading_text(s: String) -> void:
	if s == text: return
	text = s
	if loading_text:
		loading_text.set_text(text)


func set_elispse(v: bool) -> void:
	if v == elispse: return
	elispse = v
	loading_text.show_elipse(v)
#endregion Setters

#region API ------------------------------------------------------------------------------
## Called by the SceneManager to start the 'in' transition.
## Takes the animation name as a String
func start_transition(animation_name: String) -> void:
	if Engine.is_editor_hint():
		return
	if !animation_name:
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_animation = animation_name
	animations.play(animation_name)
	timer.start()


## Called by the SceneManager to start the 'out' transition.
func finish_transition() -> void:
	if Engine.is_editor_hint():
		return
	
	if timer:
		timer.stop()
	
	var ending_animation: String = starting_animation.replace("to", "from")
	if !animations.has_animation(ending_animation):
		push_warning("'%s' animation does not exist")
		ending_animation = "fade_from_black"
	animations.play(ending_animation)
	
	await animations.animation_finished
	queue_free()


## Called by the SceneManager to update the progress bar from the background.
## Progress is determined by the state of [ResourceLoader] load_threaded_get_status().
func update_bar(value: float) -> void:
	progress_bar.value = value


## Used in the [AnimationPlayer] track to signal when the screen is covered.
func report_midpoint() -> void:
	transition_complete.emit()


#endregion API ---------------------------------------------------------------------------

#region PrivateMethods
## If the scene takes to long show a progress bar.
func _on_timer_timeout() -> void:
	progress_bar.visible = true


func _on_theme_changed() -> void:
	main_control.theme = theme

#endregion ProvateMethods
