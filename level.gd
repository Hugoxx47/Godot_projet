extends Node

var pierre = preload("res://pierre.tscn")
var william = preload("res://william.tscn")
var obstacle = preload("res://obstacle.tscn")
var volant_scene = preload("res://volant.tscn")
var thomas = preload("res://thomas.tscn")
var type_obstacle = [pierre, william, obstacle, thomas]
var obstacles : Array

var speed : float
var speed_debut : float = 15.0
var speed_max : float = 30.0
var screen_size : Vector2i
var taille_sol : int
var difficulte : int
var max_difficulte : int = 2
var score : int
var SCORE_MODIFIER : int = 10
var HIGHSCORE : int
var play : bool
var dernier_obstacle
var distance_min = 300 * (speed / speed_debut)
var distance_max = 500 * (speed / speed_debut)
var taille_oiseau := [700, 800]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	taille_sol = $sol.get_node("Sprite2D").texture.get_height()
	$restart.get_node("Button").pressed.connect(_newgame)
	_newgame()


func _newgame():
	score = 0
	show_score()
	play = false
	get_tree().paused = false
	difficulte = 0
	
	for obs in obstacles:
		if is_instance_valid(obs):
			obs.queue_free()
			obstacles.clear()
		
	$dino.position = Vector2i(121,940)
	$dino.velocity = Vector2i(0, 0)
	$sol.position = Vector2i(0, 0)
	$Camera2D.position = Vector2i(960, 543)
	
	$SCORES.get_node("Start").show()
	$restart.get_node("Button").hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if play:
		speed = speed_debut + score / 4000
		if speed > speed_max:
			speed = speed_max
		ajustement_diff()
		generated_obstacle()
			
		$dino.position.x += speed
		$Camera2D.position.x += speed
		
		score += speed
		show_score()
		
		if $Camera2D.position.x - $sol.position.x > screen_size.x * 1.5:
			$sol.position.x += screen_size.x
			
		for obs in obstacles:
			if is_instance_valid(obs):
				if obs.position.x < ($Camera2D.position.x - screen_size.x):
					remove_obs(obs)
	else:
		if Input.is_action_pressed("ui_accept"):
			play = true
			$SCORES.get_node("Start").hide()
			
func generated_obstacle():
	if obstacles.is_empty() or dernier_obstacle.position.x < score + randi_range(distance_min, distance_max):	
		var obs_type = type_obstacle[randi() % type_obstacle.size()]
		var obs
		var max_obs = difficulte + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var taille_obs = obs.get_node("Sprite2D").texture.get_height()
			var scale_obs = obs.get_node("Sprite2D").scale
			var obstacle_x : int = screen_size.x + score + 100 + (i * 100)
			var obstacle_y : int = screen_size.y - taille_sol - (taille_obs * scale_obs.y / 2) +5
			dernier_obstacle = obs
			add_obs(obs, obstacle_x, obstacle_y)
		# oiseau
		if difficulte == max_difficulte:
			if (randi() % 2) == 0:
				obs = volant_scene.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = taille_oiseau[randi() % taille_oiseau.size()]
				add_obs(obs, obs_x, obs_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(toucher_obs)
	add_child(obs)
	obstacles.append(obs)
	
func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func toucher_obs(body):
	if body.name == "dino":
		game_over()

func show_score():
	$SCORES.get_node("score").text = "SCORE: " + str(score / SCORE_MODIFIER)
	
func show_highscore():
	if score > HIGHSCORE:
		HIGHSCORE = score
		$SCORES.get_node("Highscore").text = "HIGHSCORE: " + str(HIGHSCORE / SCORE_MODIFIER)

func ajustement_diff():
	difficulte = score / 5000
	if difficulte > max_difficulte:
		difficulte = max_difficulte

func game_over():
	show_highscore()
	get_tree().paused = true
	play = false
	$restart.get_node("Button").show()
