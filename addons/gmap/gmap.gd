@icon("icons/doclogo.svg")
class_name gmap extends Node
var pckPacker := PCKPacker.new()


static func creatmap(map: gmapInfo, http: AwaitableHTTPRequest) -> Error:
	var dir = DirAccess.open("res://")
	var zip := ZIPReader.new()
	var r: AwaitableHTTPRequest.HTTPResult
	var templates = JSON.parse_string(FileAccess.get_file_as_string("user://templates.json"))
	dir.make_dir_recursive("UserMaps/{Name}".format({Name = map.name}))
	if map.template != "None":
		r = await http.async_request(templates[map.template])
		if r.success:
			var extract_destination = "res://UserMaps/{Name}/".format({Name = map.name})
			var file = FileAccess.open("res://TMP_template.zip", FileAccess.WRITE)
			file.store_buffer(r.body_raw as PackedByteArray)
			file.close()
			zip.open("res://TMP_template.zip")
			for file_name in zip.get_files():
				var destination = extract_destination + file_name
				var extracted_file = FileAccess.open(destination,FileAccess.WRITE)
				extracted_file.store_buffer(zip.read_file(file_name))
				extracted_file.close()
		else:
			printerr("unable to get template")
			zip.close()
			return ERR_CANT_OPEN
		zip.close()
	ResourceSaver.save(map, "UserMaps/{Name}/map.tres".format({Name = map.name}))
	DirAccess.remove_absolute("res://TMP_template.zip")
	EditorInterface.get_resource_filesystem().scan()
	print_rich("[color=green]Map created successfully[/color]")
	return OK


static func buildmap(mapinfo: gmapInfo):
	var packer = PCKPacker.new()
	var error = packer.pck_start("{0}.gmap".format([mapinfo.name]))
	if error != OK:
		print("Failed to create the package file!")
		return
	_add_directory_to_pck(packer, "res://UserMaps/{0}".format([mapinfo.name]), "res://Usermaps")
	packer.flush(true)


static func buildTemplate(TempateInfo: gmapInfo):
	var zip: ZIPPacker = ZIPPacker.new()
	zip.open("{0}_Template.zip".format([TempateInfo.name]))
	_add_directory_to_zip(zip, "", "res://UserMaps/{Name}/".format({Name = TempateInfo.name}))
	zip.close()
	EditorInterface.get_resource_filesystem().scan()
	print_rich("[color=green]template created successfully[/color]")


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


static func _add_directory_to_pck(packer: PCKPacker, dir_path: String, pck_path: String):
	var dir = DirAccess.open(dir_path)
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				_add_directory_to_pck(
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

static func _add_directory_to_zip(zip_packer, dir: String, base_dir: String = ""):
	var dir_contents = DirAccess.open(base_dir + dir)
	dir_contents.list_dir_begin()
	var file_name = dir_contents.get_next()
	while file_name != "":
		if dir_contents.current_is_dir():
			_add_directory_to_zip(zip_packer, dir + file_name + "/", base_dir)
		else:
			zip_packer.write_file((base_dir + dir + file_name).to_utf8_buffer())
			zip_packer.close_file()
		file_name = dir_contents.get_next()
	dir_contents.list_dir_end()
