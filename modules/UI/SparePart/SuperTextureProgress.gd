extends TextureProgress

export(bool) var showName = false
export(String) var Name = ""
export(float) var labelSize = 72

onready var label = $LabelValue
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.size = labelSize
	label.text = "{nama}: ".format({nama=Name}) if showName else "" + String(value)
	pass
