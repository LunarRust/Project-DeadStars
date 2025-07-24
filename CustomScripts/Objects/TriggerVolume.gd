extends Node
signal VolumeBeenEntered
signal VolumeBeenExited

@export var TriggerOnce : bool = false
@export var Enabled : bool = true
@export var TriggerResetTime : float = 0.0
@export var TriggerDelay : float = 0.0
@export var TriggerByGroup : Array[String]

var TriggerTime : float = 0.0
var BeenEntered : bool = false
var BeenExited : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	TriggerTime += delta
	if TriggerTime >= TriggerResetTime:
		TriggerTime = 0.0
		BeenEntered = false
		BeenExited = false


func _on_area_entered(area):
	if Enabled:
		if !BeenEntered:
			print("TriggerVolume: Area Entered")
			if !TriggerByGroup.is_empty():
				for i in TriggerByGroup:
					if area.get_parent().is_in_group(i):
						await get_tree().create_timer(TriggerDelay).timeout
						VolumeBeenEntered.emit()
						if TriggerOnce:
							BeenEntered = true
							self.queue_free()
			else:
				await get_tree().create_timer(TriggerDelay).timeout
				VolumeBeenEntered.emit()
				if TriggerOnce:
					self.queue_free()
					BeenEntered = true


func _on_area_exited(area):
	if Enabled:
		if  !BeenExited:
			print("TriggerVolume: Area Exited")
			if !TriggerByGroup.is_empty():
				for i in TriggerByGroup:
					if area.get_parent().is_in_group(i):
						await get_tree().create_timer(TriggerDelay).timeout
						VolumeBeenExited.emit()
						if TriggerOnce:
							self.queue_free()
							BeenExited = true
			else:
				await get_tree().create_timer(TriggerDelay).timeout
				VolumeBeenExited.emit()
				if TriggerOnce:
					self.queue_free()
					BeenExited = true


func _on_body_exited(body):
	pass # Replace with function body.


func _on_body_entered(body):
	pass # Replace with function body.
