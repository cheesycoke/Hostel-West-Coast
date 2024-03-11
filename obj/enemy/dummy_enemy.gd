extends CharacterBody3D

class_name Enemy

@export var maxhp:int = 10
@export var enemyname:String = "ENEMYNAME"
@onready var HEALTH_COMPONENT = preload("res://obj/sys/health_component.tscn")
@onready var TRACKER_COMPONENT = preload("res://obj/enemy/playerwatcher.tscn")
@onready var BLOODSPRAY = preload("res://obj/fx/blood_spray.tscn")
@onready var GIBS = preload("res://obj/fx/gibs.tscn")
var spawnerpos:Vector3
var hpComponent:Health
var tracker:Tracker

func _ready():
	add_to_group("enemy")
	await get_tree().process_frame
	initHealth()
	initTracker()

func _physics_process(delta):
	move_and_slide()

func initHealth():
	hpComponent = HEALTH_COMPONENT.instantiate()
	hpComponent.maxhp = maxhp
	hpComponent.hp = maxhp
	hpComponent.died.connect(die)
	add_child(hpComponent)

func initTracker():
	tracker = TRACKER_COMPONENT.instantiate()
	add_child(tracker)
	#tracker.pursue.connect(pursue)

func hurt(dmg:int,pushawaypos:Vector3):
	bleed()
	hpComponent.changeHP(-dmg)

func die():
	drop()
	gib()
	GameLogic.checkAllClear(global_position)
	call_deferred("queue_free")

func drop():
	var roll = randi_range(0,10)
	if roll < 6:
		pass
	elif roll < 9:
		GameLogic.dropAmmo(global_position)
	else:
		GameLogic.dropWeapon(global_position)

func pursue():
	pass

func bleed():
	var blood = BLOODSPRAY.instantiate()
	get_parent().add_child(blood)
	if has_node("Midpoint"):
		blood.global_position = get_node("Midpoint").global_position
	else:
		blood.global_position = global_position

func gib():
	var blood = GIBS.instantiate()
	get_parent().add_child(blood)
	if has_node("Midpoint"):
		blood.global_position = get_node("Midpoint").global_position
	else:
		blood.global_position = global_position
