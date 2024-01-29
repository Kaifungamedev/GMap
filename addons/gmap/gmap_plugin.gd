@tool
extends EditorPlugin
var builder

func _enter_tree():
	builder = preload("builder/MapBulder.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_BR,builder)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(builder)

