extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var CategoryAreaYouWishToLoad
export(bool) var isPressedNow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	isPressedNow = pressed
	pass # Replace with function body.

func UnPressSectionButton():
	pressed = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal LoadThisCategoryPlease(CategoryScenePath)
func LoadNowCategory():
	emit_signal("LoadThisCategoryPlease",CategoryAreaYouWishToLoad)
	pass

signal StatusPressed(value)
func _on_InheritableCategoryButton_toggled(button_pressed):
	isPressedNow = button_pressed
	emit_signal("StatusPressed",button_pressed)
	pass # Replace with function body.
