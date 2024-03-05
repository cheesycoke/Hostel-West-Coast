extends Node3D

@export var weaponInv: Array[Weapon]
@export var Ammos: Array[AmmoRes]
const invsize:int = 2
var cur:int = 0
@onready var camshaker = $"../CamShaker"
@onready var player = $".."
const GUNRAY = preload("res://obj/gunray.tscn")
const WEAPON_PICKUP = preload("res://obj/ent/weapon_pickup.tscn")

@onready var firesound = $FireSound
@onready var meshpos = $MeshPos
@onready var timer = $Timer

var AmmoInUse:int = 0

func _ready():
	for i in Ammos:
		i.CurAmmo = int(i.MaxAmmo/2)
	setWeapon(cur)

func _process(delta):
	if weaponInv[cur].Auto == true:
		if Input.is_action_pressed("fire"):
			fire()
	else:
		if Input.is_action_just_pressed("fire"):
			fire()
	if Input.is_action_just_pressed("nextweapon"):
		cur += 1
		cur = wrap(cur,0,weaponInv.size())
		setWeapon(cur)

func setWeapon(_wpn=1):
	timer.start(0.0001)
	AmmoInUse = Ammos.find(weaponInv[cur].AmmoType)
	for i in meshpos.get_children():
		i.queue_free()
	var newmesh = weaponInv[cur].Model.instantiate()
	meshpos.add_child(newmesh)
	
	pass

func fire():
	if timer.time_left <= 0 and Ammos[AmmoInUse].CurAmmo >= weaponInv[cur].AmmoUse:
		doRays(weaponInv[cur].BulletsFired)
		Ammos[AmmoInUse].CurAmmo -= weaponInv[cur].AmmoUse
		camshaker.startShakin(0.3)
		timer.start(weaponInv[cur].ReloadTime)
	clampAmmos()

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

func getWeapon(wpn:Weapon):
	if weaponInv.size() < 2:
		weaponInv.append(wpn)
		cur = weaponInv.size()-1
	else:
		var dropping = weaponInv[cur]
		weaponInv[cur] = wpn
		dropWeapon(dropping)
	setWeapon()
	clampAmmos()

func dropWeapon(wpn:Weapon):
	var rootscene = player.get_parent()
	var gundrop = WEAPON_PICKUP.instantiate()
	gundrop.weapon = wpn
	rootscene.add_child(gundrop)
	gundrop.global_position = player.global_position

func getWeaponName():
	return weaponInv[cur].Name

func getAmmo(isLarge):
	var ObtainedAmmoType:AmmoRes
	if randi_range(0,1) == 0:
		ObtainedAmmoType = Ammos[AmmoInUse]
	else:
		ObtainedAmmoType = Ammos.pick_random()
	if isLarge:
		ObtainedAmmoType.CurAmmo += int(ObtainedAmmoType.MaxAmmo/2)
	else:
		ObtainedAmmoType.CurAmmo += int(ObtainedAmmoType.MaxAmmo/4)
	clampAmmos()

func clampAmmos():
	for i in Ammos:
		i.CurAmmo = clamp(i.CurAmmo,0,i.MaxAmmo)
