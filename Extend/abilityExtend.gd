extends PLAYER
#
##abilities
#var BladeSwipe = ability_state("Ability[BladeSwipe]")
#
##func interact():
##	var impact = _get_collisions()
##	if impact:
##		if impact._get_group()[0] == 
#
#func _read_input():
#	velocity = Vector2.ZERO #velocity set to 0 so you can't move when casting
#
#	if Input.is_action_just_pressed("Q_ability"):
#		print("hi")
#		aniTree.set("parameters/Casting/blend_position", position.direction_to(get_global_mouse_position()).normalized())#checks my mouse position and plays according animation for it.
#		state = ABILITY
#		BladeSwipe.execute(self)
#	if Input.is_action_just_pressed("E_ability"):pass
#	if Input.is_action_just_pressed("R_ability"):pass
#	if Input.is_action_just_pressed("F_ability"):pass
#
#func _physical_process(delta):
#	_read_input()
