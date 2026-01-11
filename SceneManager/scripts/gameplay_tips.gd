# Authors: Jachin Minyard
@tool
extends Control
class_name GameplayTips
## A Control node that displays tips on a timer.
##
## Displays a tip every few seconds determined by 
## [member GameplayTips.tip_duration]

var _previous_tip: String = ""
@export var tip_duration: float = 4.0
@export var transition_out_name: String = "fade_out"
@export var transition_in_name: String = "fade_in"
@export var _tips: Array[String] = []

@onready var timer: Timer = $TipsTimer
@onready var animator: AnimationPlayer = $TipsAnimations
@onready var label: Label = %Tip

#region Builtins
func _ready() -> void:
	init()
	timer.timeout.connect(_on_tips_timeout)
	timer.wait_time = tip_duration
	timer.start()
	label.text = _random_tip()

#endregion Builtins

#region API
## Other nodes can call this in ready to give a custom list of tips.
func init(tips: Array[String] = _tips, duration: float = tip_duration, 
			in_trans: String = "fade_in", out_trans: String = "fade_out") -> void:
	_tips = tips
	tip_duration = duration
	transition_in_name = in_trans
	transition_out_name = out_trans

#endregion API

#region PrivateMethods
# Select a random tip to display.
func _random_tip() -> String:
	if _tips.is_empty():
		return ""
	
	var _next_tip: String = _tips.pick_random()
	if _next_tip != _previous_tip:
		_previous_tip = _next_tip
		return _next_tip
	else:
		return _random_tip()


func _on_tips_timeout() -> void:
	timer.stop()
	animator.play(transition_out_name)
	await Signal(animator.animation_finished)
	label.text = _random_tip()
	animator.play(transition_in_name)
	timer.start()

#endregion PrivateMethods
