extends CharacterBody2D

var tir_scene = preload("res://ousmane.tscn") 

const gravite : int = 4200
const saut_vitesse : int = -1800

var combo_count = 0
var combo_timer = 0.0
var combo_delay = 2.0
var score = 0

var can_shoot := true

func _ready():
	$ProjectileTimer.timeout.connect(_on_ProjectileTimer_timeout)

func _physics_process(delta):
	velocity.y += gravite * delta

	if is_on_floor():
		if not get_parent().play:
			$AnimatedSprite2D.play("immoble")
		else:
			$courir.disabled = false
			if Input.is_action_pressed("ui_accept"):
				velocity.y = saut_vitesse
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("bas")
				$courir.disabled = true
			else:
				$AnimatedSprite2D.play("courir")
	else:
		$AnimatedSprite2D.play("haut")

	# Tir contrôlé par le Timer uniquement
	if Input.is_action_just_pressed("caca") and $ProjectileTimer.is_stopped():
		tirer_projectile()
		$ProjectileTimer.start()  # Démarre le Timer pour le cooldown

	move_and_slide()




	

func _process(delta):
	if combo_count > 0:
		combo_timer += delta
		if combo_timer > combo_delay:
			combo_count = 0
			print("Combo réinitialisé")

func tirer_projectile():
	var projectile = tir_scene.instantiate()
	projectile.position = $ProjectPos.global_position
	get_parent().add_child(projectile)

func _on_body_entered(body):
	if body.has_variable("est_oiseau") and body.est_oiseau:
		combo_count += 1
		combo_timer = 0
		var score_bonus = 500 * combo_count
		score += score_bonus
		print("Combo: " + str(combo_count) + " - Score: " + str(score))
		body.queue_free()
		queue_free()

func _on_ProjectileTimer_timeout():
	can_shoot = true
