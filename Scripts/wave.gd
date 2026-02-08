#extends Area2D
#
#@export var speed: float = 750.0
#@onready var ray = $RayCast2D
#
#func _physics_process(delta: float) -> void:
	#position += transform.x * speed * delta
#
#func _on_body_entered(_body: Node2D) -> void:
	## On allonge temporairement le rayon pour être sûr de toucher le mur
	## même si l'onde est déjà un peu à l'intérieur
	#ray.target_position = Vector2(100, 0) 
	#ray.force_raycast_update()
	#
	#if ray.is_colliding():
		#var normal = ray.get_collision_normal()
		#
		## 1. Calcul du rebond exact
		#var current_dir = transform.x
		#var new_dir = current_dir.reflect(normal)
		#
		## 2. Application
		#rotation = new_dir.angle()
		#
		## 3. Sortie forcée de la zone de collision pour éviter les bugs
		## On replace l'onde au point de contact + un petit décalage
		#global_position = ray.get_collision_point() + (normal * 5.0)
	#else:
		## Si ça traverse encore, c'est que le RayCast ne voit pas le Layer de l'obstacle
		#print("Erreur : Le RayCast ne voit pas l'obstacle sur le Layer ", _body.collision_layer)

extends Area2D

@export var speed: float = 750.0
@onready var ray = $RayCast2D

func _physics_process(delta: float) -> void:
	# On avance vers "l'avant" de l'objet
	position += transform.x * speed * delta

func _on_body_entered(_body: Node2D) -> void:
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
