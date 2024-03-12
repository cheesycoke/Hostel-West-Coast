@tool
extends Node3D

func remove_wall_up():
	$wallUp.free()
func remove_wall_down():
	$wallDown.free()
func remove_wall_left():
	$wallLeft.free()
func remove_wall_right():
	$wallRight.free()
func remove_door_up():
	$doorUp.free()
func remove_door_down():
	$doorDown.free()
func remove_door_left():
	$doorLeft.free()
func remove_door_right():
	$doorRight.free()
