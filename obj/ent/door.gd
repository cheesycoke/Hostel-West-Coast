extends CSGBox3D
signal opened
@onready var the_door = $TheDoor

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func punched():
	print("doorhit!")
	emit_signal("opened")
	the_door.queue_free()
	
