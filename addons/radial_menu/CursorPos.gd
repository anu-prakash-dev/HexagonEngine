extends Control

signal hover(index)
signal selected(index)

var count = 0
var touches = 0
var last_index = 0
var cursor = Vector2(0, 0)

func set_count(new_count: int):
	self.count = new_count

func get_index():
	if not self.count: return 0

	var angle = atan2(cursor.y, cursor.x)
	var index_offset = (2 * PI) / self.count

	# Calculate the angle as a percentage of the entire circle
	# divided up into equal sized arcs based on the number of items (count)
	var to_return = (PI - angle) / index_offset

	# Clip to the min-max and remove the additional calulation offset
	return floor(max(0, min(self.count - 1, to_return - index_offset / 2)))

func compute_index():
	var current_index = self.get_index()
	if current_index == self.last_index:
		return

	self.last_index = current_index
	self.emit_signal("hover", current_index)

func touch_start(_event: InputEventScreenTouch):
	if touches < 1:
		cursor = Vector2(0, 0)

	touches += 1

func touch_end(_event: InputEventScreenTouch):
	touches -= 1
	if touches <= 0:
		touches = 0
		self.emit_signal("selected", self.get_index())

func touch_drag(event: InputEventScreenDrag):
	self.cursor += event.relative

	# Check for hover events
	self.compute_index()

func mouse_start(_event: InputEventMouseButton):
	if touches < 1:
		mouse_drag()

	touches += 1

func mouse_end(_event: InputEventMouseButton):
	touches -= 1
	if touches <= 0:
		touches = 0
		self.emit_signal("selected", self.get_index())

func mouse_drag(_event: InputEventMouseMotion = null):
	if touches < 1: return

	var parent = self.get_parent()
	var center = self.get_global_position()

	self.cursor = (center - self.get_global_mouse_position()) * -1

	# Check for hover events
	self.compute_index()

func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed:
			self.touch_start(event)

		else:
			self.touch_end(event)

	elif event is InputEventScreenDrag:
		self.touch_drag(event)

	elif event is InputEventMouseButton:
		if event.pressed:
			self.mouse_start(event)

		else:
			self.mouse_end(event)

	elif event is InputEventMouseMotion:
		self.mouse_drag(event)
