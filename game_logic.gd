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

var enemiesRemaining:int = 0
var levelClear:bool = false
var curfloor:int = 1

func _ready():
	pass

func restartEverything():
	levelClear = false
	if stashedPlayer != null:
		stashedPlayer.queue_free()
	for i in get_children():
		if i is Player:
			i.queue_free()
	changeLevel(true)
	

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
	enemiesRemaining = get_tree().get_nodes_in_group("enemy").size()
	if get_tree().get_nodes_in_group("enemy").size() <= 1:
		levelClear = true
	else:
		levelClear = false

func addRoom(pos,rot):
	var newroom = BASEROOM.instantiate()
	get_tree().current_scene.add_child(newroom)
	newroom.global_position = pos
	newroom.rotation_degrees.y = rot

func changeLevel(reset:bool=false):
	if curfloor == 8:
		transition("res://scn/menus/endscreen.tscn")
		return
	$HUDs/transitioner.play("fade")
	levelClear = false
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

func transition(scenepath):
	get_tree().change_scene_to_file(scenepath)
	$HUDs/transitioner.stop()
	$HUDs/transitioner.play("fade")
	
var initializing:bool = false
const GAME_SCENE_1 = preload("res://scn/game_scene1.tscn")
func startGame():
	initializing = true
	get_tree().change_scene_to_packed(GAME_SCENE_1)
	$HUDs/transitioner.stop()
	$HUDs/transitioner.play("fade")

const SHATTER = preload("res://obj/fx/shatter.tscn")
func shatterWood(pos):
	var woodshards = SHATTER.instantiate()
	get_tree().current_scene.add_child(woodshards)
	woodshards.global_position=pos
	woodshards.restart()
const BLOOD_SPRAY = preload("res://obj/fx/blood_spray.tscn")
func bleed(pos):
	$SFX/Splort.global_position=pos
	$SFX/Splort.play(0.0)
	var blood = BLOOD_SPRAY.instantiate()
	get_tree().current_scene.add_child(blood)
	blood.global_position=pos
	blood.restart()
