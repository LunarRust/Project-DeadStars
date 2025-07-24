extends Node2D
@export var time : float = 0
@export var tweenPosition : bool = false
@export var endPosition : Vector2 = Vector2(0,0)
@export var tweenRotation : bool = false
@export var endRotation : float = 0
@export var tweenScale : bool = false
@export var endScale : float = 0
var startPos : Vector2
var startRot : float
var startScale : float


func _ready():
	startPos = self.position
	startRot = self.rotation
	startScale = self.scale.x
	startTween()


func startTween():
	if tweenPosition:
		var tween : Tween = create_tween().set_loops()
		tween.tween_property(self,"position",endPosition,time).set_trans(Tween.TRANS_QUAD).as_relative()
		tween.tween_property(self,"position",startPos,time).set_trans(Tween.TRANS_QUAD)
	if tweenRotation:
		var tween : Tween = create_tween().set_loops()
		tween.tween_property(self,"rotation",endRotation,time).set_trans(Tween.TRANS_QUAD).as_relative()
		tween.tween_property(self,"rotation",startRot,time).set_trans(Tween.TRANS_QUAD)
	if tweenScale:
		var tween : Tween = create_tween().set_loops()
		tween.tween_property(self,"scale",Vector2.ONE * endScale,time).set_trans(Tween.TRANS_QUAD).as_relative()
		tween.tween_property(self,"scale",Vector2.ONE * startScale,time).set_trans(Tween.TRANS_QUAD)
