extends Control

func _ready():
	GameLogic.music.playmenumusic()
	$SubViewportContainer/SubViewport/AnimationPlayer.play("camera")

func _process(delta):
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	GameLogic.startGame()

func _on_options_pressed():
	GameLogic.transition("res://scn/menus/settings.tscn")

func _on_info_pressed():
	GameLogic.transition("res://scn/menus/how_to_play.tscn")
