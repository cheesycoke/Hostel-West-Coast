extends Node
@onready var musicplayer = $MusicPlayer
const MENUMUSIC = preload("res://audio/music/menumusic.mp3")
const GOOFING = preload("res://audio/music/goofing.mp3")

func playmenumusic():
	musicplayer.stream = MENUMUSIC
	musicplayer.play(0.0)
