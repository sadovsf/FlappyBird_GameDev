extends Control

signal score_changed(new_score :int)
signal start_game
signal restart_game

@onready var _score_label := $Score as Label


var score :int = 0:
	set(val):
		score = val
		if self._score_label:
			self._score_label.text = str(val)
		self.score_changed.emit(val)
		
var is_ingame :bool = false:
	set(val):
		is_ingame = val
		$GameName.visible = not val
		$MenuPanel.visible = not val
		
		$Score.visible = val
		$GameOver.visible = false


func on_game_started():
	self.score = 0
	self.is_ingame = true
	

func on_game_over():
	$GameOver.visible = true


func _on_start_button_pressed():
	self.start_game.emit()


func _on_restart_pressed():
	self.restart_game.emit()


func _on_exit_button_pressed():
	get_tree().quit()
