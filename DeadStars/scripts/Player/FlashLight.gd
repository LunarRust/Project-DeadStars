extends TextureButton
@export var Flashlight : SpotLight3D
@export var Flashlight2 : SpotLight3D
@export var PlayerAnim : AnimationTree
@export var SoundSource : AudioStreamPlayer
@export var Sound : AudioStream


func _pressed():
	ToggleLight()


func ToggleLight(DoSound : bool = true):
	animTrigger("Flashlight")
	Flashlight.visible = !Flashlight.visible
	Flashlight2.visible = !Flashlight2.visible
	if DoSound:
		SoundSource.stream = Sound
		SoundSource.play()


func animTrigger(triggername : String):
	PlayerAnim["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	PlayerAnim["parameters/conditions/" + triggername] = false;
