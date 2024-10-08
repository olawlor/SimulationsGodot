extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var rate : float = 0.1; # m/s drop rate
	var limit: float = 10.0; # m minimum height
	var newY = transform.origin.y;
	newY -= rate*delta
	if (newY<limit):
		newY=limit
	transform.origin.y=newY
