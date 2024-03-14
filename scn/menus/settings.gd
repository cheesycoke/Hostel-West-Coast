extends Control

func _on_back_pressed():
	GameLogic.transition("res://scn/menus/main_menu.tscn")

func _ready():
	$MasterVol.value = Settings.masVol
	$MusicVol.value = Settings.musVol
	$SFXVol.value = Settings.sfxVol
	$sfxtest.stop()

func _on_master_vol_value_changed(value):
	Settings.masVol = value

func _on_music_vol_value_changed(value):
	Settings.musVol = value

func _on_sfx_vol_value_changed(value):
	Settings.sfxVol = value
	$sfxtest.play(0.0)

func _on_resolution_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
			centerwindow()
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1366,768))
			centerwindow()
		3:
			DisplayServer.window_set_size(Vector2i(1280,720))

func centerwindow():
	var screen = DisplayServer.screen_get_size(0)
	get_window().position=(screen/2)-get_window().size/2
#it don't always work! what happened to center window!!!!
