extends Node
# Create new ConfigFile object.
var config = ConfigFile.new()
@export var KOMVerLabel : RichTextLabel
@export var DeadStarsLabel : RichTextLabel
@export var KOMVer : String
@export var DeadStars : String



# Called when the node enters the scene tree for the first time.
func _ready():
	var err = config.load("user://system.cfg")
	# Store some values.
	if err != OK:
		config.set_value("Versions", "KOMVer", KOMVer)
		config.set_value("Versions", "DeadStars", DeadStars)
		config.set_value("Config_Data", "Exists", true)
	# Save it to a file (overwrite if already exists).
		config.save("user://system.cfg")

	for Versions in config.get_sections():
		var KOMVer = config.get_value(Versions, "KOMVer")
		var DeadStars = config.get_value(Versions, "DeadStars")
		if KOMVer != null:
			if KOMVerLabel != null:
				KOMVerLabel.text = ("[shake rate=20] [" + KOMVer + "]")
		if DeadStars != null:
			if DeadStarsLabel != null:
				DeadStarsLabel.text = ("[shake rate=20]DeadStars [" + DeadStars + "]")
	DeadStars = config.get_value("Versions", "DeadStars")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
