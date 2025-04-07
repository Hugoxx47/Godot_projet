extends Area2D

@export var speed: float = 2000.0
@export var max_distance: float = 2000.0  # La distance maximale avant suppression
var distance_travelled: float = 0.0


func _process(delta):
	position.x += speed * delta
	distance_travelled += speed * delta

	# Supprimer le projectile s'il dépasse la distance maximale
	if distance_travelled > max_distance:
		queue_free()

func _on_area_entered(area):
	# Vérifie si l'objet entrant est un Volant (l'oiseau)
	print(area.name)
	if area.is_in_group("enemies"):  # Vérifie si l'objet est dans le groupe "enemies"
		print("Projectile a touché un oiseau: " + area.name)  # Débogue pour voir quel objet est touché
		area.queue_free()  # Supprime l'oiseau
		queue_free()  # Supprime le projectile
