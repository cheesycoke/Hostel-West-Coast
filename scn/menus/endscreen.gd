extends Control

func _ready():
	$Button.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func _on_button_pressed():
	GameLogic.transition("res://scn/menus/intro.tscn")
