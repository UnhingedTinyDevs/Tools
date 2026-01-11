@tool
extends Resource
class_name PoissonSettings
## Settings that controll the distribution of [PoissonDisc]
##
## Simple settings with setter that emit signals when changed.
## Save the settings to save a give distribution Cluster.

## The default scene to use for displaying shapes
const DEFAULT_POINT_DEBUG_UID: String = "uid://bh1llhygf5hh8"

#region Exports
 ## The minimum distance between points
@export var min_distance: float = 100.0: set = set_min_dist
## max_distance = min_distance * max_dist_mult	
@export var max_dist_mult: float = 2.0: set = set_max_dist_mult
## the scene to use in debugging
@export var point_scene: PackedScene = preload(DEFAULT_POINT_DEBUG_UID): set = set_point_scene
## Number of attempts to make a point in the area around the current node
@export var max_attempts: int = 20: set = set_max_attempts
## The Shape2D to sample inside of. [br]
## This Shape should usally come from an Area2D
@export var shape: Shape2D: set = set_shape

#endregion

#region Setters
## Set the minimum distance allowed between points
func set_min_dist(v: float) -> void:
	if min_distance == v: return
	min_distance = v
	emit_changed()


## Sets the multiplier that determines the max distance between points [br]
## max_distance = min_distance * max_dist_mult
func set_max_dist_mult(v: float) -> void:
	if max_dist_mult == v: return
	max_dist_mult = v
	emit_changed()


## Set a [PackedScene] that determines what the point debug looks like
func set_point_scene(v: PackedScene) -> void:
	if point_scene == v: return
	point_scene = v
	emit_changed()


## Sets the max attempts to find a neighbor for an active point.
func set_max_attempts(v: int) -> void:
	if max_attempts == v: return
	max_attempts = v
	emit_changed()


## Sets the [Shape2D] being used by the spawn Area.
func set_shape(v: Shape2D) -> void:
	if v == shape: return
	if shape and shape.changed.is_connected(_shape_properties_changed):
		shape.changed.disconnect(_shape_properties_changed)
	shape = v
	emit_changed()
	shape.changed.connect(_shape_properties_changed)


#endregion

func _shape_properties_changed() -> void:
	emit_changed()
