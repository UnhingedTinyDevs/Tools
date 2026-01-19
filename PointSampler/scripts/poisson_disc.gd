extends RefCounted
class_name PoissonDisc


#region Variables ------------------------------------------------------------------------
## All script variables that are not local to a method should be placed here.

#region signals
# place all signals here
#endregion

#region enum
# place all enums here
#endregion

#region  constants
const PRINT_OFFSET: float = 100.0 ## Distance off to print above ground
const START_POINT_ATEMPTS: int = 512
#endregion

#region static-variables
# export all static variables here
#endregion

#region export-variables
# place all export variables here

#endregion

#region variables
# place all regular variables here
## Holds the values that determine how the points are selected
var settings: PoissonSettings = null
## Stores a list of the final points chosen by the algorith
var points: Array[Vector2] = []: get = get_points

var _grid: Array = []
var _active_list: Array[Vector2] = [] ## Will hold the active points.
var _grid_cell_size: float
var _cached_shape_rect: Rect2
var _shape_helper: ShapeHelpers = ShapeHelpers.new()
#endregion

#region on-ready
# place all on ready variables here
#endregion

#endregion -------------------------------------------------------------------------------

#region Builtin Functions ----------------------------------------------------------------
func _init() -> void:
	pass

#endregion -------------------------------------------------------------------------------

#region API Calls ------------------------------------------------------------------------
func run() -> void:
	# validation
	if not Engine.is_editor_hint():
		assert(settings != null, "No Settings have been provided")
		assert(settings.shape != null, "No Shape is set in the settings")
	
	# cleanup
	points.clear()
	_active_list.clear()
	
	if not settings:
		return
	if not settings.shape:
		return
	
	_cached_shape_rect = settings.shape.get_rect()
	_init_grid()
	_generate_points()


func get_points() -> Array[Vector2]:
	print("getting points")
	return points

#endregion -------------------------------------------------------------------------------

#region Signal Handlers ------------------------------------------------------------------

func _init_grid() -> void:
	_grid_cell_size = settings.min_distance / sqrt(2)
	var grid_width: int = int(ceil(_cached_shape_rect.size.x / _grid_cell_size))
	var grid_height: int = int(ceil(_cached_shape_rect.size.y / _grid_cell_size))
	_grid = []
	for i in range(grid_width):
		_grid.append([])
		for j in range(grid_height):
			_grid[i].append(null)
	pass



func _generate_points() -> void:
	var start = _shape_helper.rand_point_in_shape(settings.shape)
	_add_point(start)
	
	while _active_list.size() > 0:
		var point: Vector2 = _active_list.pick_random()
		var is_found: bool = false
		
		for i in range(0, settings.max_attempts):
			var new_pt: Vector2 = _generate_rand_pt_around(point)
			
			if _is_valid_point(new_pt):
				_add_point(new_pt)
				is_found  = true
				break
		
		if not is_found:
			_active_list.remove_at(_active_list.find(point))


func _add_point(p: Vector2):
	points.append(p)
	_active_list.append(p)
	var grid_pos: Vector2i = _point_to_grid(p)
	_grid[grid_pos.x][grid_pos.y] = p


func _generate_rand_pt_around(p: Vector2) -> Vector2:
	var r: float = randf_range(
						settings.min_distance, 
						settings.min_distance * settings.max_dist_mult
						)
	var angle: float = randf() * TAU
	return p + Vector2(cos(angle), sin(angle)) * r


func _point_to_grid(p: Vector2) -> Vector2i:
	# Accounts for negitive coordinates
	var rel: Vector2 = p - _cached_shape_rect.position
	return Vector2i(
		int(rel.x / _grid_cell_size),
		int(rel.y / _grid_cell_size)
	)


func _is_valid_point(p: Vector2) -> bool:
	if _point_out_of_bounds(p):
		return false
	
	var gp: Vector2i = _point_to_grid(p)
	
	for dx in range(-2, 3):
		for dy in range(-2, 3):
			var np: Vector2i = gp + Vector2i(dx, dy)
			if _check_neighbor(np):
				var neighbor: Variant = _grid[np.x][np.y]
				if neighbor != null and p.distance_to(neighbor) < settings.min_distance:
					return false
	return true


func _check_neighbor(p: Vector2i) -> bool:
	return (
		p.x >= 0 and p.x < _grid.size()	
		and p.y >= 0 and p.y < _grid[0].size()
	)


func _point_out_of_bounds(p: Vector2) -> bool:
	return ((not _cached_shape_rect.has_point(p)) or 
			(not _shape_helper.shape_contains(p, settings.shape)))




#endregion -------------------------------------------------------------------------------
