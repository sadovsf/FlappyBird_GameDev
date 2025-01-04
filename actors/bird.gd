extends RigidBody2D

## Velocity assigned when player flaps (in px/s)
@export var fly_velocity :float = 300


var _teleport_pos = null


func teleport(pos :Vector2):
	_teleport_pos = pos


func _integrate_forces(state):
	if _teleport_pos != null:
		linear_velocity = Vector2.ZERO
		state.transform.origin = _teleport_pos
		_teleport_pos = null
		return
	
	if Input.is_action_just_pressed("fly"):
		self.linear_velocity = Vector2.UP * fly_velocity


func _on_body_entered(body :Node2D):
	print(body.name + " hit!")
