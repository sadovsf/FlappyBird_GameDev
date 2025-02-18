extends Node2D

## Rychlost pohybu pozadí v px/s
@export var speed :int = -20:
	set(new_val):
		speed = new_val
		if is_inside_tree():
			# Editor nastaví hodnotu ještě než je node ve scéně!
			# $Top a $Base by pak byl null a hra by crashnula.
			_apply_speed()

var _is_day = true


func _ready():
	# Aplikuje speed nastavenou v editoru.
	_apply_speed()
	self._apply_speed()


## Aplikuje aktuální [param speed]
func _apply_speed():
	@warning_ignore("integer_division")
	$Top.autoscroll.x = speed / 2
	$Base.autoscroll.x = speed


func _on_area_2d_body_entered(body):
	if body.has_method("kill"):
		body.kill()


func set_day(is_day :bool):
	self._is_day = is_day
	var tween = create_tween().set_parallel()
	if is_day:
		tween.tween_property($Top/City, "modulate:a", 1, 2)
		tween.tween_property($Top/CityNight, "modulate:a", 0, 2)
		
		tween.tween_property($Top/Clouds, "modulate:a", 1, 2)
		tween.tween_property($Top/CloudsNight, "modulate:a", 0, 2)
	else:
		tween.tween_property($Top/City, "modulate:a", 0, 2)
		tween.tween_property($Top/CityNight, "modulate:a", 1, 2)
		
		tween.tween_property($Top/Clouds, "modulate:a", 0, 2)
		tween.tween_property($Top/CloudsNight, "modulate:a", 1, 2)
	
	tween.play()


func _on_day_night_cycle_timeout():
	self.set_day(! self._is_day)
