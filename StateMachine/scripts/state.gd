extends IState
class_name State
## Basic State class
##
## Implements a simple enter and exit

#region API ------------------------------------------------------------------------------
## What happens immeditly when a state is entered
func enter() -> void:
	if LOGLVL < DEBUGLVL:
		print("Entering the %s State"%state_name)
	if animations:
		animations.play(animation_name)


## What happens right before a state is exited
func exit() -> void:
	if LOGLVL < DEBUGLVL:
		print("Exiting the %s State"%state_name)
	if animations.is_sprite_flipped():
		animations.flip_sprite(false)


## Handles the state _process function runs ever frame
func process_frame(_delta: float) -> State:
	return null


## Handles the states input logic
func process_input(_event: InputEvent) -> State:
	return null


## Handles the states physics process
func process_physics(_delta: float) -> State:
	return null

#endregion -------------------------------------------------------------------------------

#region Private Methods ------------------------------------------------------------------
# Pace private methods that are not ment to be called by others here
# This could include things like signal handlers and other functions.
#endregion -------------------------------------------------------------------------------
