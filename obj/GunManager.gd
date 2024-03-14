extends Node3D

@export var weaponInv: Array[Weapon]
const startergun = preload("res://obj/weapons/pistol.tres")
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
@onready var flash = $flash

var AmmoInUse:int = 0

func _ready():
	weaponInv.clear()
	weaponInv.append(startergun)
	for i in Ammos:
		i.CurAmmo = int(i.MaxAmmo/2)
	setWeapon(cur)

func _process(delta):
	updateAmmoCounts()
	if $flash.light_energy > 0:
		$flash.light_energy -= delta*10
		$flash.light_energy = clamp($flash.light_energy,0,1)
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
	player.hud.curammo = Ammos[AmmoInUse].CurAmmo

func setWeapon(_wpn=1):
	timer.start(0.0001)
	AmmoInUse = Ammos.find(weaponInv[cur].AmmoType)
	for i in meshpos.get_children():
		i.queue_free()
	var newmesh = weaponInv[cur].Model.instantiate()
	firesound.stream = weaponInv[cur].FireSound
	meshpos.add_child(newmesh)
	
	pass

func fire():
	if timer.time_left <= 0 and Ammos[AmmoInUse].CurAmmo >= weaponInv[cur].AmmoUse and player.dead==false:
		if meshpos.get_child(0).has_method("fire"):
			meshpos.get_child(0).fire()
		gunflash()
		firesound.pitch_scale = randf_range(0.7,1.3)
		firesound.play()
		if !weaponInv[cur].AmmoObj:
			doRays(weaponInv[cur].BulletsFired)
		else:
			shootspecial(weaponInv[cur].AmmoObj)
		Ammos[AmmoInUse].CurAmmo -= weaponInv[cur].AmmoUse
		camshaker.startShakin(0.3,weaponInv[cur].BulletsFired)
		timer.start(weaponInv[cur].ReloadTime)
	clampAmmos()

func shootspecial(obj):
	var shot = obj.instantiate()
	get_tree().get_current_scene().add_child(shot)
	shot.global_position = global_position
	if shot.has_method("apply_impulse"):
		shot.apply_impulse(Vector3(30,5,0).rotated(Vector3.UP,global_rotation.y))

func doRays(num):
	
	randomize()
	if num > 1:
		var fanwidth = weaponInv[cur].FanWidth
		var fanspacing = fanwidth/(num-1)
		for i in num:
			var newray = GUNRAY.instantiate()
			newray.dmg = weaponInv[cur].Damage
			newray.rotation_degrees.y = 180
			newray.rotation_degrees.y += ((-fanwidth/2)+((i)*fanspacing))
			newray.rotation_degrees.y += randf_range(-weaponInv[cur].RandomSpread,weaponInv[cur].RandomSpread)
			add_child(newray)
	else:
		var newray = GUNRAY.instantiate()
		newray.dmg = weaponInv[cur].Damage
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
	player.hud.animateSeer("smile")
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
	player.hud.animateAmmo(ObtainedAmmoType.AmmoName)
	player.hud.animateSeer("thumb")

func clampAmmos():
	for i in Ammos:
		i.CurAmmo = clamp(i.CurAmmo,0,i.MaxAmmo)

func gunflash():
	$flash.light_energy = 1

func updateAmmoCounts():
	player.hud.bullets = Ammos[0].CurAmmo
	player.hud.shells = Ammos[1].CurAmmo
	#not expandable at all. lol
