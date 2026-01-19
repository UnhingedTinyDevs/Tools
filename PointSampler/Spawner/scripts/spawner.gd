@tool
extends PointSampler
class_name Spawner
## Uses a point sampler to set up a spawn area for different types of Characters
##
## Can enforce collision checks in which case enable [member Spawner.check_collisions] and set the
## desired layers on [member Spawner.collision_check_mask]. The Spawner can also enforce naviagtion
## layer rules to enable these set [members Spawner.check_navigation] to true, and configure the desired
## layers the spawner can use to spawn its nodes with the [member Spawner.nav_checks].

#region Exports --------------------------------------------------------------------------
@export_group("Spawn Settings")
@export var max_spawns: int = 5 ## the total number of spawns this spawner can produce
@export var spawn_attempts: int = 50  ## the number of times to try to spawn something before resetting.
@export var spawn_interval: float = 5.0 ## the time between spawns
@export var spawn_types: Array[SpawnItem] = [] ## An array of the [SpawnItem]'s
@export var default_spawn: SpawnItem ## What items should the spawner fall back on, or set this if the spawner spawns only one thing

@export_group("Collision Avoidance")
@export var check_collisions: bool = true ## Should the spawner worry about checking collisions
@export var probe_shape: Shape2D: set = set_probe_shape ## The shape that will be used to probe for collisions
@export_flags_2d_physics var collision_checks: int = 1: set = set_probe_collision ## The collision Layer the probe should check
@export_subgroup("Character avoidance")
@export var target: CharacterBody2D ## The character we do not want to spawn on top of aka the player
@export var target_clearence: float = 50.0 ## how far from the player to force spawns

@export_group("Navigation Adherance")
@export var check_navigation: bool = true ## Should the spawner enforce navigation rules.
@export_flags_2d_navigation var nav_checks: int ## What navigation layers are allowed.

@export_group("Timer Settings")
@export var spawn_on_timer: bool = true: set = set_spawn_on_timer ## Should the spawner run on a timer
@export var spawn_rand_on_timeout: bool = true ## Spawn a random object from [member Spawner.spawn_types] when the timer times out

#endregion Exports -----------------------------------------------------------------------


#region Variables ------------------------------------------------------------------------
var spawn_pts: Array[Vector2] = [] ## List of points aviable to choose from, made by [PoissonDisc]
var spawns: Dictionary[StringName, SpawnItem] = {} ##  Stores the Items defined in [member Spawner.spawn_types] keyed by its name.
var spawned_objs: Dictionary[Node2D, bool] ## What objects have been spawned and is its refrence valid
var spawn_timer: Timer ## The timer that controls when to spawn something.
var collision_enforcer: CollisionProbe
#endregion Variables ---------------------------------------------------------------------

#region onReady --------------------------------------------------------------------------
@onready var probe: Probe = %Probe ## The probe that checks for overlapping collision shapes before spawning.

#endregion onReady -----------------------------------------------------------------------


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Run only in the editor
	if Engine.is_editor_hint():
		pass
	# Only run during game play
	elif not Engine.is_editor_hint():
		assert(target)
		assert(probe_shape)
		collision_enforcer = CollisionProbe.new(probe, collision_checks)
		_setup_timer()
		_start_timer()
		_init_spawns()
	# Run in editor and game
	else:
		super()
		spawn_pts = get_points()



#region API
func spawn(type: String) -> void:
	if Engine.is_editor_hint(): # Never spawn in the editor
		return

	if spawned_objs.size() >= max_spawns:
		print("max spawns reached will not spawn a new scene.")
		return
	if not spawns.has(type):
		print("Invalid Spawn name provided. please check the defined types in the inspector and set them if there are none.")
		return
	
	var p: Vector2 = spawn_pts.pick_random()
	
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
			
	var scene: Node2D = (spawns.get(type) as PackedScene).instantiate()
	
	scene.position = p
	add_child(scene)
	_add_to_spawned(scene)
	pass


func despawn(node: Node2D) -> void:
	if Engine.is_editor_hint():
		return
	if spawned_objs.has(node):
		node.queue_free()
		spawned_objs[node] = false
		call_deferred("_clean_spawned_list")

#endregion API ---------------------------------------------------------------------------

#region Setters --------------------------------------------------------------------------
func set_probe_shape(v: Shape2D) -> void:
	if v == probe_shape: return
	probe_shape = v.duplicate_deep()
	if probe and probe.is_inside_tree():
		probe.shape = probe_shape
		pass
	if collision_enforcer and probe:
		collision_enforcer.probe = probe
	return


## Propagate the collision to all other obj that need it.
func set_probe_collision(v: int) -> void:
	if v == collision_checks: return
	collision_checks = v
	if probe.is_inside_tree():
		probe.collision_mask = collision_checks
		pass
	if collision_enforcer:
		collision_enforcer.check_mask =   collision_checks
		pass
	return


func set_spawn_on_timer(v: bool) -> void:
	if v == spawn_on_timer: return
	spawn_on_timer = v
	# Start the timer if this is set to true while the game is running
	if spawn_on_timer and not Engine.is_editor_hint():
		_setup_timer()
		_start_timer()
		
#endregion Setters -----------------------------------------------------------------------


#region Private Methods ------------------------------------------------------------------

# Returns the GLOBAL distance between the target var and a given point
func _dist_to_target(p: Vector2) -> float:
	return target.global_position.distance_to(to_global(p))


# Use the probe to check the desired point.
func _is_point_occupied(p: Vector2) -> bool:
	if not probe:
		return false
	
	probe.position = p
	print("New Probe Position ", probe.position)
	print("point it should be at: ", p)
	probe.collision_mask = collision_checks
	probe.target_position = Vector2.ZERO
	probe.force_shapecast_update()
	return probe.is_colliding()


func _validate_point(p: Vector2) -> bool:
	if _dist_to_target(p) >= target_clearence and not _is_point_occupied(p):
		return true
	return false


func _add_to_spawned(s: Node2D) -> void:
	spawned_objs.set(s, true)
	call_deferred("_clean_spawned_list")
	pass


# Used to clean up the array once objects have been freed.
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


# Populates the spawns dictionary
func _init_spawns() -> void:
	for n: SpawnItem in spawn_types:
		spawns.set(n.sname, n)
		
#endregion Private Methods ---------------------------------------------------------------

#region Timer Methods --------------------------------------------------------------------
func _setup_timer() -> void:
	if not spawn_on_timer:  # if we are not supposed to spawn on a timer dont set up the timer
		return
	
	if not spawn_timer:
		spawn_timer = Timer.new()
		pass
	
	if not spawn_timer.timeout.is_connected(_on_timeout):
		spawn_timer.timeout.connect(_on_timeout)
		pass
	
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = true
	spawn_timer.autostart = true
	add_child(spawn_timer)
	pass


func _start_timer() -> void:
	if not spawn_on_timer: # if we are not supposed to spawn on a timer we can not start the timer
		return

	if spawn_timer and spawn_timer.is_inside_tree():
		print("timer Started")
		spawn_timer.start()
		pass

	
# what do we do when the timer spawns out.
func _on_timeout() -> void:
	if spawn_rand_on_timeout:
		spawn((spawn_types.pick_random() as SpawnItem).sname)
		_start_timer()
		return


#endregion Timer Methods -----------------------------------------------------------------
