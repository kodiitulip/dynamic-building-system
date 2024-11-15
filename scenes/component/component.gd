class_name Component
extends RigidBody2D

enum ComponentState {
	IDLE,
	GRABING,
	DEAD,
}

var component_state: ComponentState = ComponentState.DEAD:
	set = _set_state_to
var snap_points: Array[SnapPoint]
var parent_component: Component


func _ready() -> void:
	snap_points.append_array($SnapPoints.get_children().filter(
		func(child: Node) -> bool: return child is SnapPoint))
	for point: SnapPoint in snap_points:
		point.component_connected.connect(_on_snap_points_component_connected)


func _process(_delta: float) -> void:
	match component_state:
		ComponentState.IDLE:
			pass

		ComponentState.GRABING:
			position = get_global_mouse_position()
			for point: SnapPoint in snap_points:
				point.handle_raycast()

		ComponentState.DEAD:
			pass


func attach_component(component: Component, pos: Vector2) -> void:
	component.reparent($ChildComponents)
	add_collision_exception_with(component)
	component.add_collision_exception_with(self)
	component.position = pos


func deattach_component(component: Component) -> void:
	component.remove_component_data(self)
	remove_component_data(component)
	component.reparent(get_tree().root)


func remove_component_data(component: Component) -> void:
	remove_collision_exception_with(component)
	for point: SnapPoint in snap_points:
		if point.connected_component != component:
			continue
		point.connected_component = null


func set_state_to_idle() -> void:
	component_state = ComponentState.IDLE


func set_state_to_dead() -> void:
	component_state = ComponentState.DEAD


func set_state_to_grab() -> void:
	component_state = ComponentState.GRABING


func _set_state_to(state: ComponentState) -> void:
	component_state = state
	freeze = state != ComponentState.DEAD
	if not parent_component and state == ComponentState.IDLE:
		await get_tree().create_timer(1).timeout
		set_state_to_dead()


func _trigger_snap_points(enable: bool) -> void:
	if enable:
		await get_tree().create_timer(0.3).timeout
	for point: SnapPoint in snap_points:
		point.enabled = enable \
				if not point.connected_component \
				else false


func _on_snap_points_component_connected(component: Component) -> void:
	parent_component = component
	set_state_to_idle()


func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int
		) -> void:
	if not event is InputEventMouseButton:
		return
	if event.is_pressed():
		set_state_to_grab()
	else:
		set_state_to_idle()
	_trigger_snap_points(event.is_pressed())
	if parent_component and event.is_pressed():
		parent_component.deattach_component(self)
