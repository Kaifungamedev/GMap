# Gmap
Gmap is a map bundler to help your community make maps with the full power of the godot engine 
![](https://raw.githubusercontent.com/Kaifungamedev/Gmap/main/addons/gmap/icon.png)

- [Gmap](#gmap)
  - [Use](#use)
  - [integration](#integration)
	- [installing maps](#installing-maps)
  - [todo](#todo)

## Use 
using Gmap is simple 
 <!--1. install it from the [asset store](https://godotengine.org/asset-library/asset/2490) and enable it `Project -> Project settings -> plugins`.-->
 1. download of cone this repo copy the addons for in to you project and enable it  
 2. fill out the inputs in the lower left of the editor.
 3. Press `Create map`.
 4. edit your map. located in `Maps/<yourmapname>`.
 5. press build. 

That's it now you should see a .gmap file in the `res://` directory 
## integration
### installing maps
to install a map use the `installmap` function. This will install the map to the `user://Maps` directory
> **WARNING**:  
> Currently this only works in the latest release as the current commit breaks this.
## todo
 - [ ] Add gmap file support for templates
 - [x] fix error when turning off `ignore asset root`
