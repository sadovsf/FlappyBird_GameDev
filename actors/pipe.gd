extends StaticBody2D


## Rychlost jakou se trubka pohybuje v px/s
@export var speed :int = -20

func _physics_process(delta):
	position += Vector2.RIGHT * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	self.queue_free()
