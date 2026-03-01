extends RefCounted
class_name NavigationProbe
## Checks to see if a point over laps with any of the desired navigation layers

func check_point2D(point: Vector2, navmap: RID, nav_layers: int = 0) -> bool:
	var cp: Vector2 = NavigationServer2D.map_get_closest_point(navmap, point)
	if not cp.is_equal_approx(point):
		return false
	var region: RID = NavigationServer2D.map_get_closest_point_owner(navmap, point)
	return NavigationServer2D.region_get_navigation_layers(region) & nav_layers != 0
