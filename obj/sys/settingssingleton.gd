extends Node

var masVol:float = 1 : set = setMas
var musVol:float = 1 : set = setMus
var sfxVol:float = 1 : set = setSfx

func _ready():
	masVol = db_to_linear(AudioServer.get_bus_volume_db(0))
	musVol = db_to_linear(AudioServer.get_bus_volume_db(1))
	sfxVol = db_to_linear(AudioServer.get_bus_volume_db(2))

func setMas(val):
	AudioServer.set_bus_volume_db(0, linear_to_db(val))
func setMus(val):
	AudioServer.set_bus_volume_db(1, linear_to_db(val))
func setSfx(val):
	AudioServer.set_bus_volume_db(2, linear_to_db(val))
