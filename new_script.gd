extends KinematicBody2D

var velocity = Vector2(0, 0)
var candies = 0
const SPEED = 120
const GRAVITY = 5
const JUMPFORCE = - 150

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprite.play("Walk")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = - SPEED
		$Sprite.play("Walk")
		$Sprite.flip_h = true
		
	
	else:
		$Sprite.play("Idle")
		
	if not is_on_floor():
		$Sprite.play("Air")
	
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.15)
	
	



func _on_Fall_Zone_body_entered(body):
	get_tree().change_scene("res://Level 1.tscn")



