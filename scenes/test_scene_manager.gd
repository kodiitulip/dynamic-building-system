extends Node2D


var components: Array[Component] = []
var main_component: MainComponent


func _ready() -> void:
	components.append_array(get_all_components($Components))
	main_component = components.filter(
		func(component: Component) -> bool:
			return component is MainComponent
	)[0]


func get_all_components(node: Node) -> Array[Component]:
	var _components: Array[Component] = []
	for child: Node in node.get_children():
		if child is Component:
			_components.append(child)
			continue
		_components.append_array(get_all_components(child))
	return _components


func _on_build_pressed() -> void:
	main_component.current_state = MainComponent.ShipState.BUILDING


func _on_fly_pressed() -> void:
	main_component.current_state = MainComponent.ShipState.FLYING
