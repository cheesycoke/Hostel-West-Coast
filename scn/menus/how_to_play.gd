extends Control
func _ready():
	$LicenseInfo.visible = false
func _on_button_pressed():
	GameLogic.transition("res://scn/menus/main_menu.tscn")
func _on_info_pressed():
	$LicenseInfo.visible = true
