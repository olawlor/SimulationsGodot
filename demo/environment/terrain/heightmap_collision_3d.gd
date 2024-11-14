# Create heightmap collsion shape from a texture image.
#  Scale the CollisionShape3D in X and Z to match the texture pixel size.
@tool  # run in editor too
extends CollisionShape3D

@export var heightmap_texture : Texture # heightmap texture (dark low, light high)
@export var height_max : float = 10.0 # maximum height (meters)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var heightmap_image: Image = heightmap_texture.get_image()
	heightmap_image.decompress()
	heightmap_image.convert(Image.FORMAT_RF)
	
	var height_min: float = 0.0

	shape.update_map_data_from_image(heightmap_image, height_min, height_max)
	pass # Replace with function body.
