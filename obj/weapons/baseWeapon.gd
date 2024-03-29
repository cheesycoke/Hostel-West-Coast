extends Resource

class_name Weapon

#Mechanics
@export var Name: String
@export var Auto: bool
@export var BulletsFired: int = 1
@export var ReloadTime: float = 1.0
@export var RandomSpread: float = 0.0
@export var AmmoType: AmmoRes
@export var AmmoObj: PackedScene
@export var FanWidth: int = 60
@export var AmmoUse: int = 1
@export var Damage:int = 2

#AudioVisual Elements
@export var Model: PackedScene = load("res://gfx/guns/dummy/dummygun.dae")
@export var FireSound: AudioStream = load("res://audio/sfx/gun.wav")

var Ammo: int = 0
