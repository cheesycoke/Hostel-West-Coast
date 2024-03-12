extends Node3D
const CEILING_LIGHT = preload("res://obj/fx/ceiling_light.tscn")

func _ready():
	pass

func _process(delta):
	pass

func createLights(roomwidth,roomheight):
	var lightCount: int = (roomwidth*roomheight)/2
	var spacingX = roomwidth/(lightCount % int(sqrt(lightCount)))
	var spacingY = roomheight/(lightCount % int(sqrt(lightCount)))
	
	var startX = -roomwidth/2 + spacingX/2
	var startY = -roomheight/2 + spacingY/2
	
	for i in range(lightCount):
		var newlight = CEILING_LIGHT.instantiate()
		newlight.position.x = startX + (i%int(sqrt(lightCount))) * spacingX
		newlight.position.z = startY + (i/int(sqrt(lightCount))) * spacingY
		newlight.position.y = 1
		print(newlight.position)
		add_child(newlight)
		
		
