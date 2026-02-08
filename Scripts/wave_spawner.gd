extends Node2D

@export var Wave : PackedScene

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		spawn_waves()

func spawn_waves() -> void:
	# Instantiate wave
	var wave: Node2D = Wave.instantiate()
	# Give this elements global transform to the wave
	wave.transform = self.global_transform
	# Add to main scene to avoid parent movement issues
	get_tree().root.add_child(wave)
