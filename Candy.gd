extends Area2D

signal candy_collected

func _on_Candy_body_entered(body):
	$AnimationPlayer.play("Float")
	emit_signal("candy_collected")
	set_collision_mask_bit(0, false)
	$SoundCandy.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
