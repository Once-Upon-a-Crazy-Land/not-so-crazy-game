extends CanvasLayer

var candies = 0

func _ready():
	$Coins.text = String(candies)


func _on_Candy_1_candy_collected():
	candies = candies + 1
	_ready()
	if candies == 4:
		get_tree().change_scene("res://WinMenu.tscn")
