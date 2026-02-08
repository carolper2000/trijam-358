extends Node2D

@export var Wave : PackedScene
@export var ExtraPairs: int = 2
@export var Spread: int = 10

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
	
	
	for i in ExtraPairs + 1:
		if i == 0: continue
		var wave1: Node2D = Wave.instantiate()
		var wave2: Node2D = Wave.instantiate()
		wave1.transform = self.global_transform
		wave2.transform = self.global_transform
		
		wave1.global_rotation -= deg_to_rad(i*Spread)
		wave2.global_rotation += deg_to_rad(i*Spread)
		
		get_tree().root.add_child(wave1)
		get_tree().root.add_child(wave2)
