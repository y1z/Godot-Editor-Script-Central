@tool
extends EditorScript
class_name ConfigureProjectFor2d 

const window_size:Vector2i = Vector2i(500,500)
const window_title:String = "select resolution"

const error_position_value:int = -2147483647;

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	print_rich("[i]configuring project for 2D[/i]")
	ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_filter", "Nearest")
	ProjectSettings.set_setting("display/window/stretch/mode", "canvas_items")
	ProjectSettings.set_setting("display/window/stretch/aspect", "keep")
	print_rich("[b]FINISHED[/b]")
	
	var window : Window  = Window.new()
	window.title = window_title
	window.close_requested.connect(
		func():
			window.queue_free()
	)
	
	add_ui_to_window(window)
	
	EditorInterface.popup_dialog_centered(window, window_size)
	pass

func add_ui_to_window(window_:Window) -> void:
	var control: Control = Control.new()
	var top_row : HBoxContainer = HBoxContainer.new()
	var bottom_row: HBoxContainer = HBoxContainer.new()
	var vbox : VBoxContainer = VBoxContainer.new()

	
	var width_field: LineEdit = create_line_edit(200,100)
	var label_width: Label = create_label(200,100,"Width =")
	var width_button: Button = Button.new()
	
	var height_field: LineEdit = create_line_edit(200,100)
	var label_height: Label = create_label(200,100,"Height =")
	var height_button: Button = Button.new()
	
	width_button.modulate = Color(0.702, 0.129, 0.918, 1.0)
	width_button.text =  "confirm width"
	width_button.pressed.connect(
		func():
			width_field.text_submitted.emit(width_field.text)
			print("'text_submitted' emited")
	)
	
	height_button.modulate = Color(0.702, 0.129, 0.918, 1.0)
	height_button.text = "confirm height"
	height_button.pressed.connect(
		func():
			height_field.text_submitted.emit(height_field.text)
			print("'text_submitted' emited")
	)
	
	width_field.text_submitted.connect(
		func(size_text:String):
			cb_text_submitted(size_text, true)
			pass
	)
	

	
	height_field.text_submitted.connect(
		func(size_text:String):
			cb_text_submitted(size_text, false)
			pass
	)
	
	vbox.add_child(top_row)
	vbox.add_child(bottom_row)
	
	top_row.add_child(label_width)
	top_row.add_child(width_field)
	top_row.add_child(width_button)
	
	bottom_row.add_child(label_height)
	bottom_row.add_child(height_field)
	bottom_row.add_child(height_button)
	
	control.add_child(vbox)

	window_.add_child(control)
	pass

func create_line_edit(width:int, height:int, position_x:int = error_position_value, position_y:int = error_position_value) -> LineEdit:
	var result: LineEdit = LineEdit.new()
	result.size.x = width
	result.size.y = height
	if position_x != error_position_value:
		result.position.x = position_x
	if position_y != error_position_value:
		result.position.y = position_y
	return result;

func create_line_edit_v(size:Vector2i, position:Vector2i) -> LineEdit:
	return create_line_edit(size.x,size.y, position.x,position.y)

func create_label(width:int, height:int, the_text:String) -> Label:
	var result :Label = Label.new()
	result.size.x = width
	result.size.y = height
	result.text = the_text
	return result

func change_project_size(should_change_width:bool, new_size:int) -> void:
	if should_change_width:
		ProjectSettings.set_setting("display/window/size/viewport_width", new_size)
	else:
		ProjectSettings.set_setting("display/window/size/viewport_height", new_size)
	pass

func cb_text_submitted(size_text:String, should_be_width:bool) -> void:
	var new_size := size_text.to_int()
	var format_string :String = "changed width = %s" if should_be_width else "changed height = %s"
	if new_size != 0:
		change_project_size(should_be_width, new_size)
		print(format_string % new_size)
	pass
