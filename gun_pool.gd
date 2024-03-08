extends Node
#wanna see the funniest weighted RNG in the world?

const COMMON:GunList = preload("res://obj/sys/gunpools/common.tres")
const RARE:GunList = preload("res://obj/sys/gunpools/rare.tres")
const EPIC:GunList = preload("res://obj/sys/gunpools/epic.tres")

func getRandomWeapon() -> Weapon:
	var roll = randi_range(1,100)
	if roll < 60:
		return COMMON.list.pick_random()
	elif roll < 90:
		return RARE.list.pick_random()
	else:
		return EPIC.list.pick_random()

func getAllWeapons() -> Array[Weapon]:
	var everyweapon:Array
	everyweapon.append_array(COMMON.list)
	everyweapon.append_array(RARE.list)
	everyweapon.append_array(EPIC.list)
	return everyweapon
