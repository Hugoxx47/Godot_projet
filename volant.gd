extends Area2D
class_name Volant

var est_oiseau := true

func _ready() -> void:
	add_to_group("enemies")  # Ajoute l'oiseau au groupe "enemies" pour qu'il soit détecté par le projectile
	print("Oiseau ajouté au groupe 'enemies': " + str(is_in_group("enemies")))  # Débug pour vérifier



func _process(delta):
	position.x -= get_parent().speed / 2
