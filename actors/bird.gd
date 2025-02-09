extends RigidBody2D

signal hit

## Velocity assigned when player flaps (in px/s)
@export var fly_velocity :float = 300

@onready var _anim = $AnimatedSprite2D
@onready var _flap_audio = $FlapAudio


var _teleport_pos = null


func teleport(pos :Vector2):
	self.position = pos
	_teleport_pos = pos


func _integrate_forces(state):
	if _teleport_pos != null:
		linear_velocity = Vector2.ZERO
		state.transform.origin = _teleport_pos
		_teleport_pos = null
		return
	
	if Input.is_action_just_pressed("fly"):
		self.linear_velocity = Vector2.UP * fly_velocity
		self._anim.play("flap")
		self._flap_audio.play()


func _on_body_entered(_body :Node2D):
	self.hit.emit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	self.hit.emit()


func _on_sprite_animation_finished():
	self._anim.play("default")
