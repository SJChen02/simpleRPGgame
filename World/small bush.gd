extends Node2D

func create_grass_effect():#function that creates the effect for the bush 
	var GrassEffect = load("res://Effects/GrassEffect.tscn")#load the animation
	var grassEffect = GrassEffect.instance()#returns a tree of nodes that can be use as a child of your current node.
	var world = get_tree().current_scene#get the animation for the scene that called this code
	world.add_child(grassEffect)#add child called "grasseffect" to the scene
	grassEffect.global_position = global_position #allow the code to plays the animation at the position of the object




func _on_Hurtbox_area_entered(area):#when the players' hitbox entered this area
	create_grass_effect()#plays the grass effect animation
	queue_free()#remove the animation from the game after played
