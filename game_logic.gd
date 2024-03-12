extends Node

const BHOLE = preload("res://obj/fx/bhole.tscn")
const maxholes = 20
@onready var music = $Music

#DROPS
const AMMO_PICKUP = preload("res://obj/ent/ammo_pickup.tscn")
const WEAPON_PICKUP = preload("res://obj/ent/weapon_pickup.tscn")
const HP_PICKUP = preload("res://obj/ent/hp_pickup.tscn")

#ROOMGEN
const BASEROOM = preload("res://obj/rooms/baseroom2.tscn")

var stashedPlayer:Player = null
var spawnSpot:PlayerSpawner = null

var curfloor = 1

func _ready():
	pass

func restartEverything():
	if stashedPlayer != null:
		stashedPlayer.queue_free()
	for i in get_children():
		if i is Player:
			i.queue_free()
	call_deferred("changeLevel",true)

#func _process(delta):
	#if Input.is_action_just_pressed("r"):
		#get_tree().reload_current_scene()

func bullethole(pos,rot):
	var newhole = BHOLE.instantiate()
	get_tree().current_scene.add_child(newhole)
	newhole.global_position = pos
	newhole.look_at(pos+rot,Vector3.UP)
	newhole.rotation_degrees.x = 90
	if get_tree().get_nodes_in_group("bhole").size() > maxholes:
		for i in get_tree().get_nodes_in_group("bhole").size() - maxholes:
			get_tree().get_nodes_in_group("bhole")[i].queue_free()

func dropWeapon(pos):
	var gundrop = WEAPON_PICKUP.instantiate()
	gundrop.random = true
	get_tree().current_scene.add_child(gundrop)
	gundrop.global_position = pos
func dropAmmo(pos):
	var drop = AMMO_PICKUP.instantiate()
	get_tree().current_scene.add_child(drop)
	drop.global_position = pos
func dropHealth(pos):
	var drop = HP_PICKUP.instantiate()
	get_tree().current_scene.add_child(drop)
	drop.global_position = pos

func checkAllClear(pos):
	if get_tree().get_nodes_in_group("enemy").size() <= 1:
		print("they're all dead!")
		print(pos)

func addRoom(pos,rot):
	var newroom = BASEROOM.instantiate()
	get_tree().current_scene.add_child(newroom)
	newroom.global_position = pos
	newroom.rotation_degrees.y = rot

func changeLevel(reset:bool=false):
	if reset == true:
		curfloor = 1
		for i in get_children():
			if i is Player:
				i.queue_free()
	else:
		curfloor += 1
		stashedPlayer = spawnSpot.get_child(0)
		stashedPlayer.reparent(self)
	get_tree().reload_current_scene()
	#remove_child(stashedPlayer)
	#spawnSpot.add_child(stashedPlayer)

func grabChild()->Player:
	for i in get_children():
		if i is Player:
			return i
	return null
