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
	show_message("Game Over :(")
	# wait until timer counts down
	yield($MessageTimer, "timeout")
	
	$Message.text = "Save the Sheep!"
	$Message.show()
	# Make a oneshot timer and wait for it to finish
	yield(get_tree().create_timer(1), "timeout") # for adding a delay
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

# when button is pressed hide the button and emit the signal
func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
	pass 

# hide the message label on timeout
func _on_MessageTimer_timeout():
	$Message.hide()
	pass


