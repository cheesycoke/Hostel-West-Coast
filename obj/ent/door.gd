extends Node3D
signal opened
@onready var the_door = $TheDoor

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func punched():
	GameLogic.shatterWood(global_position)
	$AudioStreamPlayer.play(0.11)
	emit_signal("opened")
	the_door.queue_free()
	
