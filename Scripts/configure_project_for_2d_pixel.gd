@tool
extends EditorScript
class_name ConfigureProjectFor2d 

const window_size:Vector2i = Vector2i(500,500)
const window_title:String = "select resolution"

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
	EditorInterface.popup_dialog_centered(window, window_size)
	var control: Control = Control.new()
	var top_row : HBoxContainer = HBoxContainer.new()
	var bottom_row: HBoxContainer = HBoxContainer.new()
	var vbox : VBoxContainer = VBoxContainer.new()
	
	var width_field: LineEdit = create_line_edit(200,100)
	var label_width: Label = create_label(200,100,"Width =")
	
	width_field.text_submitted.connect(
		func(size_text:String):
			var new_size := size_text.to_int()
			if new_size != 0:
				change_project_size(true,new_size)
				print("changed width = %s" % new_size)
			pass
	)
	
	var height_field: LineEdit = create_line_edit(200,100)
	var label_height: Label = create_label(200,100,"Height =")
	
	height_field.text_submitted.connect(
		func(size_text:String):
			var new_size := size_text.to_int()
			if new_size != 0:
				change_project_size(false,new_size)
				print("changed width = %s" % new_size)
			pass
	)
	
	vbox.add_child(top_row)
	vbox.add_child(bottom_row)
	
	top_row.add_child(label_width)
	top_row.add_child(width_field)
	
	bottom_row.add_child(label_height)
	bottom_row.add_child(height_field)
	
	control.add_child(vbox)

	window.add_child(control)
	pass

func create_line_edit(width:int, height:int, position_x:int = -2147483647, position_y:int = -2147483647) -> LineEdit:
	var result: LineEdit = LineEdit.new()
	result.size.x = width
	result.size.y = height
	if position_x != -2147483647:
		result.position.x = position_x
	if position_y != -2147483647:
		result.position.y = position_y
	return result;

func create_line_edit_v(size:Vector2i, position:Vector2i) -> LineEdit:
	return create_line_edit(size.x,size.y, position.x,position.y)

func create_label(width:int, height:int,the_text:String) -> Label:
	var result :Label = Label.new()
	result.size.x = width
	result.size.y = height
	result.text = the_text
	return result

func change_project_size(should_change_width:bool,new_size:int) -> void:
	if should_change_width:
		ProjectSettings.set_setting("display/window/size/viewport_width", new_size)
	else:
		ProjectSettings.set_setting("display/window/size/viewport_height", new_size)
	pass
