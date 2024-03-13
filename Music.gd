extends Node
@onready var musicplayer = $MusicPlayer
const MENUMUSIC = preload("res://audio/music/menumusic.mp3")
const GOOFING = preload("res://audio/music/goofing.mp3")

func playmenumusic():
	if musicplayer.stream != MENUMUSIC:
		musicplayer.stream = MENUMUSIC
		musicplayer.play(0.0)
func playgamemusic():
	if musicplayer.stream != GOOFING:
		musicplayer.stream = GOOFING
		musicplayer.play(0.0)
