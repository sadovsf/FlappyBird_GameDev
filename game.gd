extends Node2D

## Předpřipravená scéna trubky pro její spawnování
@onready var _pipe_scene := preload("res://actors/pipe.tscn")
@onready var _screen_size :Vector2 = get_viewport().size
@onready var _initial_bird_pos :Vector2 = $Bird.position

## Rychlost pohybu hry v px/s
@export var game_speed :int = 100:
	set(new_val):
		game_speed = new_val
		if is_inside_tree():
			$Background.speed = -new_val
			for child in $Pipes.get_children():
				child.speed = -new_val


## Jak velká je velikost mezery mezi vygenerovanými
## trubkami v px
var _pipe_hole_size = 200


func _ready():
	$Background.speed = -game_speed


func start_game():
	for pipe in $Pipes.get_children():
		pipe.queue_free()
	
	self._reset_difficulty()
	%GUI.on_game_started()
	$Bird.visible = true
	
	await get_tree().create_timer(1).timeout
	$Bird.process_mode = Node.PROCESS_MODE_INHERIT
	$ScoreTimer.start()
	$GameDiffTimer.start()
	


## Přidá do scény trubku
## s pohybem o ryhlosti [param speed] v px/s
## Y offset středu průletu od středu obrazovky [param hole_y_offset] 
## a velikostí průletu [param hole_height] v px
func spawn_pipe(speed :int, hole_y_offset :int, hole_height :int):
	
	# Instancovat nové trubky (vrchní a spodní)
	var new_pipe_node_bottom = _pipe_scene.instantiate()
	var new_pipe_node_top = _pipe_scene.instantiate()
	new_pipe_node_bottom.speed = speed
	new_pipe_node_top.speed = speed
	
	# Předcachování více krát použité proměnné.
	@warning_ignore("integer_division")
	var half_hole_height = hole_height / 2
	var half_screen_height = _screen_size.y / 2
	
	# Otočení vrchní trubky a její pozice
	new_pipe_node_top.rotation_degrees = 180
	new_pipe_node_top.position.x = _screen_size.x + 30
	new_pipe_node_top.position.y = half_screen_height + hole_y_offset - half_hole_height
	
	# Pozicování spodní trubky
	new_pipe_node_bottom.position.x = _screen_size.x + 30
	new_pipe_node_bottom.position.y = half_screen_height + hole_y_offset + half_hole_height
	
	# Přidání obou trubek do scény
	$Pipes.add_child(new_pipe_node_top)
	$Pipes.add_child(new_pipe_node_bottom)



func _on_pipe_build_timer_timeout():
	var offset = randi_range(-150, 150)
	spawn_pipe(-game_speed, offset, _pipe_hole_size)


func _reset_difficulty():
	_pipe_hole_size = 200
	game_speed = 100


func _on_game_diff_timer_timeout():
	print("Difficulty increased")
	_pipe_hole_size = max(_pipe_hole_size - 10, 50)
	game_speed += 20


func _on_gui_start_game():
	self.start_game()


func _on_score_timer_timeout():
	%GUI.score += 1


func _on_bird_hit():
	%GUI.on_game_over()
	$ScoreTimer.stop()
	$Bird.process_mode = Node.PROCESS_MODE_DISABLED
	$AudioDeath.play(0.25)
	$AudioBackground.stop()


func _on_gui_restart_game():
	$Bird.teleport(self._initial_bird_pos)
	self.start_game()
	$AudioBackground.play()
	
