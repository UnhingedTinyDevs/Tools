extends RefCounted
class_name ShapeHelpers

const START_POINT_ATEMPTS: int = 512

## Returns a random Vector two that is garunteed to be 
## contained with in [param _shape].
func rand_point_in_shape(_shape: Shape2D) -> Vector2:
	var _rect: Rect2 = _shape.get_rect()
	for _i in range(START_POINT_ATEMPTS):
		var p := Vector2(
			randf_range(_rect.position.x, _rect.position.x + _rect.size.x),
			randf_range(_rect.position.y, _rect.position.y + _rect.size.y)
		)

		if shape_contains(p, _shape):
			return p
			
	return _shape.get_rect().get_center()  # use center as a backup


## Checks to see if [param p] is contained within [param _shape]
func shape_contains(p: Vector2, shape: Shape2D) -> bool:
	if shape is RectangleShape2D:
		return _handle_rect(p, shape)
	elif shape is CircleShape2D:
		return _handle_circle(p, shape)
	elif shape is CapsuleShape2D:
		return _handle_capsule(p, shape)
	elif shape is ConvexPolygonShape2D:
		return _handle_convex_polygon(p, shape)
	return false


func get_rect_center(_shape: RectangleShape2D) -> Vector2:
	return Vector2(_shape.size.x / 2, _shape.size.y / 2)


#region PrivateMethods
func _handle_rect(_p: Vector2, _s: Shape2D) -> bool:
	var s := (_s as RectangleShape2D).size
	var h := s * 0.5
	return abs(_p.x) <= h.x and abs(_p.y) <= h.y


func _handle_circle(_p: Vector2, _s: Shape2D) -> bool:
		var r := (_s as CircleShape2D).radius
		return _p.length_squared() <= r * r


func _handle_capsule(_p: Vector2, _s: Shape2D) -> bool:
	var cap := _s as CapsuleShape2D
	var r := cap.radius
	var h := cap.height
	var half_h := h * 0.5
	var mid = max(0.0, half_h - r)

	# central rectangle
	if abs(_p.y) <= mid and abs(_p.x) <= r:
		return true
	# semicircles
	var cy = sign(_p.y) * mid
	var d := Vector2(_p.x, _p.y - cy)
	return d.length_squared() <= r * r


func _handle_convex_polygon(p, _shape) -> bool:
	var poly := (_shape as ConvexPolygonShape2D).points
	return Geometry2D.is_point_in_polygon(p, poly)

#endregion
