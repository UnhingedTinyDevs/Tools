extends Node
class_name AgroComponent
## Determines if a character should be agro.
##
## This component uses Godots groups to check if any thing that enters the
## Agro radius should be focused, Only one thing can hold agro at any given time.

signal start_agro(body: Node2D)
signal stop_agro(body: Node2D)

@export var agro_radius: Area2D ## The area in which the owner wants to focus on to the player, if the player leaves this area the agro should stop
@export var agro_targets: Dictionary[String, int] = {} ## Holds the name of groups that should be targeted and there priority


var is_agro: bool = false ## Is the
var target: Node2D ## The current thing that is beinging chased

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	agro_radius. body_entered.connect(_start_agro)
	agro_radius.body_exited.connect(_end_agro)
	pass


# What happens when the agro area is entered by the targets body
func _start_agro(body: Node2D) -> void:
	var current_priority: int = agro_targets.get(target.get_groups())
	for g in body.get_groups():
		if not agro_targets.has(g): continue; ## We dont want to target this body
		current_target = g
		
		
	pass


func _end_agro(body: Node2D) -> void:
	pass
