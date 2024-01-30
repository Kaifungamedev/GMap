@icon("res://addons/gmap/icons/doclogo.svg")
class_name gmapInfo extends gResource
@export var name: String
@export var author: String
@export var version: Array[float]


func _init(Name: String, Author: String, Version: Array[float]):
	name = Name
	author = Author
	version = Version
