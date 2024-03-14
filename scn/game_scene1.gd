extends Node3D
@onready var generator = $Generator
func _ready():
	GameLogic.music.playgamemusic()
	

func gameLoaded():
	pass

#func _process(delta):
	#if Input.is_action_just_pressed("r"):
		#GameLogic.changeLevel(false)
