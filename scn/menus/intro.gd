extends Control

func _ready():
	GameLogic.music.playmenumusic()
	$AnimationPlayer.play("intro")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scn/menus/main_menu.tscn")

func introEnd():
	get_tree().change_scene_to_file("res://scn/menus/main_menu.tscn")
