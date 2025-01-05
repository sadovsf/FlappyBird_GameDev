extends StaticBody2D


## Rychlost jakou se trubka pohybuje v px/s
@export var speed :int = -20

func _physics_process(delta):
	position += Vector2.RIGHT * speed * delta
