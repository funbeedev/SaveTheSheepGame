extends Area2D

signal hit # a custom signal to indicate when player is hit

signal moon_land # custom signal to indicate when we touch moon

export var speed = 400 # how fast player will move in pixel/sec. export allows us to adjust the variable in the inspector menu
var screen_size # size of the game window


# Called when the node enters the scene tree for the first time.
func _ready():
	
	hide() # hide player when game begins
	screen_size = get_viewport_rect().size # get size of game window
	pass 



func _on_Player_body_entered(body):
	
	print("Player: Hit by Node: %s" %body.get_name())
	
	# if player collides with Moon - the sheep is safe
	if body.get_name() == "Moon":
		hide()
		emit_signal("moon_land")
		
	# if player collides with anything else, assume its the Mob - game over
	else:
		hide() # player dissapears after being hit
		emit_signal("hit")

	
	$CollisionShape2D.set_deferred("disabled", true) # disable collision so we don't trigger hit more than once
	pass

# reset player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # player movement vector
	
	# handle the keyboard direction presses
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -=1
	
	if Input.is_action_pressed("ui_down"):
		velocity.y +=1
		
	if Input.is_action_pressed("ui_up"):
		velocity.y -=1
	
	# allows animation to move
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	# update player position
	position += velocity * delta
	
	# clamp prevents from leaving the screen based on given boundaries
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	
#	# choose sprite icons to use when moving
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "walk"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0
		
	


