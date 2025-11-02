@tool
extends EditorScript
class_name ConfigureEntireProject

const proj_dirs := [
	"res://Entities",
	"res://Entities/UI",
	"res://Scenes",
	"res://Scenes/UI",
	"res://Scripts",
	"res://Scripts/Debug Only",
	"res://Scripts/Editor",
	"res://Scripts/UI",
	"res://Sprites",
	"res://Textures",
	"res://Themes",
]

const folder_colors := {
	"res://Entities/": "orange",
	"res://Scenes/": "red",
	"res://Scripts/": "green",
	"res://Sprites/": "yellow",
	"res://Textures/": "purple",
	"res://Themes/": "pink"
}

const window_title :String = "Configure entire project"
const window_size : Vector2i = Vector2i(500, 700)


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var window : Window = Window.new()
	window.title = window_title
	window.size = window_size
	window.close_requested.connect(
		func():
			window.queue_free()
	)
	add_ui_to_window(window)
	EditorInterface.popup_dialog_centered(window, window.size)


func generate_directories() -> bool:
	print("generating folders for project")
	var result: bool = false

	for d:String in proj_dirs:
		if not DirAccess.dir_exists_absolute(d):
			var err := DirAccess.make_dir_recursive_absolute(d)

			if err != OK:
				push_error("Failed to create: %s (error %d)" % [d, err])
				return result;
		else:
			print("Already created %s" % d)

	result = true
	EditorInterface.get_resource_filesystem().scan()
	print_rich("[b]Finished generating folders for project [/b]")

	return result


func color_folders() -> void:
	print_rich("[i]Coloring folder for Project[/i]")
	ProjectSettings.set_setting("file_customization/folder_colors", folder_colors)
	EditorInterface.get_resource_filesystem().scan()
	print_rich("[b]Finished coloring folder for Project [/b]")

	pass

func create_project_folders() ->void :
	if generate_directories():
		color_folders()
	pass

func add_button(name : String, size :Vector2i, call_back_function : Callable ) -> Button:
	var result : Button = Button.new()
	result.text = name
	result.size = size
	print("is null = %s"% call_back_function.is_null())
	print("is valid = %s" % call_back_function.is_valid())
	print("is custom = %s" % call_back_function.is_custom())
	print("is standard = %s" % call_back_function.is_standard())
	print("method is = %s" % call_back_function.get_method())
	print("call argument count is = %s" % call_back_function.get_argument_count())
	if call_back_function.is_null():
		call_back_function = func(): print("pressed button")

	if call_back_function.get_argument_count() != 0:
		printerr("Can only use callables with zero arguments")
		assert(false)
	
	result.pressed.connect(
		func():
			call_back_function.call()
	)
	
	return result

func default_button_function() -> void:
	print("button pressed")

func add_ui_to_window(window: Window) -> void :
	var vbox : VBoxContainer = VBoxContainer.new()
	var control : Control = Control.new()
	control.add_child(vbox)
	print("callable")

	vbox.add_child(
		add_button("create folders",
		Vector2i(100,100),
		func():create_project_folders()
	))
	
	window.add_child(control)
	pass
