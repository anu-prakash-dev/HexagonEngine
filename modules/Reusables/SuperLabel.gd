tool
extends Label

#onready var superLabelFont:DynamicFont = preload("res://modules/Reusables/SuperLabelDynamicFont.tres")
export(DynamicFontData) var fontFile = load("res://font/ubuntu-font-family-0.83/Ubuntu-R.ttf") setget set_font_file
onready var fonto = get_font("font")
export(float) var size = 24.0 setget set_font_size
export(Color) var fontColor = Color.white setget set_font_color # to rechange again, use add color overide directly. if it is in process, it lags!
export(float) var outlineSize = 1.0 setget set_outline_size
export(Color) var OutlineColor = Color.black setget set_outline_color
export(bool) var useMipmaps = false setget set_use_mipmaps
export(bool) var useFilter = false setget set_use_filter
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_font_file(theFont:DynamicFontData):
	fontFile = theFont
	_updateFont()

func set_font_size(howBig:float):
	size = howBig
	_updateFont()

func set_font_color(whichColor:Color):
	fontColor = whichColor
	_updateFont()

func set_outline_size(howThicc:float):
	#gloat
	outlineSize = howThicc
	_updateFont()

func set_outline_color(whichColor:Color):
	OutlineColor = whichColor
	_updateFont()

func set_use_mipmaps(mipmaps:bool):
	useMipmaps = mipmaps
	_updateFont()

func set_use_filter(filter:bool):
	useFilter = filter
	_updateFont()

func _updateFont():
	# safety check! without this, it could error invalid set index base Nil.
	if fonto == null:
		return
	
	#add_font_override("font",superLabelFont)
	#add_color_override("font_color",fontColor)
	fonto.font_data = fontFile
	fonto.size = size
	
	fonto.outline_size = outlineSize
	fonto.outline_color = OutlineColor
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#fonto = get_font("font")
	#add_font_override("font",superLabelFont)
	add_color_override("font_color",fontColor)
	_updateFont()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	_updateFont()
	pass
