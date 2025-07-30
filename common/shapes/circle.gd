@tool
class_name Circle
extends Node2D

## ---
## CIRCLE
## A circle, for testing purposes
## ---

@export var radius := 32.0
@export var color := Color.WHITE
@export var is_filled := true
@export var border_width := 3.0
@export var is_antialiased := false

func _draw() -> void:
	if is_filled:
		draw_circle(Vector2.ZERO, radius, color, is_filled)
	else:
		draw_circle(Vector2.ZERO, radius, color, is_filled, border_width, is_antialiased)

func redraw() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): # Only redraws every frame when in editor! Otherwise, request redraw()
		queue_redraw()
