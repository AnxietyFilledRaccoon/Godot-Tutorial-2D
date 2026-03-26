extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Music.play()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")

func _on_mob_timer_timeout():
	# Se crea un mob nuevo.
	var mob = mob_scene.instantiate()

	# Se elige un punto aleatorio para Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Seteamos la posición del mob a el punto anterior.
	mob.position = mob_spawn_location.position

	# Hacemos que el mob vaya perpendicular al path.
	var direction = mob_spawn_location.rotation + PI / 2

	# Falopa al movimiento.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Velocidad del mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawneamos un mob en main.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_hud_start_game() -> void:
	$StartButton.hide()
	new_game().emit()
