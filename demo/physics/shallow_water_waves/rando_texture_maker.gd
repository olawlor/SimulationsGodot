@tool
extends Node3D

@export var wid : int = 512
@export var ht : int = 512
@export var texture : ImageTexture = null

# Create a texture of random colored pixels
func _ready() -> void:
	var img : Image = Image.create_empty(wid,ht,false,Image.FORMAT_RGBA8)
	for y in range(0,ht):
		for x in range(0,wid):
			img.set_pixel(x,y,Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),randf_range(0,1)))
	texture = ImageTexture.create_from_image(img)
