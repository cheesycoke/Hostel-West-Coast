extends StaticBody3D
func use():
	if GameLogic.levelClear == true:
		GameLogic.changeLevel(false)
		print(GameLogic.curfloor)
