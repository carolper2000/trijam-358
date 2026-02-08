extends CharacterBody2D

@export var speed = 200

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	look_at(get_global_mouse_position())

func _physics_process(_delta):
	get_input()
	move_and_slide()

func spawn_waves():
	$WaveSpawner.spawn_waves()
