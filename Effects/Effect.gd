extends AnimatedSprite

func _ready():#will load when this is program is called.
	connect("animation_finished", self, "_on_animation_finished")#when the code for "animation_finnished" is done it will activate "_on_animation_finished"
	play("Animate")#plays the effect


func _on_animation_finished():#function that will remove the sprite from the game. 
	queue_free() #remove the sprite from the game


