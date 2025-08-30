class_name PriorityMap
extends RefCounted

signal highest_priority_updated(highest: int)
signal updated(highest: int)
signal cleared

## ---
## PRIORITY MAP
## Wrapper for an int-to-Variant dictionary where the ints are priorities.
## Useful for implementing priority-based overrides.
## NOTE: This class is designed for PROTOTYPING PURPOSES. In a performance critical situation, it may be better to inline this code?
## ---
## Last edited August 29th, 2025
## ---

var _map: Dictionary[int, Variant] = {}
var _current_highest: int = -INF

## Sets the value for a particular priority.
## Returns true if the value is changed or assigned, false if no change.
func set_value_with_priority(value: Variant, priority: int = 1) -> bool:
	# 1. Detect if it is different from what is already there
	var is_different := true
	if _map.get(priority, null) == value:
		is_different = false
	
	# 2. Assign
	_map.set(priority, value)
	## Recomputation only occurs if we ADDED AT OR HIGHER THAN HIGHEST, and it was DIFFERENT
	if priority >= _current_highest and is_different:
		_compute_new_highest()
		highest_priority_updated.emit(_current_highest)
	
	# 3. If it is different, we update...
	if is_different:
		updated.emit(_current_highest)
	return is_different

## Remove a priority key from the map, regardless of value.
## NOTE: Use this if you are pretty sure that no one else has changed the value on this priority in the meantime.
## Returns true if removed, false if no change.
func remove_priority(priority: int = 1) -> bool:
	# 1. Remove the key
	var res := _map.erase(priority)
	
	## Recomputation only occurs if we REMOVED THE HIGHEST
	if _current_highest == priority: 
		_compute_new_highest()
		highest_priority_updated.emit(_current_highest)
	
	# 2. Removal is pretty important, we update...
	updated.emit(_current_highest)
	return res

## Remove a priority key with the matching value.
## NOTE: Use this if you think the value might have changed and you need to match it.
## Returns true if removed, false if no change.
func remove_value_with_priority(value: Variant, priority: int = 1) -> bool:
	if _map.has(priority) and _map.get(priority) == value:
		_map.erase(priority)
		
		## Recomputation only occurs if we REMOVED THE HIGHEST
		if _current_highest == priority: 
			_compute_new_highest()
			highest_priority_updated.emit(_current_highest)
		
		# Only update on success
		updated.emit(_current_highest)
		return true
	return false

## Clear all content.
## Emits signals.
func reset() -> void:
	_map.clear()
	
	_compute_new_highest()
	
	highest_priority_updated.emit(_current_highest)
	updated.emit(_current_highest)
	cleared.emit()

## Gets the highest priority value.
## If the highest priority is invalid or there are none, returns default (typically null).
func get_highest_priority_value(default: Variant = null) -> Variant:
	if _current_highest == -INF:
		return default
	var val: Variant = _map.get(_current_highest, default)
	return val

func is_empty() -> bool:
	return _map.is_empty()

func _compute_new_highest() -> void:
	_current_highest = -INF
	if _map.is_empty():
		return
	for i: int in _map.keys():
		_current_highest = max(_current_highest, i)
