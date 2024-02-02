class_name addon extends Resource
## name of template
@export var name: String
## asset comes from the asset library
@export var GodotAsset: bool = true
## Asset library addon id. only used if [code]GodotAsset = true[/code]
@export var assetID: int
## if [code]GodotAsset[/code] is false this will be used to download the addon
@export var downloadUrl: String
