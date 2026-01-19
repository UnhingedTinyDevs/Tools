extends RefCounted
class_name CollisionProbe
## Checks if there are collisions in an area.
##
## Very simple class just hold functions where all arguments are passed in.


## Checks for collisions as a given point [param p], if areas is true, check for area collisions.
## of bodies is true check for body collisions
func check_point2D(point: Vector2, probe: ShapeCast2D, areas: bool = true, bodies: bool = true) -> bool:
	probe.collide_with_areas = areas
	probe.collied_with_bodies = bodies
	probe.position = point
	probe.target_position = Vector2.ZERO
	probe.force_shapecast_update()
	return probe.is_colliding()



func check_line2D(start: Vector2, end: Vector2, probe: ShapeCast2D, areas: bool = true, bodies: bool = true) -> bool:
	probe.collide_with_areas = areas
	probe.collide_with_bodies = bodies

	probe.position = start
	probe.target_position = end
	probe.force_shapecast_update()
	return probe.is_colliding()
