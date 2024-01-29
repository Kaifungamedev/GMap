@tool
class_name gmap_dock extends ScrollContainer
var res = DirAccess.open("res://")
@onready var templateSelector = $VBoxContainer/mapTemplate/OptionButton
@onready var mapSelector = $VBoxContainer/HBoxContainer/OptionButton
@onready var mapNameTextEdit = $VBoxContainer/MapInformation/MapName
@onready var mapAuthorTextEdit = $VBoxContainer/MapInformation/MapAuthor
@onready var versionMajor = $VBoxContainer/MapInformation/GridContainer/MAJOR
@onready var versionMinor = $VBoxContainer/MapInformation/GridContainer/MINOR
@onready var versionPatch = $VBoxContainer/MapInformation/GridContainer/PATCH


func _on_create_map_pressed():
	if mapNameTextEdit.text == "" or mapAuthorTextEdit.text == "":
		printerr("Map unconfigured")
	gmap.creatmap(
		gmapInfo.new(
			mapNameTextEdit.text,
			mapAuthorTextEdit.text,
			[versionMajor.value, versionMinor.value, versionPatch.value]
		)
	)


func _on_updateMapList_pressed():
	if not res.dir_exists("Maps"):
		return
	mapSelector.clear()
	mapSelector.add_item("[select]")
	for dir in res.get_directories_at("Maps"):
		var mappath = "Maps/{0}/map.tres".format([dir])
		if res.file_exists(mappath):
			var mapinfo: gmapInfo = load(mappath)
			mapSelector.add_item(mapinfo.name)


func _on_map_selected(index: int):
	if mapSelector.get_item_text(index) == "[select]":
		mapNameTextEdit.text = ""
		mapAuthorTextEdit.text = ""
		versionMajor.value = 0
		versionMinor.value = 0
		versionPatch.value = 0
		return
	var mappath = "Maps/{0}/map.tres".format([mapSelector.get_item_text(index)])
	var mapinfo: gmapInfo = load(mappath)
	mapNameTextEdit.text = mapinfo.name
	mapAuthorTextEdit.text = mapinfo.author
	versionMajor.value = mapinfo.version[0]
	versionMinor.value = mapinfo.version[1]
	versionPatch.value = mapinfo.version[2]


func _on_buildmap_pressed():
	var mappath = "Maps/{0}/map.tres".format(
		[mapSelector.get_item_text(mapSelector.get_selected_id())]
	)
	var mapinfo: gmapInfo = load(mappath)
	gmap.buildmap(mapinfo)
