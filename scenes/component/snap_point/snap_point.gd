class_name SnapPoint
extends Marker2D

signal component_connected(component: Component)

var enabled: bool = false:
	set(value):
		enabled = value
		ray_cast.enabled = enabled
var connected_component: Component


@onready var ray_cast: RayCast2D = $StaticBody2D/RayCast2D


func is_colliding() -> bool:
	return ray_cast.is_colliding()


func handle_raycast() -> void:
	if not is_colliding() || connected_component != null:
		return
	var collision_body: CollisionObject2D = ray_cast.get_collider()
	var snap_point: SnapPoint = collision_body.owner
	var connecting_component: Component = snap_point.owner
	connecting_component.attach_component(
		(owner as Component),
		snap_point.position * 2
	)

	connected_component = connecting_component
	snap_point.connected_component = owner
	component_connected.emit(connected_component)
