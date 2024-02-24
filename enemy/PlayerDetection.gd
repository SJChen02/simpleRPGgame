extends Area2D

var player = null #used to tell the code that the player is not in range

func see_player():#if this function is called.
	return player != null #return player is in range

func _on_PlayerDetection_body_entered(body): #function for when player is detected
	player = body #this is used to tell the mob who to follow.


func _on_PlayerDetection_body_exited(body):
	player = null #once player exit the range, it will set player in range to null.
