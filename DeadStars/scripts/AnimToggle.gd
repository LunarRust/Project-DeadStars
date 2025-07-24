extends TextureButton
var Toggled : bool = false
@export var ButtonSoundEffect : AudioStream
@export var AnimPlayer : AnimationPlayer
@export var Anim1 : String
@export var Anim2 : String

signal On
signal Off

func _ready():
	if ButtonSoundEffect != null:
		%ButtonSound.stream = ButtonSoundEffect


func _on_pressed():
	if ButtonSoundEffect != null:
		%ButtonSound.play()
	if Toggled == true:
		Toggled = false
		Off.emit()
		if AnimPlayer != null:
			AnimPlayer.play(Anim2)

	else:
		Toggled = true
		if AnimPlayer != null:
			AnimPlayer.play(Anim1)
		On.emit()
