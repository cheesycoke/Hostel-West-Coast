extends HBoxContainer
@export var ammotype:AmmoRes
@onready var label = $Label

func _ready():
	$TextureRect.texture = ammotype.Icon

func gotten():
	$Label/AnimationPlayer.play("get")
