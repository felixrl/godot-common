class_name Components

## ---
## COMPONENTS
## A collection of static methods for "general component" access/checking
## ---
## Last updated: July 30th, 2025
## ---
## TODO
## - Make sure to also include the parent, check if it is/include in lists
## ---

## Boolean check, has component?
static func has_component(node: Node, component_type: Variant, string_name: String = "", call_recursive: bool = false) -> bool:
	if not node:
		return false
	
	return get_component(node, component_type, string_name, call_recursive) != null

## Get the first component of a type
static func get_component(node: Node, component_type: Variant, string_name: String = "", call_recursive: bool = false) -> Variant:
	if not node:
		return null
	
	var children = node.get_children(true)
	for child in children:
		if is_instance_of(child, component_type):
			if string_name == "" or string_name == child.name:
				return child
		
		if call_recursive:
			var result = get_component(child, component_type, string_name, call_recursive)
			if result:
				return result
	
	return null

## Get a list of all components of a type
static func get_all_components(node: Node, component_type: Variant, call_recursive: bool = false) -> Array[Variant]:
	if not node:
		return []
	
	var components: Array[Node] = []
	
	var children: Array[Node] = node.get_children(true)
	for child: Node in children:
		if is_instance_of(child, component_type):
			components.append(child)
		
		if call_recursive:
			components.append_array(get_all_components(child, component_type, call_recursive))
	
	return components
