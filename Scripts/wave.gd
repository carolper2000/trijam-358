extends Area2D

@export var speed: float = 750.0
@export var ttl: float = 1 #seconds
@onready var ray = $RayCast2D

func _ready() -> void:
	# Créer un timer dynamiquement
	var timer = get_tree().create_timer(ttl)
	# Connecter la fin du timer à la destruction de l'onde
	timer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	# On avance vers "l'avant" de l'objet
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# If the waves touches the player, it disappears
	if (body.name == "Player"):
		queue_free()
	
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var normal = ray.get_collision_normal()
		
		# On récupère la direction actuelle en vecteur GLOBAL
		var current_dir = transform.x
		
		# On calcule le rebond
		# .bounce() est souvent plus robuste que .reflect() pour les normales physiques
		var new_dir = current_dir.bounce(normal)
		
		# On applique la nouvelle direction
		rotation = new_dir.angle()
		
		# ON SORT DU MUR : C'est ici que l'angle se "casse" si on ne le fait pas.
		# On se place à l'impact + on pousse vers la normale.
		global_position = ray.get_collision_point() + normal * 5.0
		
		print("Collision avec normale : ", normal, " Nouvel angle : ", rad_to_deg(rotation))
	else:
		# Si le RayCast ne voit rien, c'est un problème de Masque ou de Position
		# On fait un rebond "par défaut" basé sur le mouvement pour ne pas traverser
		rotation += PI
		print("RayCast aveugle - Demi-tour de secours")
