extends Control

func _ready():
	$SubViewportContainer/SubViewport/AnimationPlayer.play("camera")

func _process(delta):
	pass
