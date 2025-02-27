extends Node

var InstanceDVD
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal NoDisc()

# Called when the node enters the scene tree for the first time.
func _ready():
	#CheckDVD()
	ConnectCartridge()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func CheckDVD():
	InstanceDVD = get_child(0)
	if(!InstanceDVD):
		emit_signal("NoDisc")
		pass
	else:
		pass
	pass

func ConnectCartridge():
	# Connect important signals of basically every DVD Cartridge
	if(InstanceDVD):
		print("Connect Cartridge!") #cartride connecc say
		InstanceDVD.connect("ChangeDVD_Exec", self, "_on_ChangeDVD_Exec")
		InstanceDVD.connect("Shutdown_Exec", self, "_on_Shutdown_Exec")
		pass
	else:
		print("No Connect Cartridge, DVD slot empty!")
		pass
	pass

signal ChangeDVD_Exec()
signal Shutdown_Exec()

func ExecuteChangeDVD():
	CheckDVD()
	if InstanceDVD:
		remove_child(InstanceDVD)
		InstanceDVD.queue_free()
		#InstanceDVD.free()
		pass
	ExecuteRemoveAllDVDs() # Make sure they are empty really
	emit_signal("ChangeDVD_Exec")
	pass
func ExecuteShutdown():
	emit_signal("Shutdown_Exec")
	pass
func ExecuteRemoveAllDVDs():
	for leftovers in get_children():
		if leftovers.is_connected("ChangeDVD_Exec", self, "_on_ChangeDVD_Exec"):
			leftovers.disconnect("ChangeDVD_Exec", self, "_on_ChangeDVD_Exec")
		if leftovers.is_connected("Shutdown_Exec", self, "_on_Shutdown_Exec"):
			leftovers.disconnect("Shutdown_Exec", self, "_on_Shutdown_Exec")
		remove_child(leftovers)
		leftovers.queue_free()
		#leftovers.free()
		pass
	pass

signal DVDTryLoad
func PlayDVD(LoadDVD):
	emit_signal("DVDTryLoad")
	InstanceDVD = LoadDVD.instance()
	add_child(InstanceDVD)
	ConnectCartridge()
	pass

func BootExclusiveThis(LoadDVD):
	pass

func _exit_tree():
	CheckDVD()
	if InstanceDVD:
		InstanceDVD.queue_free()
		pass
	pass

func _on_ChangeDVD_Exec():
	ExecuteChangeDVD()
	pass # Replace with function body.


func _on_Shutdown_Exec():
	ExecuteShutdown()
	pass # Replace with function body.


func _on_TemplateHexagonEngine_Shutdown_Exec():
	pass # Replace with function body.
