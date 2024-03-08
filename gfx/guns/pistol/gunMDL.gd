extends Node3D

@onready var anim:AnimationPlayer = $AnimationPlayer

func _ready():
	pass

func fire():
	anim.play("fire")
	await anim.animation_finished
	cock()

func cock():
	if anim.has_animation("cock"):
		anim.play("cock")
