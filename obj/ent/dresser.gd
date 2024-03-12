extends StaticBody3D
var broken:bool=false

func hurt(dmg,pos):
	if broken == false:
		getbroken()

func getbroken():
	broken = true
	$AudioStreamPlayer.play(0.1)
	$MeshInstance3D.visible = false
	var roll = randi_range(0,10)
	if roll < 5:
		GameLogic.dropAmmo(global_position)
	elif roll < 8:
		GameLogic.dropHealth(global_position)
	else:
		GameLogic.dropWeapon(global_position)
	
