extends RefCounted
class_name CollisionProbe
## Checks if there are collisions in an area.


var probe: ShapeCast2D ## The shape cast used to check for collisions
var check_mask: int: set = set_collision_mask ## The collision layers to check


func _init(sc: ShapeCast2D, cmask: int) -> void:
	probe = sc
	check_mask = cmask
	probe.collision_mask = cmask
	pass


## Checks for collisions as a given point [param p], if areas is true, check for area collisions.
## of bodies is true check for body collisions
func check_point2D(p: Vector2, areas: bool = true, bodies: bool = true) -> bool:
	assert(probe, "probe(ShapeCast2D) must be set ")
	assert(check_mask, "check_mask(int): Must be set, represents the bits of the collisions mask.")
	
	probe.collide_with_areas = areas
	probe.collied_with_bodies = bodies
	
	probe.position = p
	probe.target_position = Vector2.ZERO
	probe.force_shapecast_update()
	return probe.is_colliding()


## TODO: implement a function that checks for collisions in a line
func check_line2D(sp: Vector2, ep: Vector2, areas: bool = true, bodies: bool = true) -> bool:
	return false


func set_collision_mask(v: int) -> void:
	if check_mask == v: return
	check_mask = v
	if probe:
		probe.collision_mask = check_mask
		pass
	return


func set_probe(v: ShapeCast2D) -> void:
	if v == probe: return
	probe = v
	if check_mask:
		probe.collision_mask = check_mask
	pass
