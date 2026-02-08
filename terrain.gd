extends Node2D

const width = 400
const height = 300

const noise_params = {
	"noise_type": 2,
	"frequency": 0.025000,
	"domain_warp_enabled": true,
	"domain_warp_amplitude": 50.010000,
	"domain_warp_fractal_gain": 0.500000,
	"domain_warp_fractal_type": 0,
	"domain_warp_frequency": 0.040000,
	"domain_warp_fractal_octaves": 5.000000,
	"domain_warp_type": 0,
	"fractal_type": 0,
	"fractal_gain": 0.500000,
	"fractal_lacunarity": 2.000000,
	"fractal_octaves": 5,
	"fractal_ping_pong_strength": 2.000000,
	"fractal_weighted_strength": 0.000000,
	"cellular_distance_function": 0,
	"cellular_jitter": 0.500000,
	"cellular_return_type": 1,
}

var stone_prefab = preload("res://stone.tscn")

func _ready() -> void:
	var noise = FastNoiseLite.new()
	noise.seed = randi_range(1, 100000)
	for key in noise_params: noise.set(key, noise_params[key])
	
	for i in range(0, width):
		for j in range(0, height):
			var x = i
			var y = j
			if noise.get_noise_2d(x, y) > -0.35:
				var stone_node: Node2D = stone_prefab.instantiate()
				stone_node.position = Vector2(x, y)
				add_child(stone_node)
