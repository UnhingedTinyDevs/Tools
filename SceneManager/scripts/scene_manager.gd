# Authors: Jachin Minyard
extends Node
## Used to load and unload scenes.

#region Signals --------------------------------------------------------------------------
signal content_finished_loading(content) ## Emitted when content is finished loading
signal content_invalid(content_path: String) ## Emitted when content path is invalid 
signal content_failed_to_load(content_path: String) ## Emitted when content failed to load

#endregion Signals -----------------------------------------------------------------------

#region Enums ----------------------------------------------------------------------------
## The different types of transitions that are allowed to be used in the loading screen
#endregion Enums -------------------------------------------------------------------------


#region Variables ------------------------------------------------------------------------
var loading_screen: LoadingScreen

#endregion Variables ---------------------------------------------------------------------

#region Private Variables ----------------------------------------------------------------
var _loading_screen_scene: PackedScene = preload("uid://cuv34xojfphep")
var _transition: String
var _content_path: String
var _load_progress_timer: Timer
#var _load_in_progress: bool = false
#var _load_scene_into: Node

#endregion Private Variables -------------------------------------------------------------


#region Builtins -------------------------------------------------------------------------
func _ready() -> void:
	content_finished_loading.connect(_on_content_finished_loading)
	content_invalid.connect(_on_content_invalid)
	content_failed_to_load.connect(_on_content_failed_to_load)

	
#endregion Builtins ----------------------------------------------------------------------

## Loads a new scene given a string path or uid. [br]
## Pick one of the following for a transition [enum SceneTransitions.Transition].
func load_new_scene(content_path: String, transition: SceneTransitions.Transition = SceneTransitions.Transition.FADE_BLK ) -> void:
	_transition = SceneTransitions.get_start_transition(transition)
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	loading_screen.start_transition(_transition)
	_load_content(content_path)


## Used to check the status of the background thread loading the content.[br]
## Based on the [enum ResourceLoader.ThreadLoadStatus].
func monitor_load_status() -> void:
	print("monitor_load_status called")
	var load_progress: Array = []
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)
	print("Scene Load Status: %s", load_status)
	match load_status:
		0:
			content_invalid.emit(_content_path)
			_load_progress_timer.stop()
			return
		1:
			if loading_screen != null:
				print("'%s' Current Progress", load_progress[0] * 100)
				loading_screen.update_bar(load_progress[0] * 100)
		2:
			content_failed_to_load.emit(_content_path)
			_load_progress_timer.stop()
			return
		3:
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			loading_screen.update_bar(load_progress[0] * 100)
			var content = ResourceLoader.load_threaded_get(_content_path)
			content_finished_loading.emit(content.instantiate())

			
#region PrivateMethods -------------------------------------------------------------------
# private function used to start the loading screen transtition
# and the background loading of the content
func _load_content(content_path: String) -> void:
	if loading_screen != null:
		await loading_screen.transition_complete

	_content_path = content_path
	var loader = ResourceLoader.load_threaded_request(content_path)
	if not ResourceLoader.exists(content_path) or loader == null:
		content_invalid.emit(content_path)
		return

	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(monitor_load_status)
	get_tree().root.add_child(_load_progress_timer)
	_load_progress_timer.start()
	pass

#endregion PrivateMethods ----------------------------------------------------------------

			
#region SignalHandlers -------------------------------------------------------------------
func _on_content_finished_loading(content) -> void:
	var initial_scene = get_tree().current_scene
	initial_scene.queue_free()

	get_tree().root.call_deferred("add_child", content)
	get_tree().root.set_deferred("current_scene", content)

	if loading_screen != null:
		loading_screen.finish_transition()
		await loading_screen.animations.animation_finished
		loading_screen = null


func _on_content_invalid(path: String) -> void:
	printerr("error: cannot load resource '%s'" % path)


func _on_content_failed_to_load(path: String) -> void:
	printerr("error: cannot load resource '%s'" % path)

#endregion -------------------------------------------------------------------------------
