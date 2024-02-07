# Gmap
Gmap is a map bundler to help your community make maps with the full power of the godot engine.
![](https://raw.githubusercontent.com/Kaifungamedev/Gmap/main/addons/gmap/icon.png)

- [Gmap](#gmap)
  - [Install](#install)
  - [Docs](#docs)
    - [making a map](#making-a-map)
    - [building a map](#building-a-map)
    - [building a template](#building-a-template)
  - [Integrating](#integrating)
      - [Installing maps](#installing-maps)
      - [loading maps](#loading-maps)


## Install  
Download this repo, copy the addons folder into the root of your project, and enable it from the project settings.

## Docs
### making a map 
fill out the form in the gmap dock, and press "Create Map".
### building a map 
select the map in the map dropdown and click "Build Map".
### building a template
select the map in the map dropdown and click "Build As Template".  
## Integrating  
#### Installing maps
to install a map use the `installmap(path:String)` function.
#### loading maps
to load all maps use `loadMaps()` function.