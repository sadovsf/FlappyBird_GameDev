extends Node2D

## Rychlost pohybu pozadí v px/s
@export var speed :int = -20:
	set(new_val):
		speed = new_val
		if is_inside_tree():
			# Editor nastaví hodnotu ještě než je node ve scéně!
			# $Top a $Base by pak byl null a hra by crashnula.
			_apply_speed()


func _ready():
	# Aplikuje speed nastavenou v editoru.
	_apply_speed()
	self._apply_speed()


## Aplikuje aktuální [param speed]
func _apply_speed():
	@warning_ignore("integer_division")
	$Top.autoscroll.x = speed / 2
	$Base.autoscroll.x = speed
