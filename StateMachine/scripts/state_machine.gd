extends IStateMachine
class_name StateMachine
## Base State machine script.
##
## There is no initalization funtion implemented so make sure to add logic here
## Pass in what ever arguments you need then make sure to parse them out of the 
## args array.

#region API ------------------------------------------------------------------------------
@warning_ignore("unused_parameter")
func init(...args) -> void:
	pass


func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		_force_change_state(new_state)


func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		_force_change_state(new_state)


func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)


func change_state(s: State) -> void:
	if not enabled:
		return
	_force_change_state(s)
#endregion -------------------------------------------------------------------------------
