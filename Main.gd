extends Node

export (PackedScene) var Mob
var score
var sheep_score = 0
var show_next_goal = false
var mob_randomness = false

# starting point for game
func _ready():
	randomize()
#	new_game()
	pass 


func new_game():
	score = 0 # reset score
	
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
	
	# clear all objects belonging to the "mobs" group
	# does so by calling the queue_free function on every mode in the group
	get_tree().call_group("mobs", "queue_free")
	
	### SET DIFFICULTY - scale player, increase mob spawn ###
	print("Main: sheep score = %s" % sheep_score)
	
	mob_randomness = !mob_randomness

	if(sheep_score < 1):
		$Player.scale = Vector2(1, 1)
		
	elif(sheep_score < 4):
		$Player.scale = Vector2(1.2, 1.2)
		$MobTimer.wait_time = 0.4
		
	elif(sheep_score < 7):
		$Player.scale = Vector2(1.3, 1.3)
		$MobTimer.wait_time = 0.4
	
	elif(sheep_score < 10):
		$Player.scale = Vector2(1.4, 1.4)
		$MobTimer.wait_time = 0.3
	
	elif(sheep_score < 13):
		$Player.scale = Vector2(1.5, 1.5)
		$MobTimer.wait_time = 0.3
			
	elif(sheep_score < 16):
		$Player.scale = Vector2(1.6, 1.6)
		$MobTimer.wait_time = 0.3
		
	elif(sheep_score < 19):
		$Player.scale = Vector2(2.3, 2.3)
		$MobTimer.wait_time = 0.3
		
	elif(sheep_score < 25):
		$Player.scale = Vector2(2.5, 2.5)
		$MobTimer.wait_time = 0.2
		
	else:
		$Player.scale = Vector2(3.0, 3.0)
		$MobTimer.wait_time = 0.1
		pass
		

	# when sheep arrives
	# update the sheep score in HUD
	sheep_score += 1
	$HUD.update_sheep_score(sheep_score)
	# play sheep sound
	$SheepWinSound.play()
	
	# decide when we should show next goal to player
	if ((sheep_score == 1 ) or (sheep_score % 5 == 0)):
		show_next_goal = true
	else:
		show_next_goal = false
		
	if (show_next_goal == true):
		$Music.stop()
		$WinSound.play()

		# call next stage from HUD and show start button
		$HUD.show_next_stage(sheep_score)
	else:
		# manually call to start next stage
		_on_StartTimer_timeout()
	

	
# this timer is used to set a delay before game starts
func _on_StartTimer_timeout():
	
	$MobTimer.start()
	$ScoreTimer.start()
	$PlayerStartTimer.start()
	pass 

# use to delay before player can begin 
func _on_PlayerStartTimer_timeout():
	
	# enable the player and set position
	$Player.start($StartPosition.position) 
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
	
	# Add some randomness to the direction
	if(mob_randomness == true):
		direction += rand_range(-PI / 4, PI / 4)
		mob.rotation = direction
	
	#set the velocitiy (speed & direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
	pass
