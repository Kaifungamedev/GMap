@icon("res://addons/gmap/icons/doclogo.svg")
class_name gmapInfo extends gResource
@export var name: String
@export var author: String
@export var version: Array[float] = [0, 0, 0]
@export var template: String


func _init(Name: String, Author: String, Version: Array[float], Template: String = "None"):
	name = Name
	author = Author
	version = Version
	template = Template
