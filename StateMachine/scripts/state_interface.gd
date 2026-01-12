@abstract
extends Node
class_name IState

#region Variables ------------------------------------------------------------------------
#region Exports
@export var state_name: String;
@export var animation_name: String;
@export var sound_effect: AudioEffect;
@export_group("Debug")
@export var LOGLVL: int = 2;
@export var DEBUGLVL: int = 1;
#endregion

#region Variables
var animations: IAnimationComponent;
var audio: IAudioComponent;
var machine: StateMachine;
#endregion

#endregion -------------------------------------------------------------------------------

#region API ------------------------------------------------------------------------------
@abstract func enter() -> void; ## What happens immeditly when a state is entered
@abstract func exit() -> void; ## What happens right before a state is exited
@abstract func process_input(event: InputEvent) -> State; ## Handles the states input logic
@abstract func process_frame(delta: float) -> State; ## Handles the state _process function runs ever frame
@abstract func process_physics(delta: float) -> State; ## Handles the states physics process

#endregion -------------------------------------------------------------------------------
