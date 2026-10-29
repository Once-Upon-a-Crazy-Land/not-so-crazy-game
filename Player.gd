extends KinematicBody2D

enum States{AIR = 1, FLOOR, LADDER, WALL}
var state = States.AIR

var velocity = Vector2(0, 0)
var candies = 0
var on_ladder: = false
const SPEED = 120
const RUNSPEED = 50
const GRAVITY = 20
const JUMPFORCE = - 300
const FIREBALL = preload("res://Shell.tscn")


func _physics_process(delta):
	print(state)
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			
			$Sprite.play("Air")
			if Input.is_action_pressed("right"):
				velocity.x = lerp(velocity.x, SPEED, 0.1) if velocity.x < SPEED else lerp(velocity.x, SPEED, 0.1)
				$Sprite.flip_h = false
			elif Input.is_action_pressed("left"):
				velocity.x = lerp(velocity.x, - SPEED, 0.1) if velocity.x < SPEED else lerp(velocity.x, - SPEED, 0.1)
				$Sprite.flip_h = true
			else:
				velocity.x = lerp(velocity.x, 0, 0.15)
			move_and_fall()
			throw()

		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			
			if Input.is_action_pressed("right"):
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, RUNSPEED, 0.1)
					$Sprite.set_speed_scale(0.8)
				else:
					velocity.x = lerp(velocity.x, SPEED, 0.1)
					$Sprite.set_speed_scale(1.0)
				$Sprite.play("Walk")
				$Sprite.flip_h = false
			elif Input.is_action_pressed("left"):
				if Input.is_action_pressed("run"):
						velocity.x = lerp(velocity.x, - RUNSPEED, 0.1)
						$Sprite.set_speed_scale(0.8)
				else:
					velocity.x = lerp(velocity.x, - SPEED, 0.1)
					$Sprite.set_speed_scale(1.0)
				$Sprite.play("Walk")
				$Sprite.flip_h = true
				
			else:
				$Sprite.play("Idle")
				velocity.x = lerp(velocity.x, 0, 0.15)
		
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMPFORCE
				$SoundJump.play()
				state = States.AIR
			move_and_fall()
			throw()
			
		States.LADDER:
			
			if not on_ladder:
				state = States.AIR
				continue
				
			elif is_on_floor() and Input.is_action_pressed("Down"):
				state = States.FLOOR
				continue
			
			if Input.is_action_pressed("Down") or Input.is_action_pressed("Up") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				$Sprite.play("Climb")
	
			else:
				$Sprite.stop()
				
			if Input.is_action_pressed("Up"):
				velocity.y = - SPEED
				
			elif Input.is_action_pressed("Down"):
				velocity.y = SPEED
				
			else:
				velocity.y = lerp(velocity.y, 0, 1)
			
			if Input.is_action_pressed("left"):
				velocity.x = - SPEED / 6
				
			elif Input.is_action_pressed("right"):
				velocity.x = SPEED / 6
				
			else:
				velocity.x = lerp(velocity.y, 0, 1)
				
			velocity = move_and_slide(velocity, Vector2.UP)
			
			
			
				
func should_climb_ladder() -> bool:
	if on_ladder and (Input.is_action_pressed("Up") or Input.is_action_pressed("Down")):
		return true
	else:
		return false

func throw():
	if Input.is_action_just_pressed("throw"):
		var direction = 1 if not $Sprite.flip_h else - 1
		var f = FIREBALL.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position.y
		f.position.x = position.x + 15 * direction



func move_and_fall():
	velocity.y = velocity.y + GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Fall_Zone_body_entered(body):
	get_tree().change_scene("res://EndMenu.tscn")


func bounce():
	velocity.y = JUMPFORCE * 0.7

func ouch( var enemyposx):
	set_modulate(Color(1, 0.3, 0.3, 1))
	velocity.y = JUMPFORCE * 0.4
	$SoundHit.play()
	$Sprite.play("Crowch")
	
	if position.x < enemyposx:
		velocity.x = - 500
	elif position.x > enemyposx:
		velocity.x = 500
		
	Input.action_release("left")
	Input.action_release("right")

	$Timer.start()

func _on_Timer_timeout():
	get_tree().change_scene("res://EndMenu.tscn")


func _on_Ladder_Checker_body_entered(body):
	on_ladder = true


func _on_Ladder_Checker_body_exited(body):
	on_ladder = false
