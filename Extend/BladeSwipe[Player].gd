extends PLAYER

#export(PackedScene) var BLADE: PackedScene = preload("res://Ability/Ability[BladeSwipe].tscn")
#
#func BladeSwipe():
#	if BLADE:
#		var blade = BLADE.instance()
#		get_tree().current_scene.add_child(blade)
#		blade.global_position = self.global_position
#
#		var blade_rotation = blade_direction.angle()
#		blade.rotation = blade_rotation
#
