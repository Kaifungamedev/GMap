@tool
extends ScrollContainer
var res = DirAccess.open("res://")
var http = AwaitableHTTPRequest.new()
var templates: Dictionary
@onready var templateSelector := $VBoxContainer/mapTemplate/OptionButton
@onready var mapSelector := $VBoxContainer/HBoxContainer/OptionButton
@onready var mapNameTextEdit := $VBoxContainer/MapInformation/MapName
@onready var mapAuthorTextEdit := $VBoxContainer/MapInformation/MapAuthor
@onready var versionMajor := $VBoxContainer/MapInformation/GridContainer/MAJOR
@onready var versionMinor := $VBoxContainer/MapInformation/GridContainer/MINOR
@onready var versionPatch := $VBoxContainer/MapInformation/GridContainer/PATCH


func _ready():
	add_child(http, true)
	http.timeout = 10.0
	$VBoxContainer/mapTemplate/Button.icon = get_theme_icon("Reload", "EditorIcons")
	$VBoxContainer/HBoxContainer/Button.icon = get_theme_icon("Reload", "EditorIcons")
	_on_updateMapList_pressed()
	_on_RefreshTemplates_pressed()


func _get_template(template: String):
	var request = await null


func _on_create_map_pressed():
	var template = templateSelector.get_item_text(templateSelector.selected)
	if (
		mapNameTextEdit.text == ""
		or mapAuthorTextEdit.text == ""
		or mapSelector.get_item_text(mapSelector.selected) == "[selected]"
	):
		printerr("Map unconfigured or not selected")
		return
	if templateSelector.get_item_text(templateSelector.selected) == "[select]":
		template = "None"

	await gmap.creatmap(
		gmapInfo.new(
			mapNameTextEdit.text,
			mapAuthorTextEdit.text,
			[versionMajor.value, versionMinor.value, versionPatch.value],
			template
		),
		http
	)
	_on_updateMapList_pressed()

func _on_updateMapList_pressed():
	mapSelector.clear()
	mapSelector.add_item("[select]")
	if not res.dir_exists("UserMaps"):
		return
	for dir in res.get_directories_at("UserMaps"):
		var mappath = "res://UserMaps/{0}/map.tres".format([dir])
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
	var mappath = "UserMaps/{0}/map.tres".format([mapSelector.get_item_text(index)])
	var mapinfo: gmapInfo = load(mappath)
	mapNameTextEdit.text = mapinfo.name
	mapAuthorTextEdit.text = mapinfo.author
	versionMajor.value = mapinfo.version[0]
	versionMinor.value = mapinfo.version[1]
	versionPatch.value = mapinfo.version[2]


func _on_buildmap_pressed():
	if mapSelector.get_item_text(mapSelector.selected) == "[select]":
		printerr("please select a map")
		return

	var mappath = "UserMaps/{0}/map.tres".format(
		[mapSelector.get_item_text(mapSelector.get_selected_id())]
	)
	var mapinfo: gmapInfo = load(mappath)
	await gmap.buildmap(mapinfo)
	_on_updateMapList_pressed()


func _on_build_template_pressed():
	if mapSelector.get_item_text(mapSelector.selected) == "[select]":
		printerr("please select a map")
		return
	var mappath = "UserMaps/{0}/map.tres".format(
		[mapSelector.get_item_text(mapSelector.get_selected_id())]
	)
	gmap.buildTemplate(load(mappath))


func _on_RefreshTemplates_pressed():
	print("geting templates")
	var dir = DirAccess.open("user://")
	var request_data := await http.async_request(
		"https://raw.githubusercontent.com/Kaifungamedev/GMap-Templates/main/templates.json"
	)
	if !request_data.success:
		print("unable to get templates")
		return
	if !FileAccess.file_exists("user://templates.json"):
		FileAccess.open("user://templates.json", FileAccess.WRITE).store_string(request_data.body)
	templates = JSON.parse_string(
		FileAccess.open("user://templates.json", FileAccess.READ).get_as_text()
	)
	templateSelector.clear()
	templateSelector.add_item("[select]")
	for template in templates:
		templateSelector.add_item(template)
	print("updated templates")
