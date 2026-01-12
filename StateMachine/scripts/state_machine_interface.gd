@abstract
extends Node
class_name IStateMachine


@export var starting_state: State
## What Group of StateMachines does this machine belong to.
@export_group("Debug")
@export var LOGLVL: int = 1

var _current_state: State
var _last_state: State
var _state_list: Dictionary[String, State]
# private internal variables
var _enabled := true
var _physics_enabled := true
var _process_enabled := true
var _input_enabled := true

# Public vars with getters and setters
var current_state: State:
	get: return _current_state
	set(v): _current_state = v
var last_state: State:
	get: return _last_state
	set(v): _last_state = v
var enabled: bool:
	get: return _enabled
	set(v): enable(v)
var physics_enabled: bool:
	get: return _physics_enabled
	set(v): _physics_enabled = v
var process_enabled: bool:
	get: return _process_enabled
	set(v): _process_enabled = v
var input_enabled: bool:
	get: return _input_enabled
	set(v): _input_enabled = v
var state_list: Dictionary[String, State]:
	get:
		_state_list = get_states() 
		return _state_list


## Enables or disables the state machine it is called on. [br]
## Disables: [br]
## - process
## - physics
## - input
## - state_change
func enable(v: bool) -> void:
	if _enabled == v:
		return
	_enabled = v
	if not _enabled:
		_physics_enabled = false
		_process_enabled = false
		_input_enabled = false
		if current_state:
			current_state.exit()


## Gets all the child states of the state machine.
func get_states() -> Dictionary[String, State]:
	var rv: Dictionary[String, State] = {}
	for s in get_children():
		if s is State:
			rv.set(s.state_name, s)
	return rv 


## This function will always force a state machine to change states 
## even if this state machine is disabled.
## This function is mostly for internal use and you should rely on 
## [method StateMachine.change_state]
func _force_change_state(state: State) -> void:
	if _current_state:
		_current_state.exit()
	
	_last_state = _current_state
	_current_state = state
	_current_state.enter()


## Initalize the state machine with its arguments. [br][br]
## NOTE: '...args' becomes an array of all the parameters passed in. so make sure to check the args 
## no checking is currently in place and that is intierly up to the implementation
@abstract func init(...args) -> void;
@abstract func process_frame(_delta: float) -> void;
@abstract func process_physics(_delta: float) -> void;
@abstract func process_input(event: InputEvent) -> void;
