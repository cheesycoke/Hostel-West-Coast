extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
func _process(delta):
	pass

func showGameOver():
	visible = true
	$AnimationPlayer.play("die")
	$sfx/ekg.play()
	$sfx/splort.play(0.02)
