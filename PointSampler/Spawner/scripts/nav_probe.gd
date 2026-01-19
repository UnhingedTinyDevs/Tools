extends RefCounted
class_name NavigationProbe
## Checks to see if a point over laps with any of the desired navigation layers

func check_point2D(point: Vector2, navmap: RID) -> bool:
	var cp: Vector2 = NavigationServer2D.map_get_closest_point(navmap, point)
	return cp.is_equal_approx(point)
