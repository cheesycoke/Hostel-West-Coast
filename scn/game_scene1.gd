extends Node3D
@onready var generator = $Generator

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("r"):
		GameLogic.changeLevel(false)
