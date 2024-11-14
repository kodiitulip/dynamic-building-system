class_name Component
extends RigidBody2D

enum ComponentState {
	IDLE,
	GRABING,
	DEAD,
}

var component_state: ComponentState = ComponentState.IDLE
var snap_points: Array[SnapPoint]
var parent_component: Component

var _connected_to_base_component: bool = false
var _connected_to_non_base_component: bool = false


func _ready() -> void:
	snap_points.append_array($SnapPoints.get_children())
	for point: SnapPoint in snap_points:
		point.component_connected.connect(_on_snap_points_component_connected)


func _process(_delta: float) -> void:
	match component_state:
		ComponentState.IDLE:
			pass

		ComponentState.GRABING:
			position = get_global_mouse_position()
			for point: SnapPoint in snap_points:
				if not point.is_colliding() || point.connected_component != null:
					continue
				point.handle_raycast()
			pass

		ComponentState.DEAD:
			pass


func attach_component(component: Component, pos: Vector2) -> void:
	component.reparent($ChildComponents)
	component.global_position = pos


func deattach_component(component: Component) -> void:
	component.remove_component_data(self)
	remove_component_data(component)
	component.reparent(get_tree().root)


func remove_component_data(component: Component) -> void:
	for point: SnapPoint in snap_points:
		if point.connected_component != component:
			continue
		point.connected_component = null


func _on_snap_points_component_connected(component: Component) -> void:
	component_state = ComponentState.IDLE
	parent_component = component


func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int
		) -> void:
	if event is InputEventMouseButton:
		component_state = ComponentState.GRABING \
				if event.is_pressed() \
				else ComponentState.IDLE
		_trigger_snap_points(event.is_pressed())
		if parent_component and event.is_pressed():
			parent_component.deattach_component(self)


func _trigger_snap_points(enable: bool) -> void:
	if enable:
		await get_tree().create_timer(0.3).timeout
	for point: SnapPoint in snap_points:
		point.enabled = enable
