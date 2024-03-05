extends CharacterBody3D

class_name Enemy

@export var maxhp:int = 10
const HEALTH_COMPONENT = preload("res://obj/sys/health_component.tscn")
var hpComponent:Health

func _ready():
	initHealth()

func _physics_process(delta):
	move_and_slide()

func initHealth():
	hpComponent = HEALTH_COMPONENT.instantiate()
	hpComponent.maxhp = maxhp
	hpComponent.hp = maxhp
	add_child(hpComponent)

func hurt(dmg:int = 2):
	hpComponent.changeHP(-2)
