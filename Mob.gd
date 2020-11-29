extends RigidBody2D

export var min_speed = 150 
export var max_speed = 250


# Called when the node enters the scene tree for the first time.
func _ready():
	
#	#randomly choose one of the animation types
#	var mob_types = $AnimatedSprite.frames.get_animation_names()
#	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
#
	
	pass 

# what happens when it leave screen area
func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # delete object
