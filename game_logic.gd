extends Node

const BHOLE = preload("res://obj/fx/bhole.tscn")
const maxholes = 20

#DROPS
const AMMO_PICKUP = preload("res://obj/ent/ammo_pickup.tscn")
const WEAPON_PICKUP = preload("res://obj/ent/weapon_pickup.tscn")

#ROOMGEN
const BASEROOM = preload("res://obj/rooms/baseroom2.tscn")

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

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

func checkAllClear(pos):
	if get_tree().get_nodes_in_group("enemy").size() <= 1:
		print("they're all dead!")
		print(pos)

func addRoom(pos,rot):
	var newroom = BASEROOM.instantiate()
	get_tree().current_scene.add_child(newroom)
	newroom.global_position = pos
	newroom.rotation_degrees.y = rot
