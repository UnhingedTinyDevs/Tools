extends AnimationPlayer
class_name SceneTransitions

#region Variables ------------------------------------------------------------------------
# Declare member variables, exported values, and constants here.
# These store the state/data for this script.

#region Signals 
# Place Signals here
#endregion 

#region Enums 
# Place Enums Here
## Easy way to refrence the pair of animations you want to play.
enum Transition {
	FADE_BLK = 0,
	SLIDE_RIGHT = 1,
	SLIDE_LEFT = 2,
}

#endregion 

#region Consts
# Place Constants here
const FADE_TO_BLK:  String ="fade_to_black"
const FADE_FROM_BLK:  String ="fade_from_black"
const SLIDE_TO_RIGHT: String = "slide_to_right"
const SLIDE_FROM_RIGHT: String = "slide_from_right"
const SLIDE_TO_LEFT: String = "slide_to_left"
const SLIDE_FROM_LEFT: String = "slide_from_left"
#endregion

#region Static Vars

#endregion

#region Exports
# Place exports here
#endregion

#region Variables
# Place regular variables here.
#endregion

#region OnReady
# Pace On Ready variables here
#endregion

#endregion -------------------------------------------------------------------------------

#region API ------------------------------------------------------------------------------
# Public functions that other scripts are allowed to call.
# Put your gameplay logic and reusable functions here.
## Gets the string name of the start of the desired transition
static func get_start_transition(transition: Transition) -> String:
	match(transition):
		Transition.FADE_BLK:
			return FADE_TO_BLK
		Transition.SLIDE_RIGHT:
			return SLIDE_TO_RIGHT
		Transition.SLIDE_LEFT:
			return SLIDE_TO_LEFT
		_: return FADE_TO_BLK


## Gets the String name of the ending of the desired Transition
static func get_end_transition(transition: Transition) -> String:
	match(transition):
		Transition.FADE_BLK:
			return FADE_FROM_BLK
		Transition.SLIDE_RIGHT:
			return SLIDE_FROM_RIGHT
		Transition.SLIDE_LEFT:
			return SLIDE_FROM_LEFT
		_: return FADE_FROM_BLK

#endregion -------------------------------------------------------------------------------
