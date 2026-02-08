extends Node2D

@onready var ray_cast_2d = $RayCast2D
@export var Wave : PackedScene

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		spawn_waves()

func spawn_waves() -> void:
	# Instantiate wave
	var wave: Node2D = Wave.instantiate()
	# Give the ray cast global transform to the wave	
	wave.transform = ray_cast_2d.global_transform
	# Add to main scene to avoid parent movement issues
	get_tree().root.add_child(wave)
