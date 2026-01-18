@tool
extends PointSampler
class_name Spawner
## Uses a point sampler to set up a spawn area for different types of Characters



@export var max_spawns: int = 5 ## the total number of spawns this spawner can produce
@export var spawn_attempts: int = 50  ## the number of times to try to spawn something before resetting.
@export var spawn_interval: float = 5.0 ## the time between spawns
@export var spawn_types: Dictionary[String, PackedScene] ## A dictionary of the spawns by name and the related scenes
@export var probe_shape: Shape2D: set = set_probe_shape ## The shape that will be used to probe for collisions
@export_flags_2d_physics var collision_check_mask: int = 1: set = set_probe_collision ## The collision Layer the probe should check

@export var target: CharacterBody2D ## The character we do not want to spawn on top of aka the player
@export var target_clearence: float = 50.0 ## how far from the player to force spawns
 
var spawn_pts: Array[Vector2] = []
var spawned_objs: Dictionary[Node2D, bool]
var spawn_timer: Timer

@onready var probe: CollisionProbe = %Probe ## The probe that checks for overlapping collision shapes before spawning.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	spawn_pts = get_points()
	_setup_timer()
	_start_timer()
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#region API
func spawn(type: String) -> void:
	print("spawn_called")
	if spawned_objs.size() >= max_spawns:
		print("max spawns reached will not spawn a new scene.")
		return
	if not spawn_types.has(type):
		print("Invalid Spawn name provided. please check the defined types in the inspector and set them if there are none.")
		return
	if not target:
		print("no target was provided.")
		return
	if not probe_shape:
		print("No probe shape to search for overlapping collisions")
		return
	
	# TODO: Get a random point.
	var p: Vector2 = spawn_pts.pick_random()
	print("inital point picked")
	
	# TODO: Validate the point is clear and far enough away from a target character
	var is_valid: bool = _validate_point(p)
	for i in spawn_attempts:
		if is_valid: break # first point was valid break
		if not is_valid:
			p = spawn_pts.pick_random()
			is_valid = _validate_point(p)
			pass
		pass

	if not is_valid:
		print("No valid point found in %s attempts"%spawn_attempts)
		return
			
	# TODO: Instantiate the desired scene based of the stringName
	var scene: Node2D = (spawn_types.get(type) as PackedScene).instantiate()
	print("scene instantiated")
	# TODO: added the spawned enity to the spawned array.
	_add_to_spawned(scene)
	
	# TODO: Move the scene to the point.
	scene.position = p
	add_child(scene)
	pass


func despawn(node: Node2D) -> void:
	if spawned_objs.has(node):
		node.queue_free()
		spawned_objs[node] = false
		call_deferred("_clean_spawned_list")

#endregion

#region Setters
func set_probe_shape(v: Shape2D) -> void:
	if v == probe_shape: return
	probe_shape = v.duplicate_deep()
	if probe and probe.is_inside_tree():
		probe.shape = probe_shape
	return


func set_probe_collision(v: int) -> void:
	if v == collision_check_mask: return
	collision_check_mask = v
	if probe.is_inside_tree():
		probe.collision_mask = collision_check_mask
	return

#endregion


#region Private Methods

# Returns the GLOBAL distance between the target var and a given point
func _dist_to_target(p: Vector2) -> float:
	return target.global_position.distance_to(to_global(p))


# Use the probe to check the desired point.
func _is_point_occupied(p: Vector2) -> bool:
	return false


func _validate_point(p: Vector2) -> bool:
	if _dist_to_target(p) >= target_clearence and not _is_point_occupied(p):
		return true
	return false


func _add_to_spawned(s: Node2D) -> void:
	# Check which nodes are still valid.
	for i:Node2D in spawned_objs.keys():
		if is_instance_valid(i):
			continue	
		spawned_objs.set(i, false)
		pass

	# add the newest obj as true
	spawned_objs.set(s, true)
	print("added to spawned")
	call_deferred("_clean_spawned_list")
	pass


func _clean_spawned_list() -> void:
	var to_remove: Array = []
	
	for n: Node2D in spawned_objs.keys():
		if not is_instance_valid(n) or spawned_objs[n] == false:
			to_remove.append(n)
			pass
		pass
	
	for n in to_remove:
		spawned_objs.erase(n)
		pass
			
	return


func _setup_timer() -> void:
	if not spawn_timer:
		spawn_timer = Timer.new()
		pass
	if not spawn_timer.timeout.is_connected(_on_timeout):
		spawn_timer.timeout.connect(_on_timeout)
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	pass


func _start_timer() -> void:
	if spawn_timer and spawn_timer.is_inside_tree():
		print("timer Started")
		spawn_timer.start()
		pass


func _on_timeout() -> void:
	spawn(spawn_types.keys().pick_random())
	_start_timer()

#endregion
