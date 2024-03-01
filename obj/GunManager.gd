extends Node3D

@export var weaponInv: Array[Weapon]
const invsize:int = 2
var cur:int = 0
@onready var camshaker = $"../CamShaker"
@onready var player = $".."
const GUNRAY = preload("res://obj/gunray.tscn")

@onready var firesound = $FireSound
@onready var meshpos = $MeshPos
@onready var timer = $Timer

func _ready():
	setWeapon(cur)

func _process(delta):
	if weaponInv[cur].Auto == true:
		if Input.is_action_pressed("fire"):
			fire()
	else:
		if Input.is_action_just_pressed("fire"):
			fire()

func setWeapon(wpn):
	timer.start(0)
	for i in meshpos.get_children():
		i.queue_free()
	var newmesh = weaponInv[cur].Model.instantiate()
	meshpos.add_child(newmesh)
	
	pass

func fire():
	if timer.time_left <= 0:
		doRays(weaponInv[cur].BulletsFired)
		camshaker.startShakin(0.3)
		timer.start(weaponInv[cur].ReloadTime)


func doRays(num):
	randomize()
	if num > 1:
		var fanwidth = weaponInv[cur].FanWidth
		var fanspacing = fanwidth/(num-1)
		for i in num:
			var newray = GUNRAY.instantiate()
			newray.rotation_degrees.y = 180
			newray.rotation_degrees.y += ((-fanwidth/2)+((i)*fanspacing))
			newray.rotation_degrees.y += randf_range(-weaponInv[cur].RandomSpread,weaponInv[cur].RandomSpread)
			add_child(newray)
	else:
		var newray = GUNRAY.instantiate()
		newray.rotation_degrees.y = 180
		newray.rotation_degrees.y += randf_range(-weaponInv[cur].RandomSpread,weaponInv[cur].RandomSpread)
		add_child(newray)
