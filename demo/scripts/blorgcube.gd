# Simulates a "blorg cube", with animating colors in response to laser fire.
extends Node3D

@export var health : float = 1.0

# Get our material, so we can animate our color.
#   Subtle: you must check "Resource -> Local to Scene" so each cube gets its own colors.
@onready var mtl : Material = $MeshInstance3D.get_surface_override_material(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var normal = Color("00182d") # our normal color
	var rate : float = 3.0  # its color cooldown rate
	mtl.emission = lerp(mtl.emission, normal, rate * delta)
	scale = Vector3.ONE * 10 * ( health + 0.3 )
	
	if health<=0:
		ExplosionManager.explode(global_position,20,1.8)
		queue_free()
	
	# Survived this round, do slow health recovery
	health = lerp(health, 1.0, 0.1*delta) 
	

# Handle laser fire
func _on_area_3d_area_entered(_area: Area3D) -> void:
	print("Laser fire(?) entered blorg cube!")
	health -= 0.02
	mtl.emission += Color(0.3,0.0,0.0)
	
	# Little tiny explosion around the laser hit location
	var jitter : Vector3 = 0.5*Vector3(randf_range(-1,+1), randf_range(-1,+1), randf_range(-1,+1))
	ExplosionManager.explode(_area.global_position + jitter,2.0,0.2)
