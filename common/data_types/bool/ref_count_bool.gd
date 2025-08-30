class_name RefCountBool
extends RefCounted

signal true_assigned
signal false_assigned

## ---
## REF COUNT BOOL
## A boolean that uses an internal reference counter to track true/false.
## This allows multiple different users with different lifetimes to switch the bool without worrying about overwrite of others.
## NOTE: This class is designed for PROTOTYPING PURPOSES. In a performance critical situation, it may be better to inline this code?
## ---
## Last edited August 29th, 2025
## ---

var allow_negative: bool = false

var _count: int = 0
var _bool: bool = false

## CONSTRUCTOR
## NOTE: RefCountBool always defaults to zero/false.
func _init(_allow_negative: bool = false) -> void:
	allow_negative = _allow_negative

## Returns the current bool value.
func read() -> bool:
	return _bool

## Keep some number.
## If the number was originally at 0 and rises above 0, sets the bool to true and emits signal.
## Returns true if this inc caused a switch to true, false otherwise.
func inc(n: int = 1) -> bool:
	var res := false
	if _count <= 0 and (_count + n) > 0:
		_bool = true
		true_assigned.emit()
		res = true
	_count += n
	return res

## Free some number from the count.
## If the number hits 0, sets the bool to false and emits signal.
## Does not go below 0 unless allow_negative is true.
## Returns true if this dec caused a switch to false, false otherwise.
func dec(n: int = 1) -> bool:
	var res := false
	if _count > 0 and (_count - n) <= 0:
		_bool = false
		false_assigned.emit()
		res = true
	_count -= n
	if not allow_negative:
		_count = max(_count, 0)
	return res

## Resets the counter to 0, effectively forcing this bool to be false.
## Returns true if the counter was non-zero, false otherwise
func reset() -> bool:
	var res := false
	if _count > 0:
		res = true
	_bool = false
	false_assigned.emit()
	_count = 0
	return res
