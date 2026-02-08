extends CharacterBody2D

const SPEED = 15.0
const CHANGE_TIME = 1.5

var direction: Vector2 = Vector2.ZERO
var timer := 0.0


func _ready() -> void:
	pick_random_direction()


func _physics_process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		pick_random_direction()

	velocity = direction * SPEED
	move_and_slide()

	# Si collision → change de direction
	if get_slide_collision_count() > 0:
		pick_random_direction()


func pick_random_direction() -> void:
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	timer = CHANGE_TIME
