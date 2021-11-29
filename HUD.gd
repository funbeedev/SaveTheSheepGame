extends CanvasLayer

# used to tell that button is pressed
signal start_game

# when called show text for the timer duration
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# what happens when game ends. show game over message, then show start game message, pause a bit then show button
func show_game_over():
	#show_message("")
	# wait until timer counts down
	#yield($MessageTimer, "timeout")
	
	$Message.text = "Game Over :( \nTry again! Save the Sheep!"
	$Message.show()
	# Make a oneshot timer and wait for it to finish
	yield(get_tree().create_timer(0.5), "timeout") # for adding a delay
	$StartButton.show()

# when we land on moon
func show_next_stage(sheep_score):

	show_message("The Sheep is Safe!")
	
	# wait until timer counts down
	yield($MessageTimer, "timeout")
	
	$Message.text = "Save more Sheep!"
	
	# Message to show will depend on sheep score
	if(sheep_score == 1):
		$LevelMessage.text = "(Next target: Let's reach 5 sheep safe!)"
	elif (sheep_score == 5):
		$LevelMessage.text = "(Next target: Let's reach 10 sheep safe!)"
	elif (sheep_score == 10):
		$LevelMessage.text = "(Next target: Let's reach 15 sheep safe!)"
	elif (sheep_score == 15):
		$LevelMessage.text = "(Next target: Let's reach 20 sheep safe!)"
	elif (sheep_score == 20):
		$LevelMessage.text = "(Next target: Let's reach 25 sheep safe!)"
	elif (sheep_score >= 25):
		$LevelMessage.text = "All sheep are safe now! Celebrate!"
	
		
	$Message.show()
	$LevelMessage.show()
	 
	# Make a oneshot timer and wait for it to finish
	yield(get_tree().create_timer(1), "timeout") # for adding a delay
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func update_sheep_score(score):
	$SheepScore.text = str(score)


# when button is pressed hide the button and emit the signal
func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
	pass 

# hide the message label on timeout
func _on_MessageTimer_timeout():
	$Message.hide()
	$LevelMessage.hide()
	pass


