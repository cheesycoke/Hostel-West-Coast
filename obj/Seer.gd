extends AnimatedSprite2D
@onready var animtimer = $animtimer

func _ready():
	play("default")

func allsmiles():
	play("hehe")
	animtimer.start(0.6)

func thumbsup():
	play("thumbsup")
	animtimer.start(0.6)

func _on_animtimer_timeout():
	play("default")
