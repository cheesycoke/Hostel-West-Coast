extends Node3D
@onready var anim = $AnimationPlayer
var slashing:bool=false
func run():
	if slashing==false:
		anim.play("run")
func idle():
	if slashing==false:
		anim.play("idle")

func slash():
	slashing=true
	anim.play("slash")
	await anim.animation_finished
	slashing = false
