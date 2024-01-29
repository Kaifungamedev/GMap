
extends Node
class_name Utils

# code by @AwesomeAxolotl on github
static func saveBundledResource(resource, path) -> Error:
	var e := ResourceSaver.save(
		resource, path, ResourceSaver.FLAG_BUNDLE_RESOURCES
		)
	if !e:
		e = fixBundledResource(path)
	return e


# change class_name scripts to just extend the given class_name
# avoids name collisions upon load
# scripts without class_name should remain untouched
static func fixBundledResource(file_path) -> Error:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if !file:
		return ERR_CANT_OPEN
	
	var lines := file.get_as_text().split("\n")
	file.close()
	
	var skip := false
	var current_class := ""
	var match_class = RegEx.create_from_string("class_name (\\w+)")
	var skipped_lines: PackedStringArray = []
	
	file = FileAccess.open(file_path, FileAccess.WRITE)
	if !file:
		return ERR_CANT_OPEN
	
	for line in lines:
		if line.begins_with("script/source"):
			skip = true
		if skip:
			skipped_lines.append(line)
			var class_match = match_class.search(line)
			if class_match: current_class = class_match.get_string(1)
			if line == '"':
				skip = false
				if current_class != "":
					file.store_line('script/source = "extends %s' % current_class)
					file.store_line('"')
					current_class = ""
				else:
					for skipped in skipped_lines:
						file.store_line(skipped)
				skipped_lines = []
		else:
			file.store_line(line)
	file.close()
	return OK
# end code by @AwesomeAxolotl

static func replace_paths(file_path:String,exclude:Array[String] = []):
	# converts the res path in the array to user paths as this will make things easier
	var paths:Array
	for i in exclude.size():
		paths.append(exclude[i].replace("res://","user://"))
	var file = FileAccess.open(file_path,FileAccess.READ)
	var contents = file.get_as_text()
	contents = contents.replace("res://","user://")
	for i in exclude.size():
		contents = contents.replace(paths[i],exclude[i])
	return contents
