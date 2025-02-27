extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var TitleBarName = "NextMenu Title Bar!"
export(Image) var TitleIcon
export(PackedScene) var MainMenuBack
export(PackedScene) var GameplayArea
export(PackedScene) var SettingArea
export(PackedScene) var UnknownArea #area51
export(PackedScene) var ExtrasArea
onready var PrevNode = $VBoxContainer/MenuSpaceArea/InheritableMenuArea
export(NodePath) var NextNode

export(Image) var LoadSettingIcon
export(Image) var LoadUnknownIcon
export(Image) var LoadExtrasIcon
export(Image) var LoadPlayGameIcon

export(PackedScene) var Your3DSpaceLevel
export(PackedScene) var Your2DSpaceLevel
export(Texture) var LevelBannerThumbnail
export(Image) var LevelImageThumbnail
export(String) var LevelTitleg

export(bool) var a2DSpaceReportHP = false
export(bool) var a3DSpaceReportHP = false
export(bool) var a2DSpaceReportScore = false
export(bool) var a3DSpaceReportScore = false
# https://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_basics.html#exports
export(String, MULTILINE) var LevelDescription



enum SelectMenuList {MainMenu=-1, Setting=0,Unknown=1,Extras=2, Gameplay = 3, LevelSelect = 4}
export(SelectMenuList) var SelectYourMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	#LetsChangeScene
	##SoftLetsChangeScene()
	pass # Replace with function body.

func StopTesting():
	$VBoxContainer/MenuSpaceArea/SettingArea.StopTesting()
	pass

func SetYourMenuList(whichOf):
	SelectYourMenu = whichOf
	SoftLetsChangeScene()
	pass

signal GetYourMenuList(whichOf)

func ChangeMenuSpace(CurrentFrom, IntoNewSpace):
	# https://godotengine.org/qa/24773/how-to-load-and-change-scenes
	# Remove the current level
	var level = CurrentFrom
	remove_child(level)
	level.call_deferred("free")
	
	# Add the next level
	var next_level_resource = IntoNewSpace
	var next_level = next_level_resource.instance()
	$VBoxContainer/MenuSpaceArea.add_child(next_level)
	pass

func SoftChangeMenuSpace(CurrentFrom, IntoNewSpace):
	CurrentFrom.hide()
	IntoNewSpace.show()
	
	pass

func LetsChangeScene():
	var CurrentMenuSpace = $VBoxContainer/MenuSpaceArea.get_child(0)
	if SelectYourMenu == SelectMenuList.Setting:
		# https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position 
		# https://godotengine.org/qa/24773/how-to-load-and-change-scenes
		ChangeMenuSpace(CurrentMenuSpace, SettingArea)
		$VBoxContainer/MenuSpaceArea/SettingArea/HBoxContainer/CategoryScrolling/CategorySelection/AudioCategory.grab_focus()
		pass
	elif SelectYourMenu == SelectMenuList.Unknown:
		pass
	elif SelectYourMenu == SelectMenuList.Extras:
		pass
	elif SelectYourMenu == SelectMenuList.Gameplay:
		pass
	
	pass

func SoftLetsChangeScene():
	#PrevNode = $VBoxContainer/MenuSpaceArea.get_child(0)
	if SelectYourMenu == SelectMenuList.Setting:
		TitleBarName = "Setting"
		TitleIcon = LoadSettingIcon
		SoftChangeMenuSpace(PrevNode, $VBoxContainer/MenuSpaceArea/SettingArea)
		$VBoxContainer/MenuSpaceArea/SettingArea.FocusFirstCategoryButtonNow()
		PrevNode = $VBoxContainer/MenuSpaceArea/SettingArea
		pass
	elif SelectYourMenu == SelectMenuList.Unknown:
		TitleBarName = "Unknown"
		TitleIcon = LoadUnknownIcon
		SoftChangeMenuSpace(PrevNode, $VBoxContainer/MenuSpaceArea/UnknownArea)
		$VBoxContainer/MenuSpaceArea/UnknownArea.FocusWhatDoYouWantNow()
		PrevNode = $VBoxContainer/MenuSpaceArea/UnknownArea
		pass
	elif SelectYourMenu == SelectMenuList.Extras:
		TitleBarName = "Extras"
		TitleIcon = LoadExtrasIcon
		SoftChangeMenuSpace(PrevNode, $VBoxContainer/MenuSpaceArea/ExtrasArea)
		$VBoxContainer/MenuSpaceArea/ExtrasArea.FocusThisItemSelectFieldNow()
		PrevNode = $VBoxContainer/MenuSpaceArea/ExtrasArea
		pass
	elif SelectYourMenu == SelectMenuList.Gameplay:
		TitleBarName = LevelTitleg
		#LevelImageThumbnail = Image.
		TitleIcon = LoadPlayGameIcon
		SoftChangeMenuSpace(PrevNode, $VBoxContainer/MenuSpaceArea/GameplayLevelLoadingInfoArea)
		
		PrevNode = $VBoxContainer/MenuSpaceArea/GameplayLevelLoadingInfoArea
		pass
	elif SelectYourMenu == SelectMenuList.LevelSelect:
		TitleBarName = "Level Select"
		TitleIcon = LoadPlayGameIcon
		SoftChangeMenuSpace(PrevNode, $VBoxContainer/MenuSpaceArea/LevelSelectArea)
		
		PrevNode = $VBoxContainer/MenuSpaceArea/LevelSelectArea
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_9):
		#LetsChangeScene()
		pass
	$VBoxContainer/HeadingBar/TitleBarArea/Label.text = TitleBarName
	$VBoxContainer/HeadingBar/IconArea/TextureRect.texture = TitleIcon
	
	emit_signal("GetYourMenuList",SelectYourMenu)
	pass

signal PressBackButton()
func _on_BackButton_pressed():
	StopTesting()
	emit_signal("PressBackButton")
	if $VBoxContainer/MenuSpaceArea/SettingArea.visible:
		Settingers.SettingSave()
	pass # Replace with function body.


func _on_UnknownArea_LeaveAndBackToMenu():
	emit_signal("PressBackButton")
	pass # Replace with function body.

#Daisy Chained SIgnal!!!
signal PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
func _on_LevelSelectArea_PleaseLoadThisLevelOf(a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc):
	print("Next Level had received ",a3DScapePacked, a2DSpacePacked, " and going to bridge those")
	Your3DSpaceLevel = a3DScapePacked
	Your2DSpaceLevel = a2DSpacePacked
	LevelBannerThumbnail = LevelThumb
	LevelTitleg = LevelTitle
	LevelDescription = LevelDesc
	
	SetYourMenuList(SelectMenuList.Gameplay)
	emit_signal("PleaseLoadThisLevelOf", a3DScapePacked, a2DSpacePacked, LevelThumb, LevelTitle, LevelDesc)
	pass # Replace with function body.

#func _ReceiveSignalStatus(a3DReportsHP, a2DReportsHP,a3DReportsScore,a2DReportsScore):
#	a2DSpaceReportHP = a2DReportsHP
#	a3DSpaceReportHP = a3DReportsHP
#	a2DSpaceReportScore = a2DReportsScore
#	a3DSpaceReportScore = a3DReportsScore
#	pass

signal AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore)
signal canThisLevelPlayEvenOutOfFocus(mayI)
func _on_LevelSelectArea_AlsoPlsConnectThisReportStatus(a3DSpaceHP, a2DSpaceHP, a3DSpaceScore, a2DSpaceScore):
	a2DSpaceReportHP = a2DSpaceHP
	a3DSpaceReportHP = a3DSpaceHP
	a2DSpaceReportScore = a2DSpaceScore
	a3DSpaceReportScore = a3DSpaceScore
	emit_signal("AlsoPlsConnectThisReportStatus",a3DSpaceReportHP,a2DSpaceReportHP,a3DSpaceReportScore,a2DSpaceReportScore)
	
	pass # Replace with function body.


func _on_LevelSelectArea_canThisLevelPlayEvenOutOfFocus(mayI):
	emit_signal("canThisLevelPlayEvenOutOfFocus",mayI)
	pass # Replace with function body.
