extends Node2D


@onready var _initial_pos = $Bird.position


func _on_visible_on_screen_enabler_2d_screen_exited():
	$Bird.teleport(_initial_pos)
