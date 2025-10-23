@tool
extends EditorScript
class_name ConfigureProjectFor2d 


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	print_rich("[i]configuring project for 2D[/i]")
	ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_filter", "Nearest")
	ProjectSettings.set_setting("display/window/stretch/mode", "canvas_items")
	ProjectSettings.set_setting("display/window/stretch/aspect", "keep")
	print_rich("[b]FINISHED[/b]")
	pass
