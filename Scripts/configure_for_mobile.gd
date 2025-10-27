@tool
extends EditorScript
class_name ConfigureForMobile

const window_title := "configure for mobile"
const window_size := Vector2i(500, 800)

var top_label :Label = Label.new()

enum MobileSensors {
	ACCELEROMETER,
	GRAVITY,
	GYROSCOPE,
	MAGNETOMETER,
}
## The paths used for the project settings
const project_settings_map = {
	MobileSensors.ACCELEROMETER :"input_devices/sensors/enable_accelerometer",
	MobileSensors.GRAVITY : "input_devices/sensors/enable_gravity",
	MobileSensors.GYROSCOPE : "input_devices/sensors/enable_gyroscope",
	MobileSensors.MAGNETOMETER : "input_devices/sensors/enable_magnetometer",
}

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var window : Window  = Window.new()
	window.title = window_title
	window.close_requested.connect(
		func():
			window.queue_free()
	)

	change_label_color(top_label,Color(1.0, 1.0, 1.0, 1.0))
	change_label_outline(top_label, Color(1.0, 1.0, 1.0, 1.0))
	change_label_shadow(top_label,Color(0.0, 0.365, 0.702, 1.0))

	
	add_ui_to_window(window)
	
	for sensor in MobileSensors.keys():
		print("is %s enabled %s" % [sensor,is_sensor_enabled(MobileSensors.get(sensor))])

	
	EditorInterface.popup_dialog_centered(window, window_size)
	print()
	pass

func add_ui_to_window(_window:Window) -> void:
	var vbox := VBoxContainer.new()
	var control := Control.new()

	top_label.text ="Note you will have to restart the project if you change any of the settings"


	vbox.add_child(top_label)
	control.add_child(vbox)
	# for some reason we have to use the MobileSensors.value() to get the VALUE of the desired enum
	for sensor in MobileSensors.values():
		vbox.add_child(create_sensor_row(sensor))

	var save_and_restart_button : Button = Button.new()
	save_and_restart_button.pressed.connect(
		func():
			ProjectSettings.save()
			EditorInterface.save_all_scenes()
			EditorInterface.restart_editor(true)
	)
	save_and_restart_button.text = "save and restart"
	vbox.add_child(save_and_restart_button)

	_window.add_child(control)
	
	pass

func is_sensor_enabled(which_sensor : MobileSensors) -> bool:
	if !ProjectSettings.has_setting(project_settings_map[which_sensor]):
		push_error("Current setting does not exist = [%s]" % project_settings_map[which_sensor])
		return false
	
	return ProjectSettings.get_setting(project_settings_map[which_sensor],false);

func create_sensor_row(which_sensor : MobileSensors) -> HBoxContainer:
	var result : HBoxContainer = HBoxContainer.new()
	var sensor_name  : Label = Label.new()
	sensor_name.text = MobileSensors.keys()[which_sensor]
	result.add_child(sensor_name)
	
	var sensor_check_button : CheckButton = CheckButton.new()
	sensor_check_button.button_pressed = is_sensor_enabled(which_sensor)
	sensor_check_button.toggled.connect(
		func(toggle_on:bool):
			cb_on_pressed(which_sensor, toggle_on)
	)
	result.add_child(sensor_check_button)
	
	return result

func cb_on_pressed(which_sensor:MobileSensors, toggle_on:bool) -> void:
	print(project_settings_map[which_sensor])
	print("is toggle on %s" % toggle_on)
	ProjectSettings.set_setting(project_settings_map[which_sensor], toggle_on)
	change_label_color(top_label,Color(0.854, 0.091, 0.586, 1.0))
	change_label_shadow(top_label, Color(0.0, 0.0, 0.0, 1.0))
	change_label_outline(top_label, Color(1.0, 1.0, 1.0, 1.0))
	pass

func change_label_color(_label:Label,new_color : Color) -> void:
	_label.add_theme_color_override("font_color", new_color)
	pass

func change_label_shadow(_label:Label ,new_color : Color) -> void:
	_label.add_theme_color_override("font_shadow_color", new_color)
	pass

func change_label_outline(_label:Label ,new_color : Color) -> void:
	_label.add_theme_color_override("font_outline_color", new_color)
	pass
