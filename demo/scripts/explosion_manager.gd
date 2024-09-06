extends Node

# Kinda hacky, but reusing rocket exhaust's pool and scene
@onready var explode_pool : Node3D = $"/root/space/exhaust_pool"
@onready var explode_scene : PackedScene = preload("res:///meshes/exhaust.tscn")   # we'll fire out copies of this object


# Create an explosion at this world coordinate location,
#  with finish diameter this many meters across,
#  with total visible duration this many seconds.
# Called like  ExplosionManager.explode(global_position)
func explode(loc: Vector3, size:float=3.0, duration:float=0.8) -> void:
	var e = explode_scene.instantiate()
	if explode_pool != null:
		explode_pool.add_child(e)
	e.global_position = loc
	e.scale=Vector3.ONE * size * 0.2  #explosion starts smaller
	
	# Animate the explosion expanding, by adjusting the material
	var material = e.get_surface_override_material(0)
	material.emission_energy_multiplier=10  # very bright
	var tween = get_tree().create_tween()   # animate toward target
	tween.set_parallel(true)  # move and change emission at same time
	tween.tween_property(e, "scale", Vector3.ONE*size, duration)
	tween.tween_property(material, "emission_energy_multiplier", 0.0, duration)
	tween.tween_property(material, "grow_amount", 0.3, duration*0.75)
	tween.tween_property(material, "albedo_color:a", 0.0, duration)
	tween.chain().tween_callback(e.queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
