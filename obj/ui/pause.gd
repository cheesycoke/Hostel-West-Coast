extends CanvasLayer
func _ready():
	unpause()
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if visible == false:
			pause()
		else:
			unpause()

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	visible = true

func unpause():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	visible = false

func _on_resume_pressed():
	unpause()

func _on_quit_pressed():
	unpause()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameLogic.transition("res://scn/menus/main_menu.tscn")
