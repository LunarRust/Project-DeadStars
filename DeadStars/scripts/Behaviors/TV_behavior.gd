extends Node3D
@export var VideoPlayer : VideoStreamPlayer
@export var animPlayer : AnimationPlayer
@export_category("parameters")
@export var Sfx : bool = true
@export var AutoPlay : bool = false
@export var delay : float = 0
@export var loop : bool = false

func _ready():
	if loop:
		VideoPlayer.loop = true
	else:
		VideoPlayer.loop = false
	if AutoPlay:
		if delay == -1:
			pass
		else:
			await get_tree().create_timer(delay).timeout
			PlayVideo()



func PlayVideo():
	animPlayer.Anim_Play()
	if Sfx:
		%CRTbuzz.stream = load("res://DeadStars/sounds/CRTon-quiet.wav") as AudioStream
		%CRTbuzz.play()
	await get_tree().create_timer(5.0).timeout
	if Sfx:
		%CRTbuzz.stream = load("res://DeadStars/sounds/CRThum.ogg") as AudioStream
		%CRTbuzz.play()
	VideoPlayer.play()


func _on_video_stream_player_finished():
	if Sfx:
		%CRTbuzz.stop()
		%CRTbuzz.stream = load("res://DeadStars/sounds/CRToff.wav") as AudioStream
		%CRTbuzz.play()
