@tool
extends Area2D
class_name PointSampler
## An Area2D designed to generate a distribution of points
##
## Uses Poisson distribution to create the points.
## Allows for a visual representation of the points
## via [member PoissonSettings.point_scene]. 

#region Variables ------------------------------------------------------------------------
## All script variables that are not local to a method should be placed here.

#region signals
# place all signals here
#endregion

#region enum
# place all enums here
#endregion

#region  constants
# place all constants variables here
#endregion

#region static-variables
# export all static variables here
#endregion

#region export-variables
# place all export variables here
@export var settings: PoissonSettings:
	set(v):
		if v == null or settings == null:
			clear()
		
		if settings != null and settings.changed.is_connected(_on_settings_changed):
			settings.changed.disconnect(_on_settings_changed)

		settings = v
		pd.settings = settings

		if settings != null and not settings.changed.is_connected(_on_settings_changed):
			settings.changed.connect(_on_settings_changed)
			if is_node_ready():
				refresh()

@export var debug: bool = false
@export var sampler_collision: SamplerShape
#endregion

#region variables
# place all regular variables here
var pd: PoissonDisc = PoissonDisc.new()
var _drawn_points: Array[Node2D] = []
#endregion

#region on-ready
# place all on ready variables here
#endregion

#endregion -------------------------------------------------------------------------------

#region Builtin Functions ----------------------------------------------------------------
func _init() -> void:
	pass


func _enter_tree() -> void:
	_initalize_settings()
	if not sampler_collision:
		sampler_collision = _get_sampler_shape()


func _ready() -> void:
	_initalize_settings()
	if not sampler_collision:
		sampler_collision = _get_sampler_shape()
	refresh()

#endregion -------------------------------------------------------------------------------

#region API Calls ------------------------------------------------------------------------
func draw(p: Array[Vector2]) -> void:
	if not debug:
		return
	for _p in p:
		if not settings:
			return
		var s: Node2D = settings.point_scene.instantiate()
		s.position = _p
		add_child(s)
		_drawn_points.append(s)


func clear() -> void:
	for n in _drawn_points:
		if is_instance_valid(n):
			n.queue_free()
	_drawn_points.clear()


func refresh() -> void:
	clear()
	pd.run()
	
	if settings:
		sampler_collision.shape = settings.shape
	
	draw(pd.points)
	return


func get_points() -> Array[Vector2]:
	return pd.get_points()
		
#endregion -------------------------------------------------------------------------------

func _get_sampler_shape() -> SamplerShape:
	for c in get_children():
		if c is not SamplerShape:
			continue
		return c as SamplerShape
	return null


func _initalize_settings() -> void:
	pd.settings = settings if settings else PoissonSettings.new()
	if settings and not settings.changed.is_connected(_on_settings_changed):
		settings.changed.connect(_on_settings_changed)


#region Signal Handlers ------------------------------------------------------------------
func _on_settings_changed() -> void:
	refresh()

#endregion -------------------------------------------------------------------------------
