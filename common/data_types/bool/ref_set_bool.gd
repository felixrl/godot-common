class_name RefSetBool
extends RefCounted

signal true_assigned
signal false_assigned

## ---
## REF SET BOOL
## A boolean that uses an internal set to track true/false
## Allows similar behaviour to the RefCountBool, but technically permits repeated calling (like in _process)
## because "keep" and "free" only correspond to "set IDs." 
## NOTE: This class is designed for PROTOTYPING PURPOSES. In a performance critical situation, it may be better to inline this code?
## ---
## Last edited August 29th, 2025
## ---

var _set: Array[Variant] = []
var _bool: bool = false

## Returns the current bool value.
func read() -> bool:
	return _bool

## Add a key.
## If the set was empty, sets the bool to true and emits a signal.
## Returns true if not duplicate, false otherwise.
func add(key: Variant = "_default") -> bool:
	if _set.is_empty():
		_bool = true
		true_assigned.emit()
	if _set.has(key):
		return false
	_set.append(key)
	return true

## Remove a key.
## If the set becomes empty, sets the bool to false and emits a signal.
## Returns true if the key was present, false otherwise.
func remove(key: Variant = "_default") -> bool:
	if not _set.has(key):
		return false
	
	_set.erase(key)
	if _set.is_empty():
		_bool = false
		false_assigned.emit()
	return true

## Resets the set to be empty, effectively forcing this bool to be false.
## Returns true if the set was not empty, false otherwise
func reset() -> bool:
	var res := false
	if not _set.is_empty():
		res = true
	_bool = false
	false_assigned.emit()
	_set.clear()
	return res
