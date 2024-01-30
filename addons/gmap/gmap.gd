@icon("icons/doclogo.svg")
class_name gmap extends Node
var pckPacker := PCKPacker.new()
#var filedock := EditorInterface.get_resource_filesystem()


static func creatmap(map: gmapInfo):
	var dir = DirAccess.open("res://")
	dir.make_dir_recursive("UserMaps/{Name}".format({Name = map.name}))
	ResourceSaver.save(map, "UserMaps/{Name}/map.tres".format({Name = map.name}))
	EditorInterface.get_resource_filesystem().scan()
	print_rich("[color=green]Map created successfully[/color]")


static func buildmap(mapinfo: gmapInfo):
	var packer = PCKPacker.new()
	var error = packer.pck_start("{0}.pck".format([mapinfo.name]))
	if error != OK:
		print("Failed to create the package file!")
		return
	add_directory_to_pck(packer, "res://UserMaps/{0}".format([mapinfo.name]), "res://Usermaps")
	packer.flush(true)


static func add_directory_to_pck(packer: PCKPacker, dir_path: String, pck_path: String):
	var dir = DirAccess.open(dir_path)
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				add_directory_to_pck(
					packer, dir_path.path_join(file_name), pck_path.path_join(file_name)
				)
			else:
				var fs_path = dir_path.path_join(file_name)
				print(fs_path)
				var pck_file_path = pck_path.path_join(file_name)
				packer.add_file(pck_file_path, fs_path)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open the directory")


static func loadMaps():
	var resDir := DirAccess.open("res://")
	var userDir := DirAccess.open("user://")
	if resDir.file_exists("gmap.tres"):
		var config: gmapConfig = load("res://gmap.tres")
		for map in userDir.get_files_at("Maps"):
			if map.get_extension() == ".pck":
				ProjectSettings.load_resource_pack(
					"user://UserMaps/{0}".format([map]), config.allowoverrite
				)


static func installmap(absolutepath: String):
	var dir = DirAccess.open("user://")
	if !dir.dir_exists("user://UserMaps"):
		dir.make_dir("user://UserMaps")
	var file = FileAccess.open(absolutepath, FileAccess.READ)
	var mapfile = FileAccess.open(
		"user://Usermaps/{0}".format([absolutepath.get_file()]), FileAccess.WRITE
	)
	mapfile.store_buffer(file.get_buffer(1))
	file.close()
	mapfile.close()
