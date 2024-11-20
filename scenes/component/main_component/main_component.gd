class_name MainComponent
extends Component

enum ShipState {
	FLYING,
	BUILDING,
	DEAD,
}

@export var thrust: float = 150
@export var torque: float = 500.0
@export var current_state: ShipState = ShipState.FLYING


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	match current_state:
		ShipState.FLYING:
			_flying_state()
		ShipState.BUILDING:
			pass
		ShipState.DEAD:
			pass


func _flying_state() -> void:
	var rotation_dir: float = 0
	var input_rotation: float = Input.get_axis(&"rotate_left",&"rotate_right")
	var input_direction: Vector2 = Input.get_vector(
			&"thrust_left",&"thrust_right",&"thrust_foward",&"thrust_backward")
	rotation_dir += input_rotation
	apply_torque(rotation_dir * torque)
	if input_direction:
		apply_force(input_direction.rotated(rotation) * thrust)


func set_state_to_building() -> void:
	current_state = ShipState.BUILDING
	click_area.input_pickable = true
	set_state_to_idle()


func set_state_to_flying() -> void:
	current_state = ShipState.FLYING
	click_area.input_pickable = false
	set_state_to_dead()
