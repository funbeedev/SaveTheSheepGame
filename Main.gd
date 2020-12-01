extends Node

export (PackedScene) var Mob
var score
var sheep_score = 0

# starting point for game
func _ready():
	randomize()
#	new_game()
	pass 


func new_game():
	score = 0 # reset score
	
	$Player.start($StartPosition.position) # set player position
	$StartTimer.start() # start the starttimer
	
	$HUD.update_score(score)
	$HUD.show_message("Get ready to play!")
	
	$Music.play() # start music
	pass
	

# called when player is hit with Mob - game ends
func game_over():
	#stop these timers
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	# call gameover from HUD
	$HUD.show_game_over()

	# clear all objects belonging to the "mobs" group
	# does so by calling the queue_free function on every mode in the group
	get_tree().call_group("mobs", "queue_free")

	$Music.stop()
	$GameoverSound.play()
	$SheepHitSound.play() 
	
	pass
	
# called when Player lands on Moon
func next_stage():
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	# call next stage from HUD
	$HUD.show_next_stage()
	
	# clear all objects belonging to the "mobs" group
	# does so by calling the queue_free function on every mode in the group
	get_tree().call_group("mobs", "queue_free")
	
	$Music.stop()
	$WinSound.play()
	$SheepWinSound.play()
	
	# update the sheep score in HUD
	sheep_score += 1
	$HUD.update_sheep_score(sheep_score)
	pass 

	
# this timer is used to set a delay before game starts
func _on_StartTimer_timeout():
	
	# start these timers
	$MobTimer.start()
	$ScoreTimer.start()
	pass 

# increment score by 1 on timeout
func _on_ScoreTimer_timeout():
	
	score += 1
	# update the score showing on the HUB
	$HUD.update_score(score)
	pass


func _on_MobTimer_timeout():
	
	# Chose a random location on Path2D
	$MobPath/MobSpawnLocation.offset = randi()
	
	# create a mob instance and add to scene
	var mob = Mob.instance()
	add_child(mob)
	
	# set mob direction perpendicular to path direction
	# Why PI? In functions requiring angles, GDScript uses radians, not degrees. 
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2 
		
	# Set the mobs position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	
	#Add some randomness to the direction
#	direction += rand_range(-PI / 4, PI / 4)
#	mob.rotation = direction
	
	#set the velocitiy (speed & direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
	pass



